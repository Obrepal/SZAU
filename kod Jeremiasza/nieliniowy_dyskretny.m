clear all;

V0_1 = 0.85*((73 + 18)/12)^4; V0_2 = V0_1*0.9/0.85*(12/10)^4;
alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;
kk = 2000;

%Punkt pracy%
Flin(1:50-1) = 73;
FD(1:tau+1) = 18;
V1(1:tau+1) = V0_1;
V2(1:tau+1) = V0_2;
h2(1:tau+1) = 82.81;

figure(1)
grid on;
hold on;
title('h_2[cm]');
xlabel('czas [s]');

FD(tau+2:kk) = 18;
for value=109:-18:37
    Flin(50:kk) = value;
    for k=tau+2:kk
        V1(k) = V1(k-1) + T*(Flin(k-tau-1) + FD(k-1) - alfa1*(V1(k-1)/C1)^0.25);
        V2(k) = V2(k-1) + T*(alfa1*(V1(k-1)/C1)^0.25 - alfa2*(V2(k-1)/C2)^0.25);
        h2(k) = (V2(k)/C2)^0.5;
    end
    stairs(1:kk, h2(1:kk));
end

Flin(50:kk) = 73;
figure(2)
grid on;
hold on;
title('h_2[cm]');
xlabel('czas [s]');
for value=28:-5:8
    FD(tau+2:kk) = value;
    for k=tau+2:kk
        V1(k) = V1(k-1) + T*(Flin(k-tau-1) + FD(k-1) - alfa1*(V1(k-1)/C1)^0.25);
        V2(k) = V2(k-1) + T*(alfa1*(V1(k-1)/C1)^0.25 - alfa2*(V2(k-1)/C2)^0.25);
        h2(k) = (V2(k)/C2)^0.5;
    end
    stairs(1:kk, h2(1:kk));
end

