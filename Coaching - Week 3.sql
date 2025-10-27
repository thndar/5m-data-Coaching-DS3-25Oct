DESCRIBE vgsales;

SELECT *
From vgsales vgs;

SELECT Global_sales
From vgsales vgs;

--Which 5 games have the highest global sales? What do they have in common?

SELECT
    vgs.Name,
    vgs.Platform,
    vgs.Year,
    vgs.Genre,
    vgs.Publisher,
    vgs.Global_Sales
FROM vgsales vgs
ORDER BY vgs.Global_Sales DESC
LIMIT 5;

--Calculate total sales by genre. Which genre generates the most revenue globally?
SELECT
    vgs.Genre,  
    SUM(vgs.Global_Sales) AS Total_Global_Sales
FROM vgsales vgs
GROUP BY vgs.Genre
ORDER BY Total_Global_Sales DESC;

--Find the average sales per game for each platform. Which platforms have the highest average?
SELECT  
     vgs.Platform,
    AVG(vgs.Global_Sales) AS AVG_Sale  
FROM vgsales vgs
GROUP BY vgs.Platform
ORDER BY AVG_Sale DESC;


--Which publisher has released the most games? Do they also have the highest total sales?
SELECT  
     vgs.publisher,
     COUNT(*) AS Total_Games,
     MAX(vgs.Global_Sales) AS Total_Sale  
     FROM vgsales vgs
GROUP BY vgs.publisher
ORDER BY Total_Sale DESC;

--For games released after 2010, which genre dominated each region (NA, EU, JP)?
SELECT  
     vgs.genre,
     SUM(vgs.NA_Sales) AS NA_Total_Sale , 
     SUM(vgs.EU_Sales) AS EU_Total_Sale , 
     SUM(vgs.JP_Sales) AS JP_Total_Sale , 
     SUM(vgs.Other_Sales) AS Other_Total_Sale 
FROM vgsales vgs
WHERE TRY_CAST(vgs.Year AS INTEGER) > 2010
GROUP BY vgs.genre
ORDER BY SUM(vgs.Global_Sales) DESC;


WITH genre_totals AS (
  SELECT
    vgs.Genre,
    SUM(vgs.NA_Sales) AS NA_Total_Sales,
    SUM(vgs.EU_Sales) AS EU_Total_Sales,
    SUM(vgs.JP_Sales) AS JP_Total_Sales,
    SUM(vgs.Other_Sales) AS Other_Total_Sale
  FROM vgsales vgs
  WHERE TRY_CAST(vgs.Year AS INTEGER) > 2010
  GROUP BY vgs.Genre
)
SELECT
  (SELECT Genre FROM genre_totals ORDER BY NA_Total_Sales DESC LIMIT 1) AS Dominant_NA_Genre,
  (SELECT Genre FROM genre_totals ORDER BY EU_Total_Sales DESC LIMIT 1) AS Dominant_EU_Genre,
  (SELECT Genre FROM genre_totals ORDER BY JP_Total_Sales DESC LIMIT 1) AS Dominant_JP_Genre,
  (SELECT Genre FROM genre_totals ORDER BY Other_Total_Sale DESC LIMIT 1) AS Dominant_Other_Genre;

--Calculate the percentage of global sales that each region contributes. Which region is most important?
SELECT 
    (SUM(vgs.NA_Sales) / SUM(vgs.Global_Sales)) * 100 AS NA_Percentage,
    (SUM(vgs.EU_Sales) / SUM(vgs.Global_Sales)) * 100 AS EU_Percentage,
    (SUM(vgs.JP_Sales) / SUM(vgs.Global_Sales)) * 100 AS JP_Percentage,
    (SUM(vgs.Other_Sales) / SUM(vgs.Global_Sales)) * 100 AS Other_Percentage
FROM vgsales vgs



--7. Find games where Japanese sales exceed North American sales. What patterns do you notice about genre or
--publisher?

 SELECT  
     vgs.Genre,
     SUM(vgs.NA_Sales) AS NA_Total_Sales,
     SUM(vgs.JP_Sales) AS JP_Total_Sales   
 FROM vgsales vgs
 GROUP BY vgs.Genre
 HAVING SUM(vgs.JP_Sales) > SUM(vgs.NA_Sales)
 ORDER BY SUM(vgs.JP_Sales) DESC