SELECT 
    p.name,
    m.pizza_name,
    m.price,
    m.price * (1 - COALESCE(pd.discount, 0) / 100) AS discount_price,
    pz.name AS pizzeria_name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
LEFT JOIN person_discounts pd 
    ON po.person_id = pd.person_id 
    AND m.pizzeria_id = pd.pizzeria_id
ORDER BY p.name, m.pizza_name;


SELECT 
    p.name,
    m.pizza_name,
    m.price,
    (m.price * (1 - COALESCE(pd.discount, 0) / 100))::numeric(10,0) AS discount_price,
    pz.name AS pizzeria_name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
LEFT JOIN person_discounts pd 
    ON po.person_id = pd.person_id 
    AND m.pizzeria_id = pd.pizzeria_id
ORDER BY p.name, m.pizza_name;