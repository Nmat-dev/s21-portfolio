COMMENT ON TABLE person_discounts IS 'Хранение персональных скидок клиентов для каждой пиццерии';
COMMENT ON COLUMN person_discounts.id IS 'Уникальный идентификатор записи (первичный ключ)';
COMMENT ON COLUMN person_discounts.person_id IS 'Идентификатор клиента (ссылка на таблицу person)';
COMMENT ON COLUMN person_discounts.pizzeria_id IS 'Идентификатор пиццерии (ссылка на таблицу pizzeria)';
COMMENT ON COLUMN person_discounts.discount IS 'Размер скидки в процентах (0–100), применяется к заказам';


SELECT count(*) = 5 AS check
FROM pg_description
WHERE objoid = 'person_discounts'::regclass