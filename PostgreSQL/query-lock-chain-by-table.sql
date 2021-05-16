select pid, state, usename, query, query_start 
from pg_stat_activity 
where pid in (
  select pid from pg_locks l 
  join pg_class t on l.relation = t.oid 
  and t.relkind = 'r' 
  where t.relname = '<Your Table>'
);