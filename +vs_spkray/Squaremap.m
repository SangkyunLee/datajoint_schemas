%{
# vs_spkray.Squaremap
->vs_spkray.Condition
-----
stimcenter_x = 0 : float # in degree 
stimcenter_y = 0 : float # in degree
dotsize : float #  in degree 
dotcolor : smallint unsigned # [0-255]
dotloc_x : float  # in pixel
dotloc_y : float  # in pixel
dotloc_xi : smallint unsigned  # index of x grid
dotloc_yi : smallint unsigned  # index of y grid
dotloc_ci : smallint unsigned  # index of color


squaremap_ts = CURRENT_TIMESTAMP : timestamp  # automatic

%}

classdef Squaremap < dj.Manual
end