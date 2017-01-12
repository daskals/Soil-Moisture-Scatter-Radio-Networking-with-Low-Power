%Spiros Daskalakis 
%8/6/2014

clear all
close all
clc


SERIES_CAP_ON = 0;

 CH_default = 357e-12;
CL_default = 297e-12;

% CH_default =(103e-12);
% CL_default =(35e-12);
%3.26,255

%C_series = (CH_default+CL_default)/2;
C_series = 30e-12;
if(SERIES_CAP_ON)
    CH = (CH_default*C_series)/(CH_default + C_series);
    CL = (CL_default*C_series)/(CL_default + C_series);
else
    CH = CH_default;
    CL = CL_default;
end


Bi = 2e3;
Bguard = 1e3;
Step = Bi+Bguard;
Fi = 30e3:Step:60e3 - Step; % Fi = 50e3:Step:150e3 - Step;
 

%Parallel Capacitor
system = solve('F = 1/(R*(Cp+CH)*ln(2))', 'B = ((1/(R*(Cp+CL)*ln(2))) - (1/(R*(Cp+CH)*ln(2))))', 'R', 'Cp')

for ii = 1 : length(Fi)
    
    Cp_temp = subs(system.Cp,{'B','F','CH','CL'},[Bi,Fi(ii),CH,CL]);
    
    Cp(ii) = double(Cp_temp(Cp_temp>0));
    
    Rt = subs(system.R,{'B','F','CH','CL'},[Bi,Fi(ii),CH,CL]);
    R(ii) = double(Rt(Rt>0));
    
end;


total_sensors = length(R)



% In order to have DC  <= 60% then R1 <= R2/2
% Moreover , in order to keep things balanced we assume that R1 >= 1e3

%Rtot = double(R)
Rtot = round(double(R))

for(ii = 1: length(R))

    [ R1max(ii) ,R2min(ii)] = find_R1_R2_adjustable_duty_cycle(Rtot(ii),0.6);
  
end

%capacitors in pF
Cp_round = round(Cp.*1e12)./1e12;
%Always first check for R2 availability then based on your buys calculate R1!!

R2min_round = R2min;
R1max_round = Rtot - 2.*R2min_round;
% R2min_round = (ceil(R2min/200))*200;
% R1max_round = round2((Rtot - 2.*R2min_round),10);

error_R = double(abs((R1max_round + 2*R2min_round) - R))
error_Cp = abs(Cp_round - Cp)*1e12;

All_array = double([R1max_round; R2min_round; Cp*1e12]')

%%%%%%%%%%%%%%%%%%%%polto for the parallel capasitor
Coll=CL:1e-12:CH;
Res=R1max_round(1)+ 2*R2min_round(1);
f=1./(Res*(Cp(1)+Coll)*log(2));
figure(1)
plot(f/1000,Coll*1e+12)
grid on
xlabel('Frequency (Khz)')
title('Parallel capasitor vs series capasitor');
ylabel('Capasitance (pF)')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import the data
[~, ~, raw] = xlsread('resistors_caps.xlsx','Sheet1','A1:A191');
resistorscaps_res = reshape([raw{:}],size(raw));
clearvars raw;
comersial_res=resistorscaps_res* [1,10 ,100,1000,10000];

[~, ~, raw] = xlsread('resistors_caps.xlsx','Sheet1','B1:B23');
resistorscaps_caps = reshape([raw{:}],size(raw));
clearvars raw;
comersial_caps=resistorscaps_caps* [1,10 ,100,1000,10000];



for i=1:size(All_array,1)
    for j=1:(size(All_array,2)-1)
               
        val=All_array(i,j);
       tmp=abs(comersial_res-val);
        [id idxs] = min(tmp(:));%index of closest value
        closest = comersial_res(idxs); %closest value
         Array_commercial(i,j)=closest;
     end
    
end



for i=1:size(All_array,1)
    
               
      val=All_array(i,3);
       tmp=abs(comersial_caps-val);
        [id idxs] = min(tmp(:));%index of closest value
        closest = comersial_caps(idxs); %closest value
         Array_commercial(i,3)=closest;
     end
    

Array_commercial
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

%C = 357e-12;
%Call = ((C .* Cp(index))./(C+Cp(index))+C_series);




for(ii = 1: length(R))
  
    R2 = R2min_round(ii);
    R1 = R1max_round(ii);
    [D,Ptot3(ii)] = Power_Consumption_calculator(R1,R2);
    [D,Ptot3_old(ii)] = Power_Consumption_calculatorV1_old(R1,R2);
end
Ptot3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
plot(Fi/1000,Ptot3,'-o')
grid on;
%title('Power vs Center Freq')
xlabel('Center Frequency (Khz)')
ylabel('Tag Power Consumtion (uW)')
%legend('V2 low power','V1')



%    R2 = 14.7e3;
%    R1 = 7.32e3;
%   [D,Ptot3] = Power_Consumption_calculator(R1,R2) 
% Vcc = 0.135+1.8;
% Ptot3_praxi=   34.6*Vcc
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












