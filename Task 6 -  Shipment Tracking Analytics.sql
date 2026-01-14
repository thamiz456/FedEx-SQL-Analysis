-- TASK 6 -- latest status (Delivered, In Transit, or Returned) along with the latest Delivery_Date
 WITH LatestUpdate AS (SELECT Shipment_ID,Delivery_Status, Delivery_Date,ROW_NUMBER() OVER(PARTITION BY Shipment_ID
 ORDER BY Delivery_Date DESC) AS rn
    FROM fedex_shipments)
SELECT  Shipment_ID,Delivery_Status AS Latest_Status, Delivery_Date AS Latest_Delivery_Date
FROM LatestUpdate
WHERE rn = 1;

-- Identify routes where the majority of shipments are still “In Transit” or “Returned”.
SELECT Route_ID, COUNT(*) AS Total_Shipments,
 SUM(CASE WHEN Delivery_Status = 'In Transit' THEN 1 ELSE 0 END) AS InTransit_Count,
    SUM(CASE WHEN Delivery_Status = 'Returned' THEN 1 ELSE 0 END) AS Returned_Count,
      SUM(CASE WHEN Delivery_Status IN ('In Transit', 'Returned') THEN 1 ELSE 0 END) AS Problem_Count
FROM fedex_shipments
GROUP BY Route_ID
HAVING Problem_Count > (Total_Shipments / 2)
ORDER BY Problem_Count DESC;


-- Find the most frequent delay reasons (if available in delay-related columns or flags).

SELECT Delay_Reason,COUNT(*) AS Reason_Count
FROM fedex_shipments
WHERE Delay_Reason IS NOT NULL 
  AND Delay_Reason <> ''
GROUP BY Delay_Reason
ORDER BY Reason_Count DESC;


-- Identify orders with exceptionally high delay (>120 hours) to investigate potential bottlenecks.

SELECT s.Shipment_ID,s.Order_ID,s.Warehouse_ID, s.Agent_ID,s.Route_ID, s.Delay_Hours,s.Delivery_Status,s.Delay_Reason
FROM fedex_shipments s
WHERE s.Delay_Hours > 120
ORDER BY s.Delay_Hours DESC;