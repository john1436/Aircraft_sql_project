# Aircraft Range Analysis — PostgreSQL (pgAdmin)

A compact SQL project built and executed in **pgAdmin** using the `bookings.aircrafts_data` and `bookings.airports_data` tables from the PostgreSQL Airlines demo database.

## 1) Problem Statement
Airlines must assign the right aircraft to the right routes:
- **Short-haul** aircraft → regional flights  
- **Medium-haul** aircraft → cross-country flights  
- **Long-haul** aircraft → intercontinental flights  

This project analyzes aircraft ranges, segments the fleet into haul types, and summarizes fleet distribution to support route planning decisions.

## 2) Skills Demonstrated
- SQL aggregations: `AVG`, `MAX`, `GROUP BY`, `CASE WHEN`
- Window functions: `RANK`, percentages
- Creating and managing **views** and **materialized views**
- Exporting results (CSV/Excel) for reporting and visualization

## 3) How to Run (pgAdmin)
1. Create a new database (or use an existing one) and load the airline demo dump if needed.  
2. Open **Query Tool** and run `02_views.sql` to create the `projects` schema, enrichment views, and a materialized view.  
3. Run `03_analysis.sql` for core and advanced analysis queries (and `04_airports_bonus.sql` for airport-related insights).  
4. To export results: right-click a result grid → **Export Data** → CSV/Excel. Save exports into a `sample_exports/` folder in your repo.  
5. Refresh the materialized view when data changes:
   ```sql
   REFRESH MATERIALIZED VIEW projects.mv_top_models_by_range;

## 4) Dataset

This project uses the **PostgreSQL Airline Demo Database**, a publicly available sample dataset.  
- Source: [PostgresPro Demo Database](https://postgrespro.com/community/demodb)  

For convenience, you may also include small sample CSVs (e.g., first 10–20 rows) of the key tables in a `/sample_data` folder so others can preview the structure without downloading the full dump.
