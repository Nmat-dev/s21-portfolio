SELECT 
    COALESCE(person.name, '-') AS person_name,
    filtered_visits.visit_date,
    COALESCE(pizzeria.name, '-') AS pizzeria_name
FROM (
    SELECT person_id, pizzeria_id, visit_date
    FROM person_visits
    WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-03'
) AS filtered_visits
FULL JOIN person ON filtered_visits.person_id = person.id
FULL JOIN pizzeria ON filtered_visits.pizzeria_id = pizzeria.id
ORDER BY person_name, visit_date, pizzeria_name;