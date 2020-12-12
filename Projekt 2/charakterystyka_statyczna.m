clear all;

alfa1 = -1.262719; alfa2 = 0.329193;
beta1 = 0.039291; beta2 = 0.027184;

u = -1:0.01:1;
for i=1:length(u)
    y(i) = g2((beta1+beta2)*g1(u(i))/(1+alfa1+alfa2));
end

plot(u, y, 'b');
grid on;
xlabel('u');
ylabel('y');

function g1_out = g1(u)
    g1_out = (exp(5.5*u)-1)/(exp(5.5*u)+1);
end

function g2_out = g2(x1)
    g2_out = 1 - exp(-2.5*x1);
end