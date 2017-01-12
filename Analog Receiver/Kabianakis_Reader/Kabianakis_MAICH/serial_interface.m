instrreset;
close all
clear all


s1 = serial('/dev/ttyUSB0');

s1.InputBufferSize = 1024;

fopen(s1);

while(s1.BytesAvailable > 0)
    fread(s1,s1.BytesAvailable);
end

str = fscanf(s1);
num = str2num(str);
disp(sprintf('Temperature = %2.2f', num));

fclose(s1);
