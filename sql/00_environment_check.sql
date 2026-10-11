-- Confirms the SQL Server instance and version before working with AdventureWorks.
SELECT 
    @@VERSION AS sql_server_version,
    SERVERPROPERTY('ServerName') AS server_name,
    SERVERPROPERTY('InstanceDefaultBackupPath') AS backup_path;
