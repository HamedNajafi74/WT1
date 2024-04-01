classdef Ex_1_V47
    properties
        % Generator Prperties
        Un=690;     % Generator nomial stator voltage Volt
        fn=50;         % Generator nomial frequency in Hz
        p=4;            % Generator number of poles
        Pn=660;     % Generator rated power output in kW
        Wg=2980;    % Generator Weight in kg
        JG=28;          % Generator Rotational Momentum of Inertia in kg.m^2
        Rs=0.0048;  % Generator stator Resistance in ohm
        Xls=0.068;      % Generator stator Leakage Reactance in ohm
        Rrp=0.0040;     % Generator Rotor Resistance (referenced to stator) in ohm
        Xlrp=0.0897;    % Generator Rotor Reactance  (referenced to stator) in ohm
        Xm=2.81;        % Generator Magnetizing Reactance in ohm
        LRV=2464;   % Generator Locked Rotor Voltage in Volt
        % GearBox
        ng=52.7;
        % Wind Turbine Properties
        Jt=520000;  % WT Rotational Momentum of Inertia in kg.m^2
        Ks_eq_pu=0.6;   % WT spring coefficient
        Dtg_pu=1.5;     % WT damper coeffciient
        R=47/2;         % WT blades Radious
        c=[0.5176,116,0.4,5,21,0.0068,0.9]; % WT Coefficeints of aerodynamics
        Beta=0; % WT blades angle
    end
    methods
        function wse = wse(obj)
            wse = 2*pi*obj.fn;  % Generator synchronous electrical speed in rad/s
        end
        function wsm = wsm(obj)
            wsm = 2*pi*obj.fn*2/obj.p;  % Generator synchronous mechanical speed in rad/s
        end
        function ns = ns(obj)         % Generator synchronous mechanical speed in rpm 
            ns = 120*obj.fn/obj.p;
        end
        function nr = nr(obj,s)       % Generator Rotor mechanical speed in rpm
            nr = (1-s).*(120*obj.fn/obj.p);
        end
        function k = Nr2Ns(obj)     % Generator Ns/Nr
            k = obj.LRV/obj.Un;
        end
        function lambda=Lambda(obj,wt,Vw)   % WT Lambda
            lambda = (obj.R.*wt)./Vw;
        end
        function cp = Cp(obj,Lambda)    % WT Cp
            invLi = (1./(Lambda+0.08.*obj.Beta))-(0.035./(obj.Beta.^3+1));
            cp = obj.c(7).*(obj.c(1).*(obj.c(2).*invLi-obj.c(3).*obj.Beta-obj.c(4)).*exp(-obj.c(5).*invLi)+obj.c(6).*Lambda);
        end
    end
end

        
            
            
        
    