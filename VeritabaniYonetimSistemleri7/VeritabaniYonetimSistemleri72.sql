
-- *** Temel SQL *** --
-- SQL DDL (Veri Tanımlama Dili / Data Definition Language) Komutları --



-- INDEX --

CREATE TABLE "Musteriler" (
	"musteriNo" SERIAL NOT NULL,
	"adi" CHARACTER VARYING(40) COLLATE "pg_catalog"."default" NOT NULL,
	"soyadi" CHARACTER VARYING(40) COLLATE "pg_catalog"."default" NOT NULL,
	CONSTRAINT "musteriNoPK" PRIMARY KEY ("musteriNo")
);

CREATE INDEX "musterilerAdiIndex" ON "Musteriler" ("adi");

CREATE INDEX "musterilerSoyadiIndex" ON "Musteriler" USING btree ("soyadi");

DROP INDEX "musterilerAdiIndex";



-- Kalıtım Örneği

CREATE DATABASE "AlisVerisUygulamasi"
ENCODING='UTF-8'
LC_COLLATE='tr_TR.UTF-8'
LC_CTYPE='tr_TR.UTF-8'
OWNER postgres
TEMPLATE=template0;

CREATE SCHEMA "Personel";

CREATE TABLE "Personel"."Personel" ( 
	"personelNo" SERIAL,
	"adi" Character Varying(40) NOT NULL,
	"soyadi" Character Varying(40) NOT NULL,
	"personelTipi" Character(1) NOT NULL,
	CONSTRAINT "personelPK" PRIMARY KEY ("personelNo")
);
	
CREATE TABLE "Personel"."Danisman" ( 
	"personelNo" INT,
	"sirket" Character Varying(40) NOT NULL,
	CONSTRAINT "danismanPK" PRIMARY KEY ("personelNo")
);

CREATE TABLE "Personel"."SatisTemsilcisi" ( 
	"personelNo" INT,
	"bolge" Character Varying(40) NOT NULL,
	CONSTRAINT "satisTemsilcisiPK" PRIMARY KEY ("personelNo")
);
	

ALTER TABLE "Personel"."Danisman"
	ADD CONSTRAINT "DanismanPersonel" FOREIGN KEY ("personelNo")
	REFERENCES "Personel"."Personel" ("personelNo")
	ON DELETE CASCADE
	ON UPDATE CASCADE;


ALTER TABLE "Personel"."SatisTemsilcisi"
	ADD CONSTRAINT "SatisTemsilcisiPersonel" FOREIGN KEY ("personelNo")
	REFERENCES "Personel"."Personel" ("personelNo")
	ON DELETE CASCADE
	ON UPDATE CASCADE;


SELECT * FROM "Personel"."Personel"
INNER JOIN "Personel"."SatisTemsilcisi"
ON "Personel"."Personel"."personelNo" = "Personel"."SatisTemsilcisi"."personelNo"


SELECT "adi", "soyadi" FROM "Personel"."Personel"
WHERE "personelTipi"='S';




-- Özyineli Birleştirme / Tekli Bağıntı Örneği


CREATE TABLE "Personel" ( 
	"personelNo" SERIAL,
	"adi" Character Varying(40) NOT NULL,
	"soyadi" Character Varying(40) NOT NULL,
	"muduru" INTEGER,
	CONSTRAINT "personelPK" PRIMARY KEY ("personelNo"),
	CONSTRAINT "personelFK" FOREIGN KEY ("muduru") REFERENCES "Personel" ("personelNo") ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO "Personel"
("adi", "soyadi")
VALUES ('Ahmet', 'Şahin');

INSERT INTO "Personel"
("adi", "soyadi")
VALUES ('Ayşe', 'Kartal');

INSERT INTO "Personel"
("adi", "soyadi", "muduru")
VALUES ('Mustafa', 'Çelik', '1');

INSERT INTO "Personel"
("adi", "soyadi", "muduru")
VALUES ('Fatma', 'Demir', '2');

SELECT "Calisan"."adi" AS "Çalışan Adi",
    "Calisan"."soyadi" AS "Çalışan Soyadı",
	"Yonetici"."adi" AS "Yönetici Adi",
	"Yonetici"."soyadi" AS "Yönetici Soyadi"
FROM "Personel" AS "Calisan"
INNER JOIN "Personel" AS "Yonetici" ON "Yonetici"."personelNo" = "Calisan"."muduru";

SELECT "Calisan"."adi" AS "Çalışan Adi",
    "Calisan"."soyadi" AS "Çalışan Soyadı",
	"Yonetici"."adi" AS "Yönetici Adi",
	"Yonetici"."soyadi" AS "Yönetici Soyadi"
FROM "Personel" AS "Calisan"
LEFT OUTER JOIN "Personel" AS "Yonetici" ON "Yonetici"."personelNo" = "Calisan"."muduru";




-- Görünüm / View Örneği


CREATE OR REPLACE VIEW "public"."SiparisMusteriSatisTemsilcisi" AS
SELECT "orders"."OrderID",
    "orders"."OrderDate",
    "customers"."CompanyName",
    "customers"."ContactName",
    "employees"."FirstName",
    "employees"."LastName"
FROM "orders"
INNER JOIN "employees" ON "orders"."EmployeeID" = "employees"."EmployeeID"
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID";


SELECT * FROM "SiparisMusteriSatisTemsilcisi"




-- SQL Fonksiyonları --



-- Çoklu Satır Fonksiyonları --



-- AVG - Ortalama --


SELECT SUM("UnitPrice") / COUNT("ProductID") FROM "products";

SELECT AVG("UnitPrice") FROM "products";



-- COUNT -- Satır sayısı --
-- Sorgu sonucunda oluşan sonuç kümesindeki satır sayısını döndürür.
-- Yalnızca bir sütun için uygulanırsa o sütundaki NULL olmayan kayıtların
-- sayısı bulunur.

SELECT COUNT("Region")
FROM "customers"
WHERE "Country" = 'Mexico';

SELECT COUNT(*)
FROM "customers"
WHERE "Country" = 'Mexico';

-- Tablodaki tüm kayıtların sayısı
SELECT COUNT(*)
FROM "customers"

SELECT COUNT("CustomerID") AS "Müşteri Sayısı"
FROM "customers";

SELECT COUNT("CustomerID") AS "Müşteri Sayısı"
FROM "customers"
WHERE "Country" = 'Türkiye';




-- LIMIT

SELECT * FROM "products" ORDER BY "ProductID" ASC LIMIT 4

SELECT * FROM "products" ORDER BY "ProductID" DESC LIMIT 5




-- MAX
-- Seçilen sütundaki en büyük değere ulaşmak için kullanılır.

SELECT MAX("UnitPrice") FROM "products";

SELECT MAX("UnitPrice") AS "En Yüksek Fiyat" FROM "products";




-- MIN
-- Seçilen sütundaki en küçük değere ulaşmak için kullanılır.

SELECT MIN("UnitPrice") FROM "products";

SELECT MIN("UnitPrice") AS "En Düşük Fiyat" FROM "products";




-- SUM
-- Seçilen sütundaki değerlerin toplamına ulaşmak için kullanılır.

SELECT SUM("UnitPrice") FROM "products";

SELECT SUM("UnitPrice") AS "Toplam" FROM "products";




-- GROUP BY
-- Sorgu sonucunu belirtilen alan(lar)a göre gruplar.
-- Seçilecek alan, gruplama yapılan alan (SupplierID) ya da çoklu satır 
-- fonksiyonları (COUNT) olmalı.
-- Gruplanan alanla ilgili koşul yazılabilmesi için HAVING ifadesinin
-- kullanılması gereklidir.


-- Aşağıdaki sorgu, ü̈rünleri tedarikçilerine göre gruplar ve her 
-- tedarikçinin sağladığı ürünlerin sayısını hesaplayarak tedarikçi 
-- bilgisi ile birlikte döndürür.

SELECT "SupplierID", COUNT("SupplierID") AS "Ürün Sayısı"
FROM "products"
GROUP BY "SupplierID"


SELECT "SupplierID", SUM("UnitsInStock") AS "Stok Sayısı"
FROM "products"
GROUP BY "SupplierID"


SELECT "customers"."CompanyName", COUNT("orders"."OrderID"), SUM("products"."UnitPrice")
FROM "orders" 
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID" 
INNER JOIN "order_details" ON "order_details"."OrderID" = "orders"."OrderID" 
LEFT OUTER JOIN "products" ON "order_details"."ProductID" = "products"."ProductID" 
GROUP BY "CompanyName"
ORDER BY 1;



-- HAVING
-- Gruplandırılmış veriler üzerinde filtreleme yapma işlemi için kullanılır.
-- HAVING ile yazılan koşullar gruplama fonksiyonları ile veya gruplama 
-- yapılan alan üzerinden yapılır.

SELECT "SupplierID", COUNT("SupplierID") AS "Ürün Sayısı"
FROM "products"
GROUP BY "SupplierID"
HAVING COUNT("SupplierID") > 2;

SELECT "SupplierID", COUNT("SupplierID") AS "Ürün Sayısı"
FROM "products"
GROUP BY "SupplierID"
HAVING "SupplierID" = 2;


-- Çoklu satır fonksiyonları ile WHERE kullanılmaz.
-- Aşadğıdaki iki sorgu yanlıştır.

SELECT "SupplierID", COUNT("SupplierID") AS "Ürün Sayısı"
FROM "products"
WHERE COUNT("SupplierID") > 2;

SELECT "SupplierID", COUNT("SupplierID") AS "Ürün Sayısı"
FROM "products"
GROUP BY "SupplierID"
WHERE COUNT("SupplierID") > 2;
