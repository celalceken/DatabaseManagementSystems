
-- EXPLAIN ANALYSE

EXPLAIN ANALYSE
SELECT * FROM "orders"
WHERE "ShipCity" = 'Bern';

----------------------------------

-- PROJEKSİYON

EXPLAIN ANALYSE
SELECT * 
FROM "customer" 
INNER JOIN "store" ON "customer"."store_id" = "store"."store_id"
INNER JOIN "rental" ON "rental"."customer_id" = "customer"."customer_id" 
INNER JOIN "inventory" ON "inventory"."store_id" = "store"."store_id" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id";

-- 20:52:27 Query time: 12.442 second(s), Number of cursor's records: 23


EXPLAIN ANALYSE
SELECT "customer"."first_name", "customer"."last_name",
    "film"."film_id", "film"."title"
FROM "customer" 
INNER JOIN "store" ON "customer"."store_id" = "store"."store_id" 
INNER JOIN "rental" ON "rental"."customer_id" = "customer"."customer_id" 
INNER JOIN "inventory" ON "inventory"."store_id" = "store"."store_id" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id";

-- 20:52:40 Query time: 7.177 second(s), Number of cursor's records: 24

----------------------------------

-- LIMIT ve OFFSET

EXPLAIN ANALYSE
SELECT "store"."store_id", "film"."title"
FROM "inventory" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id";

-- 21:04:05 Query time: 5 millisecond(s), Number of cursor's records: 13


EXPLAIN ANALYSE
SELECT "store"."store_id", "film"."title"
FROM "inventory" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id"
LIMIT 20  OFFSET 39;

-- 21:04:16 Query time: 2 millisecond(s), Number of cursor's records: 12

----------------------------------

-- SIRALAMA

EXPLAIN ANALYSE
SELECT "store"."store_id", "film"."title"
FROM "inventory"
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id";

-- 21:12:37 Query time: 5 millisecond(s), Number of cursor's records: 13


EXPLAIN ANALYSE 
SELECT "store"."store_id", "film"."title"
FROM "inventory"
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id" 
ORDER BY "film"."title";

-- 21:12:41 Query time: 7 millisecond(s), Number of cursor's records: 16

----------------------------------

-- INDEX

EXPLAIN ANALYSE
SELECT * FROM "customer"
WHERE "first_name" = 'Jeniffer';

-- Execution time: 0.132 ms


EXPLAIN ANALYSE
SELECT * FROM "customer"
WHERE "last_name" = 'Davis';

-- Execution time: 0.036 ms

----------------------------------

-- EXISTS ve IN


EXPLAIN ANALYSE
SELECT DISTINCT "customer"."first_name", "customer"."last_name"
FROM "customer"
WHERE "customer_id" IN (SELECT "customer_id" FROM "payment"); 

-- 21:34:45 Query time: 3 millisecond(s), Number of cursor's records: 9


EXPLAIN ANALYSE
SELECT "customer"."first_name", "customer"."last_name"
FROM "customer"
WHERE "customer_id" IN (SELECT DISTINCT "customer_id" FROM "payment");

-- 21:34:49 Query time: 6 millisecond(s), Number of cursor's records: 10


EXPLAIN ANALYSE
SELECT "customer"."first_name", "customer"."last_name"
FROM "customer"
WHERE EXISTS 
    (SELECT "customer_id" FROM "payment" 
    WHERE "customer"."customer_id" = "payment"."customer_id");

-- 21:34:53 Query time: 4 millisecond(s), Number of cursor's records: 7

----------------------------------

-- Birleşim

EXPLAIN ANALYSE
SELECT DISTINCT "customer"."first_name", "customer"."last_name" 
FROM "customer"
INNER JOIN "payment"
ON "payment"."customer_id" = "customer"."customer_id";

-- 21:47:16 Query time: 14 millisecond(s), Number of cursor's records: 10


EXPLAIN ANALYSE
SELECT "customer"."first_name", "customer"."last_name" 
FROM "customer"
WHERE EXISTS 
    (SELECT * FROM "payment"
    WHERE "payment"."customer_id" = "customer"."customer_id");

-- 21:47:19 Query time: 4 millisecond(s), Number of cursor's records: 7

----------------------------------

-- HAVING

EXPLAIN ANALYSE
SELECT "category"."name", COUNT("film"."film_id") 
FROM "film"
LEFT OUTER JOIN "film_category" ON "film"."film_id" = "film_category"."film_id"
LEFT OUTER JOIN "category" ON "film_category"."category_id" = 
    "category"."category_id"
GROUP BY "category"."name"
HAVING "category"."name" = 'Horror' OR "category"."name" = 'Comedy';

-- 22:04:45 Query time: 3 millisecond(s), Number of cursor's records: 16


EXPLAIN ANALYSE
SELECT "category"."name", COUNT("film"."film_id") 
FROM "film"
LEFT OUTER JOIN "film_category" ON "film"."film_id" = "film_category"."film_id"
LEFT OUTER JOIN "category" ON "film_category"."category_id" = 
    "category"."category_id"
WHERE "category"."name" = 'Horror' OR "category"."name" = 'Comedy'
GROUP BY "category"."name";

-- 22:05:02 Query time: 2 millisecond(s), Number of cursor's records: 16

----------------------------------

-- Alt Sorgu Sayısı

EXPLAIN ANALYSE
SELECT * FROM "products" 
WHERE "UnitPrice" < (SELECT AVG("UnitPrice") FROM "products")
AND "UnitsInStock" < (SELECT AVG("UnitsInStock") FROM "products");

-- 22:12:27 Query time: 2 millisecond(s), Number of cursor's records: 11


EXPLAIN ANALYSE
SELECT * FROM "products" 
WHERE ("UnitPrice", "UnitsInStock") < 
    (SELECT AVG("UnitPrice"), AVG("UnitsInStock") FROM "products");

-- 22:12:32 Query time: 1 millisecond(s), Number of cursor's records: 8


----------------------------------

