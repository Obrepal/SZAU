clear all;

V0_1 = 0.85*((73 + 18)/12)^4; V0_2 = V0_1*0.9/0.85*(12/10)^4;
alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;
kk = 2000;

%Punkt pracy%
F1in(1:50-1) = 73;
FD(1:tau+1) = 18; FD(tau+2:kk) = 18;
V1(1:tau+1) = V0_1;
V2(1:tau+1) = V0_2;
h2(1:tau+1) = 82.81;
e(1:tau+1) = 0;

h2_zad(1:49) =(V0_2/C2)^0.5; h2_zad(50:599) = (V0_2/C2)^0.5-10;
h2_zad(600:1199) = (V0_2/C2)^0.5+20; h2_zad(1200:kk) = (V0_2/C2)^0.5+20;
FD(1200:1225)=23;

K_k = 5.7;%2.355; %wzmocnienie krytyczne
T_k = 380;%172; %okres oscylacji

K_r = 0.6*K_k+1.5;%+1.5
T_i = 0.5*T_k+10; %stała czasowa całkowania +10
T_d = 0.12*T_k+12; %stała czasowa różniczkowania +12
r2 = K_r*T_d;
r1 = K_r*(1/(2*T_i) - 2*T_d - 1);
r0 = K_r*(1 + 1/(2*T_i) + T_d);

for k=tau+2:kk    
%symulacja obiektu na podstawie modelu liniowego
    V1(k) = V1(k-1) + T*(F1in(k-tau-1) + FD(k-1) - alfa1*((V0_1/C1)^0.25 + (V1(k-1)-V0_1)/(4*C1*(V0_1/C1)^0.75)));
    V2(k) = V2(k-1) + T*(alfa1*((V0_1/C1)^0.25 + (V1(k-1)-V0_1)/(4*C1*(V0_1/C1)^0.75)) - alfa2*((V0_2/C2)^0.25 + (V2(k-1)-V0_2)/(4*C2*(V0_2/C2)^0.75)));
    h2(k) = sqrt(V0_2/C2) + (V2(k)-V0_2)/(2*C2*sqrt(V0_2/C2));

%uchyb regulacji
	e(k) = h2_zad(k) - h2(k);
    
%sygnał sterujący regulatora PID
	F1in(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + F1in(k-1);
    
%ograniczenie na przyrost sterowania
    delta = 1;
    if F1in(k) - F1in(k-1) > delta
        F1in(k) = F1in(k-1) + delta;
    elseif F1in(k-1) - F1in(k) > delta
        F1in(k) = F1in(k-1) - delta;
    end
    
 %ograniczenie na wartość sterowania
    if F1in(k) > 200
        F1in(k) = 200;
    elseif F1in(k) < 0
        F1in(k) = 0;
    end    
end

figure(1)
grid on;
hold on;
title('h_2[cm]');
xlabel('czas [s]');
stairs(1:kk, h2(1:kk), 'b'); %obiekt
stairs(1:kk, h2_zad(1:kk), 'k:'); %wartość zadana

figure(2);
grid on;
hold on;
title('F_{1in} [cm^3/s]');
xlabel('czas [s]');
stairs(1:kk, F1in(1:kk), 'b');

