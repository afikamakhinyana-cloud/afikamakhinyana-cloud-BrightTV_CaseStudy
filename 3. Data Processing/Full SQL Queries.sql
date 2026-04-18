------------------------------------------------------------------------------------------------------------------------------------------------------------------
---The first part of this query is focused on exploring the data and getting a better understanding of it. I’ll be running basic queries like LIMIT, SELECT DISTINCT, and others to check things like the total number of users and users within certain age groups.

---At this stage, I won’t be switching between or joining the two tables. In Databricks, it’s possible to query data from another table within the same query as long as the table is correctly referenced in the FROM clause (using its full name if needed). Because of that, I can still work from one main query without having to move back and forth between tables.

---Once I have a clearer picture of how the data looks and behaves, I’ll move on to breaking it down and explaining it in a way that makes sense for the CEO. For now, I’ll be working within a single dataset, and I’ll introduce join queries later when I start building the presentation for the CEO.
------------------------------------------------------------------------------------------------------------------------------------------------------------------

---view all the viewership data

SELECT * 
FROM bright_tv_viewership;

--Filtering specific columns from viewership table to get more insight

SELECT UserID0, 
       Channel2, 
       RecordDate2, 
       `Duration 2`
FROM bright_tv_viewership;

---What unique provinces are there?

SELECT DISTINCT Province 
FROM bright_tv_users;

---What unique channels are there?

SELECT DISTINCT Channel2 
FROM bright_tv_viewership;

-----------------------------------------------
------How many unique users in each table?

----This query is from the users table.
SELECT COUNT(DISTINCT UserID) AS Unique_Users_In_Users_Table
FROM bright_tv_users;

----This query is from the  viewers table.
SELECT COUNT(DISTINCT UserID0) AS Unique_Users_In_Viewership_Table
FROM bright_tv_viewership;

-----------------------------------------------------------
---Now that I have some understanding of the data, I can start to explore the data further.(Lets try filtering the data to see what we can find out)
---------------------------------------------------------------------------------------------------------------------------------------------------

---I am going to find users from Gauteng only.

SELECT UserID, Name, Province, Age 
FROM bright_tv_users
WHERE Province = 'Gauteng';

---I will Find viewership for a random channel, in this example will be channel O.

SELECT UserID0, Channel2, RecordDate2, `Duration 2`
FROM bright_tv_viewership
WHERE Channel2 = 'Channel O';

---I will find users that are above age 40

SELECT UserID, 
      Name, 
      Age, 
      Province
FROM bright_tv_users
WHERE Age > 40;

---Finding viewership in March 2016 only

SELECT UserID0, 
       Channel2, 
       RecordDate2
FROM bright_tv_viewership
WHERE RecordDate2 >= '2016-03-01' AND RecordDate2 < '2016-04-01';

-----------------------------------------------------------------------------------------
---Below I will start applying SQL operators to understand the data further.
-----------------------------------------------------------------------------------------
---I will find the average duration of viewership for each channel.

SELECT Channel2, 
       AVG(`Duration 2`) AS Avg_Duration
FROM bright_tv_viewership
GROUP BY Channel2
ORDER BY Avg_Duration DESC;

---Finding users that are not from gauteng

SELECT UserID, 
       Name, 
       Province
FROM bright_tv_users
WHERE Province != 'Gauteng';

---Finding sessions shorter than 2 minutes (from Duration 2)

SELECT UserID0, 
       Channel2, 
       `Duration 2`
FROM bright_tv_viewership
WHERE MINUTE(`Duration 2`) < 2;

---I will find users that are between the age 25 and 35

SELECT UserID, 
       Name, 
       Age
FROM bright_tv_users
WHERE Age >= 25 AND Age <= 35;

---AND - Young users from Western Cape

SELECT UserID, 
       Name, 
       Age, 
       Province
FROM bright_tv_users
WHERE Age < 30 AND Province = 'Western Cape';

---OR - Users from Gauteng OR Western Cape

SELECT UserID, 
       Name, 
       Province
FROM bright_tv_users
WHERE Province = 'Gauteng' OR Province = 'Western Cape';

---Query to exclude certain channels

SELECT UserID0, 
       Channel2
FROM bright_tv_viewership
WHERE Channel2 NOT IN ('CNN', 'Boomerang');

---Finding users between age 20 and 30

SELECT UserID, 
       Name, 
       Age
FROM bright_tv_users
WHERE Age BETWEEN 20 AND 30;

----------------------------------------------------------------------------------------
---Lets start sorting the data in different sort orders to understand it more.
--------------------------------------------------------------------------------------------
---Users by age( oldest first)

SELECT UserID, 
       Name, 
       Age, 
       Province
FROM bright_tv_users
ORDER BY Age DESC;

---Viewership by date (most recent first)

SELECT UserID0, 
      Channel2, 
      RecordDate2
FROM bright_tv_viewership
ORDER BY RecordDate2 DESC;

---Sort by  Multiple columns - Channel then time

SELECT Channel2, 
       RecordDate2, 
       UserID0
FROM bright_tv_viewership
ORDER BY Channel2 ASC, RecordDate2 ASC;

---Top 10 oldest users

SELECT UserID, 
       Name, 
       Age
FROM bright_tv_users
ORDER BY Age DESC
LIMIT 10;

--- Most recent 5 viewership records

SELECT UserID0, 
       Channel2, 
       RecordDate2
FROM bright_tv_viewership
ORDER BY RecordDate2 DESC
LIMIT 5;

-----------------------------------------------------------------------
---Applying SQL aliases
------------------------------------------------------------------------
---Renaming columns to simplify

SELECT 
    UserID AS ID,
    Name AS First_Name,
    Province AS Location
FROM bright_tv_users
LIMIT 10;

---Alias with spaces (using backticks)

SELECT 
    UserID0 AS `User Identifier`,
    Channel2 AS `TV Channel`,
    RecordDate2 AS `Watch Date`
FROM bright_tv_viewership
LIMIT 10;

--------------------------------------------------------------------------
---Lets apply agrregate functions
--------------------------------------------------------------------------
---COUNT - Total users

SELECT COUNT(*) AS Total_Users
FROM bright_tv_users;

---COUNT with DISTINCT

SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT UserID0) AS Unique_Users
FROM bright_tv_viewership;

---User age statistics

SELECT 
    MIN(Age) AS Youngest_User,
    MAX(Age) AS Oldest_User,
    AVG(Age) AS Average_Age
FROM bright_tv_users
WHERE Age > 0;

-- First, understand what's in Duration 2

SELECT 
    `Duration 2`,
    HOUR(`Duration 2`) AS Hours,
    MINUTE(`Duration 2`) AS Minutes,
    SECOND(`Duration 2`) AS Seconds
FROM bright_tv_viewership
LIMIT 10;

-------------------------------------------------------------------
---I will start grouping data.
---------------------------------------------------------------------------
---Count users by province

SELECT 
    Province,
    COUNT(*) AS Number_of_Users
FROM bright_tv_users
WHERE Province IS NOT NULL
GROUP BY Province
ORDER BY Number_of_Users DESC;

---Count viewership by channel

SELECT 
    Channel2,
    COUNT(*) AS Number_of_Sessions
FROM bright_tv_viewership
GROUP BY Channel2
ORDER BY Number_of_Sessions DESC;

---Channel by hour (extract hour from RecordDate2)

SELECT 
    Channel2,
    HOUR(RecordDate2) AS UTC_Hour,
    COUNT(*) AS Sessions
FROM bright_tv_viewership
GROUP BY Channel2, HOUR(RecordDate2)
ORDER BY Channel2, UTC_Hour;


------------------------------------------------------------------------------------------------------------------------------------------------------------------
---Now that I’ve explored the data and worked through different queries and syntax, I’m shifting my focus to what’s most important for the CEO. The queries below are aimed at turning the data into simple, clear insights that I can use to build the presentation.
------------------------------------------------------------------------------------------------------------------------------------------------------------------

---I will be joining both tables and this will be my master table with all needed columns

CREATE OR REPLACE TEMP VIEW brighttv_master AS
SELECT 
    -- User columns
    u.UserID,
    u.Name,
    u.Surname,
    u.Email,
    u.Gender,
    u.Race,
    u.Age,
    u.Province,
    u.`Social Media Handle` AS Social_Media,
    
    -- Viewership columns
    v.Channel2 AS Channel,
    v.RecordDate2 AS UTC_Timestamp,
    
    -- Convert Duration to minutes
    (HOUR(v.`Duration 2`) * 60) + 
    MINUTE(v.`Duration 2`) + 
    (SECOND(v.`Duration 2`) / 60.0) AS Duration_Minutes,
    
    -- SA Time conversion (THIS IS KEY FOR YOUR CASE STUDY)
    FROM_UTC_TIMESTAMP(v.RecordDate2, 'Africa/Johannesburg') AS SA_Timestamp,
    DATE(FROM_UTC_TIMESTAMP(v.RecordDate2, 'Africa/Johannesburg')) AS SA_Date,
    HOUR(FROM_UTC_TIMESTAMP(v.RecordDate2, 'Africa/Johannesburg')) AS SA_Hour,
    DAYOFWEEK(FROM_UTC_TIMESTAMP(v.RecordDate2, 'Africa/Johannesburg')) AS SA_DayNum,
    CASE DAYOFWEEK(FROM_UTC_TIMESTAMP(v.RecordDate2, 'Africa/Johannesburg'))
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS SA_DayName

FROM bright_tv_users u
JOIN bright_tv_viewership v ON u.UserID = v.UserID0;

----lets see if the master code ran

SELECT * FROM brighttv_master LIMIT 5;

-------------------------------------------------
---PART A: INSIGHTS ON USER & USAGE TRENDS
--------------------------------------------------
---Overall platform health (Executive Summary)

SELECT 
    COUNT(DISTINCT UserID) AS Active_Users,
    COUNT(*) AS Total_Sessions,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Watch_Hours,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes,
    ROUND(SUM(Duration_Minutes) / COUNT(DISTINCT UserID), 1) AS Avg_Minutes_Per_User
FROM brighttv_master;

---Daily usage trend (How does consumption change over time?)

SELECT 
    SA_Date,
    SA_DayName,
    COUNT(DISTINCT UserID) AS Daily_Active_Users,
    COUNT(*) AS Daily_Sessions,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Daily_Hours
FROM brighttv_master
GROUP BY SA_Date, SA_DayName
ORDER BY SA_Date;

---Hourly usage pattern (SA Time - Most important for scheduling), this question answers the " When do people watch question"

SELECT 
    SA_Hour,
    CASE 
        WHEN SA_Hour BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN SA_Hour BETWEEN 6 AND 11 THEN 'Morning'
        WHEN SA_Hour BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN SA_Hour BETWEEN 18 AND 23 THEN 'Prime Time'
    END AS Time_Slot,
    COUNT(*) AS Sessions,
    COUNT(DISTINCT UserID) AS Unique_Users,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Duration
FROM brighttv_master
GROUP BY SA_Hour
ORDER BY SA_Hour;

--What would I say is the weekly pattern?

SELECT 
    SA_DayName,
    COUNT(*) AS Sessions,
    COUNT(DISTINCT UserID) AS Unique_Users,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes,
    -- What percentage of weekly total?
    ROUND(SUM(Duration_Minutes) * 100.0 / SUM(SUM(Duration_Minutes)) OVER(), 1) AS Pct_Of_Week
FROM brighttv_master
GROUP BY SA_DayNum, SA_DayName
ORDER BY SA_DayNum;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---Below I will start looking at factors that influence the users consumption
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---Does age influence what people consume?

SELECT 
    CASE 
        WHEN Age BETWEEN 0 AND 17 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        WHEN Age > 50 THEN '50+'
        ELSE 'Unknown'
    END AS Age_Group,
    COUNT(DISTINCT UserID) AS Users,
    COUNT(*) AS Sessions,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(SUM(Duration_Minutes) / COUNT(DISTINCT UserID), 1) AS Avg_Hours_Per_User,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes
FROM brighttv_master
WHERE Age > 0
GROUP BY Age_Group
ORDER BY Age_Group;

---Does Gender influence consumption?

SELECT 
    Gender,
    COUNT(DISTINCT UserID) AS Users,
    COUNT(*) AS Sessions,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(SUM(Duration_Minutes) / COUNT(DISTINCT UserID), 1) AS Avg_Hours_Per_User,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes
FROM brighttv_master
WHERE Gender IS NOT NULL AND Gender != 'None'
GROUP BY Gender;

---Does province influence influence?

SELECT 
    Province,
    COUNT(DISTINCT UserID) AS Users,
    COUNT(*) AS Sessions,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(SUM(Duration_Minutes) / COUNT(DISTINCT UserID), 1) AS Avg_Hours_Per_User
FROM brighttv_master
WHERE Province IS NOT NULL AND Province != 'None'
GROUP BY Province
ORDER BY Total_Hours DESC
LIMIT 10;

---Does Content Type (Channel) influence session length?

SELECT 
    Channel,
    COUNT(*) AS Sessions,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes,
    ROUND(PERCENTILE(Duration_Minutes, 0.5), 1) AS Median_Session_Minutes,
    -- Short sessions under 2 minutes (dropoff risk)
    ROUND(SUM(CASE WHEN Duration_Minutes < 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Pct_Sessions_Under2min
FROM brighttv_master
GROUP BY Channel
HAVING Sessions > 100
ORDER BY Avg_Session_Minutes DESC
LIMIT 15;

---Does Time of Day influence session length?

SELECT 
    CASE 
        WHEN SA_Hour BETWEEN 0 AND 5 THEN 'Late Night (0-5)'
        WHEN SA_Hour BETWEEN 6 AND 11 THEN 'Morning (6-11)'
        WHEN SA_Hour BETWEEN 12 AND 17 THEN 'Afternoon (12-17)'
        WHEN SA_Hour BETWEEN 18 AND 23 THEN 'Prime Time (18-23)'
    END AS Time_Slot,
    COUNT(*) AS Sessions,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes,
    ROUND(PERCENTILE(Duration_Minutes, 0.5), 1) AS Median_Session_Minutes
FROM brighttv_master
GROUP BY Time_Slot
ORDER BY Time_Slot;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---CONTENT RECOMMENDATIONS FOR LOW CONSUMPTION DAYS
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Identifying the lowest consumption days

SELECT 
    SA_DayName,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    COUNT(*) AS Sessions,
    COUNT(DISTINCT UserID) AS Active_Users,
    -- Rank days by consumption (1 = lowest)
    RANK() OVER (ORDER BY SUM(Duration_Minutes) ASC) AS Consumption_Rank
FROM brighttv_master
GROUP BY SA_DayNum, SA_DayName
ORDER BY Consumption_Rank;

---What channels perform well on the LOWEST day (Monday)?

SELECT 
    Channel,
    COUNT(*) AS Monday_Sessions,
    COUNT(DISTINCT UserID) AS Monday_Users,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Monday_Hours,
    ROUND(AVG(Duration_Minutes), 1) AS Monday_Avg_Duration
FROM brighttv_master
WHERE SA_DayName = 'Monday'
GROUP BY Channel
HAVING Monday_Sessions > 20
ORDER BY Monday_Hours DESC
LIMIT 10;

---Comparing channel performance: Monday vs Saturday (Peak day), This shows what works on low days vs high days


SELECT 
    Channel,
    ROUND(SUM(CASE WHEN SA_DayName = 'Monday' THEN Duration_Minutes ELSE 0 END) / 60, 1) AS Monday_Hours,
    ROUND(SUM(CASE WHEN SA_DayName = 'Saturday' THEN Duration_Minutes ELSE 0 END) / 60, 1) AS Saturday_Hours,
    -- Which channels overperform on Monday?
    ROUND((SUM(CASE WHEN SA_DayName = 'Monday' THEN Duration_Minutes ELSE 0 END) / 
           NULLIF(SUM(CASE WHEN SA_DayName = 'Saturday' THEN Duration_Minutes ELSE 0 END), 0)) * 100, 1) AS Monday_vs_Saturday_Pct
FROM brighttv_master
GROUP BY Channel
HAVING Monday_Hours > 10 OR Saturday_Hours > 10
ORDER BY Monday_vs_Saturday_Pct DESC;

---Recommended content for Monday (based on what works)

SELECT 
    Channel,
    COUNT(*) AS Sessions,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Duration,
    -- Retention score (higher is better)
    ROUND(SUM(CASE WHEN Duration_Minutes > 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Pct_Watched_Over5min
FROM brighttv_master
WHERE SA_DayName = 'Monday'
GROUP BY Channel
HAVING Sessions > 30
ORDER BY Avg_Duration DESC, Pct_Watched_Over5min DESC
LIMIT 10;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---What initiatives can we use to grow user base
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---Identify inactive users (Registered but never watched)

SELECT 
    u.UserID,
    u.Name,
    u.Email,
    u.Province,
    u.Gender,
    u.Age,
    u.`Social Media Handle`,
    'Never Watched' AS Status
FROM bright_tv_users u
LEFT JOIN bright_tv_viewership v ON u.UserID = v.UserID0
WHERE v.UserID0 IS NULL
ORDER BY u.UserID;

---Count of inactive users by province

SELECT 
    u.Province,
    COUNT(DISTINCT u.UserID) AS Total_Users,
    COUNT(DISTINCT v.UserID0) AS Active_Users,
    COUNT(DISTINCT u.UserID) - COUNT(DISTINCT v.UserID0) AS Inactive_Users,
    ROUND((COUNT(DISTINCT u.UserID) - COUNT(DISTINCT v.UserID0)) * 100.0 / COUNT(DISTINCT u.UserID), 1) AS Inactive_Percentage
FROM bright_tv_users u
LEFT JOIN bright_tv_viewership v ON u.UserID = v.UserID0
WHERE u.Province IS NOT NULL AND u.Province != 'None'
GROUP BY u.Province
ORDER BY Inactive_Users DESC;

---Segment users by engagement level

SELECT 
    UserID,
    Name,
    Province,
    Age,
    Gender,
    COUNT(*) AS Sessions,
    ROUND(SUM(Duration_Minutes), 0) AS Total_Minutes,
    CASE 
        WHEN SUM(Duration_Minutes) = 0 THEN 'Inactive'
        WHEN SUM(Duration_Minutes) < 30 THEN 'Light (under 30 min)'
        WHEN SUM(Duration_Minutes) BETWEEN 30 AND 120 THEN 'Medium (30-120 min)'
        WHEN SUM(Duration_Minutes) BETWEEN 121 AND 300 THEN 'Heavy (2-5 hours)'
        WHEN SUM(Duration_Minutes) > 300 THEN 'Super User (5+ hours)'
    END AS Engagement_Tier
FROM brighttv_master
GROUP BY UserID, Name, Province, Age, Gender
ORDER BY Total_Minutes DESC;

---What channels do the most engaged users watch?

WITH heavy_users AS (
    SELECT UserID
    FROM brighttv_master
    GROUP BY UserID
    HAVING SUM(Duration_Minutes) > 120
)
SELECT 
    Channel,
    COUNT(DISTINCT h.UserID) AS Heavy_User_Count,
    COUNT(*) AS Total_Sessions,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Duration
FROM brighttv_master m
JOIN heavy_users h ON m.UserID = h.UserID
GROUP BY Channel
ORDER BY Heavy_User_Count DESC
LIMIT 10;

---Best time to send push notifications to inactive users

SELECT 
    SA_Hour,
    COUNT(DISTINCT UserID) AS Active_Users_At_This_Hour,
    COUNT(*) AS Sessions,
    RANK() OVER (ORDER BY COUNT(DISTINCT UserID) DESC) AS Engagement_Rank
FROM brighttv_master
GROUP BY SA_Hour
ORDER BY Engagement_Rank
LIMIT 5;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------This query is the query that I will extract to excel so that I can be able to create all the necessary tables for the project.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- PRESENTATION SLIDE 2: Executive Summary
-- Heading: Key Platform Metrics
-- Description: Overall health of BrightTV platform showing active users, watch time, and engagement levels
-- ============================================

SELECT 
    'Active Users' AS Metric,
    COUNT(DISTINCT UserID) AS Value,
    '4,386 out of 5,375 total (82% active rate)' AS Insight
FROM brighttv_master

UNION ALL

SELECT 
    'Total Watch Hours',
    ROUND(SUM(Duration_Minutes) / 60, 0),
    '1,523 hours watched in Q1 2016'
FROM brighttv_master

UNION ALL

SELECT 
    'Total Sessions',
    COUNT(*),
    '10,000 viewing sessions recorded'
FROM brighttv_master

UNION ALL

SELECT 
    'Avg Session (Minutes)',
    ROUND(AVG(Duration_Minutes), 1),
    '9.1 minutes average - short form content preferred'
FROM brighttv_master

UNION ALL

SELECT 
    'Avg Per User (Minutes)',
    ROUND(SUM(Duration_Minutes) / COUNT(DISTINCT UserID), 1),
    '21 minutes per user over 3 months'
FROM brighttv_master

UNION ALL

SELECT 
    'Inactive Users',
    (SELECT COUNT(DISTINCT UserID) FROM bright_tv_users) - (SELECT COUNT(DISTINCT UserID) FROM brighttv_master),
    '989 users registered but never watched - growth opportunity'
FROM (SELECT 1) t;

-- ============================================
-- PRESENTATION SLIDE 3: Weekly Consumption Pattern
-- Heading: Weekly Viewing Pattern - Which Days Drive the Most Consumption?
-- Description: Saturday has the highest consumption (296 hours). Monday has the lowest (115 hours) - 61% lower than Saturday.
-- Key Insight: Monday is the biggest opportunity for growth
-- ============================================

SELECT 
    SA_DayName AS Day_of_Week,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    COUNT(*) AS Sessions,
    COUNT(DISTINCT UserID) AS Active_Users,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes
FROM brighttv_master
GROUP BY SA_DayNum, SA_DayName
ORDER BY SA_DayNum;

-- ============================================
-- PRESENTATION SLIDE 4: Hourly Consumption Pattern (SA Time)
-- Heading: When Do Users Watch? - Hourly Viewing Pattern
-- Description: Peak viewing is 5PM-7PM (after work/school). 5PM has 648 sessions - the highest of any hour.
-- Key Insight: Schedule premier content between 3PM-7PM for maximum reach
-- ============================================

SELECT 
    SA_Hour AS Hour_SA_Time,
    COUNT(*) AS Sessions,
    COUNT(DISTINCT UserID) AS Active_Users,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes,
    CASE 
        WHEN SA_Hour BETWEEN 15 AND 19 THEN 'PEAK TIME'
        WHEN SA_Hour BETWEEN 20 AND 23 THEN 'EVENING'
        WHEN SA_Hour BETWEEN 6 AND 11 THEN 'MORNING'
        ELSE 'OFF-PEAK'
    END AS Time_Category
FROM brighttv_master
GROUP BY SA_Hour
ORDER BY SA_Hour;

-- ============================================
-- PRESENTATION SLIDE 5: Top Performing Channels
-- Heading: Which Channels Drive the Most Engagement?
-- Description: Sports and Music dominate the top 10. ICC Cricket World Cup leads with 412 hours.
-- Key Insight: Live sports events generate the longest session durations
-- ============================================

SELECT 
    Channel,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    COUNT(*) AS Sessions,
    COUNT(DISTINCT UserID) AS Unique_Viewers,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes,
    ROUND(SUM(Duration_Minutes) * 100.0 / SUM(SUM(Duration_Minutes)) OVER(), 1) AS Percentage_Of_Total
FROM brighttv_master
GROUP BY Channel
ORDER BY Total_Hours DESC
LIMIT 10;

-- ============================================
-- PRESENTATION SLIDE 6: Monday vs Saturday Comparison
-- Heading: The Monday Problem - 61% Lower Consumption Than Saturday
-- Description: Monday has only 115 hours vs Saturday's 296 hours. This is the biggest growth opportunity.
-- Key Insight: Increasing Monday by just 50% would add 57+ hours per week
-- ============================================

SELECT 
    SA_DayName AS Day_of_Week,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    COUNT(*) AS Sessions,
    COUNT(DISTINCT UserID) AS Active_Users,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes,
    CASE 
        WHEN SA_DayName = 'Monday' THEN 'OPPORTUNITY - Lowest performing day'
        WHEN SA_DayName = 'Saturday' THEN 'BENCHMARK - Best performing day'
    END AS Insight
FROM brighttv_master
WHERE SA_DayName IN ('Monday', 'Saturday')
GROUP BY SA_DayName;

-- ============================================
-- PRESENTATION SLIDE 7: What Works on Mondays?
-- Heading: Top Performing Channels on Monday
-- Description: These channels already perform well on Mondays. Promote these to boost Monday consumption.
-- Key Insight: Music and sports highlights work best on low-performing days
-- ============================================

SELECT 
    Channel,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Monday_Hours,
    COUNT(*) AS Monday_Sessions,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes
FROM brighttv_master
WHERE SA_DayName = 'Monday'
GROUP BY Channel
ORDER BY Monday_Hours DESC
LIMIT 5;

-- ============================================
-- PRESENTATION SLIDE 8: User Engagement Segmentation
-- Heading: User Segmentation - Who Are Your Users?
-- Description: Most users are Light or Medium engagers. 989 users are completely inactive.
-- Key Insight: Reactivating inactive users and upgrading Light users is the fastest growth path
-- ============================================

WITH user_totals AS (
    SELECT 
        UserID,
        SUM(Duration_Minutes) AS Total_Minutes
    FROM brighttv_master
    GROUP BY UserID
)
SELECT 
    CASE 
        WHEN Total_Minutes = 0 THEN 'Inactive (0 min)'
        WHEN Total_Minutes < 30 THEN 'Very Light (<30 min)'
        WHEN Total_Minutes BETWEEN 30 AND 120 THEN 'Light (30-120 min)'
        WHEN Total_Minutes BETWEEN 121 AND 300 THEN 'Medium (2-5 hours)'
        WHEN Total_Minutes > 300 THEN 'Heavy (5+ hours)'
    END AS Engagement_Tier,
    COUNT(*) AS User_Count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS Percentage
FROM user_totals
GROUP BY Engagement_Tier
ORDER BY 
    CASE Engagement_Tier
        WHEN 'Inactive (0 min)' THEN 1
        WHEN 'Very Light (<30 min)' THEN 2
        WHEN 'Light (30-120 min)' THEN 3
        WHEN 'Medium (2-5 hours)' THEN 4
        WHEN 'Heavy (5+ hours)' THEN 5
    END;

-- ============================================
-- PRESENTATION SLIDE 9: Best Times to Reach Users
-- Heading: Optimal Push Notification Times
-- Description: 5PM (17:00) has the most active users - 584 users watching at this hour.
-- Key Insight: Schedule all push notifications for 5PM SA time for maximum reach
-- ============================================

SELECT 
    SA_Hour AS Hour_SA_Time,
    COUNT(DISTINCT UserID) AS Active_Users,
    COUNT(*) AS Sessions,
    RANK() OVER (ORDER BY COUNT(DISTINCT UserID) DESC) AS Engagement_Rank,
    CASE 
        WHEN SA_Hour = 17 THEN 'BEST TIME - Send notifications here'
        WHEN SA_Hour IN (12, 19, 18, 20) THEN 'SECONDARY - Good alternative times'
        ELSE 'Other'
    END AS Recommendation
FROM brighttv_master
GROUP BY SA_Hour
ORDER BY Active_Users DESC
LIMIT 5;


-- PRESENTATION: Factors Influencing Consumption - Gender
-- Heading: Does Gender Affect Viewing Habits?
-- Description: Compares male vs female viewing behavior

SELECT 
    Gender,
    COUNT(DISTINCT UserID) AS Number_of_Users,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(SUM(Duration_Minutes) / COUNT(DISTINCT UserID), 1) AS Avg_Minutes_Per_User,
    ROUND(AVG(Duration_Minutes), 1) AS Avg_Session_Minutes
FROM brighttv_master
WHERE Gender IN ('male', 'female')
GROUP BY Gender;

---------------------------------------------------------------------------------------------------
-- PRESENTATION: Factors Influencing Consumption - Province
-- Heading: Which Provinces Have the Highest Engagement?
-- Description: Geographic distribution of users and watch time
-----------------------------------------------------------------------------------------------
SELECT 
    Province,
    COUNT(DISTINCT UserID) AS Number_of_Users,
    ROUND(SUM(Duration_Minutes) / 60, 1) AS Total_Hours,
    ROUND(SUM(Duration_Minutes) / COUNT(DISTINCT UserID), 1) AS Avg_Hours_Per_User
FROM brighttv_master
WHERE Province IS NOT NULL AND Province != 'None'
GROUP BY Province
ORDER BY Total_Hours DESC
LIMIT 5;

--------------------------------------------------------------------------------------------------------
-- PRESENTATION: Content Recommendations for Low Days
-- Heading: What Content Works on Mondays (Lowest Day)?
-- Description: Channels that perform well on Monday vs their average performance
------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    Channel,
    ROUND(AVG(CASE WHEN SA_DayName = 'Monday' THEN Duration_Minutes END), 1) AS Monday_Avg_Duration,
    ROUND(AVG(Duration_Minutes), 1) AS Overall_Avg_Duration,
    ROUND(AVG(CASE WHEN SA_DayName = 'Monday' THEN Duration_Minutes END) - AVG(Duration_Minutes), 1) AS Difference,
    CASE 
        WHEN AVG(CASE WHEN SA_DayName = 'Monday' THEN Duration_Minutes END) > AVG(Duration_Minutes) THEN 'OVERPERFORMS on Monday'
        ELSE 'Underperforms on Monday'
    END AS Monday_Performance
FROM brighttv_master
WHERE SA_DayName IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
GROUP BY Channel
HAVING COUNT(CASE WHEN SA_DayName = 'Monday' THEN 1 END) > 10
ORDER BY Monday_Avg_Duration DESC
LIMIT 5;

----------------------------------------------------------------------------------------------------------------------------------------------
-- PRESENTATION: Growth Initiatives - Inactive Users
-- Heading: Who Are the Inactive Users?
-- Description: 989 users registered but never watched anything
---------------------------------------------------------------------------------------------------------------------

SELECT 
    u.UserID,
    u.Name,
    u.Email,
    u.Province,
    u.Gender,
    CASE 
        WHEN u.Age BETWEEN 18 AND 30 THEN 'Young Adult'
        WHEN u.Age BETWEEN 31 AND 45 THEN 'Adult'
        WHEN u.Age > 45 THEN 'Middle Age+'
        ELSE 'Unknown'
    END AS Age_Category
FROM bright_tv_users u
LEFT JOIN bright_tv_viewership v ON u.UserID = v.UserID0
WHERE v.UserID0 IS NULL
LIMIT 20;

