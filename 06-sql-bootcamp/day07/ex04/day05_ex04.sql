DROP INDEX if EXISTS idx_menu_unique;
CREATE UNIQUE INDEX idx_menu_unique ON menu (pizzeria_id, pizza_name);
SET enable_seqscan = off;
EXPLAIN ANALYZE
SELECT
    pizzeria_id,
    pizza_name
FROM
    menu
WHERE
    pizzeria_id = 1
    AND pizza_name = 'cheese pizza';