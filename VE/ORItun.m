classdef ORItun
    
    
    properties
        animal_id;
        learnses_id;
        stmgrp_id;
        session_id;
        tpscan_ids;
        btwin;
        rtwin;
        twin;
        cell_common;
        cellinx;
        trialinx;
        celln;
        
        dffn;
        dff;
        nhat;


    end
    
    methods(Access=public)
        function self = ORItun(Info,key)
            dtypes ={'nhat','dff','dffn'};
           
            for idtyp = 1: length(dtypes)
                
                dtype =dtypes{idtyp};
                
                cg = cell(1);   
                
                for iscan = 1 :length(Info.tpscan_ids)
                    key1 = key;
                    key1.scan_id = Info.tpscan_ids(iscan);
                    rel = slee_tp_ve.Datsort&key1;
                    dat = fetchn(rel,dtype);
                    cg1 = contgain(dat{1});            
                    vs =vs_spkray.Grating;
                    trcond= (vs_spkray.Trial)&key1;
                    cg{1}(iscan) = cg1.set_evt(vs,trcond);
                end
                
            
                self.(dtype) = cg{1};
            end
            
            fld = fieldnames(Info);
            for ifld = 1: length(fld)
                self.(fld{ifld})=Info.(fld{ifld});
            end

        end
       

        
        
        function [tun,etun,ori]=get_oritun(self,dtype,cinx,contrast,bavg)
            %function get_oritun(self,dtype,cinx,contrast,bavg)
            % get ORI tuning from cinx(cell idx; default=self.cell_common)
            % if isemtpy(cinx), get ori only within selected cell pool
            % i.e., outcell = setdiff(cinx,self.cellinx{ises}{iscan});
            
            if isempty(cinx)
                cinx = self.cell_common;
                bwithincommon = true;
                cinx0 = zeros(max(cinx),1);
                cinx0(cinx) = 1:length(cinx);
            end
            
            CG = self.(dtype);
            
            nscan = length(CG);
            tun = cell(1,nscan);
            etun = cell(1,nscan);
            for j = 1: nscan

               [y,  ey, ori]=ORItun.get_oritun1(CG(j),cinx, contrast,false);
               outcell=[];
               if bwithincommon
                   out = setdiff(cinx,self.cellinx{j});
                   outcell = cinx0(out);                   
               end

               y(:,:,outcell)=NaN;
               ey(:,:,outcell)=NaN;

               if ~bavg
                   tun{j} = y;
                   etun{j}=ey;
               else
                   tun{j} = squeeze(mean(y,2));
                   etun{j}=squeeze(mean(ey,2));
               end
            end

        
        end
    end
        
  
        
    methods(Static)
        
        function [y,  ey, ori]= get_oritun1(ORI,cinx, contrast,bavg)
            
            [y, ey, ori] = ORI.get_oritun(cinx,'contrast',contrast);
            y(y(:)==0) =NaN; 
            ey(ey(:)==0) =NaN; 

            if bavg
                y = squeeze(nanmean(y,2));
                ey = squeeze(nanmean(ey,2));            
            end
        end
        
    end
    
  
    
end



