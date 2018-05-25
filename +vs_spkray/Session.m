%{
# vs_spkray.Session 
->common.Session
-----
scr_distance = 100        : float #                         # (cm) eye-to-monitor distance
scr_size_x = 309.4         : float #(mm), following default setting with screen L7014                       
scr_size_y =173.95        : float #(mm)                        
refreshrate = 60          : smallint # Hz
resolution_x = 1366                : smallint                      # display resolution along x
resolution_y = 768                : smallint                      # display resolution along y
maxlum = 300               : float #(cd/m^2)
session_ts=CURRENT_TIMESTAMP    : timestamp                     # automatic
%}
classdef Session < dj.Manual
end