-- window functions (row_number, rank, avg) are useful for calculations
--   involving multiple rows related to the current row

--  leaderboard
WITH fastest_ride_per_user AS (
    SELECT DISTINCT ON (user_id, trail_id)
      user_id,
      trail_id,
      rides.completed_at - rides.started_at AS ride_time
    FROM rides
    ORDER BY user_id, trail_id
)
SELECT
  user_id,
  trail_id,
  to_char(ride_time, 'HH24:MI:SS') AS ride_time,
  rank()
  OVER (PARTITION BY trail_id
    ORDER BY ride_time)
FROM fastest_ride_per_user
ORDER BY 2, 4;


-- HAVING is similar to WHERE, but for aggregates

-- leaderboard for trail beginners (less than 20 rides on trail)
WITH users_to_consider AS (
    SELECT
      user_id,
      trail_id
    FROM rides
    GROUP BY user_id, trail_id
    HAVING count(*) < 20
), fastest_ride_per_user AS (
    SELECT DISTINCT ON (rides.user_id, rides.trail_id)
      rides.user_id,
      rides.trail_id,
      rides.completed_at - rides.started_at AS ride_time
    FROM rides
      JOIN users_to_consider
        ON
          users_to_consider.user_id = rides.user_id
          AND users_to_consider.trail_id = rides.trail_id
    ORDER BY user_id, trail_id
)
SELECT
  user_id,
  trail_id,
  to_char(ride_time, 'HH24:MI:SS'),
  rank()
  OVER (PARTITION BY trail_id
    ORDER BY ride_time)
FROM fastest_ride_per_user
ORDER BY 2, 4;