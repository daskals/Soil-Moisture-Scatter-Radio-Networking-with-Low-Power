%%Synchronize measurements
clear all
close all
clc

%load the file
load('/Users/eleftherioskampianakis/Documents/Everything/Dropbox/Work/TUC/TelecomLab/Projects/Backscatter/BackscatterHumiditySensor/Scripts_Data/receiverSDRImplementation/Measurements/calibration_measurements_V1.mat')


round_val = 4; %best number 4

%Separate time
%get only the time for sensor #4
time_vector1 = time_vector1(:,1:2:end);

hour_BS = time_vector1(1,:);
min_BS = time_vector1(2,:);
sec_BS = round(time_vector1(3,:)./round_val)*round_val;       %round to nearest penth(pentada) 

%merge to single time measuring
time_BS = hour_BS*3600 + min_BS*60 + sec_BS;

hour_TT = calibrationV0(:,3);
min_TT = calibrationV0(:,4);
sec_TT = round(calibrationV0(:,5)./round_val)*round_val;

time_TT = hour_TT*3600 + min_TT*60 + sec_TT;


[time_common inds_BS inds_TT] = intersect(time_BS,time_TT);


%create the measurement vector
unfiltered_BS = F_sense_hist(4, F_sense_hist(4,:) ~= 0);
unfiltered_TT = calibrationV0(:,7);

unfiltered_temp = calibrationV0(:,7);


%Create the freq vector from BS sensor and RH vector from tinyTag
F_BS = F4(inds_BS);
RH_TT = unfiltered_TT(inds_TT)';
TEMP_TT = unfiltered_temp(inds_TT)';











