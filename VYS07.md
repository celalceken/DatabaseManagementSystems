BSM211 Veritabanı Yönetim Sistemleri - Celal ÇEKEN, İsmail ÖZTEL, Veysel Harun ŞAHİN


# Temel SQL (SQL DDL Komutları; CREATE, ALTER, DROP, ADD, SET, CONSTRAINTS)

## Konular

* Nesne oluşturma, silme, düzenleme
* SQL Kısıtları (CONSTRAINTS)


## Nesne oluşturma, silme, düzenleme

### CREATE 

* Nesne (veritabanı, şema, tablo, view, fonksiyon vb.) oluşturmak için kullanılır


### CREATE DATABASE 
* Veritabanı oluşturmak için kullanılır.

~~~sql
CREATE DATABASE "AlisVerisUygulamasi"
ENCODING='UTF-8'
LC_COLLATE='tr_TR.UTF-8'-- Bu özellik sonradan değiştirilemez (arama, sıralama işlemleri için)
LC_CTYPE='tr_TR.UTF-8'	-- Bu özellik sonradan değiştirilemez (büyük küçük harf dönüşümü, bir veri harf mi? vb.)
OWNER postgres
TEMPLATE=template0;
~~~

* Windows işletim sistemi için

~~~sql
CREATE DATABASE "AlisVerisUygulamasi"
ENCODING='UTF-8'
LC_COLLATE='Turkish_Turkey.1254'
LC_CTYPE='Turkish_Turkey.1254'
OWNER postgres
TEMPLATE=template0;
~~~



### CREATE SCHEMA 

* Veritabanını mantıksal olarak bölümlere ayırmak için kullanılır. 
* Sabit disklerdeki klasör yapısına benzetilebilir. Bu sayede veritabanı daha kolay yönetilir. Çok sayıda kişinin aynı projede çalışabilmesi (isim uzayı) ve güvenlik kolaylaşır.

~~~sql
CREATE SCHEMA "sema1";
~~~



### CREATE TABLE 

* Tablo oluşturmak için kullanılır.

* Tablo oluşturulurken sütunlarının veri tipi bildirilir.
* PostgreSQL'deki veri tiplerine aşağıdaki sayfadan erişilebilir.
  + https://www.postgresql.org/docs/10/static/datatype.html
* Sütunlar için uygun veri tipinin seçilmesi önemlidir. Bu yapıldığı takdirde;
  + Hız artar, kaynaklar etkin kullanılır.
  + Veriler tutarlı olarak saklanır (doğrulama).
  + Bazı saldırılara karşı önlem alınmış olur.

~~~sql
CREATE TABLE "sema1"."Urunler" (
    "urunNo" SERIAL,
    "kodu" CHAR(6) NOT NULL,
    "adi" VARCHAR(40) NOT NULL,
    "uretimTarihi" DATE DEFAULT '2019-01-01',
    "birimFiyati" MONEY,
    "miktari" SMALLINT DEFAULT 0,
    CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
    CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
    CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~


### DROP TABLE

~~~sql
DROP TABLE "sema1"."Urunler";
~~~


### DROP SCHEMA

~~~sql
DROP SCHEMA "sema1";
~~~



### DROP DATABASE

~~~sql
DROP DATABASE "AlisVerisUygulamasi";
~~~


 
### TRUNCATE TABLE

* Bir tablonun içindeki tüm verileri silmek için kullanılır.

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
INSERT INTO "Urunler" 
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO001', 'TV', '13', '2019-10-30', 5);

INSERT INTO "Urunler" 
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO002', 'TV', '13', '2019-10-30', 5);
~~~

~~~sql
TRUNCATE TABLE "Urunler";
~~~



### ALTER TABLE
* Tablonun yapısını düzenlemek için kullanılır.

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
ALTER TABLE "Urunler" ADD COLUMN "uretimYeri" VARCHAR(30);
~~~

~~~sql
ALTER TABLE "Urunler" DROP COLUMN "uretimYeri";
~~~

~~~sql
ALTER TABLE "Urunler" ADD "uretimYeri" VARCHAR(30);
~~~

~~~sql
ALTER TABLE "Urunler" ALTER COLUMN "uretimYeri" TYPE CHAR(20);
~~~



* Otomatik artım örneği - SERIAL kullanımı.

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
INSERT INTO "Urunler" 
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'TV', '13', '2019-10-30', 5);
~~~


* Otomatik artım örneği - SEQUENCE Kullanımı 1

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" INTEGER,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
CREATE SEQUENCE "sayac";
~~~

~~~sql
ALTER SEQUENCE "sayac" OWNED BY "Urunler"."urunNo";
~~~

~~~sql
INSERT INTO "Urunler"
("urunNo", "kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
(NEXTVAL('"public"."sayac"'), 'ELO004', 'TV', '13', '2019-10-30', 5);
~~~


* SEQUENCE nesnesinin bir sonraki değerini NEXTVAL kullanarak elde edebiliriz.
* SEQUENCE işleme fonksiyonlarını aşağıdaki bağlantıdan öğrenebiliriz.
* https://www.postgresql.org/docs/10/static/functions-sequence.html

~~~sql
SELECT NEXTVAL('sayac');
~~~

~~~sql
SELECT CURRVAL('sayac');
~~~


* Otomatik artım örneği - SEQUENCE Kullanımı 2
  + Tablo oluşturulurken de SEQUENCE kullanabiliriz.

~~~sql
CREATE SEQUENCE "sayac";
~~~

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" INTEGER DEFAULT NEXTVAL('sayac'),
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
INSERT INTO "Urunler"
("urunNo", "kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
(NEXTVAL('sayac'), 'ELO004', 'TV', '13', '2019-10-30', 5);
~~~

~~~sql
INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'TV', '13', '2019-10-30', 5);
~~~



## SQL Kısıtları (CONSTRAINTS)

* Veri bütünlüğünün korunmasına yardımcı olur.



### NOT NULL 
* Tanımlandığı alan boş olamaz. Veri girilmek zorundadır.

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

* "kodu" alanına veri girilmediği zaman hata alırız.

~~~sql
INSERT INTO "Urunler"
("adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('TV', '13', '2019-10-30', 5);
~~~

~~~sql
ALTER TABLE "Urunler" ALTER COLUMN "kodu" DROP NOT NULL;
~~~

~~~sql
ALTER TABLE "Urunler" ALTER "kodu" SET NOT NULL;
~~~



### DEFAULT

* Tanımlandığı alana değer girilmemesi durumunda varsayılan bir değerin atanmasını sağlar.

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT 0,
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "miktari")
VALUES
('ELO004', 'TV', '13', 5);
~~~

~~~sql
ALTER TABLE "Urunler" ALTER "uretimTarihi" DROP DEFAULT;
~~~

~~~sql
ALTER TABLE "Urunler" ALTER COLUMN "uretimTarihi" SET DEFAULT '2019-01-01';
~~~



### UNIQUE 

* Tanımlandığı alandaki verilerin eşsiz (tekil, benzersiz) olmasını sağlar.


~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerUnique";
~~~

~~~sql
ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerUnique" UNIQUE ("kodu");
~~~


* İki alanlı UNIQUE örneği

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu", "adi"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerUnique";
~~~

~~~sql
ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerUnique" UNIQUE ("kodu", "adi");
~~~

~~~sql
INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'TV', '13', '2016-10-24', 5);
~~~

~~~sql
INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO005', 'Bilgisayar', '13', '2019-10-20', 5);
~~~



### CHECK 

* Tanımlandığı alandaki değer aralığını sınırlamada kullanılır.


~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0)
);
~~~

~~~sql
ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerCheck";
~~~

~~~sql
ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerCheck" CHECK ("miktari" >= 0);
~~~

~~~sql
INSERT INTO "Urunler"
("kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
VALUES
('ELO004', 'Bilgisayar', '13', '2016-04-05', -3);
~~~


### Birincil Anahtar (PRIMARY KEY) 

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo")
);
~~~

~~~sql
ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerPK";
~~~

~~~sql
ALTER TABLE "Urunler" ADD CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo");
~~~



* İki alanlı birincil anahtar örneği.

~~~sql
CREATE TABLE "Urunler1" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK1" PRIMARY KEY("urunNo", "kodu")
);
~~~

~~~sql
ALTER TABLE "Urunler1" DROP CONSTRAINT "urunlerPK1";
~~~

~~~sql
ALTER TABLE "Urunler1" ADD CONSTRAINT "urunlerPK1" PRIMARY KEY("urunNo", "kodu");
~~~



### Yabancı Anahtar (FOREIGN KEY) 

~~~sql
CREATE TABLE "UrunTipleri" (
    "tipNo" SERIAL,
    "adi" VARCHAR(30) NOT NULL,
	CONSTRAINT "urunTipiPK" PRIMARY KEY("tipNo")
);
~~~

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"urunTipi" INTEGER NOT NULL, 
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0),
	CONSTRAINT "urunlerFK" FOREIGN KEY("urunTipi") REFERENCES "UrunTipleri"("tipNo")	
);
~~~


* Bu ifade yukarıdaki ile aynıdır. ON DELETE ve ON UPDATE durumunda ne yapılacağı belirtilmediğinde varsayılan olarak NO ACTION olur.

~~~sql
CREATE TABLE "Urunler" (
	"urunNo" SERIAL,
	"kodu" CHAR(6) NOT NULL,
	"adi" VARCHAR(40) NOT NULL,
	"urunTipi" INTEGER NOT NULL, 
	"uretimTarihi" DATE DEFAULT '2019-01-01',
	"birimFiyati" MONEY,
	"miktari" SMALLINT DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY("urunNo"),
	CONSTRAINT "urunlerUnique" UNIQUE("kodu"),
	CONSTRAINT "urunlerCheck" CHECK("miktari" >= 0),
	CONSTRAINT "urunlerFK" FOREIGN KEY("urunTipi") REFERENCES "UrunTipleri"("tipNo") ON DELETE NO ACTION ON UPDATE NO ACTION
);
~~~


* Üç davranış şekli vardır: NO ACTION (varsayılan), RESTRICT, CASCADE

~~~sql
ALTER TABLE "Urunler" DROP CONSTRAINT "urunlerFK";
~~~

~~~sql
ALTER TABLE "Urunler"
ADD CONSTRAINT "urunlerFK" FOREIGN KEY("urunTipi") 
REFERENCES "UrunTipleri"("tipNo")
ON DELETE NO ACTION
ON UPDATE NO ACTION;
~~~

~~~sql
ALTER TABLE "Urunler"
ADD CONSTRAINT "urunlerFK" FOREIGN KEY("urunTipi") 
REFERENCES "UrunTipleri"("tipNo")
ON DELETE RESTRICT
ON UPDATE RESTRICT;
~~~

~~~sql
ALTER TABLE "Urunler"
ADD CONSTRAINT "urunlerFK" FOREIGN KEY("urunTipi") 
REFERENCES "UrunTipleri"("tipNo")
ON DELETE CASCADE
ON UPDATE CASCADE;
~~~
