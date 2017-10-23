
--***********Aşağıdaki sorgular NorthWind Örnek Veritabanını Kullanmaktadır.********--

--**************** SELECT ********************--

-- Select Komutu veritabanından veri almak (arama/listeleme) için kullanılır.

SELECT * FROM "customers";

SELECT "CompanyName", "ContactName" FROM "customers";


-- İstenilen koşula uyan kayıtların listelenmesi için WHERE komutu kullanılır.


SELECT * FROM "customers" WHERE "Country" = 'Germany';

SELECT * FROM "customers" WHERE "Country"='Germany' and "City" = 'Berlin';


--Tabloda bazı sütunlar tekrar eden kayıtlar içerebilir. “DISTINCT” ifadesi sorgu sonucu gelen değerler
-- içerisindeki tekrarlanan kayıtların tek kayıt olarak gösterilmesini sağlar.

SELECT DISTINCT "City" from "customers";

-- Sorgular sonucunda listelenen kayıtların belirli alanlara göre alfabetik veya sayısal olarak
-- artan yada azalan şeklinde sıralanması için “ORDER BY” komutu kullanılır.

SELECT * FROM "customers" ORDER BY "ContactName" ASC;

SELECT * FROM "customers" ORDER BY "ContactName" DESC;

SELECT * FROM "customers" ORDER BY "ContactName" DESC, "CompanyName";

SELECT * FROM "customers" ORDER BY "Country", "ContactName";


-------------------------------------------


SELECT * FROM "customers" WHERE "Country" LIKE '%land%';

SELECT * FROM "customers" WHERE "Country" Like '_ermany';

SELECT * FROM "customers" WHERE "City" LIKE 'L_ndon';


-------------------------------------------


SELECT * FROM "products" WHERE "UnitPrice" BETWEEN 10 AND 20;

SELECT * FROM "products" WHERE "ProductName" BETWEEN 'C' AND 'M';

select * from "customers" where "public"."customers"."Country" IN ('Japan','Türkiye');






-------------------------------------------


SELECT "CompanyName" AS "Musteriler" FROM "customers";

SELECT "UnitPrice", "UnitPrice" * 1.18 AS "KDVliTutar" FROM "products";

SELECT
"OrderID" AS "SiparisNo",
"ShipPostalCode" || ',' || "ShipAddress" AS "GonderiAdresi"
FROM "orders"
WHERE "OrderDate" BETWEEN '07/04/1996' AND '07/09/1996';


--------------------------------------

SELECT   "public"."orders"."OrderID",
         "public"."customers"."CompanyName",
         "public"."customers"."ContactName",
         "public"."orders"."OrderDate"
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID" 



SELECT   "public"."orders"."OrderID",
         "public"."customers"."CompanyName",
         "public"."customers"."ContactName",
         "public"."orders"."OrderDate"
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID"

where "OrderID"=10248




SELECT
  "orders"."OrderID" AS "Siparis No",
  "customers"."CompanyName" AS "Şirket",
  "orders"."OrderDate" AS "Sipariş Tarihi"
FROM "orders"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID";

SELECT
  "orders"."OrderID" AS "Siparis No",
  "customers"."CompanyName" AS "Şirket",
  "orders"."OrderDate" AS "Sipariş Tarihi"
FROM "orders", "customers"
WHERE "orders"."CustomerID" = "customers"."CustomerID"
ORDER BY "customers"."CompanyName" DESC;

SELECT
  "orders"."OrderID",
  "orders"."OrderDate",
  "customers"."CompanyName",
  "employees"."FirstName",
  "employees"."LastName"
FROM "orders"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID"
INNER JOIN "employees" ON "orders"."EmployeeID" = "employees"."EmployeeID";

SELECT
  "orders"."OrderID",
  "products"."ProductName"
FROM "order_details"
INNER JOIN "orders" ON "order_details"."OrderID" = "orders"."OrderID"
INNER JOIN "products" ON "order_details"."ProductID" = "products"."ProductID";


-----------------------------


SELECT
  "orders"."OrderID" as "Siparis No",
  "customers"."CompanyName" as "Şirket",
  "orders"."OrderDate" as "Sipariş Tarihi"
FROM "customers"
LEFT OUTER JOIN "orders" ON "orders"."CustomerID" = "customers"."CustomerID" ;


-----------------------------


SELECT
  "orders"."OrderID" as "Siparis No",
  "employees"."FirstName" as "Satış Temsilcisi Ad",
	"employees"."LastName" as "Satış Temsilcisi Soyad",
  "orders"."OrderDate" as "Sipariş Tarihi"
FROM "orders"
RIGHT OUTER JOIN "employees" on "orders"."EmployeeID" = "employees"."EmployeeID" ;


-----------------------------

--Bir tablodan alınan verileri, yeni bir tabloya kopyalamak için kullanılır. Yeni tablonun
--mevcut olmaması gerekir.

SELECT "CompanyName", "ContactName" INTO "MusteriYedek" FROM "customers";



--INSERT komutu tabloya yeni kayıt eklemek için kullanılır. 
--Ekleme işlemlerinde veri bütünlüğü kısıtları göz önüne alınır.

INSERT INTO "customers" ("CustomerName", "ContactName","Address", "City", "PostalCode", "Country")
VALUES ('Cardinal','Tom B. Erichsen','Skagen 21','Stavanger','4006','Norway');

--Yalnızca bazı sütunlara veri eklememizde mümkündür. Veri eklenmeyen sütunlar null (boş)
--gözükecektir.

INSERT INTO Customers ("CustomerName ", " City ", " Country ")
VALUES ('Cardinal','Stavanger','Norway');


-- Bir tablodan alınan verileri, varolan bir tabloya kopyalamak için kullanılır.

INSERT INTO "MusteriYedek" SELECT "CompanyName", "ContactName" FROM "customers"; 




--UPDATE komutu tablodaki kayıt(lar)ın değiştirilmesini sağlar.
--Güncelleme işlemlerinde veri bütünlüğü kısıtları göz önüne alınır.

UPDATE Customers
SET ContactName='Alfred Schmidt', City='Hamburg'
WHERE CustomerName='Alfreds Futterkiste';  --WHERE ifadesi kullanılmazsa tüm satırlar değiştirilir.--





--DELETE ifadesi tablodaki kayıt veya kayıtların silinmesini sağlar.
--Silme işlemlerinde veri bütünlüğü kısıtları göz önüne alınır.

DELETE FROM Customers
WHERE CustomerName='Alfreds Futterkiste' AND ContactName='Maria Anders';


--Tabloyu silmeden tablodaki bütün satırları silmek mümkündür. Aşağıdaki komut tablodaki
bütün kayıtları silmeye yarar.
DELETE FROM table_name;




