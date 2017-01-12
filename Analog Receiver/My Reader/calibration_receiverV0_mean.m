%% MEASURE
close all;
clear all;



%%%%%%%%%%%%% CONSTANTS %%%%%%%%%%%%%%%%%
F_ADC = 0.250e6;
DEC = 1;
Fs = F_ADC/DEC;
Ts = 1/Fs;

ResolutionCFO = 1; % in Hz
N_FCFO = Fs/ResolutionCFO;
F_axisCFO = -Fs/2:Fs/N_FCFO:Fs/2-Fs/N_FCFO;

ResolutionEST = 1; % in Hz
N_FEST = Fs/ResolutionEST;
F_axisEST = -Fs/2:Fs/N_FEST:Fs/2-Fs/N_FEST;

RH_CACHE = 1;                                   %Cache for saving in memory before appending to file
SUB_CENTERS = [26000];

%LEFT=[0 0 0 277900 280684 284471 0 0]
%RIGTH=[0 0 0 280705 282600 286252 0 0]

N_SENSORS = length(SUB_CENTERS);
%N_SENSORS = 1;
SUB_BW = 3e3;
FILENAME = '../Measurements/measurements_BS';


%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%%
fi = fopen('usrp_fifo', 'rb');

%t_sampling = 0.1;      % seconds
t_sampling = 1;      % seconds
N_samples = Fs*t_sampling;

t = 0:Ts:t_sampling-Ts;

counter = 0;
packets = 1;


%init time variable for saving
hour_prev = 0;
HIST_SIZE = 1500;
%initialize sensor measurements size;
F_sense_hist = zeros(N_SENSORS,HIST_SIZE);
data_time=zeros(3,HIST_SIZE);
Hum_hist = zeros(RH_CACHE, N_SENSORS);            %Initialize the vector that saves the RH measurements for appending to file after every hour
F_hist = zeros(RH_CACHE, N_SENSORS);              %Initialize the vector to save f_val
counter=0
while(1)

    x = fread(fi, 2*N_samples, 'float32');% get samples (*2 for I-Q)
    x = x(1:2:end) + j*x(2:2:end);      % deinterleaving
    counter = counter + 1;
    
    
    %number of packets to drop
    if mod(counter, 1) == 0
        
        
        packets = packets + 1;
        
        % fft
        x_fft = fftshift(fft(x, N_FCFO));
        
        % cfo estimate
        [mval mpos] = max(abs(x_fft));
        
        DF_est = F_axisCFO(mpos);
        
        % cfo corrrection
        x_corr = x.*exp(-j*2*pi*DF_est*t).';
        
        
        
        % sensor's fft
        x_corr_fft = fftshift(fft(x_corr, N_FEST));
        
        
        
        disp(sprintf('%d',packets));
        for ii = 1:length(SUB_CENTERS)
        
            %for ii = 1:length(SUB_CENTERS)
            LEFT = SUB_CENTERS(ii) - SUB_BW/2;
            RIGHT = SUB_CENTERS(ii) + SUB_BW/2;
            
            x_sensor_fft = x_corr_fft;
            x_sensor_fft(F_axisEST < -RIGHT) = 0;
            x_sensor_fft(F_axisEST > RIGHT) = 0;
            x_sensor_fft(abs(F_axisEST) < LEFT) = 0;
            
            
            
            %find subcarrier
            [mval mpos] = max(abs(x_sensor_fft).^2);
            F_sensor_power = round(mval);
            F_sensor_est = round(abs(F_axisEST(mpos)));
            
            disp(sprintf('ID=%d F=%d Power=%ld\n',ii,F_sensor_est,F_sensor_power));
           
            
            c=clock;
            F_sense_hist(ii,packets) = F_sensor_est;
            
            
            data_time(1,packets)=F_sensor_est;
            data_time(2,packets)=c(5);
            data_time(3,packets)=c(6);
            
            if(packets >=600)
            %f_val_mean = mean(F_sense_hist(ii,packets-1),F_sense_hist(ii,packets))
            f_val_mean = mean(F_sense_hist(ii,packets))
            
            end;
           
        end
        
       
        if 1
            figure(1);
           semilogy(F_axisEST, abs(x_corr_fft).^2);
        end;
        
        
        %%%%%%%%%%%%%%%% RH ESTIMATOR %%%%%%%%%%%%%
         %When packet number reaches HIST_SIZE (default 60) calculate the weighted average and save
        
         if(mod(packets,HIST_SIZE) ==0)
            
        return;
        end
        
    end
   
end

