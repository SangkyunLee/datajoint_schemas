%{
# common.Tpscan
-> common.Session
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
fov : varchar(255) # Field of View information

scan_notes = ""     : varchar(4095)  #  free-notes
scan_ts = CURRENT_TIMESTAMP : timestamp   # don't edit
%}


classdef Tpscan < dj.Manual
end