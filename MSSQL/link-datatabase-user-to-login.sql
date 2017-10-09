/*Link users from a restored database with a new login
withou re-create
*/

exec sp_change_users_login "Update_One",  user_database, server_login