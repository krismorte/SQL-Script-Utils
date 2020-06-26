select inst_id,
       target,
       OPNAME,
       START_TIME,
       LAST_UPDATE_TIME,
       round((SOFAR/TOTALWORK) * 100,2) as PCT_DONE,
       round(TIME_REMAINING/60,1) as "MINUTES REMAINING",
       MESSAGE 
from gv$session_longops 
where OPNAME not like '%aggregate%' 
and TOTALWORK > SOFAR;