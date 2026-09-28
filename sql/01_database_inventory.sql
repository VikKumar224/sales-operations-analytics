SELECT
    s.name AS schema_name,
    t.name AS table_name
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
ORDER BY
    s.name,
    t.name;