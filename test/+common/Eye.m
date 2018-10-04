%{
#common.Eye
->common.Tpscan
-----

data_path : varchar(255) # wheel file location
data_fn : varchar(255) # wheeldata file name
recorder : varchar(20) # recording system (e.g., Pairie 5.4)
daq_ch1 : smallint # the first channel number in DAQ file
daq_ch2 : smallint # the second channel number in DAQ file
eye_ts = CURRENT_TIMESTAMP : timestamp   # don't edit
%}
classdef Eye < dj.Manual
end