close all
clear all
clc

Pwsn = 42.4e-3;
Ftx = 250e3; %kbps
Nbits = 64; %bits
Ttx = Nbits/Ftx; %sec
Ttx*1e3
Ewsn = Pwsn*Ttx*1e3 %mJ


Tbs = 1000e-3; %sec
Pbs = 720e-6;% W

Ebs = Pbs*Tbs*1e3 %mJ




