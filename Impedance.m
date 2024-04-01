close all
clear
clc
%%
j=1i;
%% Defining Turbine by class
V47 = Ex_1_V47;
%% Allocating Slip Values
s_percent = -(0:0.1:5)';
s = s_percent./100;
wr =V47.nr(s).*(2*pi/60);       % Generator rotor mechanical speed in rad/s
%% Initializing ciruit parameters
Vsph = V47.Un/sqrt(3);
%% Computing circuit thevenine Impedance
Zth = (V47.Rs+j*V47.Xls)+parallel((j*V47.Xm),(j*V47.Xlrp+(V47.Rrp./s)));
%% Plotting and Conclusion 
figure
subplot(2,1,1);
plot(-s_percent,abs(1./Zth),'-b','LineWidth',1.5);
ylabel('|Zth| (ohms)')
grid on
subplot(2,1,2); 
plot(-s_percent,angle(1./Zth).*180./pi,'-b','LineWidth',1.5);
xlabel('-%s')
ylabel('<Zth (°)')
grid on
%%
sys_s = tf('s');
sysZth= (V47.Rs+j*V47.Xls)+parallel((j*V47.Xm),(j*V47.Xlrp+(-j*V47.Rrp/sys_s)));
figure
bode(1/sysZth)

%%
s_nom=-0.6117319/100;
Zth_nom = (V47.Rs+j*V47.Xls)+parallel((j*V47.Xm),(j*V47.Xlrp+(V47.Rrp./s_nom)));
Isph_nom = Vsph/Zth_nom; 
3*Vsph*abs(Isph_nom)*cos(angle(Isph_nom))/1000