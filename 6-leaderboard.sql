-- window functions (row_number, rank, avg) are useful for calculations
--   involving multiple rows related to the current row

--  leaderboard
WITH fastest_ride_per_user AS (
    SELECT DISTINCT ON (user_id, trail_id)
      user_id,
      trail_id,
      rides.completed_at - rides.started_at AS ride_time
    FROM rides
    WHERE trail_id = 1
    ORDER BY user_id, trail_id, ride_time
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