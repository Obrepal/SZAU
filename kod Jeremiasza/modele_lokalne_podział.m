 
   %podział na liczbę zbiorów
    il = 5;
   %przedział 
    ymax = 150;
    ymin = 15;
    %długość zbioru
    dy = (ymax-ymin)/il;
    %wartości parametrów sigmf 
    a = 0.8;
    c = ymin+dy:dy:ymax-dy;
    
    %środki przedziałów zaznaczone ko na wykresach 
    h2r0 = ones(1,il);
    h2r0(1) = (c(1)+ymin)/2-1;
    h2r0(il) = min((ymax+c(il-1))/2+1, ymax);
    if il > 2
        h2r0(2:il-1) = (c(2:il-1)+c(1:il-2))./2;    
    end    
    %tworzenie grafiki 

        figure
        hold on
        grid on
        grid minor 
        for r = 1:il
            if r == 1
               plot(ymin:0.1:ymax, sigmf(ymin:0.1:ymax , [-a c(1)]))
           elseif r == il
               plot(ymin:0.1:ymax,sigmf(ymin:0.1:ymax , [a c(il-1)]))
            else
               plot(ymin:0.1:ymax,dsigmf(ymin:0.1:ymax, [a c(r-1) a c(r)]))
            end
        end
        plot(h2r0, ones(1,il), 'ko')
        xlabel('h2')
       axis([15 150 0 1.02])
       ylabel('przynależność')
       xlabel('h_2 [cm]')
       
        print("przy5","-dpng","-r400")