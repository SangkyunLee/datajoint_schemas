%{
# common.Tpscan # fov is now primary key
-> common.Session
fov ='FOV1': enum('FOV1','FOV2','FOV3','FOV4','FOV5','FOV6','FOV7','FOV8','FOV9','FOV10') # Field of View information
scan_id : smallint #scan id
---
data_path : varchar(255) # scan directory for raw data
data_fn1 : varchar(255) # scan filename for raw data ch1
data_fn2 : varchar(255) # scan filename for raw data ch2
data_fn3 : varchar(255) # scan filename for raw data ch3

ch1_color = 'red' : enum('red','yellow','blue','green','unkown')
ch2_color = 'green'  : enum('red','yellow','blue','green','unkown')
ch3_color = 'unkown' : enum('red','yellow','blue','green','unkown')
scanmethod = 'unkown' : enum('galvo','spiral','reson','unkown')

anesthesia  = 'unkown':  enum('awake','fentanyl','isoflurane','ketamine','unkown')
area  : varchar(255)
layer  = 'NA': enum('NA','L2/3','L4','L5','L6') 
depth : int 
objective : enum('16x','25x','40x','unkown')

dwell_time =NULL: float #micro second
pixres : float # pixel resolution (in micron)

laser_power : float  #(mW)
laser_wavelength : float #(nm)


scan_notes = ""     : varchar(4095)  #  free-notes
scan_ts = CURRENT_TIMESTAMP : timestamp   # don't edit
%}

classdef Tpscan2 < dj.Manual
    methods
        function [dpath, fn, fullfns] = getFilename(self, ch)
            keys = fetch(self);
            n = length(keys);
            
            fullfns = cell(n,1);
            dpath = cell(n,1);
            fn = cell(n,1);
            for i = 1:n
                key = keys(i);
                assert(length(key)==1, 'one scan at a time please')
                assert(ch>=1 & ch<=3, 'only ch 1-3');
                
                [path1, fn1] = fetch1(common.Tpscan&key, ...
                    'data_path', sprintf('data_fn%d',ch));
                dpath{i} = path1;
                fn{i} = fn1;
                
                fullfns{i} = fullfile(path1,fn1);
            end
            
        end
    end
    
end