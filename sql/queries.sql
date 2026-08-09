-- how many layoffs happened each year, and average size per event
SELECT l.year,
       COUNT(*) AS event_count,
       AVG(l.total_laid_off) AS avg_size
FROM layoffs l
GROUP BY l.year
ORDER BY l.year;
     
-- average layoff size and event count by industry     
SELECT c.industry,
       COUNT(*) AS event_count,
       AVG(l.total_laid_off) AS avg_size
FROM layoffs l 
JOIN companies c ON l.company=c.company
GROUP BY c.industry
ORDER BY avg_size DESC; 

-- rank industries by total layoffs, separately within each year
SELECT l.year, 
       c.industry,
       RANK() OVER (PARTITION BY l.year ORDER BY SUM(l.total_laid_off)DESC) AS industry_rank
FROM layoffs l
JOIN companies c ON l.company=c.company
GROUP BY l.year,c.industry
ORDER BY l.year,industry_rank;

-- years where average layoff size exceeded 300, using a CTE
WITH yearly_avg AS (
    SELECT l.year,
           AVG(l.total_laid_off) AS avg_size
    FROM layoffs l
    GROUP BY l.year
)
SELECT *
FROM yearly_avg
WHERE avg_size > 300;

-- average layoff size and event count by funding stage
SELECT c.stage,
       COUNT(*) AS event_count,
       AVG(l.total_laid_off) AS avg_size
FROM layoffs l
JOIN companies c ON l.company = c.company
GROUP BY c.stage
ORDER BY avg_size DESC;

-- top 10 single largest layoff events
SELECT l.company, l.date, l.total_laid_off, c.industry
FROM layoffs l
JOIN companies c ON l.company = c.company
ORDER BY l.total_laid_off DESC
LIMIT 10;

-- what fraction of layoffs disclosed a headcount, by industry
SELECT c.industry,
       AVG(l.disclosed) AS disclosure_rate
FROM layoffs l
JOIN companies c ON l.company = c.company
GROUP BY c.industry
ORDER BY disclosure_rate DESC;

-- yearly total layoffs plus a running total across years
SELECT l.year,
       SUM(l.total_laid_off) AS yearly_total,
       SUM(SUM(l.total_laid_off)) OVER (ORDER BY l.year) AS running_total
FROM layoffs l
GROUP BY l.year
ORDER BY l.year;

-- industries with more than 100 layoff events
SELECT c.industry,
       COUNT(*) AS event_count
FROM layoffs l
JOIN companies c ON l.company = c.company
GROUP BY c.industry
HAVING COUNT(*) > 100
ORDER BY event_count DESC;