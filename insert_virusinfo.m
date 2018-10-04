
rel = fetch(common.Animal)

for i =1 : length(rel)

    
    if strfind(rel(i).animal_id,'SST')
        tuple1 = rel(i);
        tuple1.virus_id = 1
        tuple1.virus_name = 'pGP-AAV-syn-jGCaMP7f-WPRE (AAV1)'        
        tuple1.gene = 'GCaMP7f'
        tuple1.virus_type = 'AAV1'
        tuple1.promoter = 'hSyn'
        tuple1.floxed = 'NA'
        tuple1.source = 'Addgene'
        tuple1.decaytime =0.2
        insert(common.Virus,tuple1);
       
        tuple2 = rel(i);
        tuple2.virus_id = 2
        tuple2.virus_name = 'AAV1.CAG.Flex.tdTomato.WPRE.bGH'
        tuple2.reporter = 'tdTomato'
        tuple2.virus_type = 'AAV1'
        tuple2.promoter = 'CAG'
        tuple2.floxed = 'DIO'
        tuple2.source = 'Penn'
        insert(common.Virus,tuple2);
    elseif strfind(rel(i).animal_id,'thy1')
        tuple1 = rel(i);
        tuple1.virus_id = 1
        tuple1.virus_name = ''        
        tuple1.gene = 'GCaMP6S'        
        tuple1.decaytime =0.85
        insert(common.Virus,tuple1);
    end
end
    