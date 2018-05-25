%{
-> common.Animal
session_id : varchar(20) #session id
---
data_path : varchar(255) # main directory for raw data
session_date : date # session date

pre_session_id : varchar(20) # pre-session id
post_session_id : varchar(20) # post-session id

%}


%{
animal_id       : varchar(20)                   # id (internal to database)
---
dob = null                    : date                          # animal's date of birth
sex = "unknown"               : enum('M','F','unknown')       # sex
owner = "Unknown"             : varchar(20)# owner's name
line = "Unknown"              : enum('Unknown','C57/BJ6 (WT)','Thy1-GCaMP6s,GP4.3','SST-Cre','PV-Cre','Wfs1-Cre','Wfs1-Ai9','Viaat-Ai9','PV-Ai9','SST-Ai9','VIP-Ai9','PV-ChR2-tdTomato','SST-ChR2-tdTomato','TH-DREADD','FVB','PV-tdtomato','MECP2(129)','MECP2(FVB)','129') # mouse line
animal_notes = ""             : varchar(4096)                 # strain, genetic manipulations
animal_ts = CURRENT_TIMESTAMP : timestamp                     # automatic
%}




%{
# common.Tpscan
-> common.Session
scan_id : smallint #scan id
---
data_path : varchar(255) # scan directory for raw data
data_fn1 : varchar(255) # scan filename for raw data ch1
data_fn2 : varchar(255) # scan filename for raw data ch2
data_fn3 : varchar(255) # scan filename for raw data ch3

ch1 = 'red' : enum('red','yellow','blue','green','unkown')
ch2 = 'green' : enum('red','yellow','blue','green','unkown')
ch3 = 'unkown': enum('red','yellow','blue','green','unkown')
scanmethod : enum('galvo','spiral','reson','unkown')

anesthesia :  enum('awake','fentanyl','isoflurane','ketamine','unkown')
area = 'V1' : varchar(255)
layer = 'L2/3' : enum('NA','L2/3','L4','L5','L6') 
depth : int 
laser_power : float  #(mW)
laser_wavelength : float #(nm)
fov : varchar(255) # Field of View information
scan_notes = ""     : varchar(4095)  #  free-notes
scan_ts = CURRENT_TIMESTAMP : timestamp   # don't edit
%}
