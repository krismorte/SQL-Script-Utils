/* 
==============================================================================
Author:		    Tommy Swift & Krisnamourt
Name:           spDynamicMerge
Create date:    5/18/2015
Update date:    15/11/2018
Description:	Stored Procedure to Create MERGE Statements from Source Table
                joining back to target tables on PK columns for CRUD statement
                comparisons
Parameters:     @schemaName - Default = 'dbo' 
				@sourceDb source database
				@targetDb target database
				@sourceTb sourde table
				@targetTb to be Merged
				Schema required if table schema name is other than 'dbo'
Assumptions:    - The parameter table exists on both the Source and Target 
                    and PK's are the same on both DB tables.
                - PK columns will be used to determine record existence.
                - SP resides on the Target database where the filtered list
                    of columns per table occur.  This ensures that only the
                    columns used in the Target are evaluated.
==============================================================================
*/

create PROCEDURE [dbo].[spDynamicMerge]
    @sourceDb VARCHAR(100) ,
	@targetDb VARCHAR(100) ,
	@schemaName VARCHAR(100) = 'dbo',
	@sourceTb VARCHAR(8000),
	@targetTb VARCHAR(8000)
AS
BEGIN TRANSACTION	
	SET NOCOUNT ON;
	BEGIN TRY
    
    DECLARE  @pkColumnsCompare VARCHAR(8000)            
            ,@nonPKColumnsTarget VARCHAR(8000)
            ,@nonPKColumnsSource VARCHAR(8000)
            ,@nonPKColumnsCompare VARCHAR(8000)
            ,@columnListingSource VARCHAR(8000)
            ,@columnListingTarget VARCHAR(8000)
            ,@sqlCommand NVARCHAR(4000)

	create table #columns (name varchar(400))

	insert into #columns
		exec ('select c.name from '+@targetDb+'.sys.indexes i 
        INNER JOIN '+@targetDb+'.sys.index_columns ic 
            ON ic.object_id = i.object_id 
				AND i.index_id = ic.index_id 
        INNER JOIN '+@targetDb+'.sys.columns c
            ON ic.object_id = c.object_id
                AND ic.column_id = c.column_id  
        INNER JOIN '+@targetDb+'.sys.tables t
            ON t.object_id = c.object_id     
		INNER JOIN '+@targetDb+'.sys.schemas s
			on s.schema_id = t.schema_id 
			WHERE i.is_primary_key = 1
			AND s.name + ''.'' + t.name = '''+@schemaName+'.'+@targetTb+'''')
    select *from #columns
    --Get list of PK columns for Insert determination
    SELECT @pkColumnsCompare = COALESCE(@pkColumnsCompare + ' AND ', '') + 'Target.' + name + ' = ' + 'Source.' + name           
	FROM #columns

	truncate table #columns
    insert into #columns
		exec ('SELECT DISTINCT c.name
    FROM '+@sourceDb+'.sys.tables t
        INNER JOIN '+@sourceDb+'.sys.schemas s
			on s.schema_id = t.schema_id
		LEFT JOIN '+@sourceDb+'.sys.columns c
            ON t.object_id = c.object_id  
        LEFT JOIN '+@sourceDb+'.sys.indexes i
            ON i.object_id = c.object_id    
        LEFT JOIN '+@sourceDb+'.sys.index_columns ic 
            ON ic.object_id = i.object_id 
                AND ic.column_id = c.column_id  
    WHERE ic.object_id IS NULL AND
        s.name + ''.'' + t.name ='''+@schemaName+'.'+@sourceTb+'''')

	--Get List of non-PK columns for Updates
    SELECT @nonPKColumnsTarget = COALESCE(@nonPKColumnsTarget + ', ', '') + 'Target.' + name
        ,  @nonPKColumnsSource = COALESCE(@nonPKColumnsSource + ', ', '') + 'Source.' + name
        ,  @nonPKColumnsCompare = COALESCE(@nonPKColumnsCompare + ', ', '') + 'Target.' + name + ' = ' + 'Source.' + name
    FROM #columns

	truncate table #columns
	insert into #columns
    exec ('SELECT DISTINCT c.name
    FROM '+@sourceDb+'.sys.tables t
		INNER JOIN '+@sourceDb+'.sys.schemas s
			on s.schema_id = t.schema_id
        INNER JOIN  '+@sourceDb+'.sys.columns c
            ON t.object_id = c.object_id      
    WHERE s.name + ''.'' + t.name ='''+@schemaName+'.'+@sourceTb+'''')


    -- Create comma delimited column listing
    SELECT @columnListingTarget = COALESCE(@columnListingTarget + ', ', '') + name
        , @columnListingSource = COALESCE(@columnListingSource + ', ', '') + 'Source.'+ name    
    FROM #columns
   

    --select @pkColumnsCompare, @nonPKColumnsTarget, @nonPKColumnsSource, @nonPKColumnsCompare, @columnListingTarget, @columnListingSource

    SELECT @sqlCommand = 
	'WITH temp AS ' + CHAR(13) + CHAR(10) + 
	'(' + CHAR(13) + CHAR(10) +
	' SELECT * FROM '+@sourceDb+'.' + @schemaName + '.' + @sourceTb + ' WITH(NOLOCK) ' + CHAR(13) + CHAR(10) +		
	') ' + CHAR(13) + CHAR(10) +
	'MERGE '+@targetDb+'.' + @schemaName + '.' + @targetTb  + ' AS Target ' + CHAR(13) + CHAR(10) +
     'USING temp AS Source ' + CHAR(13) + CHAR(10) +
        'ON ' + @pkColumnsCompare + CHAR(13) + CHAR(10) +
    ' WHEN MATCHED THEN ' + CHAR(13) + CHAR(10) +
       'UPDATE SET ' + @nonPKColumnsCompare + CHAR(13) + CHAR(10) +
    ' WHEN NOT MATCHED BY TARGET ' + CHAR(13) + CHAR(10) +
    'THEN ' + CHAR(13) + CHAR(10) +
       'INSERT (' + @columnListingTarget + ') ' + CHAR(13) + CHAR(10) +
       'VALUES (' + @columnListingSource + '); '

    --select @sqlCommand
    
    EXECUTE sp_executesql @sqlCommand

	drop table #columns

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, 
				   @ErrorSeverity,
				   @ErrorState
				   );

	END CATCH;

IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;

GO