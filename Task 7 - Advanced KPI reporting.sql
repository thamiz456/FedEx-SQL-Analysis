-- Task 7: Advanced KPI Reporting
-- Create SQL queries to calculate and summarize the following KPIs:
-- Average Delivery Delay per Source_Country.
SELECT r.Source_Country,ROUND(AVG(CASE WHEN s.Delay_Hours IS NULL THEN 0 ELSE s.Delay_Hours END), 2) AS Avg_Delay_Hours
FROM fedex_shipments s
JOIN fedex_routes r 
    ON s.Route_ID = r.Route_ID
GROUP BY r.Source_Country
ORDER BY Avg_Delay_Hours DESC;


-- On-Time Delivery %
SELECT ROUND(SUM( CASE WHEN s.Delay_Hours <= 0 THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS On_Time_Delivery_Percentage
FROM fedex_shipments s;


-- Average Delay (in hours) per Route_ID
SELECT Route_ID,ROUND(AVG(CASE WHEN Delay_Hours IS NULL THEN 0 ELSE Delay_Hours END), 2) AS Avg_Delay
FROM fedex_shipments
GROUP BY Route_ID
ORDER BY Avg_Delay DESC;


-- Warehouse Utilization %
SELECT w.Warehouse_ID,w.Capacity_per_day, SUM(CASE WHEN s.Shipment_ID IS NOT NULL THEN 1 ELSE 0 END) AS Shipments_Handled,
    ROUND(SUM(CASE WHEN s.Shipment_ID IS NOT NULL THEN 1 ELSE 0 END)/ w.Capacity_per_day * 100,2) AS Warehouse_Utilization_Percentage
FROM fedex_warehouses w
LEFT JOIN fedex_shipments s
    ON w.Warehouse_ID = s.Warehouse_ID
GROUP BY w.Warehouse_ID, w.Capacity_per_day
ORDER BY Warehouse_Utilization_Percentage DESC;

