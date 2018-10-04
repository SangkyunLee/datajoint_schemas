addpath(genpath('~/data/codes2P'))
datajointpath = '/home/slee/data/datajoint/';
addpath(genpath(fullfile(datajointpath,'datajoint-matlab-master')))
% run ([datajointpath '/mym-distribution/mymSetup.m'])

setenv DJ_HOST SMSD:3306   
setenv DJ_USER slee_tp
setenv DJ_PASS korea44