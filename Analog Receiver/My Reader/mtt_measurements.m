
close all;
clear all;
clc;

Fs = 1e6;            %Same as gnuradio
Ts = 1/Fs;

Resolution = 0.5;        % in Hz
N_F = Fs/Resolution;
F_axis = -Fs/2:Fs/N_F:Fs/2-Fs/N_F;

%Subcarrier center Freq
SUB_CENTER = [109000]

PLOT=1;
fig=0;

SUB_BW = 1.5e3;

%%
fi = fopen('rtlfifo', 'rb');

% seconds%t_sampling =1 ;                   % seconds
t_sampling = 0.1;                           % seconds


N_samples = round(Fs*t_sampling);

t = 0:Ts:t_sampling-Ts;

counter = 0;
packets = 0;

HIST_SIZE = 1000;

F_sense_hist = zeros(HIST_SIZE,1);


while(1)
    
    x = fread(fi, 2*N_samples, 'float32');% get samples (*2 for I-Q)
    x = x(1:2:end) + j*x(2:2:end);      % deinterleaving
    counter = counter + 1;
    if mod(counter, 2) == 0
        packets = packets + 1;
        
        % fft
        x_fft = fftshift(fft(x, N_F));
        
        % cfo estimate
        [mval mpos] = max(abs(x_fft).^2);
        
        DF_est = F_axis(mpos);
        
        % cfo correction
        x_corr = x.*exp(-j*2*pi*DF_est*t).';
        
        % corrected cfo
        x_corr_fft = fftshift(fft(x_corr, N_F));
        
        % sensor's fft
         
        for(ii = 1:length(SUB_CENTER))
            LEFT = SUB_CENTER(ii) - SUB_BW;
            RIGHT = SUB_CENTER(ii) + SUB_BW;
            
            x_sensor_fft = x_corr_fft;
            x_sensor_fft(F_axis < -RIGHT) = 0;
            x_sensor_fft(F_axis > RIGHT) = 0;
            x_sensor_fft(abs(F_axis) < LEFT) = 0;
            
            %find subcarrier
            [mval mpos] = max(abs(x_sensor_fft));
            
            F_sensor_est(ii) = abs(F_axis(mpos));
            F_sensor_power = round(mval);
            
             %find power of subcarrier in dBm 
            %F_sensor_est_power=10*log10((abs(mval).^2)*Ts);
            
           fprintf('ID=%d|N=%d|F=%5.1f|Power=%ld\n',ii,packets,F_sensor_est,F_sensor_power)
           id_exp(packets)=ii;
           packets_exp(packets)=packets;
           freq_exp(packets)=F_sensor_est;
           power_exp(packets)=F_sensor_power;
           
        
            if fig
               
                figure(1);
                subplot(2, 1, 1);
                plot(t, real(x_corr));
                hold on;
                plot(t, imag(x_corr), 'g--');
                hold off;
                drawnow;
                subplot(2, 1, 2);
                semilogy(F_axis, abs(x_corr_fft).^2);
                grid on;
                axis tight;
                drawnow;  
            end
            
            if PLOT
                if(ii == 1)
                    figure(1);
                    semilogy(F_axis, abs(x_corr_fft).^2);
                    axis tight;
                end
            end
            
            
        if(mod(packets,HIST_SIZE) ==0)
         save(datestr(now,30))
            return; 
        end
        
        end
               
    end    
   
end




