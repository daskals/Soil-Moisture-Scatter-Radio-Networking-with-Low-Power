
%%
bin_num = 200;
bin_window = 120;

%%
inds_reader = find(F_sense_hist > 0);
inds_reader = inds_reader(1:end-1);
inds_f320 = find(freqs > 1);
inds_f320 = inds_f320(1:end-1);

f_reader = F_sense_hist(inds_reader);
f_f320 = freqs(inds_f320);

time_merged_f320 = zeros(1,length(f_f320));

for(ii = 1: length(f_f320))
    time_merged_f320(ii) = time_vector_f320{ii}(1)*3600*24 + time_vector_f320{ii}(2)*3600 + time_vector_f320{ii}(3)*60 + floor(time_vector_f320{ii}(4))-95;
end

time_merged_reader = zeros(1,length(f_reader));
for(ii = 1: length(f_reader))
    time_merged_reader(ii) = time_vector_reader{ii}(1)*3600*24 + time_vector_reader{ii}(2)*3600 + time_vector_reader{ii}(3)*60 + floor(time_vector_reader{ii}(4));
end



[time_common, inds_f320_common ,inds_reader_common] = intersect(time_merged_f320,time_merged_reader);
f_f320_common = f_f320(inds_f320_common);
f_reader_common = f_reader(inds_reader_common);

% f_reader_common = sgolayfilt(f_reader_common,21,301);
gain = mean(f_reader_common'./f_f320_common);
% offset = 0; %from rename script

f_f320_common = f_f320_common.*gain + offset;

figure(1)
hold on
plot(f_f320_common);
plot(f_reader_common,'r');
hold off
title 'Before'

mses_before = (f_f320_common' - f_reader_common).^2;
aes_before = (f_f320_common' - f_reader_common)./20;


mse_before = mean(mses_before)
rms_before = sqrt(mse_before)
mae_before = mean(abs(aes_before))




[bin_counts, f_bins] = hist(f_reader_common,bin_num);


for(ii = 1:length(bin_counts) - bin_window)
    
    bin_sum(ii) = 0;
    
    for(jj = ii:ii+bin_window)
        
        bin_sum(ii) = bin_sum(ii) + bin_counts(jj);
        
    end
    
    
end

[mval mpos] = max(bin_sum);


f_bins_good = f_bins(mpos:mpos+bin_window);

f_reader_good = f_reader_common(f_reader_common >= min(f_bins_good) & f_reader_common <= max(f_bins_good));

f_reader_common(f_reader_common < min(f_bins_good) | f_reader_common > max(f_bins_good)) = mean(f_reader_good);

f_reader_good = f_reader_common;

figure(2)
hold on
plot(f_f320_common);
plot(f_reader_good,'r');
hold off
title 'gaussian'


f_reader_good = sgolayfilt(f_reader_good,5,205);

figure(3)
hold on
plot(f_f320_common);
plot(f_reader_good,'r');
hold off
title 'after'

mses_after = (f_f320_common' - f_reader_good).^2;
aes_after = (f_f320_common' - f_reader_good)./20;



% error_percent = (length((find(abs(aes) > 100)) )./length(f_f320_common))*100


mse_after = mean(mses_after)
rms_after = sqrt(mse_after)
mae_after = mean(abs(aes_after))




