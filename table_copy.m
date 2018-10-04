
colname=rel.tableHeader.names;
table = common.Tpscan;
newtable = common.Tpscan2; 
key = fetch(table);

for i = 1 : length(key)
    
   tuple= fetch(table&key(i),'*');
   insert(newtable,tuple);
end