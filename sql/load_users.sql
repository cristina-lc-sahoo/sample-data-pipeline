   TRUNCATE TABLE dbo.users;

   BULK INSERT dbo.users
   FROM 'users.csv'
   WITH (DATA_SOURCE = 'my_blob', FORMAT = 'CSV', FIRSTROW = 2,
         FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
