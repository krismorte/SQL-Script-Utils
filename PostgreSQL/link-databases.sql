/*

https://thoughtbot.com/blog/postgres-foreign-data-wrapper

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

--enable the extensio
CREATE EXTENSION postgres_fdw;

--add a server path
CREATE SERVER local_auth
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'youser-server', dbname 'your-database');

--add authentication linking the current user and the server
CREATE USER MAPPING FOR CURRENT_USER
  SERVER local_auth
  OPTIONS (user 'user-name', password 'password');

--you have to create a schema to link the remote database
CREATE SCHEMA authdb;

--import the metada from the remote database to the new schema
IMPORT FOREIGN SCHEMA public
  FROM SERVER local_auth
  INTO authdb;
  