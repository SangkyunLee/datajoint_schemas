%{
#common.wheel
->common.Tpscan
-----

data_path : varchar(255) # wheel file location
data_fn : varchar(255) # wheeldata file name
recorder : varchar(20) # recording system (e.g., Pairie 5.4)
wheel_ch1 : smallint # the first channel number in DAQ file
wheel_ch2 : smallint # the second channel number in DAQ file
wheel_ts = CURRENT_TIMESTAMP : timestamp   # don't edit
%}

classdef Wheel < dj.Manual
end