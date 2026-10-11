# Project Journal

## 2026-10-10 — AdventureWorks database inventory

### Work completed

- Continued from the existing setup: SQL Server and SSMS are installed, `AdventureWorks2025` is restored, and the project repository is in place.
- Corrected the README and interview review to reflect the current SQL Server/T-SQL project stack.
- Expanded `sql/01_database_inventory.sql` to report table row counts and column counts, column names and data types, nullability, and foreign-key relationships.
- Ran the expanded inventory successfully in SSMS with `AdventureWorks2025` selected. The earlier table-name query returned 72 tables. The expanded script produced its three result sets.

### What I learned

The inventory describes the database structure; it does not display every stored data value or answer a business question. The row counts come from SQL Server catalog metadata, so they are useful for exploration and can be checked with exact counts later if needed. Foreign keys reveal declared table relationships, but I still need to understand each table's grain and business meaning before joining data for analysis.

### Brandt's connection

This is the data-discovery step. For Brandt's, the equivalent would be learning which POS reports or exports are available, what fields they contain, and whether each row represents an order or an individual menu item before deciding what to analyze.

### Next step

Inspect a focused set of sales tables, starting with `Sales.SalesOrderHeader` and `Sales.SalesOrderDetail`. Record their important columns, keys, relationships, row grain, and business meaning in `docs/data_dictionary.md` before writing business-analysis queries.
