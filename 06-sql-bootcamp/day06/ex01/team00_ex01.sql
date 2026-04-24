WITH RECURSIVE travel AS (
    SELECT
        'a'::varchar AS current_node,
        ARRAY['a'::varchar] AS tour,
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
   OR total_cost = (SELECT MAX(total_cost) FROM full_routes)
ORDER BY total_cost, tour;