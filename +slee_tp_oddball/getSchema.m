function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'slee_tp_oddball', 'slee_tp_oddball');
end
obj = schemaObject;
end
