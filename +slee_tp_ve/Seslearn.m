%{
# slee_tp_ve.Seslearn # learning over session
->common.Animal
learnses_id : smallint # learning session id
-----
start_sesid : varchar(20) # learning start session id
end_sesid : varchar(20) # learning end session id
start_date : date
end_date : date
learning_stim : varchar(50) # vstim for learning
%}

classdef Seslearn < dj.Lookup
end