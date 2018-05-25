classdef vslearning
    
    
    properties
        animal_id; %animal name
        session_ids; %session ids(e.g., pre, intermediate, post)
        scan_ids;
        stmgrp; % stimulus group
        tp;%TPscan([], [], []); %tp for scans        
        sync;  %photodiode for visual stim for scans
        vs;
        eye; % eyeinfo for scans
        w; % wheelinfo for scans
        
        
        
        cellinx; % selected cells by visual response;
        trialinx; % selected trials indexs by behavior state for scans 
        cell_common; % commonly selected cells across learning
        
    end
    
    methods
        function self = vslearning(animal_id,ses_ids,stmgrp)
%             animal_id ='SL_thy1_0206_MB';
%             ses_ids = {'0425_D8','0501_D14'};
%             stmgrp = 'cont-ori-48R';
            
            stmkey = sprintf('grp_id="%s"',stmgrp);
            
            
            self.tp = cell(1,length(ses_ids));
            for j = 1 : length(ses_ids)
                key = struct('animal_id',animal_id,...
                    'session_id',ses_ids{j});
                self.tp{j} = pl_pr.Deconvsang&key&(vs_spkray.Scan&stmkey);
                self.sync{j}= pl_pr.Syncvs2tpscan&key&(vs_spkray.Scan&stmkey);
                 
                self.vs{j} = vs_spkray.Grating&(vs_spkray.Scan& self.tp{j});
                
                self.scan_ids{j} = fetchn(self.tp{j},'scan_id');
            end 
            self.animal_id = animal_id;
            self.session_ids = ses_ids;            
            self.stmgrp = stmgrp;
        end

        
        function [self]= select_cell_vresp(self)
           
        end
        
        
        function self = get_common_cellinx(self)
            % function self = get_common_cellinx(self)
            % get commonly selected cells across session
            
            nses = length(self.tp);
            cids = cell(1,nses);
            for i = 1 : nses
              
                cids{i} = unique(cell2mat(self.cellinx{i}));
                if i ==1,
                    self.cell_common = cids{i};
                else
                    % select cell identified between groups
                    self.cell_common = intersect(self.cell_common, cids{i});
                end
            end
        end
        
        
    end
    
  
    
end
