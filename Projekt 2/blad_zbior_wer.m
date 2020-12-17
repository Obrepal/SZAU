%ładowanie parametrów modelu
model

%ładowanie danych weryfikujących
load('dane_weryfikujace', 'y', 'u')

E_oe = 0;
y_mod(1:4) = y(1:4);
for k=5:length(y)
    q = [u(k-3) u(k-4) y_mod(k-1) y_mod(k-2)]';
    y_mod(k) = w20 + w2*tanh(w10+w1*q);
    E_oe = E_oe + (y_mod(k)-y(k))^2; 
end
E_oe

% %generacja wykresów
% figure;
% subplot(2, 1, 1);
% stairs(u, 'b'); %wejście u
% grid on;
% ylim([-1 1])
% ylabel('u');
% xlabel('k');
% 
% subplot(2,1,2);
% stairs(y, 'Color', [0.3010 0.7450 0.9330]); %wyjście y
% hold on;
% stairs(y_mod, 'r-.');
% grid on;
% ylabel('y');
% xlabel('k');