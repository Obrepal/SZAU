function [w] =poziomy_aktywacji(il, h2)
%funkcja wyznaczająca poziomy aktywacji poszczególnych reguł (= modeli lokalnych)

    %przedział
    ymax = 150;
    ymin = 15;
    %długość zbioru
    dy = (ymax-ymin)/il;
    %wartości parametrów sigmf
    a = 0.8;
    c = ymin+dy:dy:ymax-dy;

    for i=1:il
        if i == 1
            w(1) = sigmf(h2, [-a c(1)]);
        elseif i == il
            w(il) = sigmf(h2, [a c(il-1)]);
        else
            w(i) = dsigmf(h2, [a c(i-1) a c(i)]);
        end
    end
end
