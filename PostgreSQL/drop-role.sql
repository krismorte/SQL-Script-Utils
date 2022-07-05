/*  Drop role

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

REASSIGN OWNED BY "USER" TO postgres;

REVOKE ALL privileges on ALL TABLES IN SCHEMA public from "USER"

DROP ROLE "USER"



