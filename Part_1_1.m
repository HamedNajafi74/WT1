%close all
clear
clc
%%
j=1i;
%% Defining Turbine by class
V47 = Ex_1_V47;
%% Allocating Slip Values
s_percent = -(0.31:0.1:0.61)';
%s_percent = -(0.2:0.1:0.8)'
%s_percent =-(0:0.1:50)';
s = s_percent./100;
wr =V47.nr(s).*(2*pi/60);       % Generator rotor mechanical speed in rad/s
%% Initializing ciruit parameters
Vsph = V47.Un/sqrt(3);
%% Computing circuit thevenine Impedance
Zth = (V47.Rs+j*V47.Xls)+parallel((j*V47.Xm),(j*V47.Xlrp+(V47.Rrp./s)));
%% Solving and computing current
Isph = Vsph./Zth;
Irp = Isph.*((j*V47.Xm)./((j*V47.Xm)+(j*V47.Xlrp+(V47.Rrp./s))));
Ir = Irp./V47.Nr2Ns;
%% Computing Appearant Power (S=3.V_sph.I_sph*)
S = 3.*Vsph.*conj(Isph)./1e+03; % in kVA
Pgen = -real(S);                  % in kW
Qcons = imag(S);               % in kVAr
pf = cos(angle(S)) ;         % power factor
Pcus = 3.*V47.Rs.*abs(Isph).^2./1e+03; % in kW
Pag = Pgen+Pcus;    % Air Gap Power in kW
Pm = (1-s).*Pag;        % Mechanical power on Generator's shaft in kW
Prot = 0.*Pm;           %considered Zero     % Rotational Power Loss before Generator's shaft in kW
Pt = Prot + Pm ;        % Pwer after GearBox on High-speed shaft in kW
Tm = Pt./wr;            % Torque on High-speed shaft in N.m  ?
Te = Pgen./wr ;            % Eletrical Torque 
%% Plotting and Conclusion 
figure
plot(-s_percent,Pgen,'-b','LineWidth',1.5);
hold on
plot(-s_percent,Pm,'-r','LineWidth',1.5);
grid on
plot(-s_percent,Pm-Pgen,'-k','LineWidth',1.5);
xlabel('-%s') %-1×%s
ylabel('Power (kW)')
dif=abs(V47.Pn-Pgen);
nomial_i=find(dif==min(dif));
x = -1*s_percent(nomial_i);
y = Pgen(nomial_i);
plot(x,y,'xg','MarkerSize',10,'LineWidth',1.5);
txt=['\uparrow Pgen= ',num2str(round(Pgen(nomial_i),3)),', %s= ',num2str(-1*s_percent(nomial_i))];
text(x*0.99,y*0.90,txt,'FontSize',12,'HorizontalAlignment','left','FontName','TimesNewRoman','Interpreter','tex');
legend({'Power Injected to the Grid','Power feeded to the Generator','Power Loss (rot.,cur,cus)','Nearest point to Pn'},'Location','best','FontName','TimesNewRoman');

figure
plot(-s_percent,Tm,'-b','LineWidth',1.5)
grid on
hold on
plot(-s_percent,Te,'-r','LineWidth',1.5)
plot(x,Te(nomial_i),'xr','MarkerSize',10,'LineWidth',1.5);
txt=['\uparrow Te= ',num2str(round(Te(nomial_i),3)),', %s= ',num2str(-1*s_percent(nomial_i))];
text(x*0.99,Te(nomial_i)*0.95,txt,'FontSize',12,'HorizontalAlignment','left','FontName','TimesNewRoman','Interpreter','tex');
xlabel('-%s') %-1×%s
ylabel('Torque (N.m)')
plot(x,Tm(nomial_i),'xb','MarkerSize',10,'LineWidth',1.5);
txt=['Tm= ',num2str(round(Tm(nomial_i),3)) ,' \downarrow'];
text(x*1.01,Tm(nomial_i)*1.1,txt,'FontSize',12,'HorizontalAlignment','right','FontName','TimesNewRoman','Interpreter','tex');

figure
plot(-s_percent,-(pf),'-b','LineWidth',1.5)
grid on
hold on
xlabel('-%s') %-1×%s
ylabel('-1×Cos(\phi)')
y=-pf(nomial_i);
plot(x,y,'xk','MarkerSize',10,'LineWidth',1.5);
txt=[' \uparrow pf= ',num2str(round(y,3)),',%s= ',num2str(-1*s_percent(nomial_i))];
text(x*0.975,y*0.99,txt,'FontSize',12,'HorizontalAlignment','left','FontName','TimesNewRoman','Interpreter','tex');
%% Wind speed iteration for Part1_2
N=30;   %N = iteration count limit
e=0.1; % acceptable Tolerance in Power mismatch for different wind speeds in kW
rho = 1.225; %ρ in kg/m^3
wt = wr./V47.ng; % Turbine mechanical speed in radian/s
wtc = sum(wt)/length(wt);    % Turbine mechanical speed rad/s constant considered

wtc=round(wtc); %rounding wtc number

Vwi=(1000.*Pt./(0.5*rho*V47.R^2*0.7)).^(1/3); % initial guess for Wind speeds in m/s
Vw=Vwi;
flag=zeros(length(Vw),1);
for jj=1:length(Vwi)
    Pi = 0.5*rho*pi*V47.R^2*Vwi(jj)^3*V47.Cp(V47.R*wtc/Vwi(jj))/1000;
    if Pi>Pt(jj)
        Vw(jj) = Vwi(jj)*1.1;
    else
        Vw(jj) = Vwi(jj)*0.9;
    end
    Pf = 0.5*rho*pi*V47.R^2*Vw(jj)^3*V47.Cp(V47.R*wtc/Vw(jj))/1000;
    for ii=1:N
        if abs(Pf-Pt(jj))<e
            flag(jj)=1;
            break
        end
        
        if Pf>Pt(jj)*3
            Pf=Pt(jj)*2;
            Vw(jj)=(1000.*Pf./(0.5*rho*V47.R^2*0.5)).^(1/3);
        elseif Pf<Pt(jj)*0.1
            Pf=Pt(jj)*0.2;
            Vw(jj)=(1000.*Pf./(0.5*rho*V47.R^2*0.5)).^(1/3);
        end
        
        x1=Pi;
        x2=Pf;
        y1=Vwi(jj);
        y2=Vw(jj);
        [Vwi(jj),Vw(jj)]=swap(Vwi(jj),Vw(jj));
        Vw(jj)=(Pt(jj)-x1)*((y2-y1)/(x2-x1))+y1;
        Pi=Pf;
        Pf = 0.5*rho*pi*V47.R^2*Vw(jj)^3*V47.Cp(V47.R*wtc/Vw(jj))/1000;
    end
end
%Vw;
%Cps=V47.Cp(V47.R*wtc./Vw);

figure
Vw_temp=(5:0.1:round(V47.R.*wtc,0));
lambda_temp=(V47.R.*wtc)./Vw_temp;
Cp_temp=V47.Cp(lambda_temp);
plot(Vw_temp,Cp_temp,'-b','LineWidth',1.5);
grid on
hold on
index=find(Cp_temp==max(Cp_temp));
x=Vw_temp(index);
y=Cp_temp(index);
plot(x,y,'xr','MarkerSize',10,'LineWidth',1.5);
txt=[' \downarrow Vw= ',num2str(Vw_temp(index)),', λ= ',num2str(round(lambda_temp(index),1)),', Cp=',num2str(round(Cp_temp(index),2))];
text(x*0.88,Cp_temp(index)+0.05,txt,'FontSize',12,'HorizontalAlignment','left','FontName','TimesNewRoman','Interpreter','tex');
xlabel("Wind Speed (m/s)")
ylabel("Cp")

lambda_cal=(V47.R.*wtc)./Vw;
Cp_cal=V47.Cp(lambda_cal);
stem(Vw,Cp_cal,'+k','MarkerSize',5)
text(Vw,Cp_cal,strcat([' '],[num2str(-s_percent.*10)]),'horiz','left','vert','bottom')


Pcal=(0.5*rho*pi*V47.R^2).*(Vw.^3).*(V47.Cp(V47.R.*wtc./Vw))./1000;

% figure
% plot(Pt,abs(Pt-Pcal),'-b','LineWidth',1.5);
% grid on

%disp(flag)
%% Part1_3 index of nomial condition: nomial_i
Qc=Pgen.*(tan(acos(abs(pf)))-tan(acos(0.97))); % in kVAr
Xc=(V47.Un)^2./(Qc*1e3);      % Xc (Ohm) when bank is Y connected
Cc=(1e3)./((2*pi*V47.fn).*Xc); % in miliFarad
Pgen(nomial_i)
Xc(nomial_i)
Cc(nomial_i)








