BSM211 Veritabanı Yönetim Sistemleri - Celal ÇEKEN, İsmail ÖZTEL, Veysel Harun ŞAHİN


# Temel SQL (SQL DDL Komutları; INDEKS, KALITIM, TEKLİ BAĞINTI, SQL DML Komutları; VIEW (GÖRÜNÜM), ÇOKLU SATIR FONKSİYONLARI, GRUPLAMA) 


## INDEX 

~~~sql
CREATE TABLE "Musteriler" (
	"musteriNo" SERIAL NOT NULL,
	"adi" CHARACTER VARYING(40) COLLATE "pg_catalog"."default" NOT NULL,
	"soyadi" CHARACTER VARYING(40) COLLATE "pg_catalog"."default" NOT NULL,
	CONSTRAINT "musteriNoPK" PRIMARY KEY ("musteriNo")
);
~~~

~~~sql
CREATE INDEX "musterilerAdiIndex" ON "Musteriler" ("adi");
~~~

~~~sql
CREATE INDEX "musterilerSoyadiIndex" ON "Musteriler" USING btree ("soyadi");
~~~

~~~sql
DROP INDEX "musterilerAdiIndex";
~~~

## INDEX-Örnek Uygulama 

* Örnek Ek Veritabanı

~~~sql
CREATE DATABASE "TestVeritabani"
ENCODING='UTF-8'
LC_COLLATE='tr_TR.UTF-8'
LC_CTYPE='tr_TR.UTF-8'	
OWNER postgres
TEMPLATE=template0;

CREATE TABLE "Kisiler" (
    "kisiNo" SERIAL,
	"adi" VARCHAR(40) NOT NULL,
	"soyadi" VARCHAR(40) NOT NULL,
	"kayitTarihi" TIMESTAMP DEFAULT '2019-01-01 01:00:00',
	CONSTRAINT "urunlerPK1" PRIMARY KEY("kisiNo")
);
~~~

~~~sql
CREATE OR REPLACE FUNCTION "veriGir"(kayitSayisi integer)
RETURNS VOID
AS  
$$
BEGIN   
    IF kayitSayisi > 0 THEN
        FOR i IN 1 .. kayitSayisi LOOP
            insert into "Kisiler" ("adi","soyadi", "kayitTarihi") 
            Values(
                substring('ABCÇDEFGĞHIiJKLMNOÖPRSŞTUÜVYZ' from ceil(random()*10)::smallint for ceil(random()*20)::SMALLINT), 
                substring('ABCÇDEFGĞHIiJKLMNOÖPRSŞTUÜVYZ' from ceil(random()*10)::smallint for ceil(random()*20)::SMALLINT),
                NOW() + (random() * (NOW()+'365 days' - NOW()))
                 );
        END LOOP;
    END IF; 
END;
$$
LANGUAGE 'plpgsql'  SECURITY DEFINER;
~~~

~~~sql
SELECT "veriGir"(100000);
~~~

~~~sql
EXPLAIN ANALYZE
SELECT * FROM "Kisiler"
WHERE "adi"='DENEME' -- Satırlardan birinin adi alanı "DENEME" olarak değiştirilmeli
~~~

  + Execution time: 10.274 ms

~~~sql
CREATE INDEX "adiINDEX" ON "public"."Kisiler" USING btree( "adi" Asc NULLS Last );
~~~

~~~sql
EXPLAIN ANALYZE
SELECT * FROM "Kisiler"
WHERE "adi"='DENEME' -- Satırlardan birinin adi alanı "DENEME" olarak değiştirilmeli
~~~

  + Execution time: 0.086 ms







## Kalıtım Örneği

~~~sql
CREATE DATABASE "AlisVerisUygulamasi"
ENCODING='UTF-8'
LC_COLLATE='tr_TR.UTF-8'
LC_CTYPE='tr_TR.UTF-8'
OWNER postgres
TEMPLATE=template0;
~~~

~~~sql
CREATE SCHEMA "Personel";
~~~

~~~sql
CREATE TABLE "Personel"."Personel" ( 
	"personelNo" SERIAL,
	"adi" CHARACTER VARYING(40) NOT NULL,
	"soyadi" CHARACTER VARYING(40) NOT NULL,
	"personelTipi" CHARACTER(1) NOT NULL,
	CONSTRAINT "personelPK" PRIMARY KEY ("personelNo")
);
~~~

~~~sql
CREATE TABLE "Personel"."Danisman" ( 
	"personelNo" INT,
	"sirket" CHARACTER VARYING(40) NOT NULL,
	CONSTRAINT "danismanPK" PRIMARY KEY ("personelNo")
);
~~~

~~~sql
CREATE TABLE "Personel"."SatisTemsilcisi" ( 
	"personelNo" INT,
	"bolge" CHARACTER VARYING(40) NOT NULL,
	CONSTRAINT "satisTemsilcisiPK" PRIMARY KEY ("personelNo")
);
~~~


* Temel tablo ile çocuk tablo arasında bağıntı kurulumu. "CASCADE" kullanımının en uygun olduğu yer
~~~sql
ALTER TABLE "Personel"."Danisman"
	ADD CONSTRAINT "DanismanPersonel" FOREIGN KEY ("personelNo")
	REFERENCES "Personel"."Personel" ("personelNo")
	ON DELETE CASCADE
	ON UPDATE CASCADE;
~~~

* Temel tablo ile çocuk tablo arasında bağıntı kurulumu. "CASCADE" kullanımının en uygun olduğu yer
~~~sql
ALTER TABLE "Personel"."SatisTemsilcisi"
	ADD CONSTRAINT "SatisTemsilcisiPersonel" FOREIGN KEY ("personelNo")
	REFERENCES "Personel"."Personel" ("personelNo")
	ON DELETE CASCADE
	ON UPDATE CASCADE;
~~~

* Kalıtım kullanıldığında verilerin alınması
~~~sql
SELECT * FROM "Personel"."Personel"
INNER JOIN "Personel"."SatisTemsilcisi"
ON "Personel"."Personel"."personelNo" = "Personel"."SatisTemsilcisi"."personelNo"
~~~

~~~sql
SELECT * FROM "Personel"."Personel"
INNER JOIN "Personel"."Danisman"
ON "Personel"."Personel"."personelNo" = "Personel"."Danisman"."personelNo"
~~~

* Sorguların hızlandırılması için temel tabloya eklenen alan
~~~sql
SELECT "adi", "soyadi" FROM "Personel"."Personel"
WHERE "personelTipi"='S';
~~~

~~~sql
SELECT "adi", "soyadi" FROM "Personel"."Personel"
WHERE "personelTipi"='D';
~~~

~~~sql
SELECT "adi", "soyadi" FROM "Personel"."Personel"
INNER JOIN "Personel"."Danisman"
ON "Personel"."personelNo" = "Danisman"."personelNo"
~~~


## Özyineli Birleştirme / Tekli Bağıntı Örneği

~~~sql
CREATE TABLE "Personel" (
	"personelNo" SERIAL,
	"adi" CHARACTER VARYING(40) NOT NULL,
	"soyadi" CHARACTER VARYING(40) NOT NULL,
	"yoneticisi" INTEGER,
	CONSTRAINT "personelPK" PRIMARY KEY ("personelNo"),
	CONSTRAINT "personelFK" FOREIGN KEY ("yoneticisi") REFERENCES "Personel" ("personelNo")
);
~~~

~~~sql
INSERT INTO "Personel"
("adi", "soyadi")
VALUES ('Ahmet', 'Şahin');
~~~

~~~sql
INSERT INTO "Personel"
("adi", "soyadi")
VALUES ('Ayşe', 'Kartal');
~~~

~~~sql
INSERT INTO "Personel"
("adi", "soyadi", "yoneticisi")
VALUES ('Mustafa', 'Çelik', '1');
~~~

~~~sql
INSERT INTO "Personel"
("adi", "soyadi", "yoneticisi")
VALUES ('Fatma', 'Demir', '2');
~~~

~~~sql
SELECT "Calisan"."adi" AS "calisanAdi",
    "Calisan"."soyadi" AS "calisanSoyadi",
	"Yonetici"."adi" AS "yoneticiAdi",
	"Yonetici"."soyadi" AS "yoneticiSoyadi"
FROM "Personel" AS "Calisan"
INNER JOIN "Personel" AS "Yonetici" ON "Yonetici"."personelNo" = "Calisan"."yoneticisi";
~~~

~~~sql
SELECT "Calisan"."adi" AS "calisanAdi",
    "Calisan"."soyadi" AS "calisanSoyadi",
	"Yonetici"."adi" AS "yoneticiAdi",
	"Yonetici"."soyadi" AS "yoneticiSoyadi"
FROM "Personel" AS "Calisan"
LEFT OUTER JOIN "Personel" AS "Yonetici" ON "Yonetici"."personelNo" = "Calisan"."yoneticisi";
~~~

  + Yoneticisi olmayan çalışanlar da listelenir.




## Görünüm (View) ##

* Bir veya daha fazla tablodan seçilen satırlar ve alanlardaki bilgilerin yeni bir tablo gibi görüntülenmesini temin eden yapıdır.

* Tablo(lar)dan tüm satırlar seçilebileceği gibi yalnızca belli kriterlere uyan satırlar da seçilebilir.

* Tablo(lar)daki tüm alanlar görünüme dahil edilebileceği gibi yalnızca belli alanlar da görünüme dahil edilebilir.

* Seçme (SELECT) işlemi için kısa yol tanımlamak adına kullanılır.

* Genellikle karmaşık olan seçme (SELECT) işlemlerinde tercih edilir.

* Dinamiktir. GÖRÜNÜM (VIEW) ile oluşturulan tabloya gerçekleştirilen her erişimde kendisini oluşturan ifadeler (görünüm – view ifadeleri) yeniden çalıştırılır.

* Karmaşık sorguları basit hale getirir.

* Güvenlik nedeniyle de kullanılır.
  + Örneğin şirket personeli, müşterilerin genel bilgilerini (ad, soyad, adres v.b.) görebilsin ancak kredi kartı bilgilerine erişemesin isteniyorsa yalnızca görmesini istediğimiz bilgileri içeren bir görünüm oluşturulabilir ve ilgili personeli bu görünüme yetkilendiririz.

> Aşağıdaki sorgular NorthWind Örnek Veritabanını Kullanmaktadır. 

~~~sql
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
~~~

~~~sql
SELECT * FROM "SiparisMusteriSatisTemsilcisi"
~~~

~~~sql
DROP VIEW "SiparisMusteriSatisTemsilcisi";
~~~


## SQL Fonksiyonları 

> Aşağıdaki sorgular NorthWind Örnek Veritabanını Kullanmaktadır. 



### Çoklu Satır Fonksiyonları 



* COUNT (Satır sayısı)
* Sorgu sonucunda oluşan sonuç kümesindeki satır sayısını döndürür.
* Yalnızca bir sütun için uygulanırsa o sütundaki NULL olmayan kayıtların sayısı bulunur.

~~~sql
SELECT COUNT("Region")
FROM "customers"
WHERE "Country" = 'Mexico';
~~~

~~~sql
SELECT COUNT(*)
FROM "customers"
WHERE "Country" = 'Mexico';
~~~


  + Tablodaki tüm kayıtların sayısı
~~~sql
SELECT COUNT(*)
FROM "customers"
~~~

~~~sql
SELECT COUNT("CustomerID") AS "musteriSayisi"
FROM "customers";
~~~

~~~sql
SELECT COUNT("CustomerID") AS "musteriSayisi"
FROM "customers"
WHERE "Country" = 'Türkiye';
~~~



### LIMIT

~~~sql
SELECT * FROM "products" ORDER BY "ProductID" ASC LIMIT 4
~~~

~~~sql
SELECT * FROM "products" ORDER BY "ProductID" DESC LIMIT 5
~~~



### MAX
* Seçilen sütundaki en büyük değere ulaşmak için kullanılır.

~~~sql
SELECT MAX("UnitPrice") FROM "products";
~~~

~~~sql
SELECT MAX("UnitPrice") AS "enYuksekFiyat" FROM "products";
~~~



### MIN
* Seçilen sütundaki en küçük değere ulaşmak için kullanılır.

~~~sql
SELECT MIN("UnitPrice") FROM "products";
~~~

~~~sql
SELECT MIN("UnitPrice") AS "enDusukFiyat" FROM "products";
~~~



### SUM
* Seçilen sütundaki değerlerin toplamına ulaşmak için kullanılır.

~~~sql
SELECT SUM("UnitPrice") FROM "products";
~~~

~~~sql
SELECT SUM("UnitPrice") AS "toplam" FROM "products";
~~~

### AVG - Ortalama 

~~~sql
SELECT SUM("UnitPrice") / COUNT("ProductID") FROM "products";
~~~

~~~sql
SELECT AVG("UnitPrice") FROM "products";
~~~



### GROUP BY

* Sorgu sonucunu belirtilen alan(lar)a göre gruplar.
* Seçilecek alan, gruplama yapılan alan ya da çoklu satır fonksiyonları (COUNT) olmalı.
* Gruplama işleminden sonra koşul yazılabilmesi için HAVING ifadesinin kullanılması gereklidir.


* Aşağıdaki sorgu, ü̈rünleri tedarikçilerine göre gruplar ve her tedarikçinin sağladığı ürünlerin sayısını hesaplayarak tedarikçi bilgisi ile birlikte döndürür.

~~~sql
SELECT "SupplierID", COUNT("SupplierID") AS "urunSayisi"
FROM "products"
GROUP BY "SupplierID"
~~~

~~~sql
SELECT "SupplierID", SUM("UnitsInStock") AS "stokSayisi"
FROM "products"
GROUP BY "SupplierID"
~~~

~~~sql
SELECT "customers"."CompanyName", COUNT("orders"."OrderID"), SUM("products"."UnitPrice")
FROM "orders" 
INNER JOIN "customers" ON "orders"."CustomerID" = "customers"."CustomerID" 
INNER JOIN "order_details" ON "order_details"."OrderID" = "orders"."OrderID" 
LEFT OUTER JOIN "products" ON "order_details"."ProductID" = "products"."ProductID" 
GROUP BY "CompanyName"
ORDER BY 1;
~~~


### HAVING
* Gruplandırılmış veriler üzerinde filtreleme yapma işlemi için kullanılır.
* HAVING ile yazılan koşullar çoklu satır fonksiyonları ile veya gruplama yapılan alan üzerinden yapılır.

~~~sql
SELECT "SupplierID", COUNT("SupplierID") AS "urunSayisi"
FROM "products"
GROUP BY "SupplierID"
HAVING COUNT("SupplierID") > 2;
~~~

~~~sql
SELECT "SupplierID", COUNT("SupplierID") AS "urunSayisi"
FROM "products"
GROUP BY "SupplierID"
HAVING "SupplierID" = 2;
~~~

* Çoklu satır fonksiyonları ile WHERE kullanılmaz.
* Aşağıdaki iki sorgu yanlıştır.

~~~sql
SELECT "SupplierID", COUNT("SupplierID") AS "urunSayisi"
FROM "products"
WHERE COUNT("SupplierID") > 2;
~~~

~~~sql
SELECT "SupplierID", COUNT("SupplierID") AS "urunSayisi"
FROM "products"
GROUP BY "SupplierID"
WHERE COUNT("SupplierID") > 2;
~~~



































