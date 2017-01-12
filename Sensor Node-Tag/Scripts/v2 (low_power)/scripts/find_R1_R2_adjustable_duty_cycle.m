%Spiros Daskalakis 7/6/2014
%vriskei tin sxesi metaxi tis R1 kai ths R2 gia dedomeno dutty cicle
%_____________________________________________________________________
%R1max(ii) = round(Rtot(ii)/5)         % gia 60%
%R2min(ii) = 2*R1max(ii)
      
%R1max(ii) = 2*R2min(ii);
%R2min(ii) = round(Rtot(ii)/4);         %gia 70%  
%_____________________________________________________________________
function [ R1max ,R2min] = find_R1_R2_adjustable_duty_cycle(RTOTAL,Duty)

    matr= solve('R1+2*R2= RTOTAL',  '((R1+R2)/(R1+2*R2))=Duty', 'R1', 'R2');
    R1 = subs(matr.R1,{'RTOTAL','Duty'},[RTOTAL,Duty]);
    R2 = subs(matr.R2,{'RTOTAL','Duty'},[RTOTAL,Duty]);
    
      R1max = round(R1)  ;     
      R2min =R2 ;
end

