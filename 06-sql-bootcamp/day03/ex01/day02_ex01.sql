SELECT gs.missing_date::date AS missing_date
FROM generate_series('2022-01-01'::date, '2022-01-10'::date, interval '1 day') AS gs(missing_date)
LEFT JOIN (
    SELECT visit_date
    FROM person_visits
    WHERE person_id = 1 OR person_id = 2
) AS visited ON gs.missing_date = visited.visit_date
WHERE visited.visit_date IS NULL
ORDER BY missing_date;