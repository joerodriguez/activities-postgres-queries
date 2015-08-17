-- get all days with atleast 1 ride
SELECT
  trail_id,
  date_trunc('day', completed_at) :: DATE AS day
FROM rides
GROUP BY 1, 2;

-- assign a "grouping" to consecutive days
WITH trail_counts AS (
    SELECT
      trail_id,
      date_trunc('day', completed_at) :: DATE AS day
    FROM rides
    GROUP BY 1, 2
)
SELECT
  day,
  trail_id,
  --day - '2000-01-01' :: DATE -
  row_number()
  OVER (PARTITION BY trail_id
    ORDER BY day) AS grouping
FROM trail_counts;

-- putting it all together
WITH trail_counts AS (
    SELECT
      trail_id,
      date_trunc('day', completed_at) :: DATE AS day
    FROM rides
    GROUP BY 1, 2
)
  , consecutive_groups AS (
    SELECT
      trail_id,
      day - '2000-01-01' :: DATE -
      row_number()
      OVER (PARTITION BY trail_id
        ORDER BY day) AS grouping
    FROM trail_counts
)
  , all_streak_counts AS (
    SELECT
      trail_id,
      count(*) streak
    FROM consecutive_groups
    GROUP BY trail_id, grouping
)

SELECT
  trail_id,
  max(streak)
FROM all_streak_counts
GROUP BY trail_id
ORDER BY 2 DESC;