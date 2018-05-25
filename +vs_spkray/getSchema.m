function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'vs_spkray', 'vs_spkray');
end
obj = schemaObject;
end
