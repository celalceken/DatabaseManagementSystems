——————Kalıtım—————

ALTER TABLE "personel"."Danisman"
	ADD CONSTRAINT "DanismanPersonel" FOREIGN KEY ( "personelNo" )
	REFERENCES "personel"."Personel" ( "personelNo" ) MATCH FULL
	ON DELETE Cascade
	ON UPDATE Cascade;

ALTER TABLE "personel"."SatisTemsilcisi"
	ADD CONSTRAINT "SatisTemsilcisiPersonel" FOREIGN KEY ( "personelNo" )
	REFERENCES "personel"."Personel" ( "personelNo" ) MATCH FULL
	ON DELETE Cascade
	ON UPDATE Cascade;


select * from "personel"."Personel"
inner join "personel"."SatisTemsilcisi" 
on "personel"."Personel"."personelNo"= "personel"."SatisTemsilcisi"."personelNo"


select adi,soyadi from "personel"."Personel" 
where personelTipi=’S’;

———View—————

CREATE OR REPLACE VIEW "public"."OrderCustomerEmployee" AS  
SELECT orders."OrderID",
    orders."OrderDate",
    customers."CompanyName",
    customers."ContactName",
    employees."FirstName",
    employees."LastName"
FROM ((orders
     JOIN employees ON ((orders."EmployeeID" = employees."EmployeeID")))
     JOIN customers ON ((orders."CustomerID" = customers."CustomerID")));




———————Özyineli Birleştirme/ Tekli İlişki—————

ALTER TABLE "employees"
	ADD CONSTRAINT "lnk_employees_employees" FOREIGN KEY ( "ReportsTo" )
	REFERENCES "employees" ( "EmployeeID" ) MATCH FULL
	ON DELETE Cascade
	ON UPDATE Cascade;
---------------------
SELECT   "public"."employees"."FirstName",
         "public"."employees"."LastName",
         "Yonetici"."FirstName",
         "Yonetici"."LastName"
FROM     "employees" 
INNER JOIN "employees" AS "Yonetici"  ON "Yonetici"."EmployeeID" = "employees"."ReportsTo"






——————————Alt Sorgu —————-





select avg("UnitPrice") From "products"

select "ProductID","UnitPrice" From "products"
where "UnitPrice"< (select avg("UnitPrice") From "products")





select "ProductID" from "products" where "ProductName"='Bilgisayar Y Z'


SELECT  Distinct "public"."customers"."CustomerID",
         "public"."customers"."CompanyName",
         "public"."customers"."ContactName"
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID" 
INNER JOIN "order_details"  ON "order_details"."OrderID" = "orders"."OrderID" 
where "order_details"."ProductID" =
(select "ProductID" from "products" where "ProductName"='Y Z Bilgisayar')

order by "public"."customers"."CustomerID"





select "ProductID" from "products" where "ProductName" like 'A%'

SELECT  Distinct "public"."customers"."CustomerID",
         "public"."customers"."CompanyName",
         "public"."customers"."ContactName"
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID" 
INNER JOIN "order_details"  ON "order_details"."OrderID" = "orders"."OrderID" 
where "order_details"."ProductID" IN
(select "ProductID" from "products" where "ProductName" like 'A%')




SELECT * FROM  "products"
WHERE "UnitPrice" = ANY 
(
    SELECT "UnitPrice" 
    FROM "suppliers"
    LEFT OUTER JOIN "products" 
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
)


SELECT * FROM  "products"
WHERE "UnitPrice" IN 
(
    SELECT "UnitPrice" 
    FROM "suppliers"
    LEFT OUTER JOIN "products" 
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
)


SELECT * FROM  "products"
WHERE "UnitPrice" < ANY 
(
    SELECT "UnitPrice" 
    FROM "suppliers"
    LEFT OUTER JOIN "products" 
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
)

SELECT * FROM  "products"
WHERE "UnitPrice" < ALL 
(
    SELECT "UnitPrice" 
    FROM "suppliers"
    LEFT OUTER JOIN "products" 
    ON "suppliers"."SupplierID" = "products"."SupplierID"
    WHERE "suppliers"."CompanyName" = 'Tokyo Traders'
)



SELECT "SupplierID", SUM("UnitsInStock") AS "Stoktaki Toplam Ürün Sayısı" 
FROM  "products"
GROUP BY "SupplierID"
HAVING SUM("UnitsInStock") < (SELECT AVG("UnitsInStock") FROM "products")

SELECT "CustomerID", "CompanyName", "ContactName" 
FROM "customers"
WHERE EXISTS
(
       SELECT * FROM "orders" WHERE "customers"."CustomerID" = "orders"."CustomerID"
)




select avg("Quantity") from "order_details"

select "ProductID",sum("Quantity")
from "order_details"
group by "ProductID"
having sum("Quantity")> (select max("Quantity") from "order_details"
)


SELECT 
"ProductName", 
"UnitsInStock", 
(SELECT MAX("UnitsInStock") FROM "products") AS "En Büyük Değer" 
FROM "products



SELECT "SupplierID", 
COUNT("UnitsInStock") AS "Toplam",
sqrt(SUM(("UnitsInStock" - (SELECT AVG("UnitsInStock") FROM "products")) ^ 2) / COUNT("UnitsInStock"))  AS "Standart Sapma" 
FROM "products"GROUP BY "SupplierID"



SELECT "ProductName", "UnitPrice" FROM "products" AS "urunler1”
WHERE "urunler1"."UnitPrice" > 
(
SELECT AVG("UnitPrice") FROM "products" AS "urunler2" 
WHERE "urunler1"."SupplierID" = "urunler2"."SupplierID”
)


SELECT "CustomerID", "CompanyName", "ContactName" 
FROM "customers”
WHERE EXISTS
(
SELECT * FROM "orders" WHERE "customers"."CustomerID" = "orders"."CustomerID”
)

