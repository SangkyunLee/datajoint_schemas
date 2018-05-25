function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'slee_tp_ve', 'slee_tp_ve');
end
obj = schemaObject;
end
