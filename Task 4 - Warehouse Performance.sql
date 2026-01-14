-- TASK 4 
-- Find the top 3 warehouses with the highest average delay in shipments dispatched
SELECT w.Warehouse_ID, w.City, w.Country, ROUND(AVG(s.Delay_Hours), 2) AS Avg_Delay_Hours
FROM fedex_shipments s
JOIN fedex_warehouses w
    ON s.Warehouse_ID = w.Warehouse_ID
GROUP BY w.Warehouse_ID, w.City, w.Country
ORDER BY Avg_Delay_Hours DESC
LIMIT 3;

-- Calculate total shipments vs delayed shipments for each warehouse.
SELECT s.Warehouse_ID, COUNT(*) AS Total_Shipments,SUM(CASE WHEN s.Delay_Hours > 0 THEN 1 ELSE 0 END) AS Delayed_Shipments
FROM fedex_shipments s
GROUP BY s.Warehouse_ID
ORDER BY Delayed_Shipments DESC;

-- Use CTEs to identify warehouses where average delay exceeds the global average delay.

WITH GlobalAvg AS (SELECT AVG(Delay_Hours) AS Global_Avg_Delay FROM fedex_shipments),
 WarehouseAvg AS (SELECT Warehouse_ID,AVG(Delay_Hours) AS Avg_Delay  FROM fedex_shipments GROUP BY Warehouse_IDn )
SELECT  w.Warehouse_ID, ROUND(w.Avg_Delay, 2) AS Warehouse_Avg_Delay, ROUND(g.Global_Avg_Delay, 2) AS Global_Avg_Delay
FROM WarehouseAvg w
CROSS JOIN GlobalAvg g
WHERE w.Avg_Delay > g.Global_Avg_Delay
ORDER BY w.Avg_Delay DESC;

-- Rank all warehouses based on on-time delivery percentage
WITH WarehouseStats AS ( SELECT Warehouse_ID,COUNT(*) AS Total_Shipments,SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) AS On_Time_Shipments,
        ROUND(SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100,2) AS On_Time_Percentage
    FROM fedex_shipments
    GROUP BY Warehouse_ID)
SELECT Warehouse_ID,Total_Shipments, On_Time_Shipments, On_Time_Percentage,
    RANK() OVER (ORDER BY On_Time_Percentage DESC) AS On_Time_Rank
FROM WarehouseStats
ORDER BY On_Time_Rank;