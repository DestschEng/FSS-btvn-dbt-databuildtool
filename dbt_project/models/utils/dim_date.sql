SELECT
    date AS date,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(QUARTER FROM date) AS quarter,
    CASE WHEN EXTRACT(MONTH FROM date) IN (1, 2, 3) THEN 'Q1'
         WHEN EXTRACT(MONTH FROM date) IN (4, 5, 6) THEN 'Q2'
         WHEN EXTRACT(MONTH FROM date) IN (7, 8, 9) THEN 'Q3'
         ELSE 'Q4' END AS quarter_name
FROM GENERATE_SERIES(
    '2020-01-01'::DATE, 
    '2030-12-31'::DATE, 
    INTERVAL '1 day'
) AS date
