function [w] = model_rozmyty(il, h2)
%funkcja wyznaczająca poziomy aktywacji poszczególnych reguł (= modeli lokalnych)

%stałe z zadania
alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;

%przedział
ymax = 150;
ymin = 15;
%długość zbioru
dy = (ymax-ymin)/il;
%wartości parametrów sigmf
a = 0.8;
c = ymin+dy:dy:ymax-dy;

%śnasz kochane punkty pracy
h2r0 = ones(1,il);
h2r0(1) = (c(1)+ymin)/2-1;
h2r0(il) = min((ymax+c(il-1))/2+1, ymax);

h1r0(1) = (alfa2/alfa1)^2*h2r0(1);
h1r0(il) = (alfa2/alfa1)^2*h2r0(il);

if il > 2
    h2r0(2:il-1) = (c(2:il-1)+c(1:il-2))./2;
    h1r0(2:il-1) = (alfa2/alfa1)^2*h2r0(2:il-1);
end

%V0_1 = C1*((73 + 18)/12)^4; V0_2 = V0_1*0.9/0.85*(12/10)^4;
V0_1 = C1*(alfa2/alfa1)^2*h2r0; V0_2 = C2.*h2r0.*h2r0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tworzenie grafiki

% figure
% hold on
% grid on
% grid minor
% 
% for i=1:il
%     if i == 1
%         w(1) = sigmf(h2, [-a c(1)]);
%     elseif i == il
%         w(il) = sigmf(h2, [a c(il-1)]);
%     else
%         w(i) = dsigmf(h2, [a c(i-1) a c(i)]);
%     end
% end
 end
