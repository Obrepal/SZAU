clear all;
il = 3;
w = ones(1,il);

%stałe z zadania
alfa1 = 12; alfa2 = 10; C1 = 0.85; C2 = 0.9; tau = 40; T = 1;
kk = 10;


ymax = 150;
ymin = 15;
dy = (ymax-ymin)/il;
a = 0.8;
c = ymin+dy:dy:ymax-dy;

h2r0 = ones(1,il);
h2r0(1) = (c(1)+ymin)/2-1;
h2r0(il) = min((ymax+c(il-1))/2+1, ymax);

h1r0(1) = (alfa2/alfa1)^2*h2r0(1);

if il > 2
    h2r0(2:il-1) = (c(2:il-1)+c(1:il-2))./2;
    h1r0(2:il-1) = (alfa2/alfa1)^2*h2r0(2:il-1);
end

%punkt pracy
V0_1r = C1*[(alfa2/alfa1)^2*h2r0].^2; V0_2r = C2.*h2r0.*h2r0;


V1(1:kk)=ones(1,kk);
V2(1:kk)=ones(1,kk);
Flin(1:kk)= ones(1,kk);
FD(1:kk)= ones(1,kk);
h2(1:kk)= ones(1,kk);
Flin(1:tau+1) = 73;
FD(1:tau+1) = 18;
V1(1:tau+1) = 0.85*((73 + 18)/12)^4;
V2(1:tau+1) = 0.85*((73 + 18)/12)^4*0.9/0.85*(12/10)^4;






w = ones(1,il);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%figure
%hold on 


for value=109:-18:37
    Flin(50:kk) = value;
    for k=tau+2:kk
        for r = 1:il
            V0_1=V0_1r(il);
            V0_2=V0_2r(il);
%             
%             
            V1(k) = V1(k-1) + T*(Flin(k-tau-1) + FD(k-1) - alfa1*((V0_1/C1).^0.25 + (V1(k-1)-V0_1)/(4*C1*(V0_1/C1).^0.75)));
            V2(k) = V2(k-1) + T*(alfa1*((V0_1/C1).^0.25 + (V1(k-1)-V0_1)/(4*C1*(V0_1/C1).^0.75)) - alfa2*((V0_2/C2).^0.25 + (V2(k-1)-V0_2)/(4*C2*(V0_2/C2).^0.75)));
            h2(k) = sqrt(V0_2/C2) + (V2(k)-V0_2)/(2*C2*sqrt(V0_2/C2));
            
%             %wagi
%             if r == 1
%                 w(1) = sigmf(h2r0(il), [-a c(1)]);
%             elseif r == il
%                 w(il) = sigmf(h2r0(il), [a c(il-1)]);
%             else
%                 w(r) = dsigmf(h2r0(il), [a c(r-1) a c(r)]);
%             end
        end
%         %do rozbudowy
% %         V1 = w*V1;
% %          V2) = w*V2;
    %stairs(1:kk, h2(1:kk), '--');

    end
end
