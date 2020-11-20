clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
modyfikacja_regulatora = 0; %1 - gdy zmodyfikowane funkcje przynależności regulatora rozmytego
                            %0 - gdy niezmodyfikowane funkcje przynależności
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
kolor = 'r--';
alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;
h2r0 = [36.5 82.5 128.5];
V0_1 = C1*((alfa2/alfa1)^2*h2r0).^2; V0_2 = C2.*h2r0.*h2r0;
kk = 3000; il = 3;

%Punkt pracy układu
Flin(1:tau+1,1:il) = 73;
Flin_r(1:tau+1) = 73;
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

K_k = [2.955 5.7 8.5]; %wzmocnienia krytyczne
T_k = [217 380 524]; %okresy oscylacji

K_r = [3.7432/8 0.6*K_k(2)+1.5 0.6*K_k(3)+4];
T_i = [3.7432/0.03891 0.5*T_k(2)+10 0.5*T_k(3)-10]; %stałe czasowe całkowania
T_d = [79.6297/3.7432 0.12*T_k(2)+12 0.12*T_k(3)+20]; %stałe czasowe różniczkowania
r2 = K_r.*T_d;
r1 = K_r.*((2*T_i).^(-1) - 2*T_d - 1);
r0 = K_r.*(1 + (2*T_i).^(-1) + T_d);

for k=tau+2:kk
%model rozmyty obiektu
    for r = 1:il 
        V1(k,r) = V1(k-1,r) + T*(Flin_r(k-tau-1) + FD(k-1) - alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)));
        V2(k,r) = V2(k-1,r) + T*(alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)) - alfa2*((V0_2(r)/C2)^0.25 + (V2(k-1,r)-V0_2(r))/(4*C2*(V0_2(r)/C2)^0.75)));
        h2(k,r) = sqrt(V0_2(r)/C2) + (V2(k,r)-V0_2(r))/(2*C2*sqrt(V0_2(r)/C2));
    end
    w = poziomy_aktywacji(il, h2rozmyte(k-1), 1, modyfikacja_regulatora);
    h2rozmyte(k) = w*h2(k,:)';

%uchyb regulacji
	e(k) = h2_zad(k) - h2rozmyte(k);
    
%sygnał sterujący regulatora rozmytego PID
    for r = 1:il 
        Flin(k,r) = r2(r)*e(k-2) + r1(r)*e(k-1) + r0(r)*e(k) + Flin(k-1,r);
        
        %ograniczenie na przyrost sterowania
        delta = 1;
        if Flin(k,r) - Flin(k-1,r) > delta
            Flin(k,r) = Flin(k-1,r) + delta;
        elseif Flin(k-1,r) - Flin(k,r) > delta
            Flin(k,r) = Flin(k-1,r) - delta;
        end

        %ograniczenie na wartość sterowania
        if Flin(k,r) > 200
            Flin(k,r) = 200;
        elseif Flin(k,r) < 0
            Flin(k,r) = 0;
        end
    end
    
    w = poziomy_aktywacji(il, h2rozmyte(k), 1, modyfikacja_regulatora);
    Flin_r(k) = w*Flin(k,:)';   
end

figure(1)
grid on;
hold on;
title('h_2[cm]');
xlabel('czas [s]');
stairs(1:kk, h2rozmyte(1:kk), kolor); %obiekt
stairs(1:kk, h2_zad(1:kk), 'k:'); %wartość zadana

figure(2);
grid on;
hold on;
title('F_{1in} [cm^3/s]');
xlabel('czas [s]');
stairs(1:kk, Flin_r(1:kk), kolor);