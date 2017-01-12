%Spiros Daskalakis 
%8/6/2014

clear all
close all
clc

SERIES_CAP_ON = 0;

% CH_default = 357e-12;
% CL_default = 297e-12;


%gia net 40 tags
%  CH_default =83e-12;
%  CL_default =4.3e-12;


 CH_default =83e-12;
 CL_default =4.3e-12;


%C_series = 170e-12;
if(SERIES_CAP_ON)
    CH = (CH_default*C_series)/(CH_default + C_series);
    CL = (CL_default*C_series)/(CL_default + C_series);
else
    CH = CH_default;
    CL = CL_default;
end


Bi = 1.5e3;
Bguard = 1e3;
Step = Bi+Bguard;

%Fi = 300e3:Step:900e3 - Step 


Fi = 100e3:Step:200e3 - Step 
%Parallel Capacitor
system = solve('F = 1/(R*(Cp+CH)*ln(2))', 'B = ((1/(R*(Cp+CL)*ln(2))) - (1/(R*(Cp+CH)*ln(2))))', 'R', 'Cp')

for ii = 1 : length(Fi)
    Cp_temp = subs(system.Cp,{'B','F','CH','CL'},[Bi,Fi(ii),CH,CL]);
    Cp(ii) = double(Cp_temp(Cp_temp>0));
    
    Rt = subs(system.R,{'B','F','CH','CL'},[Bi,Fi(ii),CH,CL]);
    R(ii) = double(Rt(Rt>0));
    
end;
total_sensors = length(R)
%Rtot = round(double(R));
%Rtot = round(R);
Rtot = R;
for(ii = 1: length(R))

    R2min_round(ii) = Rtot(ii)/2;
  
end

%capacitors in pF
%Cp_round = round(Cp.*1e12)./1e12;
Cp_round = (Cp.*1e12)./1e12;

%R2min_round = (ceil(R2min/200))*200;

error_R = double(abs((2*R2min_round) - R));
error_Cp = abs(Cp_round - Cp)*1e12;
All_array = double([ R2min_round; Cp*1e12]')





R2=All_array(1,1);
C1=All_array(1,2); 
C1=C1*10^(-12);

Csen=CL_default :5e-12: CH_default;

if(SERIES_CAP_ON)
    
CL = (Csen*C_series)./(Csen + C_series);
else
CL = Csen ;
end


Call=C1+CL;
R = 2*R2;

Ftel = 1./(R*Call*log(2))

figure
subplot(3,1,1)
plot (CL*1e12,Ftel/1000)
xlabel('Csensor+Cparallel')
ylabel('Freq')

subplot(3,1,2)
plot(Csen*1e12,Ftel/1000)
xlabel('Csensor')
ylabel('Freq')

subplot(3,1,3)
plot(Call*1e12,Ftel/1000)
xlabel('Csum')
ylabel('Freq')














