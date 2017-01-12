clear all
close all
clc


SERIES_CAP_ON = 0;

CH_default =  1400e-12;
CL_default = 850e-12;


%C_series = (CH_default+CL_default)/2;
C_series = 100e-12;
if(SERIES_CAP_ON)
    CH = (CH_default*C_series)/(CH_default + C_series);
    CL = (CL_default*C_series)/(CL_default + C_series);
else
    CH = CH_default;
    CL = CL_default;
end


Bi = 5e3;
Bguard = 5e3;
Step = Bi+Bguard;
% Fi = 50e3:Step:100e3 - Step;

Fi = 30e3:Step:60e3 - Step
% Fi = 50e3

%Parallel Capacitor
system = solve('F = 1/(R*(Cp+CH)*ln(2))', 'B = ((1/(R*(Cp+CL)*ln(2))) - (1/(R*(Cp+CH)*ln(2))))', 'R', 'Cp')


for ii = 1 : length(Fi)
    
    Cp_temp = subs(system.Cp,{'B','F','CH','CL'},[Bi,Fi(ii),CH,CL]);
    
    Cp(ii) = double(Cp_temp(Cp_temp>0));
    
    Rt = subs(system.R,{'B','F','CH','CL'},[Bi,Fi(ii),CH,CL]);
    R(ii) = double(Rt(Rt>0));
    
end;


total_sensors = length(R)



%In order to have DC <= 60% then R1 <= R2/2
% Moreover , in order to keep things balanced we assume that R1 >= 1e3
Rtot = round(double(R))


for(ii = 1: length(R))
    
    R1max(ii) = round(Rtot(ii)/5);
    R2min(ii) = 2*R1max(ii);
%     
%     R2min(ii) = round(Rtot(ii)/4);
%     R1max(ii) = 2*R2min(ii);
%     

end

%capacitors in pF
Cp_round = round(Cp.*1e12)./1e12;

%Always first check for R2 availability then based on your buys calculate R1!!

R2min_round = (ceil(R2min/200))*200;
R1max_round = round2((Rtot - 2.*R2min_round),10);

error_R = abs((R1max_round + 2*R2min_round) - R);
error_Cp = abs(Cp_round - Cp)*1e12;




All_array = [R1max_round; R2min_round; Cp*1e12]'

% dlmwrite('caps_res_60pDC.csv',All_array,'delimiter',';')
% fid = fopen('caps_res_60pDC.csv', 'at');
% fprintf(fid, 'R1max ; R2min ; Cp ');
% fclose(fid);
%%

%Power Consumption calculator
%Main reason for power consumption is the branch that consumes power when
%discharge is GND. This is equal to the current consumed at R1 divided by
%the time of out=0; Therefore if I = V/R1 and D = (R1+ R2)/(R1+2*R2) then
%P = I*(1-D)*V and I = (V/R1)*(1-D)

R2 = R2min_round(1)
R1 = R1max_round(1)
index = 10;
C = 357e-12;
%Call = ((C .* Cp(index))./(C+Cp(index))+C_series);

Vcc = 2.33;
Vf = 0.25;


D = (R1+ R2)./(R1+2*R2)
Pch = (Vcc^2)./(3*(R1+2*R2)*log(2))*1e6
Pr1 = ((1-D)*(Vcc^2)./R1)*1e6
Pq = 70*Vcc;
Pd = (Vf/Vcc)*(Pq+Pch+Pr1);
Pd2 = (Vf/Vcc)*(Pq+Pch);
Ptot = Pr1+Pq+Pd+Pch
Ptot2 = Pq+Pd2+Pch
Pq=222.3

Ptot3 = Pq+Pch

return


%%

%Capacitance at 50khz, 40%RH is 325pF, if sensitivity = 0.6pF/%RH
%Equation: y = 0.6x + 301 (1)

%capacitance at 80khz, 55%R 330pF, if sensitivity = 0.6pF/%RH
%equation: y = 0.6x + 297 (2)

% We consider Rmin = 10% and Rmax 100%, then
% (1) for 50kHz



index = 1;

R1 = R1max_round(index);
R2 = R2min_round(index);




RH = 0:100-1;

C = (0.6*RH + 297)*1e-12;
C2 = Cp(index);

%Cp = 350e-12
%Call = C + Cp;
Call = ((C .* C2)./(C+C2)+C_series);

F = 1./((R1+2*R2).*(Call)*log(2));


y1 = RH(1);
y2 = RH(end);

x1 = F(1);
x2 = F(end);

x = linspace(F(1), F(end), 100);

y = (((y2 - y1)/(x2 - x1)).*(x - x1)) + y1 ;

plot(F,RH, x, y)






%%

Crh = 330e-12;
R1 = 4870;
R2 = 10e3;
Cs = 330e-12;
Cp = 600e-12;
Csall = (Cs*Crh)/(Cs+Crh);
Call = Csall + Cp
R = R1+2*R2;
F = 1/(R*Call*log(2))
Fm = 60e3;

C = 1/(log(2)*R*Fm)












