clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
il = 5; %ilość modeli lokalnych (od 2 do 5)
modyfikacja_modelu = 0; %1 - gdy zmodyfikowane funkcje przynależności modelu rozmytego (tylko dla il = 3)
                        %0 - gdy niezmodyfikowane funkcje przynależności
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%stałe
alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;
kk = 2000;

%przedział
ymax = 150;
ymin = 15;
%długość zbioru
dy = (ymax-ymin)/il;
%wartości parametrów sigmf
c = ymin+dy:dy:ymax-dy;

%punkty linearyzacji modeli lokalnych
h2r0 = ones(1,il);
h2r0(1) = (c(1)+ymin)/2-1;
h2r0(il) = min((ymax+c(il-1))/2+1, ymax);
if il > 2
    h2r0(2:il-1) = (c(2:il-1)+c(1:il-2))./2;
end
V0_1 = C1*((alfa2/alfa1)^2*h2r0).^2; V0_2 = C2.*h2r0.*h2r0;

%punkt pracy układu
Flin(1:50-1) = 73;
FD(1:tau+1) = 18;
V1(1:tau+1,1:il) = 0.85*((73 + 18)/12)^4;
V2(1:tau+1,1:il) = 0.85*((73 + 18)/12)^4*0.9/0.85*(12/10)^4;
h2(1:tau+1,1:il) = 82.81;
h2rozmyte(1:tau+1) = 82.81;

figure(1)
grid on;
hold on;
title('h_2[cm]');
xlabel('czas [s]');

FD(tau+2:kk) = 18;
for value=109:-18:37
    Flin(50:kk) = value;
    for k=tau+2:kk
        w = poziomy_aktywacji(il, h2rozmyte(k-1), modyfikacja_modelu, 0);
        for r = 1:il 
            V1(k,r) = V1(k-1,r) + T*(Flin(k-tau-1) + FD(k-1) - alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)));
            V2(k,r) = V2(k-1,r) + T*(alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)) - alfa2*((V0_2(r)/C2)^0.25 + (V2(k-1,r)-V0_2(r))/(4*C2*(V0_2(r)/C2)^0.75)));
            h2(k,r) = sqrt(V0_2(r)/C2) + (V2(k,r)-V0_2(r))/(2*C2*sqrt(V0_2(r)/C2));
        end
        h2rozmyte(k) = w*h2(k,:)';
    end
    stairs(1:kk, h2rozmyte(1:kk), 'r--');
end


figure(2)
grid on;
hold on;
title('h_2[cm]');
xlabel('czas [s]');

Flin(50:kk) = 73;
for value=28:-5:8
    FD(tau+1:kk) = value;
    for k=tau+2:kk
        w = poziomy_aktywacji(il, h2rozmyte(k-1), modyfikacja_modelu, 0);
        for r = 1:il 
            V1(k,r) = V1(k-1,r) + T*(Flin(k-tau-1) + FD(k-1) - alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)));
            V2(k,r) = V2(k-1,r) + T*(alfa1*((V0_1(r)/C1)^0.25 + (V1(k-1,r)-V0_1(r))/(4*C1*(V0_1(r)/C1)^0.75)) - alfa2*((V0_2(r)/C2)^0.25 + (V2(k-1,r)-V0_2(r))/(4*C2*(V0_2(r)/C2)^0.75)));
            h2(k,r) = sqrt(V0_2(r)/C2) + (V2(k,r)-V0_2(r))/(2*C2*sqrt(V0_2(r)/C2));
        end
        h2rozmyte(k) = w*h2(k,:)';
    end
    stairs(1:kk, h2rozmyte(1:kk), 'r--');
end
