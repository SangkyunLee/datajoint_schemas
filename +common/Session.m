%{
# common.Session
-> common.Animal
session_id                  : varchar(20)                   # session id
---
session_date                : date                          # session date
pre_session_id              : varchar(20)                   # pre-session id
post_session_id             : varchar(20)                   # post-session id
session_ts = CURRENT_TIMESTAMP : timestamp   # don't edit
%}


classdef Session < dj.Manual
end