SELECT grantee, privilege_type,grantor,table_schema,table_name
FROM information_schema.role_table_grants 
WHERE table_name='table' and grantee='user'