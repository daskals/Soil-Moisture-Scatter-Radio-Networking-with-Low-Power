
%Daskalakis Spiros
% rtl Sdr code  SNR

close all;
clear all;
clc;

F_ADC = 2500e3;
DEC = 1;
Fs = F_ADC/DEC;
Ts = 1/Fs;

ResolutionCFO = 1; % in Hz
N_FCFO = Fs/ResolutionCFO;



%%
fi = fopen('usrp_fifo', 'rb');
N_samples = 100000;


    
   while(1)
    x = fread(fi, 2*N_samples, 'float32');   % get samples (*2 for I-Q)
    
    x = x(1:2:end) + j*x(2:2:end);% deinterleaving
    
    sum(abs(x).^2)/length(x)
   end
    % fft
  
  % energy= p_signal_f*Ts
    
    

    






