--FUNCTION 
CREATE or replace FUNCTION generate_pass(sz integer) RETURNS text
    AS $$
DECLARE
   j int4;
   result text;
   allowed text;
   allowed_len int4;
BEGIN
   allowed := '123456789&#%@+=_abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ&#%@+=_123456789';
   allowed_len := length(allowed);
   result := '';
   WHILE length(result) < sz LOOP
      j := int4(random() * allowed_len);
      result := result || substr(allowed, j+1, 1);
   END LOOP;
   RETURN result;
END;
$$
    LANGUAGE plpgsql;

--call 
select generate_pass(10) 

