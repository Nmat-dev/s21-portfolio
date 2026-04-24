WITH date_range AS (
    SELECT gs.missing_date::date
    FROM generate_series('2022-01-01'::date, '2022-01-10'::date, interval '1 day') AS gs(missing_date)
)
SELECT date_range.missing_date
FROM date_range
LEFT JOIN (
    SELECT visit_date
    FROM person_visits
    WHERE person_id = 1 OR person_id = 2
) AS visited ON date_range.missing_date = visited.visit_date
WHERE visited.visit_date IS NULL
ORDER BY date_range.missing_date;