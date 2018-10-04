%{
# common.Virus
-> common.Animal
virus_id : smallint 
-----
virus_name = ''    : varchar(255)                                      # full virus name
gene = "NA"        : enum('GCaMP6s','GCaMP6m','GCaMP6f','GCaMP7f','GCaMP7b','NA') # gene name
opsin = "NA"      : enum('None','ChR2(H134R)','ChR2(E123T/T159C)','ArchT1.0','NA') # opsin version
reporter="NA"      : enum('tdTomato','mCherry','NA','unkown')  
virus_type='NA'         : enum('AAV1','AAV2','AAV5','AAV9','Rabies','Lenti','NA')     # type of virus
serotype = "NA"    : enum('AAV2/1','AAV2','AAV2/5','AAV2/8','NA','unknown')     # AAV serotype
promoter = "NA"    : enum('CamKIIa','hSyn','EF1a','CAG','CMV','NA','unknown')   # viral promoter
floxed = "NA"              : enum('DIO','fDIO','NA')
source             : enum('Penn','UNC', 'Addgene', 'Homegrown')                    # source of virus 
lot=''                   : varchar(32)                                       # lot #
titer=null                 : float                                             # titer
dillution=null             : float
decaytime =null                   : float  # 1/e decay time in sec

inject_date  = null         : date  
inject_time = null          : time

virus_ts = CURRENT_TIMESTAMP : timestamp                     # automatic

%}

classdef Virus < dj.Manual
end