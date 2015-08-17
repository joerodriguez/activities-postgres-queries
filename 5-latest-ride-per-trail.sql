-- distinct on is useful when trying to find a single row in a group.
--   group by can also be used in many cases, but it loses the identity of the row

--  most recent ride
select
  DISTINCT on (trail_id) rides.id as ride_id,
  user_id,
  trails.name as trail_name,
  to_char(date_trunc('day', completed_at), 'Mon dd, yyyy') as completed_day
from rides
left join trails on trails.id = rides.trail_id
order by trail_id, completed_at DESC;
