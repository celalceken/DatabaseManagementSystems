

SELECT * FROM "customers";

SELECT "CompanyName", "ContactName" FROM "customers";

SELECT * FROM "customers" WHERE "Country" = 'Germany';

SELECT * FROM "customers" WHERE "Country"='Germany' and "City" = 'Berlin';

SELECT DISTINCT "City" from "customers";

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


-------------------------------------------


SELECT "CompanyName" AS "Musteriler" FROM "customers";

SELECT "UnitPrice", "UnitPrice" * 1.18 AS "KDVliTutar" FROM "products";

SELECT
"OrderID" AS "SiparisNo",
"ShipPostalCode" || ',' || "ShipAddress" AS "GonderiAdresi"
FROM "orders"
WHERE "OrderDate" BETWEEN '07/04/1996' AND '07/09/1996';


--------------------------------------


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


SELECT "CompanyName", "ContactName" INTO "MusteriYedek" FROM "customers";

INSERT INTO "MusteriYedek" SELECT "CompanyName", "ContactName" FROM "customers";
