close all
clear
clc
%%
j=1i;
%% Defining Turbine by class
V47 = Ex_1_V47;
%% Allocating Slip Values
s_percent = -0.65;
s = s_percent./100;
wr =V47.nr(s).*(2*pi/60);       % Generator rotor mechanical speed in rad/s
%% Determining Base Values
wb = V47.wse;
Sb = 660e3; % in VA
Vb = V47.Un;  Vbr = V47.Nr2Ns*Vb;
Ib = Sb/(sqrt(3)*Vb);
Zb = (Vb^2)/Sb;
Lb = Zb/wb;

wmgb = V47.wsm;
wegb = V47.wse;

wtb = wmgb/V47.ng;

Tgb = Sb/wmgb;
Ttb = Sb/wtb;
%% Equvalent Circuit Parameters Per Unit
Rs_pu = V47.Rs / Zb 

Xls_pu = V47.Xls / Zb 
Lls_pu = Xls_pu

Rrp_pu = V47.Rrp / Zb 

Xlrp_pu = V47.Xlrp / Zb 
Llrp_pu = Xlrp_pu

Xm_pu = V47.Xm / Zb 
Lm_pu = Xm_pu 
%% Inertia Constants
Hg = (0.5*V47.JG*(V47.wsm)^2) / Sb 
Ht = (0.5*V47.Jt*(V47.wsm/V47.ng)^2) / Sb