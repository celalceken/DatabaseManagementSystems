

CREATE DATABASE "AlisVerisUygulamasi"
ENCODING='UTF-8'
LC_COLLATE='tr_TR.UTF-8'
LC_CTYPE='tr_TR.UTF-8'
OWNER postgres
TEMPLATE=template0;


-------------------------------

-- Şema Oluşturma Örneği

CREATE SCHEMA sema1;


-------------------------------

-- Otomatik Artım Örneği - SERIAL Kullanımı

CREATE TABLE "sema1"."Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK(miktari >= 0)
);

INSERT INTO "sema1"."Urunler" 
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'TV', '13', '24.10.2016', 5);


-------------------------------

-- Otomatik Artım Örneği - SEQUENCE Kullanımı 1

CREATE TABLE "Urunler" (
	"urunNo" INTEGER,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK(miktari >= 0)
);

CREATE SEQUENCE "sayac";

ALTER SEQUENCE "sayac" OWNED BY "Urunler"."urunNo";

INSERT INTO "sema1"."Urunler"
("urunNo", "kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
(NEXTVAL('sayac'), 'ELO004', 'TV', '13', '24.10.2016', 5);


-- SEQUENCE nesnesinin bir sonraki değerini NEXTVAL kullanarak elde edebiliriz.

SELECT NEXTVAL('sayac');


-------------------------------

-- Otomatik Artım Örneği - SEQUENCE Kullanımı 1

CREATE SEQUENCE "sayac";

CREATE TABLE "Urunler" (
	"urunNo" INTEGER DEFAULT NEXTVAL('sayac'),
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK(miktari >= 0)
);


-------------------------------


--NO ACTION varsayılan ayar

ALTER TABLE "orders"
ADD CONSTRAINT "lnk_employees_orders" FOREIGN KEY ("EmployeeID")
REFERENCES "employees"("EmployeeID")
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE "orders"
ADD CONSTRAINT "lnk_employees_orders" FOREIGN KEY ("EmployeeID")
REFERENCES "employees"("EmployeeID")
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE "orders"
ADD CONSTRAINT "lnk_employees_orders" FOREIGN KEY ("EmployeeID")
REFERENCES "employees" ("EmployeeID")
ON DELETE NO ACTION
ON UPDATE NO ACTION;


-------------------------------


CREATE TABLE "Musteriler" (
	"musteriNo" SERIAL NOT NULL,
	"adi" CHARACTER VARYING(40) COLLATE "pg_catalog"."default" NOT NULL,
	"soyadi" CHARACTER VARYING(40) COLLATE "pg_catalog"."default" NOT NULL,
	CONSTRAINT "musteriNoPK" PRIMARY KEY ("musteriNo")
);

CREATE INDEX "indexAdi" ON "Musteriler" ("adi");

CREATE INDEX "indexSoyadi" ON "Musteriler" USING btree ("soyadi");


-------------------------------


ALTER TABLE "SiparisDetay"
ADD CONSTRAINT "UrunSiparisUnique" UNIQUE ("urunNo", "siparisNo");


-------------------------------


SELECT SUM("UnitPrice") / COUNT("ProductID") FROM "products";

SELECT AVG("UnitPrice") FROM "products";

SELECT * FROM "products" ORDER BY "ProductID" DESC LIMIT 4


--------


SELECT "CategoryID", COUNT("CategoryID") AS "Ürün Sayısı"
FROM "products"
GROUP BY "CategoryID"

SELECT "CategoryID", SUM("UnitPrice") AS "Toplam B. Fiyat"
FROM "products"
GROUP BY "CategoryID"


SELECT   "public"."customers"."CompanyName", count("public"."orders"."OrderID"), sum("public"."products"."UnitPrice")         
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID" 
INNER JOIN "order_details"  ON "order_details"."OrderID" = "orders"."OrderID" 
INNER JOIN "products"  ON "order_details"."ProductID" = "products"."ProductID" 
GROUP BY "CompanyName"
ORDER BY 1;


SELECT "CategoryID", COUNT("CategoryID") AS "Ürün Sayısı"
FROM "products"
GROUP BY "CategoryID"
HAVING COUNT("CategoryID") > 7;

SELECT "CategoryID", COUNT("CategoryID") AS "Ürün Sayısı"
FROM "products"
GROUP BY "CategoryID"
HAVING "CategoryID"=2;

SELECT "Country", COUNT("CustomerID") AS "Müşteri Sayısı"
FROM "customers"
GROUP BY "Country"
HAVING COUNT("CustomerID") > 5;

SELECT "customers"."CompanyName", COUNT("OrderID")
FROM "orders"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID"
GROUP BY "CompanyName"
ORDER BY "CompanyName";



