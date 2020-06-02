/*Query index with th creat script

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0;