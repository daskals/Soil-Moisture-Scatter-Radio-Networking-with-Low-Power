function [D,Ptot] = Power_Consumption_calculatorV1_old(R1,R2)
%%
%Power Consumption calculator
%Main reason for power consumption is the branch that consumes power when
%discharge is GND. This is equal to the current consumed at R1 divided by
%the time of out=0; Therefore if I = V/R1 and D = (R1+ R2)/(R1+2*R2) then
%P = I*(1-D)*V and I = (V/R1)*(1-D)

%C = 357e-12;
%Call = ((C .* Cp(index))./(C+Cp(index))+C_series);

Vcc = 2.33;
Vf = 0.25;


D = (R1+ R2)./(R1+2*R2);
Pch = (Vcc^2)./(3*(R1+2*R2)*log(2))*1e6;
Pr1 = ((1-D)*(Vcc^2)./R1)*1e6;
%Pq = 70*Vcc;
Pq = 220;
Pd = (Vf/Vcc)*(Pq+Pch+Pr1);
Pd2 = (Vf/Vcc)*(Pq+Pch);
Ptot = double(Pr1+Pq+Pch);
Ptot2 = Pq+Pd2+Pch;
Ptot3=  double(Pq+Pch);
D=double(D);



end

