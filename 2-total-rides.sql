-- count all rides
SELECT count(*)
FROM rides;

-- count rides by trail
SELECT
  trail_id,
  count(*)
FROM rides
GROUP BY trail_id;

-- order by most popular trail
SELECT
  trail_id,
  count(*)
FROM rides
GROUP BY 1
ORDER BY 2 DESC;

-- show trail names
SELECT
  trail_id,
  trails.name AS trail_name,
  count(*)    AS times_ridden
FROM rides
  JOIN trails ON trail_id = trails.id
GROUP BY 1, 2
ORDER BY 3 DESC;