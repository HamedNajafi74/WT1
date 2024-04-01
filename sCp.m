L=1:0.1:15;
wsynt = pi*50/52.7;
invLi = 1./L-0.035;
c = [ 0.5176   116     0.4     5       21      0.0068     0.9];
Cp = c(7).*(c(1).*(c(2).*invLi-c(4)).*exp(-c(5).*invLi)+c(6).*L);

figure

plot(L,Cp)
grid on
xlabel('\lambda  Vw')
ylabel('Cp')

Lopt=L(Cp==max(Cp));

Vwopt=23.5*wsynt/Lopt;

hold on 

plot(23.5.*wsynt./L,Cp)

legend('Cp(\lambda)','Cp(Vw)')

xlim([0 20])
ylim([0 0.5])