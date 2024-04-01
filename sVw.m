s=-0.006;
Pt=658; % in kW
wsyn = pi*50;
wg = (1-s)*wsyn;
ng=52.7;
wt = wg/ng;
Vw = 10;
N = 200;
e = 1; %kW
c = [ 0.5176   116     0.4     5       21      0.0068     0.9];
for i=1:N
    L = 23.5*wt/Vw;
    invLi = 1/L-0.035;
    Cp = c(7)*(c(1)*(c(2)*invLi-c(4))*exp(-c(5)*invLi)+c(6)*L);
    Pw = 0.5*1.225*pi*(23.5)^2*(Vw)^3/1000;
    Ptcal = Pw*Cp;
    
    if abs(Pt-Ptcal)<=e
        break;
    end
    
    if Ptcal<Pt
        Vw=Vw+0.1;
    else
        Vw=Vw-0.1;
    end
    
end

    
    