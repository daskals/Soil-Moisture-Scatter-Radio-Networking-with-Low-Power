
%Daskalakis Spiros
% rtl Sdr code  SNR

close all;
%clear all;
clc;

%Fs = 250e3;
Fs = 1e6;

Ts = 1/Fs;

Resolution = 1; % in Hz
N_F = Fs/Resolution;
F_axis = -Fs/2:Fs/N_F:Fs/2-Fs/N_F;


SUB_CENTER = [39.4e3];
SUB_BW = 1.5e3;

%%
fi = fopen('usrp_fifo', 'rb');

t_sampling = 0.5 ;      % seconds
N_samples = round(Fs*t_sampling);

t = 0:Ts:t_sampling-Ts;

counter = 0;
packets = 0;

HIST_SIZE = 50;

F_sense_hist = zeros(HIST_SIZE,1);

hists = 0;

flag=1

while(1)
    
    
    x = fread(fi, 2*N_samples, 'float32');   % get samples (*2 for I-Q)
    x = x(1:2:end) + j*x(2:2:end);           % deinterleaving
    counter = counter + 1;
    
   
    
    if mod(counter,2) == 0
        
        
         
        packets = packets + 1;
        
        
        
        % fft
        x_fft = fftshift(fft(x, N_F));
        
        % cfo estimate
        [mval mpos] = max(abs(x_fft));
        
        DF_est = F_axis(mpos);
        
        % cfo correction
        x_corr = x.*exp(-j*2*pi*DF_est*t).';
        
        % corrected cfo
        x_corr_fft = fftshift(fft(x_corr, N_F));
        
        
        
        % sensor's fft
        
        LEFT = SUB_CENTER - SUB_BW;
        RIGHT = SUB_CENTER + SUB_BW;
        
        x_sensor_fft = x_corr_fft;
        x_sensor_fft(F_axis < -RIGHT) = 0;
        x_sensor_fft(F_axis > RIGHT) = 0;
        x_sensor_fft(abs(F_axis) < LEFT) = 0;
        
        
        
        %covert to Db
        %FFT_sensor_db=20*log10(abs(x_sensor_fft)); 
        
       
         
       if (flag==1)
           
           x_sensor_fft_sign= x_sensor_fft;
           p_signal_f = sum(abs(x_sensor_fft_sign).^2)./length(x_sensor_fft_sign);
           
       elseif (flag==2)
           x_sensor_fft_noise= x_sensor_fft;
           p_signal_n = sum(abs(x_sensor_fft_noise).^2)./length(x_sensor_fft_noise);
        
       end
        
     
        
        
        
        
        %find subcarrier
        [mval mpos] = max(abs(x_sensor_fft));
        
        %find senror subcarrier  possition on the F axis
        F_sensor_est = abs(F_axis(mpos));
        
        %find power of subcarrier in dBm 
        F_sensor_est_power=10*log10((abs(mval).^2)*Ts); 
        
        %print  Data  Sensor
                 
        fprintf('N=%d|F=%5.1f|Power=%7.1f\n',packets,F_sensor_est,F_sensor_est_power) 
        
        %
      
        
       
        F_sense_hist(packets) = F_sensor_est;
        
        
        
        if 1
            % plot
            figure(1);
            %subplot(2, 1, 1);
            %plot(t, real(x_corr));
            hold on;
            %plot(t, imag(x_corr), 'g--');
            hold off;
            drawnow;
            %subplot(2, 1, 2);
             semilogy(F_axis, (abs(x_corr_fft).^2));
            %semilogy(F_axis, x_corr_fft_dBm)
            grid on;
            axis tight;
            drawnow;
        end
        
        if(mod(packets,HIST_SIZE) == 0)
            
            %useful_signal=p_signal_f-p_signal_n;
            
            %SNR_freq = 10*log10(useful_signal./p_signal_n)
          
            return;
            
            
        end
        
    end 
    
    
end





