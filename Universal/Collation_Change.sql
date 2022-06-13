-- STEP 1 Check what colation is set on your database
SELECT 
	name, 
	collation_name 
FROM sys.databases 
WHERE name = 'ESD_TEST'

-- STEP 2 Make sure no one else is using database
ALTER DATABASE ESD_TEST SET SINGLE_USER WITH ROLLBACK IMMEDIATE

-- STEP 3 Change collation to Modern_Spanish_CI_AI_WS
ALTER DATABASE ESD_TEST COLLATE Polish_CI_AS;

-- STEP 4 Allow users back into the database
ALTER DATABASE ESD_TEST SET MULTI_USER

-- STEP 5 Check of collation was changed
SELECT 
	name, 
	collation_name 
FROM sys.databases 
WHERE name = 'ESD_TEST'