DROP TABLE IF EXISTS nodes;

CREATE TABLE nodes (
    point1 VARCHAR,
    point2 VARCHAR,
    cost INT
);

INSERT INTO nodes VALUES
    ('a', 'b', 10), ('b', 'a', 10),
    ('a', 'c', 15), ('c', 'a', 15),
    ('a', 'd', 20), ('d', 'a', 20),
    ('b', 'c', 35), ('c', 'b', 35),
    ('b', 'd', 25), ('d', 'b', 25),
    ('c', 'd', 30), ('d', 'c', 30);

WITH RECURSIVE travel AS (
    SELECT
        'a'::varchar AS current_node,
        ARRAY['a'] AS tour,
        0 AS total_cost,
        1 AS nodes_count
    UNION ALL
    SELECT
        nodes.point2,
        travel.tour || nodes.point2,
        travel.total_cost + nodes.cost,
        travel.nodes_count + 1
    FROM travel
    JOIN nodes ON travel.current_node = nodes.point1
    WHERE nodes.point2 <> ALL (travel.tour)
),
full_routes AS (
    SELECT
        travel.total_cost + nodes.cost AS total_cost,
        (travel.tour || ARRAY['a'])::TEXT AS tour
    FROM travel
    JOIN nodes ON travel.current_node = nodes.point1 AND nodes.point2 = 'a'
    WHERE travel.nodes_count = 4
)

SELECT total_cost, tour
FROM full_routes
WHERE total_cost = (SELECT MIN(total_cost) FROM full_routes)
ORDER BY total_cost, tour;