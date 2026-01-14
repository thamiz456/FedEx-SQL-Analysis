-- TASK 3 Route Optimization Insights --
-- Average transit time (in hours) across all shipments
SELECT r.Route_ID, ROUND(AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 2) AS Avg_Transit_Time_Hours
FROM fedex_shipments s
JOIN fedex_routes r
    ON s.Route_ID = r.Route_ID
GROUP BY r.Route_ID;

-- Average delay (in hours) per route

SELECT r.Route_ID, ROUND(AVG(s.Delay_Hours), 2) AS Avg_Delay_Hours
FROM fedex_shipments s
JOIN fedex_routes r
    ON s.Route_ID = r.Route_ID
GROUP BY r.Route_ID;

-- Distance-to-time efficiency ratio = Distance_KM / Avg_Transit_Time_Hours.
SELECT  t.Route_ID, t.Distance_KM, t.Avg_Transit_Time_Hours,
    ROUND(t.Distance_KM / t.Avg_Transit_Time_Hours, 2) AS Efficiency_Ratio
FROM (SELECT r.Route_ID,r.Distance_KM,ROUND(AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 2)  AS Avg_Transit_Time_Hours
    FROM fedex_shipments s
    JOIN fedex_routes r
        ON s.Route_ID = r.Route_ID
    GROUP BY r.Route_ID, r.Distance_KM
) t;
-- 3 routes with the worst efficiency ratio (lowest distance-to-time).
SELECT *
FROM ( SELECT r.Route_ID,r.Distance_KM,ROUND(AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 2) AS Avg_Transit_Time_Hours,
        ROUND(r.Distance_KM / AVG(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date)), 2) AS Efficiency_Ratio
    FROM fedex_shipments s
    JOIN fedex_routes r
        ON s.Route_ID = r.Route_ID
    GROUP BY r.Route_ID, r.Distance_KM
) t
ORDER BY Efficiency_Ratio ASC
LIMIT 3;
-- routes with >20% shipments delayed
SELECT r.Route_ID,COUNT(*) AS Total_Shipments,
    SUM(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date) > r.Avg_Transit_Time_Hours) AS Delayed_Shipments,
    ROUND(SUM(TIMESTAMPDIFF(HOUR, s.Pickup_Date, s.Delivery_Date) > r.Avg_Transit_Time_Hours)/ COUNT(*) * 100, 2) AS Delay_Percentage
FROM fedex_shipments s
JOIN fedex_routes r
    ON s.Route_ID = r.Route_ID
GROUP BY r.Route_ID
HAVING Delay_Percentage > 20;

-- Recommend potential routes or hub pairs for optimization explained in power point presentation--