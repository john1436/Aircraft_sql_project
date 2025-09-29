-- 03_analysis.sql

-- 1) Quick peek
SELECT * FROM projects.v_aircraft_enriched ORDER BY range DESC LIMIT 10;

-- 2) Fleet distribution
SELECT * FROM projects.v_fleet_distribution;

-- 3) Manufacturer stats
SELECT * FROM projects.v_manufacturer_stats;

-- 4) Top N long-range models (window function)
SELECT *
FROM projects.mv_top_models_by_range
WHERE range_rank <= 10
ORDER BY range_rank;

-- 5) Percentiles of aircraft range (overall)
SELECT
  percentile_disc(0.50) WITHIN GROUP (ORDER BY range) AS p50,
  percentile_disc(0.90) WITHIN GROUP (ORDER BY range) AS p90,
  percentile_disc(0.95) WITHIN GROUP (ORDER BY range) AS p95
FROM bookings.aircrafts_data;

-- 6) Range buckets (every 1000 km)
SELECT
  width_bucket(range, 0, 15000, 15) AS bucket,  -- 0-1k, 1k-2k, ..., 14k-15k
  MIN(range) AS min_in_bucket,
  MAX(range) AS max_in_bucket,
  COUNT(*)   AS aircraft_count
FROM bookings.aircrafts_data
GROUP BY bucket
ORDER BY bucket;

-- 7) Data quality checks (nulls)
SELECT
  SUM(CASE WHEN range IS NULL THEN 1 ELSE 0 END) AS null_range,
  SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS null_model
FROM bookings.aircrafts_data;