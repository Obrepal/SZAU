clear variables
close all

%Stale%
C1=0.85;
C2=0.9;
alpha1=12;
alpha2=10;


%Punkt pracy%
tau=40;
F1P=73;
FDP=19;
h2P=82.81;
h1P=(alpha2/alpha1)^2*h2P;
V1P=C1*h1P*h1P;
V2P=C2*h2P*h2P;


%pozostałe%
start=50;
n=800;

figure
title('.')
xlabel('czas[t]')
ylabel('h2[cm]')
hold on

for i = 83:-5:23

    F1in= F1P * ones(1,n);
    F1in(start:n) = i;
    F1 = F1P * ones(1,n);
    FD = FDP * ones(1,n);
    h1 = h1P * ones(1,n);
    h2 = h2P * ones(1,n);
    V1 = C1 * h1P * h1P * ones(1,n);
    V2 = C2 * h2P * h2P * ones(1,n);
    
    for t=tau+1:n
        F1(t)= F1in(t-tau);
        V1(1,t) = V1(1,t-1) + F1(t-1) + FD(t-1) -alpha1*h1(1,t-1)^0.5;
        V2(1,t) = V2(1,t-1) + alpha1*h1(1,t-1)^0.5 -alpha2*h2(1,t-1)^0.5;
        h1(1,t) = (V1(1,t)/C1)^0.5;
        h2(1,t) = (V2(1,t)/C2)^0.5;           
    end
     plot(start:n,h2(1,start:end))
    
end
