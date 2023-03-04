/*
Author:
    Ngai Zi Jie
Background:
    My younger sister have to move to Kuala Lumpur as her university course was commencing. To find out more about renting a room
    in Kuala Lumpur, I downloaded the latest rental pricing dataset and performed data exploration below using SQL query.
*/

-- 1. Looking at the Location with lowest monthly rent for a room with furnishing and enough bathrooms
SELECT
    RIGHT([location], LEN([location])-LEN('Kuala Lumpur - ')-1) as location,
    MIN(monthly_rent) as lowest_monthly_rent,
    COUNT(*) as amount_of_data
FROM
    [dbo].[KLRentalPropertyListings] t1 JOIN [dbo].[KLRentalDetails] t2
    ON t1.[ads_id] = t2.[ads_id]
WHERE
    furnished != 'Not Furnished' AND
    bathroom/rooms >= 0.25
GROUP BY
    [location]
ORDER BY
    [lowest_monthly_rent];

-- 2. Looking at the space vs number of tenants
-- First create a new table
DROP TABLE if exists TempTable
CREATE TABLE TempTable (
    location NVARCHAR(100),
    monthly_rent INT,
    rooms INT,
    total_space INT
)

-- Insert data into the created table with the size column type changed to INT
INSERT into TempTable
SELECT
    RIGHT([location], LEN([location])-LEN('Kuala Lumpur - ')-1),
    CAST(t2.monthly_rent as int),
    t2.rooms,
    CAST(LEFT(t2.[size], LEN(t2.[size])-LEN(' sq.ft.')) as int)
FROM
    [dbo].[KLRentalPropertyListings] t1 JOIN [dbo].[KLRentalDetails] t2
    ON t1.[ads_id] = t2.[ads_id]
ORDER BY
    size;

-- Query data and see the space per tenant for each rental property
SELECT
    *,
    total_space/rooms as space_per_tenant
FROM
    TempTable
ORDER BY
    space_per_tenant,
    monthly_rent;

-- Create View to store data
/*
CREATE VIEW TempTableView AS
    SELECT
        *,
        total_space/rooms as space_per_tenant
    FROM
        [dbo].[TempTable];
*/
