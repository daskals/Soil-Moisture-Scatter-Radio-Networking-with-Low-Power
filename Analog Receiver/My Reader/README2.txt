
Spiros Daskalakis
26/2/2014


Anoigoume  terminal 

*kai dokimazoume an trexei san sdr to stikaki me tin entoli
rtlsdr -t
--------------------------------------------------------------------------
an paizei  vgazei to parakato minima :
Found Rafael Micro R820T tuner
Supported gain values (29): 0.0 0.9 1.4 2.7 3.7 7.7 8.7 12.5 14.4 15.7 16.6 19.7 20.7 22.9 25.4 28.0 29.7 32.8 33.8 36.4 37.2 38.6 40.2 42.1 43.4 43.9 44.5 48.0 49.6 
Sampling at 2048000 S/s.



*)anoigoume gnu radio me tin entoli apo to terminal:

sudo gnuradio-companion

*)anoigoume matlab apo allo terminal:

sudo /usr/local/MATLAB/MATLAB_Production_Server/R2013a/bin/matlab

*) trexoume to block pou vazei ta data sti fifo (patame sto granazi tou gui)
(/home/dell/Desktop/THL2/rtlfifo)

*)na den upraxei h fifo tin ftiaxnoume sto fakelo pou theloume me tin entoli

sudo mkfifo ournamefifo








-----------------------------------------------------------------------------

an den paizei kai vgazei auto to minima:

"Kernel driver is active, or device is claimed by second instance of librtlsdr.
In the first case, please either detach or blacklist the kernel module
(dvb_usb_rtl28xxu), or enable automatic detaching at compile time."

o logos einai : 
The problem is the Linux kernel DVB driver is loaded, which means it is
making the device available for TV reception.  Since the device is in
use by this driver, the SDR programs can't access it. 

2)lyseis: 

a)mporoume na apomonosoume to driver me tin entoli

sudo modprobe -r dvb_usb_rtl28xxu

alla otan tha xanaanoixei to laptop tha exoume to idio provlima pali

b) na baloume to driver stin blacklist gia pantaaa!!!

prosthetoume tin grammh

blacklist dvb_usb_rtl28xxu (save kai exodos meta)

sto arxeio /etc/modprobe.d/blacklist.conf
----------------------------------------------------------------------

usefull sites for sdr:

http://superkuh.com/rtlsdr.html

http://sdr.osmocom.org/trac/wiki/rtl-sdr

