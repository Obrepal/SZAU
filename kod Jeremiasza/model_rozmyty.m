
%funkcja wyznaczająca poziomy aktywacji poszczególnych reguł
clear all;
il =3;
w = ones(1,il);

%stałe z zadania
alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;
kk = 2000;

%przedział
ymax = 150;
ymin = 15;
%długość zbioru
dy = (ymax-ymin)/il;
%wartości parametrów sigmf
a = 0.8;
c = ymin+dy:dy:ymax-dy;

%nasz kochane punkty pracy
h2r0 = ones(1,il);
h2r0(1) = (c(1)+ymin)/2-1;
h2r0(il) = min((ymax+c(il-1))/2+1, ymax);

h1r0(1) = (alfa2/alfa1)^2*h2r0(1);
h1r0(il) = (alfa2/alfa1)^2*h2r0(il);

if il > 2
    h2r0(2:il-1) = (c(2:il-1)+c(1:il-2))./2;
    h1r0(2:il-1) = (alfa2/alfa1)^2*h2r0(2:il-1);
end

V0_1 = C1*[(alfa2/alfa1)^2*h2r0].^2; V0_2 = C2.*h2r0.*h2r0;

Flin(1:50-1) = 73;
FD(1:tau+1) = 18;
V1(1:tau+1) = 0.85*((73 + 18)/12)^4;
V2(1:tau+1) = 0.85*((73 + 18)/12)^4*0.9/0.85*(12/10)^4;
h2(1:tau+1) = 82.81;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tworzenie grafiki



FD(tau+2:kk) = 18;
for value=109:-18:37
    Flin(50:kk) = value;
    for k=tau+2:kk
        for r = 1:il
            V1(k) = V1(k-1) + T*(Flin(k-tau-1) + FD(k-1) - alfa1*((V0_1/C1)^0.25 + (V1(k-1)-V0_1)/(4*C1*(V0_1/C1)^0.75)));
            V2(k) = V2(k-1) + T*(alfa1*((V0_1/C1)^0.25 + (V1(k-1)-V0_1)/(4*C1*(V0_1/C1)^0.75)) - alfa2*((V0_2/C2)^0.25 + (V2(k-1)-V0_2)/(4*C2*(V0_2/C2)^0.75)));
            h2(k) = sqrt(V0_2/C2) + (V2(k)-V0_2)/(2*C2*sqrt(V0_2/C2));
            
            %wagi
            if r == 1
                w(1) = sigmf(h2, [-a c(1)]);
            elseif r == il
                w(il) = sigmf(h2, [a c(il-1)]);
            else
                w(r) = dsigmf(h2, [a c(r-1) a c(r)]);
            end
        end
    end
end

stairs(1:kk, h2(1:kk), '--');
