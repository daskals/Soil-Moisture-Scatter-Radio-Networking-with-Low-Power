instrreset;
close all
clear all

F_sense_hist_mcu = zeros(1, 10e3);
time_vector1_muc = zeros(3,10e3);
i=0;
s1 = serial('/dev/ttyUSB1','BaudRate',115200)

s1.InputBufferSize = 1024;

fopen(s1);

while(s1.BytesAvailable > 0)
    fread(s1,s1.BytesAvailable);
end

str = fscanf(s1);
num = str2num(str);

  i=0;
 time_now = clock;
 time_vector1_mcu(1:3,i+1) = [time_now(4),time_now(5),time_now(6) ];
 
disp(sprintf('F = %2.2f', num));

F_sense_hist(ii,i+1) = F_sensor_est;


fclose(s1);
