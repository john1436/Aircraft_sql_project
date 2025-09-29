-- 01_views.sql
-- Create a working schema for project artifacts
CREATE SCHEMA IF NOT EXISTS projects;

-- Enriched aircraft view (JSON extraction + manufacturer + haul type)
CREATE OR REPLACE VIEW projects.v_aircraft_enriched AS
SELECT
  a.aircraft_code,
  a.model ->> 'en'                AS model_en,
  split_part(a.model ->> 'en', ' ', 1) AS manufacturer, -- 'Airbus A320' -> 'Airbus'
  a.range,
  CASE
    WHEN a.range < 3000 THEN 'Short Haul'
    WHEN a.range BETWEEN 3000 AND 6000 THEN 'Medium Haul'
    ELSE 'Long Haul'
  END AS haul_type
FROM bookings.aircrafts_data a;

-- Fleet distribution by haul type (with % of total using window)
CREATE OR REPLACE VIEW projects.v_fleet_distribution AS
SELECT
  haul_type,
  COUNT(*)                               AS num_aircraft,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_fleet
FROM projects.v_aircraft_enriched
GROUP BY haul_type
ORDER BY num_aircraft DESC;

-- Manufacturer-level stats
CREATE OR REPLACE VIEW projects.v_manufacturer_stats AS
SELECT
  manufacturer,
  COUNT(*)                             AS aircraft_count,
  ROUND(AVG(range))                    AS avg_range_km,
  MAX(range)                           AS max_range_km
FROM projects.v_aircraft_enriched
GROUP BY manufacturer
ORDER BY aircraft_count DESC, avg_range_km DESC;

-- Top models by range with ranking (materialized for fast demos)
DROP MATERIALIZED VIEW IF EXISTS projects.mv_top_models_by_range;
CREATE MATERIALIZED VIEW projects.mv_top_models_by_range AS
SELECT
  model_en,
  manufacturer,
  range,
  RANK() OVER (ORDER BY range DESC) AS range_rank
FROM projects.v_aircraft_enriched;

