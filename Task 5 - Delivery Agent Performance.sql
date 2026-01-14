-- TASK 5 Delivery Agent Performance (10 Marks)
-- Rank delivery agents (per route) by on-time delivery percentage.

WITH WarehouseStats AS (
    SELECT Warehouse_ID, COUNT(*) AS Total_Shipments,
        SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) AS On_Time_Shipments,
        ROUND(SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100,2) AS On_Time_Percentage
    FROM fedex_shipments
    GROUP BY Warehouse_ID
)
SELECT  Warehouse_ID, Total_Shipments, On_Time_Shipments, On_Time_Percentage,
    RANK() OVER (ORDER BY On_Time_Percentage DESC) AS On_Time_Rank
FROM WarehouseStats
ORDER BY On_Time_Rank;

-- agents whose on-time % is below 85%.
WITH AgentStats AS (SELECT Agent_ID, COUNT(*) AS Total_Shipments,SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) AS On_Time_Shipments,
        ROUND(SUM(CASE WHEN Delay_Hours = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS On_Time_Percentage
    FROM fedex_shipments
    GROUP BY Agent_ID
)
SELECT *
FROM AgentStats
WHERE On_Time_Percentage < 85
ORDER BY On_Time_Percentage ASC;

-- Compare the average rating and experience (in years) of the top 5 vs bottom 5 agents using subqueries.
-- Top 5 Agents

SELECT 'Top 5 Agents' AS Category,ROUND(AVG(Avg_Rating), 2) AS Avg_Rating,
    ROUND(AVG(Experience_Years), 2) AS Avg_Experience
FROM ( SELECT Avg_Rating, Experience_Years
    FROM fedex_delivery_agents
    ORDER BY Avg_Rating DESC
    LIMIT 5) AS TopAgents

UNION ALL

-- Bottom 5 Agents
SELECT 'Bottom 5 Agents' AS Category, ROUND(AVG(Avg_Rating), 2) AS Avg_Rating,
    ROUND(AVG(Experience_Years), 2) AS Avg_Experience
FROM (SELECT Avg_Rating, Experience_Years
    FROM fedex_delivery_agents
    ORDER BY Avg_Rating ASC
    LIMIT 5
) AS BottomAgents;
-- Suggest training or workload balancing strategies for low-performing agents based on insights.task refer ppt