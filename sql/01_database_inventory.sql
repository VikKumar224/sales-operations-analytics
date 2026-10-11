/*
    AdventureWorks database inventory

    Run this in the AdventureWorks2025 database. It returns three result sets:
    1. Table sizes and column counts
    2. Columns, data types, and nullability
    3. Foreign-key relationships

    Row counts use SQL Server catalog metadata. They are fast estimates of
    stored rows and can be checked against COUNT(*) when exact counts matter.
*/

SET NOCOUNT ON;

-- 1. Tables: schema, approximate row count, and number of columns.
WITH table_rows AS (
    SELECT
        object_id,
        SUM(rows) AS row_count
    FROM sys.partitions
    WHERE index_id IN (0, 1)
    GROUP BY object_id
)
SELECT
    s.name AS schema_name,
    t.name AS table_name,
    COALESCE(tr.row_count, 0) AS row_count,
    COUNT(c.column_id) AS column_count
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
JOIN sys.columns AS c
    ON c.object_id = t.object_id
LEFT JOIN table_rows AS tr
    ON tr.object_id = t.object_id
GROUP BY
    s.name,
    t.name,
    tr.row_count
ORDER BY
    s.name,
    t.name;

-- 2. Columns: useful for identifying candidate fields and table grain.
SELECT
    s.name AS schema_name,
    t.name AS table_name,
    c.column_id,
    c.name AS column_name,
    ty.name AS data_type,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
JOIN sys.columns AS c
    ON c.object_id = t.object_id
JOIN sys.types AS ty
    ON ty.user_type_id = c.user_type_id
ORDER BY
    s.name,
    t.name,
    c.column_id;

-- 3. Foreign keys: how tables are related.
SELECT
    ps.name AS parent_schema,
    pt.name AS parent_table,
    pc.name AS parent_column,
    rs.name AS referenced_schema,
    rt.name AS referenced_table,
    rc.name AS referenced_column,
    fk.name AS foreign_key_name
FROM sys.foreign_key_columns AS fkc
JOIN sys.foreign_keys AS fk
    ON fk.object_id = fkc.constraint_object_id
JOIN sys.tables AS pt
    ON pt.object_id = fkc.parent_object_id
JOIN sys.schemas AS ps
    ON ps.schema_id = pt.schema_id
JOIN sys.columns AS pc
    ON pc.object_id = fkc.parent_object_id
   AND pc.column_id = fkc.parent_column_id
JOIN sys.tables AS rt
    ON rt.object_id = fkc.referenced_object_id
JOIN sys.schemas AS rs
    ON rs.schema_id = rt.schema_id
JOIN sys.columns AS rc
    ON rc.object_id = fkc.referenced_object_id
   AND rc.column_id = fkc.referenced_column_id
ORDER BY
    ps.name,
    pt.name,
    fk.name,
    fkc.constraint_column_id;
