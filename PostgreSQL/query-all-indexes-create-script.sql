/*Query index with th creat script

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/


select
    t.relname as table_name,
    i.relname as index_name,
    a.attname as column_name
	,pg_get_indexdef(ix.indexrelid)
from
    pg_class t,
    pg_class i,
    pg_index ix,
    pg_attribute a
where
    t.oid = ix.indrelid
    and i.oid = ix.indexrelid
    and a.attrelid = t.oid
    and a.attnum = ANY(ix.indkey)
    and t.relkind = 'r'
    --and t.relname like 'test%'
order by
    t.relname,
    i.relname;