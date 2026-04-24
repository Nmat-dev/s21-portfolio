SELECT object_name
FROM 
    (SELECT name AS object_name, 1 AS sort
    FROM person
    UNION ALL
    SELECT pizza_name AS object_name, 2 AS sort
    FROM menu)
    AS personmenu
ORDER BY sort, object_name;