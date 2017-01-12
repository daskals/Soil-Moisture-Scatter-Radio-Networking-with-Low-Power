function [Ptot3] = Power_Consumption_calculator(R2)
%%
%Power Consumption calculator
%Main reason for power consumption is the branch that consumes power when
%discharge is GND. This is equal to the current consumed at R1 divided by
%the time of out=0; Therefore if I = V/R1 and D = (R1+ R2)/(R1+2*R2) then
%P = I*(1-D)*V and I = (V/R1)*(1-D)

%C = 357e-12;
%Call = ((C .* Cp(index))./(C+Cp(index))+C_series);

Vref = 1.8;
Vf = 0.135;
Vcc = Vref+Vf;
Iref = 5;
I555 = 4.24;
Iq = Iref+I555;


Pch = (Vcc^2)./(3*(2*R2)*log(2))*1e6;

Pq = Iq*Vcc;
Ptot = Pq+Pch;
Ptot3=  double(Pq+Pch);




end

