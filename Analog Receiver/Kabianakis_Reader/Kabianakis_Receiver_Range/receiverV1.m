close all;
clear all;
clc;


F_ADC = 64e6;
DEC = 256;
Fs = F_ADC/DEC;
Ts = 1/Fs;

Resolution = 0.5; % in Hz
N_F = Fs/Resolution;
F_axis = -Fs/2:Fs/N_F:Fs/2-Fs/N_F;


%SUB_CENTERS = [43573, 45791, 46630, 48854, 51781, 53008, 56654, 58316, 59250, 63540, 66044, 67571, 68662, 72050];
SUB_CENTERS = [43573, 45791, 46630, 48854, 51781, 53008, 56654, 58316, 59250,0, 63540,0, 66044, 67571, 68662, 72150];
N_SENSORS = length(SUB_CENTERS);
%N_SENSORS = 1;
SUB_BW = 0.5e3;

%%
fi = fopen('usrp_fifo', 'rb');

t_sampling =1.2 ;      % seconds
N_samples = round(Fs*t_sampling);

t = 0:Ts:t_sampling-Ts;

counter = 0;
packets = 1;



F_sense_hist = zeros(N_SENSORS, 10e3);
time_vector1 = zeros(3,10e3);
time_vector2 = zeros(3,10e3);
while 1
    
     for ii = 1:N_SENSORS
       % for ii = 1:length(SUB_CENTERS)2
        
        while(1)
            
            
            x = fread(fi, 2*N_samples, 'float32');% get samples (*2 for I-Q)
            x = x(1:2:end) + j*x(2:2:end);      % deinterleaving
            counter = counter + 1;
            
            
            
            if mod(counter, 1) == 0
                
                
                time_now = clock;
                time_vector1(1:3,packets) = [time_now(4),time_now(5),time_now(6) ];
                
                
                % fft
                x_fft = fftshift(fft(x, N_F));
                
                % cfo estimate
                [mval mpos] = max(abs(x_fft));
       
                mval
                DF_est = F_axis(mpos);
                
                % cfo correction
                x_corr = x.*exp(-j*2*pi*DF_est*t).';
                
                % corrected cfo
                x_corr_fft = fftshift(fft(x_corr, N_F));
                
                % sensor's fft
                
                LEFT = SUB_CENTERS(ii) - SUB_BW;
                RIGHT = SUB_CENTERS(ii) + SUB_BW;
                
                x_sensor_fft = x_corr_fft;
                x_sensor_fft(F_axis < -RIGHT) = 0;
                x_sensor_fft(F_axis > RIGHT) = 0;
                x_sensor_fft(abs(F_axis) < LEFT) = 0;
                
                
                %find subcarrier
                [mval mpos] = max(abs(x_sensor_fft));
                
                F_sensor_est = abs(F_axis(mpos))
                
                  
                
                
                F_sense_hist(ii,packets) = F_sensor_est;
                
                if 1
                    % plot
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
                
                
                
                break;
                
            end
            
        end
        
        packets = packets + 1;
        
    end
    
 
end

%%
close all
TAB = [;];
figure(2);
hold on
for(ii = [1 2 4 5 6 7 8 11 14 16])

    
    F_temp =  F_sense_hist(ii,:);
    F_temp = F_temp(F_temp~=0 & F_temp~=125000);
    F_res{ii} = F_temp;
    plot(F_res{ii} - SUB_CENTERS(ii) + ii*100);

  

%     TAB(ii,:) = F_res{ii} - SUB_CENTERS(ii);

end
hold off;


