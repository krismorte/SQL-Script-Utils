SELECT owner,INDEX_name, table_name, DBMS_METADATA.get_ddl ('INDEX', index_name, owner) FROM ALL_INDEXES 
WHERE table_name=''