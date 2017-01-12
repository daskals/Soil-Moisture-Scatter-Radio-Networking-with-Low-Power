close all
clear all
clc

reader_file = 'reader_e_20_t_116_r.mat'
counter_file = 'real_e_20_t_116_r.mat'


load(sprintf('/Users/eleftherioskampianakis/Documents/Everything/Dropbox/Work/TUC/TelecomLab/Projects/Backscatter/BackscatterHumiditySensor/Data/RangeData/%s',reader_file));
time_vector_reader = time_vector;



load(sprintf('/Users/eleftherioskampianakis/Documents/Everything/Dropbox/Work/TUC/TelecomLab/Projects/Backscatter/BackscatterHumiditySensor/Data/RangeData/%s',counter_file));
time_vector_f320 = time_vector;

%%

fs_f320 = 60/120;

minute_prev = -1;

seconds = zeros(1,length(time_vector_f320))
minutes = zeros(1,length(time_vector_f320))
for(ii = 1:length(time_vector_f320))    
    
    minutes(ii) = time_vector_f320{ii}(3);
    minute_now = minutes(ii);    
    
    
    
    if(minute_now ~= minute_prev)
        
        seconds(ii) = 0;
        
        minute_prev = minute_now;
        
        continue;
    end
    seconds(ii) = seconds(ii-1) + fs_f320;
       
end
% seconds = ceil(seconds)
time_all_f320 = [minutes ; seconds]
time_merged_f320 = minutes*60+ ceil(seconds);

minute_prev = -1;

seconds = zeros(1,length(time_vector_reader))
minutes = zeros(1,length(time_vector_reader))

fs_reader = 1;

for(ii = 1:length(time_vector_reader))    
    
    minutes(ii) = time_vector_reader{ii}(3);
    minute_now = minutes(ii);    
    
    
    
    if(minute_now ~= minute_prev)
        
        seconds(ii) = 0;
        
        minute_prev = minute_now;
        
        continue;
    end
    seconds(ii) = seconds(ii-1) + fs_reader;
       
end


time_all_reader = [minutes ; seconds]
time_merged_reader = minutes*60 + seconds;


[time_common, inds_f320 ,inds_reader] = intersect(time_merged_f320,time_merged_reader);

freqs_f320_good = freqs(inds_f320)+5;
freqs_reader_good = F_sense_hist(inds_reader);


plot(1:length(freqs_reader_good), freqs_reader_good, 1:length(freqs_f320_good), freqs_f320_good)


rms = (mean(sqrt((freqs_reader_good' - freqs_f320_good).^2))/2000)*100


