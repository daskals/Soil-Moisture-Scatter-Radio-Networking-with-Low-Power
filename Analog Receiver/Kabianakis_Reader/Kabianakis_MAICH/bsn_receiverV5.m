%% MEASURE
instrreset;                                     %This resets all instruments, necessary for thermometer
close all;
clear all;
clc;

DB = 1;
network = isnet();
FREQ_DISP = 0;
PLOT = 0;
TEMP = 1;
HIST = 0;

%%%%%%%%%%%%%% THERMOM. INIT %%%%%%%%%%%%%%%
if(TEMP)
    s1 = serial('/dev/ttyUSB0');                    %Create a serial Object for thermometer
    s1.InputBufferSize = 1024;                      %Set up the Input buffer size for 1024 bytes to avoid reading for long time
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if(DB==1)
    %%%%%%%%%%%%%% DB INIT %%%%%%%%%%%%%%%%%%%%%
    addpath(fullfile(pwd, 'src'));                  % set path
    javaaddpath('lib/mysql-connector-java-5.1.6/mysql-connector-java-5.1.6-bin.jar');
    import edu.stanford.covert.db.MySQLDatabase.*; % import classes
    try                                            % create database connection
        db = MySQLDatabase('147.27.70.19', 'blase_MAIX', 'maih_user', 'maihDB_bl@se');
    catch err
        disp('DB UNREACHABLE');
        close(db)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



calibrator2pointV2;                             %Invoke the calibrator script in order to load vectors:
%f_centers_BS_all,
%bw_BS_all
%polyonyms_BS_all
%Necessary for converting
%freq to RH

%%%%%%%%%%%%% CONSTANTS %%%%%%%%%%%%%%%%%
F_ADC = 200e3;                                  %Sampling Rate
DEC = 1;                                        %Decimation (USRP1)
Fs = F_ADC/DEC;                                 %Sampling Rate after Decimation
Ts = 1/Fs;                                      %Sampling Time

ResolutionCFO = 1;                              %CFO Resulution in Hz
N_FCFO = Fs/ResolutionCFO;                      %CFO Points for FFT
F_axisCFO = -Fs/2:Fs/N_FCFO:Fs/2-Fs/N_FCFO;     %Freq Axis for CFO

ResolutionEST = 1;                              %Same as CFO but for FFT for estimation
N_FEST = Fs/ResolutionEST;
F_axisEST = -Fs/2:Fs/N_FEST:Fs/2-Fs/N_FEST;

WORKING_NODES = [1 2 3 4 5 6 7 8 10 11 12];     %Vector with selected nodes that operate good :)

SUB_CENTERS = f_centers_BS_all;                 %Center frequencies for 55%RH resulted from calibrator script
SUB_BW = 1500;                                   %Bandwidths of all sensors
FILTER_BW = 500;                                %Bandwidth of the dynamic filter
N_SENSORS = length(SUB_CENTERS);                %Number of sensors (this is not used later)
RH_CACHE = 1;                                   %Cache for saving in memory before appending to file
HIST_SIZE = 600;                                  %Number of freq estimation values before histogram for estimation of prevailing freq.
FOLDER = '../Measurements/FieldMeasurements/';  %Base folder for saving data
MEASUREMENTS_TO_RESET_FILTER = 10;               %Number of measurements to reset the dynamic filter settings

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%











%%%%%%%%%%%%% VECTORS, USRP INIT %%%%%%%%%%%%
fi = fopen('../usrp_fifo', 'rb');               %Open FIFO from gnu-radio companion
t_sampling = 1.2 ;                                %Sampling time in seconds
N_samples = round(Fs*t_sampling);               %Numper of samples taken
t = 0:Ts:t_sampling-Ts;                         %Time vector
usrp_counter = 0;                               %Counter for data received from USRP
packets = 0;                                    %Packets actually received from USRP after software decimation
measurements = 0;                               %Measurements after HIST_SIZE packets
hour_prev = -1;                                  %hour counter to detect when an hour passed to append to file
month_prev = -1;
year_prev = -1;
F_sense_hist = zeros(N_SENSORS,HIST_SIZE);      %Initialize the vector that saves freq measurements for weighted average
RH_hist = zeros(RH_CACHE, N_SENSORS);            %Initialize the vector that saves the RH measurements for appending to file after every hour
F_hist = zeros(RH_CACHE, N_SENSORS);             %Initialize the vector to save f_val
time_vector = zeros(RH_CACHE, 3);                %Initialize the vector to save time (5 -> year,month,day,hour,min)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










while(1)
    
    
    
    %%%%%%%%%%%%%%% READ FIFO  %%%%%%%%%%%%%
    x = fread(fi, 2*N_samples, 'float32');      % get samples (*2 for I-Q)
    x = x(1:2:end) + j*x(2:2:end);              % deinterleaving
    usrp_counter = usrp_counter + 1;            %Accumulate the number of packets received by USRP
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    %%%%%%%%%%%%%% PROCESSING %%%%%%%%%%%%%%
    if mod(usrp_counter, 1) == 0                %Drop packets in case processing is slower than sampling
        
        
        %%%%%%%%%%% CFO COMPENSATION %%%%%%%%%%
        x_fft = fftshift(fft(x, N_FCFO));       %FFT for estimation of carrier
        [mval mpos] = max(abs(x_fft));          %Locate carrier by finding the maximum peak
        DF_est = F_axisCFO(mpos);               %Find the deviation from frequency
        x_corr = x.*exp(-j*2*pi*DF_est*t).';    %Compensate CFO by multiplying the signal in the time domain with e^(-2*j*pi*DF*t)
        x_corr_fft = fftshift(fft(x_corr, N_FEST));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
        
        
        
        
        
        
        
        %%%%%%%%%%% SUBCARRIER ESTIMATION %%%%%%%%%
        x_sensor_fft = fftshift(fft(x_corr, N_FEST));           %Calculate the FFT of the corrected signal
        
        
        %%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%
        if(PLOT)
            figure(1)
            semilogy(F_axisEST(F_axisEST > 37000), abs(x_sensor_fft(find(F_axisEST > 37000))).^2)
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        packets = packets + 1;                              %Accumulate number of packets received
        
        for ii = WORKING_NODES                                  %run for all working nodes
            
            
            SUB_BW = bw_BS_all(ii)./2;
            %%%%%%%%%%% BAND PASS FILTER %%%%%%%%%%%
            LEFT = SUB_CENTERS(ii) - SUB_BW;                %Left bound
            RIGHT = SUB_CENTERS(ii) + SUB_BW;               %Rifht bound
            x_sensor_fft = x_corr_fft;
            x_sensor_fft(F_axisEST < -RIGHT) = 0;               %Zero out all that is left and right from the frequency band of ith sensor
            x_sensor_fft(F_axisEST > RIGHT) = 0;
            x_sensor_fft(abs(F_axisEST) < LEFT) = 0;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            
            
            
            %%%%%%%% SINGLE FREQ ESTIMATION %%%%%%%
            [mval mpos] = max(abs(x_sensor_fft).^2);            %Find find max from periodogram
            F_sensor_power = round(mval);                       %Find power (unused right now)
            F_sensor_est = round(abs(F_axisEST(mpos)));         %Find max position in F_axis
            F_sense_hist(ii,packets) = F_sensor_est;            %Save to F_sense_hist vector
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if(FREQ_DISP == 1)
                disp(sprintf('ID=%d F=%d Power=%ld\n',ii,F_sensor_est,F_sensor_power));
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        disp(packets)
        
        %%%%%%%%%%%%%%%% RH ESTIMATOR %%%%%%%%%%%%%
        
        if(mod(packets,HIST_SIZE) == 0)                         %When packet number reaches HIST_SIZE (default 60) calculate the weighted average and save
            
            
            %%%%%%%%%%%%%% READ TEMPERATURE %%%%%%%%%%%%%%
            if(TEMP)
                fopen(s1)
                while(s1.BytesAvailable > 0)
                    fread(s1,s1.BytesAvailable);
                end
                str = fscanf(s1);
                temperature = str2num(str);
                disp(sprintf('Temperature = %2.2f', temperature));
                fclose(s1)
            else
                temperature = 25;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%%%%%%%% NETWORK CHECK %%%%%%%%%%%%%%%%%%%
            %             if(isnet == 1)
            %                 if(network == 0)
            %                     close(db);
            %                     clear(db);
            %
            %                     try                                            % create database connection
            %                         db = MySQLDatabase('147.27.70.19', 'blase_MAIX', 'maih_user', 'maihDB_bl@se');
            %                     catch err
            %                         disp('DB UNREACHABLE');
            %                         close(db)
            %                     end
            %                 end;
            %                 network = 1;
            %             else
            %                 disp('Network connectivity error')
            %                 network = 0;
            %             end
            network = isnet();
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            if(DB==1 && network == 1)
                %%%%%%%%%%%%% UPLOAD TEMPERATURE %%%%%%%%%%%%%
                query_string_temp = sprintf('INSERT INTO Temperature_maih (ID_meas, timestamp,node_ID,temperature,raw_temperature) VALUES (DEFAULT,DEFAULT,99,%2.2f,%2.2f)',temperature,temperature);
                try
                    db.prepareStatement(query_string_temp);
                    db.query;
                catch err
                    disp('DB CONNECTIVITY ERROR..');
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
            
            
            
            
            %%%%%%%%%% CONVERT TO RH AND SAVE/UPLOAD %%%%%%
            measurements = measurements + 1;                    %Accumulate number of measurements
            for node_count = WORKING_NODES                      %Run for all working nodes
                
                f_vector = F_sense_hist(node_count,1:packets);          %Select the vector of frequency estimations
                
                if(0)
                    %%%%%%%%%%% HISTOGRAM %%%%%%%%%%%%%
                    %Find the Histogram of the vector of HIST_SIzE measurements in order to
                    %use the bin counts as a weight for the weighted average calulated below
                    %The number of occurances of frequency f(ii) is saved in bin_counts(i)
                    
                    f_min = min(f_vector);                          %Find min value from in the vector of freqs
                    f_max = max(f_vector);                          %Find Max value
                    f_edges = f_min : ResolutionEST: f_max;         %Construct vector for x axis of histogram
                    bin_counts = histc(f_vector,f_edges);           %calculate the histogram and return the bin_counts
                    if(HIST)
                        figure(3);
                        hist(F_sense_hist(node_count,1:packets))
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    
                    
                    
                    
                    %%%%%%%%%%% FILTER OUT ERRORS- CALC FREQ %%%%%%
                    %Assuming that the estimations that have a bin count
                    %smaller that a certain value are erroneous, we select the bins that have a bin
                    %count larger that BIN_COUNT_FILTER If BIN_COUNT_FILTER = 0, no error filter is applied
                    %Then Find the weighted average. Weights are the bin count values
                    
                    BIN_COUNT_FILTER = 1;                                       %the filter described above
                    inds_good = find(bin_counts > BIN_COUNT_FILTER);            %Find indices in bin_counts that pass the filter
                    bin_counts = bin_counts(inds_good);                         %Filter the bins that pass the filter
                    f_edges = f_edges(inds_good);                               %Filter the frequencies that pass the filter
                    f_val = round(sum(f_edges.*bin_counts./sum(bin_counts)));   %Find the weighted average
                    
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                end;
                
                
                if(1)
                    
                    
                    bin_num =  200;
                    bin_window = 100;
                    
                    
                    f_vector = F_sense_hist(node_count,:);
                    %figure(1)
                    %plot(f_vector)
                    
                    
                    [bin_counts, f_bins] = hist(f_vector,bin_num);
                    %figure(2)
                    %stem(f_bins,bin_counts)
                    
                    for(ii = 1:length(bin_counts) - bin_window)
                        
                        bin_sum(ii) = 0;
                        
                        for(jj = ii:ii+bin_window)
                            
                            bin_sum(ii) = bin_sum(ii) + bin_counts(jj);
                            
                        end
                        
                        
                    end
                    
                    [mval mpos] = max(bin_sum);
                    % bin_counts_good = bin_counts(mpos:mpos+bin_window)
                    
                    
                    f_bins_good = f_bins(mpos:mpos+bin_window);
                    f_vector_good = f_vector(f_vector > min(f_bins_good) & f_vector < max(f_bins_good));
                    
                    if(mod(length(f_vector_good),2) == 0)
                        
                        golen = length(f_vector_good) - 21;
                        
                    else
                        golen = length(f_vector_good) - 20;
                    end
                    
                    f_vector_good = sgolayfilt(f_vector_good,3,golen);
                    
                    f_val = mean(f_vector_good);
                    
                    
                    
                end
                
                
                
                
                F_hist(measurements,node_count) = f_val;                    %Save the value in a vector
                
                
                
                
                %%%%%%%%%%% RH calculation %%%%%%%%%%%%%%
                RH = polyval(polyonyms_BS_all{node_count},f_val);           %Find the RH_value from the polyonyms(freq) produced in calibrator script
                if(node_count == 10)
                    RH = RH + 37;
                end
                RH_hist(measurements,node_count) = RH;                      %Save the RH value to a vector
                
                disp(sprintf('ID=%d F=%d VAL=%2.1f\n' ,node_count,f_val,RH));%Display
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                
                %%%%%%%%%% COLLISION DETECTION %%%%%%%%%%
                %Assuming that two sensors should never have the same freq
                %value, we detect if this is confirmed. This could happen
                %if the dynamic filter is moved in a different frequency
                %band. If that is the case then filter settings are reset
                %THIS CAN BE AVOIDED WITH PROPER GUARD BANDS
                
                if(node_count>1)                                          %For the second sensor and on
                    if(f_val_iim1 == f_val);                              %If the previous value of f_val is equal to the current
                        disp('Collision');                                % Display error
                        SUB_CENTERS(ii) = f_centers_BS_all(ii);           % Reset dynamic filter center frequency
                        %SUB_BW = bw_BS_all(ii)./2;                    % Reset BW
                    end
                end
                
                f_val_iim1 = f_val;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                
                %%%%%%%%%% ERROR DETECTION %%%%%%%%%%%%%
                %TODO create a function that detects a change in fval > N%
                %from a previous reading. Assuming that humidity hasnt
                %changed so much from the previous reading, this measurement
                %should be erroneous
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                %%%%%%%% RESET DYNAMIC FILTER %%%%%%%%%%
                % Reset the dynamic filter every once in case it has lost
                % the actual subcarrier
                %if(mod(measurements,MEASUREMENTS_TO_RESET_FILTER))
                %    SUB_CENTERS(ii) = f_centers_BS_all(ii);           % Reset dynamic filter center frequency
                %    %SUB_BW(ii) = bw_BS_all(ii)./2;                    % Reset BW
                %end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                if(DB==1 && network == 1)
                    %%%%%%%%%%%%% DB UPLOAD %%%%%%%%%%%%%%%%
                    %Check network status set up by isnet above
                    query_string_val = sprintf('INSERT INTO humidity_maih (ID_meas, timestamp,node_ID,humidity,raw_humid) VALUES (DEFAULT,DEFAULT,%d,%d,%d)',node_count,RH,f_val);
                    if(node_count == 1)                             %Create the query for the plant sensor data (sensor id 1)
                        query_string_val = sprintf('INSERT INTO ElectricalSignal_maih (ID_meas, timestamp,node_ID,voltageOfPlant,raw_voltage) VALUES (DEFAULT,DEFAULT,1,%d,%d)', RH, f_val);
                    end;
                    try
                        db.prepareStatement(query_string_val);      %Prepare and commit query
                        db.query;
                    catch err
                        disp('DB CONNECTIVITY ERROR');
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
                
                
                %%%%%%%%%%% DYNAMIC FILTER ADJUST %%%%%%%
                SUB_CENTERS(ii) = f_val;                         %Set the center frequency of the filter the last frequ calculated
                SUB_BW = FILTER_BW;                              %Set the filter bandwidth the FILTER_BW constant TODO do this more dynamic
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            end
            
            
            
            
            %%%%%%%%%%%%% TIME STORING %%%%%%%%%%%%%%%
            time_now = clock;                                   %Get current time
            year_now = time_now(1);
            month_now = time_now(2);
            hour_now = time_now(4);                             %Get current Hour
            time_vector(measurements,:) = [time_now(3) ; time_now(4) ; time_now(5)]; %Create time vector
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            
            
            %%%%%%%%%%%% APPEND DATA %%%%%%%%%%%%%
            if(mod(measurements,RH_CACHE) == 0)
                disp('Saving to file..')
                filename = sprintf('%s%d/%d.csv', FOLDER,year_now,month_now)   %Create filename, one file per month, one folder per year
                data = [time_vector F_hist RH_hist temperature];                            %Create vector with all data
                dlmwrite(filename,data,'delimiter',',','-append');              %Save data
                hour_prev = hour_now;                                           %Set the current time to be the curent time :P
                measurements = 0;                                               %Reset the counter of RH_hist, F_hist and time_vector
            end;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            packets = 0;                                        %Reset the packet counter to start F_sense_hist from 1 again
            
            continue;
            
        end
        
    end
    
end
