-- TASK 2 Delivery Delay Analysis
-- TO Calculate delivery delay (in hours) for each shipment using Delivery_Date – Pickup_Date  i used timestamp function
SELECT  Shipment_ID,Order_ID,Pickup_Date,Delivery_Date,TIMESTAMPDIFF(HOUR, Pickup_Date, Delivery_Date) AS Delivery_Time_Hours
FROM fedex_shipments;
-- Find the Top 10 delayed routes based on average delay hours

SELECT r.Route_ID, r.Source_City, r.Destination_City,ROUND(AVG(s.Delay_Hours),2) AS Avg_Delay_Hours
FROM fedex_shipments s
JOIN fedex_routes r ON s.Route_ID = r.Route_ID
GROUP BY r.Route_ID, r.Source_City, r.Destination_City
ORDER BY Avg_Delay_Hours DESC
LIMIT 10;

-- SQL window functions to rank shipments by delay within each Warehouse_ID

SELECT Shipment_ID,Warehouse_ID,Delay_Hours,DENSE_RANK() OVER (PARTITION BY Warehouse_ID ORDER BY Delay_Hours DESC) AS Delay_Rank
FROM fedex_shipments;

-- Identify the average delay per Delivery_Type (Express / Standard) to compare service-level efficiency

SELECT o.Delivery_Type,ROUND(AVG(s.Delay_Hours), 2) AS Avg_Delay_Hours FROM fedex_shipments s
JOIN fedex_orders o
  ON s.Order_ID = o.Order_ID
GROUP BY o.Delivery_Type
ORDER BY Avg_Delay_Hours DESC;
-- ---------------------------------------------