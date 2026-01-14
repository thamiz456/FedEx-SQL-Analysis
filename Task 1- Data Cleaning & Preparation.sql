-- SQL PROJECT FEDEX SENTHAMIL SELVAN M--
-- TASK 1  DATA CLEANING AND PRE PROCESSING
-- I CREATED DATABASE FEDEX AND IMPORTED ALL THE DATASETS INTO THIS DATABASE--
USE FEDEX;
-- FOR CHECKING DUPLICATED I USED FOLLOWING COUNT FUNCTION TO FIND DUPLICATES --
SELECT Order_ID, COUNT(*)
FROM fedex_orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT Shipment_ID, COUNT(*)
FROM fedex_shipments
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;
-- for checking nulls i used same count with "is null" function
SELECT COUNT(*) 
FROM fedex_shipments
WHERE Delay_Hours IS NULL;
-- for checking dates in string formats
SELECT Pickup_Date, Delivery_Date
FROM fedex_shipments
LIMIT 5;
-- since date formats are fixed while importing, just checked again for wrong ones
-- to Ensure that no Delivery_Date occurs before Pickup_Date i have used where clause with aggregator symbols
SELECT *
FROM fedex_shipments
WHERE Delivery_Date < Pickup_Date;

-- to Validate referential integrity between Orders, Routes, Warehouses, and Shipments
-- We must ensure child table values exist in parent tables.
SELECT s.*
FROM fedex_shipments s
LEFT JOIN fedex_orders o ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

SELECT s.*
FROM fedex_shipments s
LEFT JOIN fedex_delivery_agents a ON s.Agent_ID = a.Agent_ID
WHERE a.Agent_ID IS NULL;

SELECT o.*
FROM fedex_orders o
LEFT JOIN fedex_warehouses w ON o.Warehouse_ID = w.Warehouse_ID
WHERE w.Warehouse_ID IS NULL;
--