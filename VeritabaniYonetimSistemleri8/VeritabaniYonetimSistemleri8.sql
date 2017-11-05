

-- *** İleri SQL *** --




-- Alt Sorgu Örnekleri



-- WHERE ifadesi içerisinde alt sorgu


SELECT AVG("UnitPrice") FROM "products";

SELECT "ProductID", "UnitPrice" FROM "products"
WHERE "UnitPrice" < (SELECT AVG("UnitPrice") FROM "products");




SELECT "ProductID" FROM "products" WHERE "ProductName" = 'Bilgisayar Y Z';

SELECT DISTINCT "public"."customers"."CustomerID",
    "public"."customers"."CompanyName",
    "public"."customers"."ContactName"
FROM "orders"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID"
INNER JOIN "order_details" ON "order_details"."OrderID" = "orders"."OrderID"
WHERE "order_details"."ProductID" =
    (SELECT "ProductID" FROM "products" WHERE "ProductName" = 'Bilgisayar Y Z')
ORDER BY "public"."customers"."CustomerID";



-- IN ifadesi ve alt sorgu


SELECT "SupplierID" FROM "products" WHERE "UnitPrice" > 18

SELECT * FROM "suppliers"
WHERE "SupplierID" IN
    (SELECT "SupplierID" FROM "products" WHERE "UnitPrice" > 18);



SELECT "ProductID" FROM "products" WHERE "ProductName" LIKE 'A%';

SELECT DISTINCT "public"."customers"."CustomerID",
    "public"."customers"."CompanyName",
    "public"."customers"."ContactName"
FROM "orders"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID"
INNER JOIN "order_details" ON "order_details"."OrderID" = "orders"."OrderID"
WHERE "order_details"."ProductID" IN
    (SELECT "ProductID" FROM "products" WHERE "ProductName" LIKE 'A%');




-- ANY ve ALL ifadeleri ve alt sorgu


SELECT * FROM  "products"
WHERE "UnitPrice" = ANY
(
    SELECT "UnitPrice"
    FROM "suppliers"
    LEFT OUTER JOIN "products"
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
);


SELECT * FROM  "products"
WHERE "UnitPrice" IN
(
    SELECT "UnitPrice"
    FROM "suppliers"
    LEFT OUTER JOIN "products"
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
);


SELECT * FROM  "products"
WHERE "UnitPrice" < ANY
(
    SELECT "UnitPrice"
    FROM "suppliers"
    LEFT OUTER JOIN "products"
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
);


SELECT * FROM  "products"
WHERE "UnitPrice" < ALL
(
    SELECT "UnitPrice"
    FROM "suppliers"
    LEFT OUTER JOIN "products"
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
);




-- HAVING ifadesi içerisinde alt sorgu


SELECT AVG("UnitsInStock") FROM "products";

SELECT "SupplierID", SUM("UnitsInStock") AS "Stoktaki Toplam Ürün Sayısı"
FROM  "products"
GROUP BY "SupplierID"
HAVING SUM("UnitsInStock") < (SELECT AVG("UnitsInStock") FROM "products");




SELECT MAX("Quantity") FROM "order_details";

SELECT "ProductID", SUM("Quantity")
FROM "order_details"
GROUP BY "ProductID"
HAVING SUM("Quantity") > (SELECT MAX("Quantity") FROM "order_details");



-- SELECT ve alt sorgu

SELECT
    "ProductName",
    "UnitsInStock",
    (SELECT MAX("UnitsInStock") FROM "products") AS "En Büyük Değer"
FROM "products";


SELECT
    "SupplierID",
    COUNT("UnitsInStock") AS "Toplam",
    SQRT(SUM(("UnitsInStock" - (SELECT AVG("UnitsInStock") FROM "products")) ^ 2) / COUNT("UnitsInStock"))  AS "Standart Sapma"
FROM "products"
GROUP BY "SupplierID"



-- İlintili Sorgu


SELECT "ProductName", "UnitPrice" FROM "products" AS "urunler1"
WHERE "urunler1"."UnitPrice" >
(
  SELECT AVG("UnitPrice") FROM "products" AS "urunler2"
  WHERE "urunler1"."SupplierID" = "urunler2"."SupplierID"
);


SELECT "CustomerID", "CompanyName", "ContactName"
FROM "customers"
WHERE EXISTS
    (SELECT * FROM "orders" WHERE "customers"."CustomerID" = "orders"."CustomerID");



-- UNION ve UNION ALL örnekleri

SELECT "CustomerID" FROM "customers"
UNION
SELECT "CustomerID" FROM "orders"
ORDER BY "CustomerID";


SELECT "CustomerID" FROM "customers"
UNION ALL
SELECT "CustomerID" FROM "orders"
ORDER BY "CustomerID";


SELECT "CompanyName", "Country" FROM "customers"
UNION ALL
SELECT "CompanyName", "Country" FROM "suppliers"
ORDER BY 2;



-- EXCEPT örneği

SELECT "CompanyName", "Country" FROM "customers"
EXCEPT
SELECT "CompanyName", "Country" FROM "suppliers"
ORDER BY 2;



-- İşlem/Hareket (Transaction)

-- İşlem (transaction) veri tabanı yönetim sistemlerinin önemli özelliklerinden birisi.
-- ACID ile belirtilen ozellikleri destekler

-- ACID:  
-- Atomicity: İşlem(transaction) kapsamındaki alt işlemlerin tamamı bir bütün olarak ele alınır. Ya alt işlemlerin tamamı 
-- başarılı olarak çalıştırılır, ya da herhangi birinde hata varsa tamamı iptal edilir ve veritabanı eski kararlı haline 
-- döndürülür. 
-- Consistency: Herhangi bir kısıt ihlal edilirse roll back işlemiyle veritabanı eski kararlı haline döndürülür.
-- Isolation: İşlemler birbirlerini (ortak kaynak kullanımı durumunda) etkilemezler. Kullanılan ortak kaynak işlem tarafından, 
-- işlem tamamlanana kadar, kilitlenir.
-- Durability: Sistem tarafından bir hata meydana gelmesi durumunda tamamlanmış olan işlem sistem çalışmaya başladıktan sonra 
-- mutlaka tamamlanır.


BEGIN; --İşleme (Transaction) başla.

INSERT INTO "order_details" ("OrderID", "ProductID", "UnitPrice", "Quantity", "Discount")
VALUES (10248, 11, 20, 2, 0);

-- Yukarıdaki sorguda hata mevcutsa ilerlenilmez.
-- Aşağıdaki sorguda hata mevcutsa bu noktadan geri sarılır (rollback).
-- Yani yukarıdaki sorguda yapılan işlemler geri alınır.

Update "products" 
SET "UnitsInStock" = "UnitsInStock" - 2
WHERE "ProductID" = 11;

-- Her iki sorguda hatasız bir şekilde icra edilirse her ikisini de işlet ve veri tabanının durumunu güncelle.

COMMIT; --İşlemi (transaction) tamamla.



BEGIN;
UPDATE Hesap SET bakiye = bakiye - 100.00
    WHERE adi = 'Ahmet';

--SAVEPOINT my_savepoint;

UPDATE Hesap SET bakiye = bakiye + 100.00
    WHERE adi = 'Mehmet';

-- parayı Mehmete değil Ayşeye gönder
--ROLLBACK TO my_savepoint;
--UPDATE Hesap SET bakiye = bakiye + 100.00
    --WHERE adi = 'Ayşe';
COMMIT;




