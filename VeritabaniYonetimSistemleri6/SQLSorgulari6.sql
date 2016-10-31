SELECT * FROM customers;

SELECT "CompanyName","ContactName" from customers;

SELECT * FROM Customers WHERE "Country"='Germany' ;

SELECT * FROM Customers WHERE "Country"='Germany' and "City" = 'Berlin';

SELECT  distinct "City" from customers;

SELECT * FROM Customers order by "ContactName" ASC;

-------------------------------------------

SELECT * FROM Customers    WHERE "Country" LIKE '%land%';

SELECT * FROM Customers where "Country" Like '_ermany';

-------------------------------------------

SELECT * FROM Products       WHERE "UnitPrice" BETWEEN 10 AND 20;

SELECT * FROM Products       WHERE "ProductName" BETWEEN 'C' AND 'M';

-------------------------------------------

SELECT "CompanyName" as "Musteriler" from Customers;

SELECT "UnitPrice", "UnitPrice"*1.18 as "KDVliTutar"  from products;

SELECT "OrderID" as "SiparisNo", "ShipPostalCode"||','||"ShipAddress" as "GonderiAdresi" FROM "orders"   
WHERE "OrderDate" BETWEEN '07/04/1996' AND '07/09/1996'; 
 
-------------------
SELECT   "public"."orders"."OrderID" as "Siparis No",
         "public"."customers"."CompanyName" as "Şirket",
         "public"."orders"."OrderDate" as "Sipariş Tarihi"
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID" 
-------------------
SELECT   "public"."orders"."OrderID" as "Siparis No",
         "public"."customers"."CompanyName" as "Şirket",
         "public"."orders"."OrderDate" as "Sipariş Tarihi"
FROM     "orders",  "customers"
where "orders"."CustomerID" = "customers"."CustomerID" 
order by "customers"."CompanyName" DESC;

-------------------

SELECT   "public"."orders"."OrderID",
         "public"."orders"."OrderDate",
         "public"."customers"."CompanyName",
         "public"."employees"."FirstName",
         "public"."employees"."LastName"
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID" 
INNER JOIN "employees"  ON "orders"."EmployeeID" = "employees"."EmployeeID" 


-----------------------------
SELECT   "public"."orders"."OrderID" as "Siparis No",
         "public"."customers"."CompanyName" as "Şirket",
         "public"."orders"."OrderDate" as "Sipariş Tarihi"
FROM     "customers"
LEFT OUTER JOIN "orders" on "orders"."CustomerID" = "customers"."CustomerID" ;
---------------
SELECT   "public"."orders"."OrderID" as "Siparis No",
         "public"."employees"."FirstName" as "Satış Temsilcisi Ad",
		 "public"."employees"."LastName" as "Satış Temsilcisi Soyad",
         "public"."orders"."OrderDate" as "Sipariş Tarihi"
FROM     "orders"
RIGHT OUTER JOIN "employees" on "orders"."EmployeeID" = "employees"."EmployeeID" ;

select "CompanyName","ContactName" INTO "MusteriYedek02" from customers;



