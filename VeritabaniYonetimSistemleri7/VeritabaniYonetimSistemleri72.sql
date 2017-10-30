
-- *** Temel SQL *** --
-- SQL DDL Komutları --

-- CREATE --
-- Nesne (veritabanı, tablo, view, fonksiyon v.s.) oluşturmak için kullanılır


-- CREATE DATABASE --
-- Veritabanı oluşturmak için kullanılır.

CREATE DATABASE "AlisVerisUygulamasi"
ENCODING='UTF-8'
LC_COLLATE='tr_TR.UTF-8'-- Bu özellik sonradan değiştirilemez (arama, sıralama işlemleri için)
LC_CTYPE='tr_TR.UTF-8'	-- Bu özellik sonradan değiştirilemez (aksan)
OWNER postgres
TEMPLATE=template0;		--


-- CREATE SCHEMA --
-- Veritabanını mantıksal olarak bölümlere ayırmak için kullanılır. 
-- Sabit disklerdeki klasör yapısına benzetilebilir. Bu sayede veritabanı
-- daha kolay yönetilir. Çok sayıda kişinin aynı projede çalışabilmesi 
-- (isim uzayı) ve güvenlik kolaaylaşır.
 
CREATE SCHEMA sema1;


-- CREATE TABLE --
-- Tablo oluşturmak için kullanılır.

CREATE TABLE "sema1"."Urunler" (
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);


 
-- Otomatik artım örneği - SERIAL kullanımı.

CREATE TABLE "sema1"."Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);

INSERT INTO "sema1"."Urunler" 
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'TV', '13', '2017-10-30', 5);



-- Otomatik artım örneği - SEQUENCE Kullanımı 1

CREATE TABLE "Urunler" (
	"urunNo" INTEGER,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);

CREATE SEQUENCE "sayac";

ALTER SEQUENCE "sayac" OWNED BY "Urunler"."urunNo";

INSERT INTO "sema1"."Urunler"
("urunNo", "kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
(NEXTVAL('sayac'), 'ELO004', 'TV', '13', '2017-10-30', 5);



-- SEQUENCE nesnesinin bir sonraki değerini NEXTVAL kullanarak elde edebiliriz.

SELECT NEXTVAL('sayac');



-- Otomatik artım örneği - SEQUENCE Kullanımı 2
-- Tablol oluşturulurken de SEQUENCE kullanabiliriz.

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
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);



-- SQL Kısıtları (CONSTRAINTS)
-- Veri bütünlüğünün korunmasına yardımcı olur.

-- NOT NULL: Tanımlandığı alan boş olamaz. Veri girilmek zorunda.
-- DEFAULT: Tanımlandığı alana değer girilmemesi durumunda varsayılan bir
-- değerin atanmasını sağlar.

CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);

ALTER TABLE "Urunler" ALTER "uretimTarihi" DROP DEFAULT;

ALTER TABLE "Urunler" ALTER "uretimTarihi" SET DEFAULT '2017-01-01';

ALTER TABLE "Urunler" ALTER "kodu" DROP NOT NULL;

ALTER TABLE "Urunler" ALTER "kodu" SET NOT NULL;



-- UNIQUE: Tanımlandığı alandaki verilerin tekil (benzersiz, eşsiz)
-- olmasını sağlar.

CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);

ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerUnique";

ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerUnique" UNIQUE ("kodu");



-- İki alanlı UNIQUE örneği 

CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu", "adi"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);

ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerUnique";

ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerUnique" UNIQUE ("kodu", "adi");

INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'TV', '13', '2016-10-24', 5);

INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'Bilgisayar', '13', '2016-04-05', 5);

INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'Bilgisayar', '13', '2017-10-20', 5);



-- CHECK: Tanımlandığı alandaki değer aralığını sınırlamada kullanılır.

CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);

ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerCheck";

ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerCheck" CHECK ("miktari" >= 0);

INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'Bilgisayar', '13', '2016-04-05', -3);



-- PRIMARY KEY

CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo")
);


ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerPK";

ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo");



-- İki alanlı birincil anahtar örneği.

CREATE TABLE "Urunler1" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK1" PRIMARY KEY("urunNo", "kodu")
);

ALTER TABLE "Urunler1" DROP CONSTRAINT "urunlerPK1";

ALTER TABLE "Urunler1" ADD CONSTRAINT "urunlerPK1" PRIMARY KEY("urunNo", "kodu");



-- FOREIGN KEY

CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2017-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);

CREATE TABLE "Siparisler" (
	"siparisNo" SERIAL,
	"urunNo" CHAR(6) NOT NULL,
	"adet" SMALLINT NOT NULL,
	CONSTRAINT "siparisPK" PRIMARY KEY("siparisNo"),
	CONSTRAINT "siparisCheck" CHECK("miktari" > 0),
	CONSTRAINT "siparisFK" FOREIGN KEY ("urunNo") REFERENCES "Urunler"("urunNo")
);

-- Bu ifade yukarıdaki ile aynıdır. ON DELETE ve ON UPDATE durumunda ne 
-- yapılacağı belirtilmediğinde varsayılan olarak NO ACTION olur.

CREATE TABLE "Siparisler" (
	"siparisNo" SERIAL,
	"urunNo" INTEGER NOT NULL,
	"adet" SMALLINT NOT NULL,
	CONSTRAINT "siparisPK" PRIMARY KEY("siparisNo"),
	CONSTRAINT "siparisCheck" CHECK("adet" > 0),
	CONSTRAINT "siparisFK" FOREIGN KEY ("urunNo") REFERENCES "Urunler"("urunNo") ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- Üç davranış şekli: NO ACTION (varsayılan), RESTRICT, CASCADE

ALTER TABLE "Siparisler" DROP CONSTRAINT "siparisFK";

ALTER TABLE "Siparisler"
ADD CONSTRAINT "siparisFK" FOREIGN KEY ("urunNo") 
REFERENCES "Urunler"("urunNo")
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE "Siparisler"
ADD CONSTRAINT "siparisFK" FOREIGN KEY ("urunNo") 
REFERENCES "Urunler"("urunNo")
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE "Siparisler"
ADD CONSTRAINT "siparisFK" FOREIGN KEY ("urunNo") 
REFERENCES "Urunler"("urunNo")
ON DELETE CASCADE
ON UPDATE CASCADE;



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



