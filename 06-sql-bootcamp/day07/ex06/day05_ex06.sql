DROP INDEX if EXISTS idx_1;

EXPLAIN ANALYSE
SELECT
    m.pizza_name AS pizza_name,
    MAX(rating) OVER (
        PARTITION BY
            rating
        ORDER BY
            rating ROWS BETWEEN unbounded preceding
            AND unbounded following
    ) AS k
FROM
    menu m
    INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
ORDER BY
    1,
    2;

CREATE INDEX idx_1 ON pizzeria (id, rating);