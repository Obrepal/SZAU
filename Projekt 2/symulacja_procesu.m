clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dane = 0; %0 - dane uczące, 1 - dane weryfikujące
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alfa1 = -1.262719; alfa2 = 0.329193;
beta1 = 0.039291; beta2 = 0.027184;

%inicjalizacja
kk = 2000;
u(1:9) = 0; y(1:9) = 0;
x1(1:9) = 0; x2(1:9) = 0;

%sekwencja skokowych zmian sygnału sterującego
rand('seed', dane+15);
for i=1:40:kk
    u(i:i+39) = (rand(1,1)-0.5)*1.6;
end

%symulacja procesu
for k=10:kk
    x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(u(k-3));
    x2(k) = -alfa2*x1(k-1) + beta2*g1(u(k-3));
    y(k) = g2(x1(k));
end

%generacja wykresów
figure;
subplot(2, 1, 1);
stairs(u(1:kk), 'b'); %wejście u
grid on;
ylim([-1 1])
ylabel('u');
xlabel('k');

subplot(2,1,2);
stairs(y, 'Color', [0.3010 0.7450 0.9330]); %wyjście y
hold on;
plot(y, 'r.', 'MarkerSize', 7); %próbki
grid on;
ylabel('y');
xlabel('k');

%zapisanie danych do pliku
if dane==0
    plik = fopen('dane.txt', 'w');
    save('dane_uczace');
else
    plik = fopen('danewer.txt', 'w');
    save('dane_weryfikujace');
end
for k=1:kk
    fprintf(plik, '%2.12e ', u(k));
    fprintf(plik, '%2.12e\r\n', y(k));
end
fclose(plik);

%funkcje pomocnicze
function g1_out = g1(u)
    g1_out = (exp(5.5*u)-1)/(exp(5.5*u)+1);
end

function g2_out = g2(x1)
    g2_out = 1 - exp(-2.5*x1);
end