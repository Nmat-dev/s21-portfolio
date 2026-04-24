SELECT 
    po.order_date, 
    p.name || ' (age:' || p.age || ')' AS person_information
FROM person p
NATURAL JOIN (
    SELECT person_id AS id, order_date 
    FROM person_order
) AS po
ORDER BY po.order_date, person_information;