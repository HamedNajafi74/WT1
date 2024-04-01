% close all
clear
clc
%% Defining Turbine by class
V47=Ex_1_V47;
%% Allocating Lambda
Lambda=1:0.01:14;
%% Computing Cp
cp=V47.Cp(Lambda);
%% Plot
f=figure;
plot(Lambda,cp,'-b','LineWidth',1.5);
while true
    xlabel('\lambda')
    ylabel('Cp')
    grid on
    hold on
    max_i=find(cp==max(cp));
    x = Lambda(max_i);
    y = cp(max_i);
    p=plot(x,y,'xr','MarkerSize',10,'LineWidth',1.5);
    %form='\n  Cp_{opt}= %d';
    txt=['\downarrow Cp_{opt}=',num2str(round(cp(max_i),3)),', \lambda_{opt}=',num2str(Lambda(max_i))];
    text(x*0.99,y*1.1,txt,'FontSize',12,'HorizontalAlignment','left','FontName','TimesNewRoman','Interpreter','tex');
    legend({'Cp(\lambda,\beta = 0)','Cp_{opt}'},'Location','northwest','FontName','TimesNewRoman');
    break;
end
%% Print resualt
fprintf('Optimum point is \n λ= %4.2f and Cp= %5.3f\n',Lambda(max_i),cp(max_i));