clear all
close all
clc

m = 500;
progressbar('Relative Humidity','Soil Moisture') % Init single bar
for i = 1:m
    pause(0.001) % Do something important
    progressbar(i/m,i/m) % Update progress bar
end

