clear all;

alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;
h2r0 = [36.5 82.5 128.5];
V0_1 = C1*((alfa2/alfa1)^2*h2r0).^2; V0_2 = C2.*h2r0.*h2r0;
kk = 3000; il =3;

%Punkt pracy układu
Flin(1:tau+1) = 73;
FD(1:kk) = 18;
V1(1:tau+1,1:il) = 0.85*((73 + 18)/12)^4;
V2(1:tau+1,1:il) = 0.85*((73 + 18)/12)^4*0.9/0.85*(12/10)^4;
h2(1:tau+1,1:il) = 82.81;
h2rozmyte(1:tau+1) = 82.81;
e(1:tau+1) = 0;

%wartość zadana i zakłócenia
h2_zad(1:49) = 82.81; h2_zad(50:599) = 82.81-20;
h2_zad(600:1599) = 82.81+30; h2_zad(1600:kk) = 82.81-10;
FD(2500:2525)=28;
% h2_zad(1:49) = 82.81; h2_zad(50:kk) = 82.81+50;

K_k = 5.7; %wzmocnienie krytyczne
T_k = 380; %okres oscylacji

K_r = 0.6*K_k+1.5;
T_i = 0.5*T_k+10; %stała czasowa całkowania
T_d = 0.12*T_k+12; %stała czasowa różniczkowania
r2 = K_r*T_d;
r1 = K_r*(1/(2*T_i) - 2*T_d - 1);
r0 = K_r*(1 + 1/(2*T_i) + T_d);

for k=tau+2:kk    
%model rozmyty obiektu
    for r = 1:il 
        V1(k,r) = V1(k-1,r) + T*(Flin(k-tau-1) + FD(k-1) - alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)));
        V2(k,r) = V2(k-1,r) + T*(alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)) - alfa2*((V0_2(r)/C2)^0.25 + (V2(k-1,r)-V0_2(r))/(4*C2*(V0_2(r)/C2)^0.75)));
        h2(k,r) = sqrt(V0_2(r)/C2) + (V2(k,r)-V0_2(r))/(2*C2*sqrt(V0_2(r)/C2));
    end
    w = poziomy_aktywacji(il, h2rozmyte(k-1), 1, 0);
    h2rozmyte(k) = w*h2(k,:)';
    
%uchyb regulacji
	e(k) = h2_zad(k) - h2rozmyte(k);
    
%sygnał sterujący regulatora PID
	Flin(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + Flin(k-1);
    
%ograniczenie na przyrost sterowania
    delta = 1;
    if Flin(k) - Flin(k-1) > delta
        Flin(k) = Flin(k-1) + delta;
    elseif Flin(k-1) - Flin(k) > delta
        Flin(k) = Flin(k-1) - delta;
    end
    
 %ograniczenie na wartość sterowania
    if Flin(k) > 200
        Flin(k) = 200;
    elseif Flin(k) < 0
        Flin(k) = 0;
    end    
end

figure(1)
grid on;
hold on;
title('h_2[cm]');
xlabel('czas [s]');
stairs(1:kk, h2rozmyte(1:kk), 'b'); %obiekt
stairs(1:kk, h2_zad(1:kk), 'k:'); %wartość zadana

figure(2);
grid on;
hold on;
title('F_{1in} [cm^3/s]');
xlabel('czas [s]');
stairs(1:kk, Flin(1:kk), 'b');

