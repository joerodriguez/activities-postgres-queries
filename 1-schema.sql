drop table trails; drop table rides;

CREATE TABLE trails (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE rides (
  id           SERIAL PRIMARY KEY,
  user_id      INTEGER,
  trail_id     INTEGER,
  started_at   TIMESTAMP,
  completed_at TIMESTAMP
);

INSERT INTO trails (name) VALUES
  ('Dirty Bismark'), ('Betasso'), ('Walker Ranch'), ('Picture Rock'), ('Hall Ranch');

INSERT INTO rides (user_id, trail_id, started_at)
  SELECT
    (random() * 9) :: INTEGER + 1                                                          AS user_id,
    (random() * 4) :: INTEGER + 1                                                          AS trail_id,
    TIMESTAMP '2014-01-01 00:00:00' + random() * (now() - TIMESTAMP '2014-01-01 00:00:00') AS started_at
  FROM generate_series(1, 1000);

UPDATE rides
SET completed_at = (started_at + (60*60 + (random() * 180 * 60) :: INTEGER) * '1 second' :: INTERVAL);
