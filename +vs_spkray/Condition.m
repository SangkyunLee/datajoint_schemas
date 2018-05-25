%{
# vs_spkray.Condtion (manual): stimulus condition within stimgrp
-> vs_spkray.Stimgrp
cond_idx : smallint unsigned # condition index
-----
condseq_name : varchar(256) # condition-name-seq for cond_idx calculation
ncondseq : tinyblob # number of each condition in condseq 
condition_ts = CURRENT_TIMESTAMP : timestamp  # automatic
%}

classdef Condition < dj.Manual
end