-- reports based on a time interval (daily, monthly) should use generate_series
--   to "fill in the gaps"

-- common table expressions improve readability. it's like setting a
--   local variable for a temporary table

-- make sure we have a trail and month with no rides
DELETE FROM rides
WHERE trail_id = 5 AND completed_at > '2015-08-01 00:00:00';

-- fill in the gaps
WITH ride_range AS (
    SELECT
      min(completed_at) AS first_ride,
      max(completed_at) AS last_ride
    FROM rides
), months AS (
    SELECT date_trunc('month', generate_series(ride_range.first_ride, ride_range.last_ride, '1 month'))
      AS month
    FROM ride_range
)

SELECT
  trails.id                         AS trail_id,
  trails.name                       AS trail_name,
  to_char(months.month, 'Mon YYYY') AS month,
  count(rides.id)                   AS times_ridden
FROM months
  JOIN trails ON TRUE
  LEFT JOIN rides
    ON rides.trail_id = trails.id
       AND months.month = date_trunc('month', rides.completed_at)
GROUP BY 1, 2, 3
ORDER BY 4;

-- for the past year only
SELECT
  trails.id                         AS trail_id,
  trails.name                       AS trail_name,
  to_char(months.month, 'Mon YYYY') AS month,
  count(rides.id)                   AS times_ridden
FROM
  (SELECT
     date_trunc('month', generate_series(now() - '1 year' :: INTERVAL, now(), '1 month')) AS month
  ) AS months
  JOIN trails ON TRUE
  LEFT JOIN rides
    ON rides.trail_id = trails.id
       AND months.month = date_trunc('month', rides.completed_at)
GROUP BY 1, 2, 3
ORDER BY 4;
