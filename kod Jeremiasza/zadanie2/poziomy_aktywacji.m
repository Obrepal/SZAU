function [w] = poziomy_aktywacji(il, h2, modyfikacja_modelu, modyfikacja_regulatora)
%funkcja wyznaczająca poziomy aktywacji poszczególnych reguł

%modyfikacja_modelu = 1 gdy zmodyfikowane funkcje przynależności modelu rozmytego (tylko dla il = 3)
%modyfikacja_modelu = 0 gdy niezmodyfikowane funkcje przynależności modelu rozmytego

%modyfikacja_regulatora = 1 gdy zmodyfikowane funkcje przynależności regulatora rozmytego
%modyfikacja_regulatora =0 gdy niezmodyfikowane funkcje przynależności regulatora rozmytego

    %przedział
    ymax = 150;
    ymin = 15;
    %długość zbioru
    dy = (ymax-ymin)/il;
    %wartości parametrów sigmf
    c = ymin+dy:dy:ymax-dy;

    for i=1:il
        if modyfikacja_modelu == 0 
            a = 0.8;
            if i == 1
                w(1) = sigmf(h2, [-a c(1)]);
            elseif i == il
                w(il) = sigmf(h2, [a c(il-1)]);
            else
                w(i) = dsigmf(h2, [a c(i-1) a c(i)]);
            end
        else
            a = 0.15;
            if i == 1
                w(1) = sigmf(h2, [-a c(1)-12]);
            elseif i == il
                w(il) = sigmf(h2, [a c(il-1)]);
            else
                w(i) = dsigmf(h2, [a c(i-1)-12 a c(i)]);
            end
        end
        if modyfikacja_regulatora == 1
            a = 0.15;
            if i == 1
                w(1) = sigmf(h2, [-a c(1)-12]);
            elseif i == il
                w(il) = sigmf(h2, [a c(il-1)+20]);
            else
                w(i) = dsigmf(h2, [a c(i-1)-12 a c(i)+20]);
            end
        end  
    end
end

