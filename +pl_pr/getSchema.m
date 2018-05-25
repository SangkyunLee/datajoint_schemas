function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'pl_pr', 'pl_pr');
end
obj = schemaObject;
end
