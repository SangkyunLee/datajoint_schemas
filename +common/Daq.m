%{
#common.Daq (Manual) :DAQ attached to tpscan
->common.Tpscan
-----
data_path : varchar(255) # wheel file location
data_fn : varchar(255) # wheeldata file name
recorder : varchar(20) # recording system (e.g., Pairie 5.4)
nch      : smallint  # no ch
fs       : float  # sampling freq (Hz)
frame_trigger : smallint # frame trigger channel
pd       : smallint # photo diode channel
wheel_ch1 : smallint # the first wheel
wheel_ch2 : smallint # the second wheel
daq_ts = CURRENT_TIMESTAMP : timestamp   # don't edit
%}


classdef Daq < dj.Manual
    methods
        function [daq,ch,t] = loadDAQ(self,key)
            %function [daq,ch,t] = loadDAQ(self,key)
            % ch: channel info
            % t : time in second
            
            f = fetch(self&key,'*');
            DAQfn = fullfile(f.data_path,f.data_fn);
            [head,daq] = read_csv(DAQfn,f.nch);
            ch = cell2mat(head(3:2:end));
            t =daq(:,1)/1000; % in second
            daq = daq(:,2:end);
        end
    end
end