-- date_trunc is useful for grouping timestamps by an interval

-- by month
SELECT
  trail_id,
  trails.name                       AS trail_name,
  date_trunc('month', completed_at) AS month,
  count(*)                          AS times_ridden
FROM rides
  JOIN trails ON trail_id = trails.id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

-- by month (pretty)
SELECT
  trail_id,
  trails.name                                            AS trail_name,
  to_char(date_trunc('month', completed_at), 'Mon YYYY') AS pretty_month,
  count(*)                                               AS times_ridden
FROM rides
  JOIN trails ON trail_id = trails.id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

-- problem?