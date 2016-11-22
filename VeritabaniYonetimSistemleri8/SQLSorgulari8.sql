

-- Kalıtım Örneği


ALTER TABLE "personel"."Danisman"
	ADD CONSTRAINT "DanismanPersonel" FOREIGN KEY ("personelNo")
	REFERENCES "personel"."Personel" ("personelNo")
	ON DELETE CASCADE
	ON UPDATE CASCADE;


ALTER TABLE "personel"."SatisTemsilcisi"
	ADD CONSTRAINT "SatisTemsilcisiPersonel" FOREIGN KEY ("personelNo")
	REFERENCES "personel"."Personel" ("personelNo")
	ON DELETE CASCADE
	ON UPDATE CASCADE;


SELECT * FROM "personel"."Personel"
INNER JOIN "personel"."SatisTemsilcisi"
ON "personel"."Personel"."personelNo" = "personel"."SatisTemsilcisi"."personelNo"


SELECT "adi", "soyadi" FROM "personel"."Personel"
WHERE "personelTipi"='S';


------------------------------


-- Görünüm / View Örneği


CREATE OR REPLACE VIEW "public"."OrderCustomerEmployee" AS
SELECT "orders"."OrderID",
    "orders"."OrderDate",
    "customers"."CompanyName",
    "customers"."ContactName",
    "employees"."FirstName",
    "employees"."LastName"
FROM "orders"
INNER JOIN "employees" ON "orders"."EmployeeID" = "employees"."EmployeeID"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID";


------------------------------


-- Özyineli Birleştirme / Tekli İlişki Örneği


ALTER TABLE "employees"
	ADD CONSTRAINT "lnk_employees_employees" FOREIGN KEY ("ReportsTo")
	REFERENCES "employees" ("EmployeeID")
	ON DELETE CASCADE
	ON UPDATE CASCADE;


SELECT "Calisan"."FirstName" AS "Calisan Ilk Isim",
	    "Calisan"."LastName" AS "Calisan Soy Isim",
	    "Yonetici"."FirstName" AS "Yonetici Ilk Isim",
	    "Yonetici"."LastName" AS "Yonetici Soy Isim"
FROM "employees" AS "Calisan"
INNER JOIN "employees" AS "Yonetici" ON "Yonetici"."EmployeeID" = "Calisan"."ReportsTo";


------------------------------


-- Alt Sorgu Örnekleri


-- Örnek


SELECT AVG("UnitPrice") FROM "products";


SELECT "ProductID", "UnitPrice" FROM "products"
WHERE "UnitPrice" < (SELECT AVG("UnitPrice") FROM "products");


-- Örnek


SELECT "ProductID" FROM "products" WHERE "ProductName" = 'Bilgisayar Y Z';


SELECT DISTINCT "public"."customers"."CustomerID",
    "public"."customers"."CompanyName",
    "public"."customers"."ContactName"
FROM "orders"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID"
INNER JOIN "order_details" ON "order_details"."OrderID" = "orders"."OrderID"
WHERE "order_details"."ProductID" =
    (SELECT "ProductID" FROM "products" WHERE "ProductName" = 'Y Z Bilgisayar')
ORDER BY "public"."customers"."CustomerID";


-- Örnek

SELECT "SupplierID" FROM "products" WHERE "UnitPrice" > 18

SELECT * FROM "suppliers"
WHERE "SupplierID" IN
    (SELECT "SupplierID" FROM "products" WHERE "UnitPrice" > 18);


-- Örnek

SELECT "ProductID" FROM "products" WHERE "ProductName" LIKE 'A%';

SELECT DISTINCT "public"."customers"."CustomerID",
    "public"."customers"."CompanyName",
    "public"."customers"."ContactName"
FROM "orders"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID"
INNER JOIN "order_details" ON "order_details"."OrderID" = "orders"."OrderID"
WHERE "order_details"."ProductID" IN
    (SELECT "ProductID" FROM "products" WHERE "ProductName" LIKE 'A%');


-- Örnek


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


-- Örnek


SELECT "SupplierID", SUM("UnitsInStock") AS "Stoktaki Toplam Ürün Sayısı"
FROM  "products"
GROUP BY "SupplierID"
HAVING SUM("UnitsInStock") < (SELECT AVG("UnitsInStock") FROM "products");


-- Örnek


SELECT MAX("Quantity") FROM "order_details";


SELECT "ProductID", SUM("Quantity")
FROM "order_details"
GROUP BY "ProductID"
HAVING SUM("Quantity") > (SELECT MAX("Quantity") FROM "order_details");


-- Örnek


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


-- Örnek


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
