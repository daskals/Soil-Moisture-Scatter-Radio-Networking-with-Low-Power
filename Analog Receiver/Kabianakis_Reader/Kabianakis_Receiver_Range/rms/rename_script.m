close all
clear all
clc

data_folder = '/Users/eleftherioskampianakis/Documents/Everything/Dropbox/Work/TUC/TelecomLab/Projects/Backscatter/BackscatterHumiditySensor/Data/PaperMeasurements/'
rms_calcs_script = '/Users/eleftherioskampianakis/Documents/Everything/Dropbox/Work/TUC/TelecomLab/Projects/Backscatter/BackscatterHumiditySensor/Scripts_Data/rangeMeasurementScripts/rms_calcsV3'


cd(data_folder)
delete('data_all.csv')


data_all_latex = [];
experiment_counter = 1;
%%
close all
reader_file = 'reader_e_2_t_134_r_1s.mat'
f320_file = 'real_e_2_t_134_r_1s.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 2 ;
d_tr = 134;
t_window = 1000;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before, mse_after, rms_before, rms_after, mae_before, mae_after];

dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;

%%
close all
reader_file = 'reader_e_2_t_134_r_100ms.mat'
f320_file = 'real_e_2_t_134_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 2 ;
d_tr = 134;
t_window = 100;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
close all
%%
close all
reader_file = 'reader_e_2_t_134_r_10ms.mat'
f320_file = 'real_e_2_t_134_r_10ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 2 ;
d_tr = 134;
t_window = 10;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;

%%
close all
reader_file = 'reader_e_8_t_128_r_1s.mat'
f320_file = 'real_e_8_t_128_r_1s.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 8 ;
d_tr = 128;
t_window = 1000;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_8_t_128_r_100ms.mat'
f320_file = 'real_e_8_t_128_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 8 ;
d_tr = 128;
t_window = 100;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_8_t_128_r_10ms.mat'
f320_file = 'real_e_8_t_128_r_10ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 8 ;
d_tr = 128;
t_window = 10;

offset = -160;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;


%%
close all
reader_file = 'reader_e_16_t_120_r_1s.mat'
f320_file = 'real_e_16_t_120_r_1s.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 16 ;
d_tr = 120;
t_window = 1000;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_16_t_120_r_100ms.mat'
f320_file = 'real_e_16_t_120_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 16 ;
d_tr = 120;
t_window = 100;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_16_t_120_r_50ms.mat'
f320_file = 'real_e_16_t_120_r_50ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 16 ;
d_tr = 120;
t_window = 50;

offset = -32;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_16_t_120_r_25ms.mat'
f320_file = 'real_e_16_t_120_r_25ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 16 ;
d_tr = 120;
t_window = 25;

offset = -135;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_24_t_112_r_1s.mat'
f320_file = 'real_e_24_t_112_r_1s.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 24 ;
d_tr = 112;
t_window = 1000;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_24_t_112_r_100ms.mat'
f320_file = 'real_e_24_t_112_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 24 ;
d_tr = 112;
t_window = 100;

offset = -100;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_24_t_112_r_50ms.mat'
f320_file = 'real_e_24_t_112_r_50ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 24 ;
d_tr = 112;
t_window = 50;

offset = -200;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_32_t_104_r_1s.mat'
f320_file = 'real_e_32_t_104_r_1s.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 32 ;
d_tr = 104;
t_window = 1000;

offset = -240;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_32_t_104_r_100ms.mat'
f320_file = 'real_e_32_t_104_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 32 ;
d_tr = 104;
t_window = 100;

offset = -400;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_52_t_84_r_1s.mat'
f320_file = 'real_e_52_t_84_r_1s.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 52 ;
d_tr = 84;
t_window = 1000;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_52_t_84_r_100ms.mat'
f320_file = 'real_e_52_t_84_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 52 ;
d_tr = 84;
t_window = 100;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%% FOLA
close all
reader_file = 'reader_e_86_t_50_r_1s.mat'
% f320_file = 'real_e_86_t_50_r_1s.mat'

% load(reader_file);
% time_vector_reader = time_vector;

% load(f320_file);
% time_vector_f320 = time_vector;

d_et = 86 ;
d_tr = 50;
t_window = 1000;

% offset = 0;

% run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,1,1,1,1,1,1];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

mse_before = 3510;
mse_after = 65.09;
rms_before = sqrt(mse_before);
rms_after = sqrt(mse_after);
mae_before = 8.13;
mae_after = 3.14;

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_86_t_50_r_100ms.mat'
f320_file = 'real_e_86_t_50_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 86 ;
d_tr = 50;
t_window = 100;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%% FOLA
close all
reader_file = 'reader_e_96_t_40_r_1s.mat'
f320_file = 'real_e_96_t_40_r_1s.mat'

% f320_file = 'real_e_86_t_50_r_1s.mat'

% load(reader_file);
% time_vector_reader = time_vector;

% load(f320_file);
% time_vector_f320 = time_vector;

d_et = 96 ;
d_tr = 40;
t_window = 1000;

% offset = 0;

% run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,1,1,1,1,1,1];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');
mse_before = 10.32;
mse_after = 17.28;
rms_before = sqrt(mse_before);
rms_after = sqrt(mse_after);
mae_before = 0.1;
mae_after = 0.19;

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_96_t_40_r_100ms.mat'
f320_file = 'real_e_96_t_40_r_100ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 96 ;
d_tr = 40;
t_window = 100;

offset = 0;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;
%%
close all
reader_file = 'reader_e_96_t_40_r_25ms.mat'
f320_file = 'real_e_96_t_40_r_25ms.mat'

load(reader_file);
time_vector_reader = time_vector;

load(f320_file);
time_vector_f320 = time_vector;

d_et = 96 ;
d_tr = 40;
t_window = 25;

offset = -140;

run(rms_calcs_script);

data_all = [d_et,d_tr,t_window,mse_before,mse_after,rms_before,rms_after,mae_before,mae_after];
dlmwrite('data_all.csv',data_all,'delimiter',';','-append');

str = [sprintf('$%d$&',experiment_counter),sprintf('$%d$&',d_et),sprintf('$%d$&',d_tr),sprintf('$%d$&',t_window), sprintf('$%7.2f$&',mse_before),sprintf('$%7.2f$&',mse_after),sprintf('$%7.2f$&',rms_before),sprintf('$%7.2f$&',rms_after), sprintf('$%7.2f$&',mae_before), sprintf('$%7.2f$\\\\\n\\hline\n',mae_after)]
data_all_latex = [data_all_latex str]


save(sprintf('experiment_%d',experiment_counter));
experiment_counter = experiment_counter+1;





