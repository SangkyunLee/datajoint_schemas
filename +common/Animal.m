
%{
animal_id       : varchar(20)                   # id (internal to database)
---
dob = null                    : date                          # animal's date of birth
sex = "unknown"               : enum('M','F','unknown')       # sex
owner = "Unknown"             : varchar(20)# owner's name
line = "Unknown"              : enum('Unknown','C57/BJ6 (WT)','Thy1-GCaMP6s,GP4.3','SST-Cre','PV-Cre','Wfs1-Cre','Wfs1-Ai9','Viaat-Ai9','PV-Ai9','SST-Ai9','VIP-Ai9','PV-ChR2-tdTomato','SST-ChR2-tdTomato','TH-DREADD','FVB','PV-tdtomato','MECP2(129)','MECP2(FVB)','129') # mouse line
wdate = null                  : date # craniotomy date
animal_notes = ""             : varchar(4096)                 # strain, genetic manipulations
animal_ts = CURRENT_TIMESTAMP : timestamp                     # automatic
%}

classdef Animal < dj.Manual
end