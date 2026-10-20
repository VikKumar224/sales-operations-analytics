 --This query checks Count to confirm row count of 31465 (matches the inventory query)  order_count=number of (purchases), not dollar and not units
SELECT COUNT(*) AS order_count FROM Sales.SalesOrderHeader ;

--This query checks for any repeats of SalesOrderID, using DISTINCT it checks for how many individual IDs not how many total times, 
--after running they match (31465) and in a situation they dont match the total rows would be greater since duplicates
SELECT COUNT(*) AS order_count,
		COUNT(DISTINCT SalesOrderID) AS  distinct_order_count
		FROM Sales.SalesOrderHeader ;

-- Checks for repeats of SalesOrderID in SalesOrderDetail: 121,317 lines vs 31,465 distinct orders (no match).
-- SalesOrderID repeats once per product line, so one row = one product line on an order (3.9 lines per order).
SELECT COUNT(*) AS line_count,
		COUNT(DISTINCT SalesOrderID) AS distinct_order_count
From Sales.SalesOrderDetail;

