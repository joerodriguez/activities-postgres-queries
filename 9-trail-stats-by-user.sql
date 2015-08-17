select
  trail_id,
  user_id,
  min(ride_time),
  avg(ride_time),
  max(ride_time)
from (
    SELECT
      user_id,
      trail_id,
      rides.completed_at - rides.started_at AS ride_time
    FROM rides
    ORDER BY user_id, trail_id
) r
group by 1, 2
order by 1, 2;
