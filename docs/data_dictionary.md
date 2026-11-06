# Data Dictionary

Database: AdventureWorks2025 (SQL Server). Checks are in `sql/02_sales_table_grain.sql`.

## Sales.SalesOrderHeader

- **Grain:** one row = one order
- **Rows:** 31,465
- **Primary key:** SalesOrderID
- **How I checked:** COUNT(*) = COUNT(DISTINCT SalesOrderID) = 31,465, so no order ID repeats
- **Main foreign keys:** CustomerID → Sales.Customer, SalesPersonID → Sales.SalesPerson, TerritoryID → Sales.SalesTerritory
- **Key columns:**
  - OrderDate: date the order was placed (stored with a time part, always 00:00:00 in the rows I looked at)
  - SubTotal: price of the products on the order, before tax and shipping. Use this for sales revenue
  - TotalDue: SubTotal + TaxAmt + Freight (checked on 5 rows). What the customer paid in total, not revenue

## Sales.SalesOrderDetail

- **Grain:** one row = one product line on an order
- **Rows:** 121,317
- **Primary key:** SalesOrderID + SalesOrderDetailID (composite key). SalesOrderID says which order; SalesOrderDetailID says which line
- **How I checked:** 121,317 lines vs 31,465 distinct SalesOrderIDs, so SalesOrderID repeats once per line
- **Main foreign keys:** SalesOrderID → Sales.SalesOrderHeader, SpecialOfferID + ProductID → Sales.SpecialOfferProduct
- **Key columns:**
  - ProductID: which product is on the line
  - OrderQty: number of units of that product on the line (can be more than 1)
  - LineTotal: dollar amount for the line (price × quantity, after any discount; not checked yet)

## Relationship

- SalesOrderHeader (one) to SalesOrderDetail (many), joined on SalesOrderID. About 3.9 lines per order.
- Watch out: after joining, Header values like SubTotal repeat on every line, so summing them counts each order about 3.9 times. Sum SubTotal from Header alone, or LineTotal from Detail.
- One line ≠ one unit: OrderQty can be more than 1, so units = SUM(OrderQty).
