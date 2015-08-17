-- get all days with at least 1 ride
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
  day - now() :: DATE -
  row_number()
  OVER (PARTITION BY trail_id
    ORDER BY day) AS grouping
FROM trail_counts;

-- row_number will increase by 1 for each result
-- day - now() will also increase by 1 for consecutive days
-- taking the difference yields the same "grouping"

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
      trail_id, day,
      day - now() :: DATE -
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
  trails.id,
  trails.name,
  max(streak) as streak
FROM all_streak_counts
  join trails on trail_id = trails.id
GROUP BY 1, 2
ORDER BY streak DESC;
