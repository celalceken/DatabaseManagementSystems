CREATE DATABASE "AlisVerisUygulamasi1" ENCODING='UTF-8' 
LC_COLLATE='tr_TR.UTF-8' LC_CTYPE='tr_TR.UTF-8'
OWNER postgres 
TEMPLATE=template0;


CREATE SCHEMA sema1;


CREATE TABLE "sema1"."Urunler" ( 
	"urunNo" serial,
	"kodu" Char( 6 ) NOT NULL,
	"adi" Varchar( 40 )  NOT NULL,
	"uretimTarihi" Date DEFAULT '2000-01-01',
	"birimFiyati" Money,
	"miktari" SmallInt DEFAULT '0',
	CONSTRAINT "urunlerPK" PRIMARY KEY ( "urunNo" ),
	CONSTRAINT "urunlerUnique1" UNIQUE( "kodu" ),
	CONSTRAINT "urunlerCheck1" CHECK(miktari >= 0) 
);


SELECT NEXTVAL('sequence1')

INSERT INTO "sema1"."Urunler" ("urunNo","kodu", "adi", "birimFiyati", "uretimTarihi", "miktari")
 VALUES(nextval('sequence1'::regclass),'ELO004', 'TV', '13', '1.1.2000', 5)

 
 CREATE TABLE "public"."Urunler3"
(
    urunNo INTEGER,
    kodu CHAR(6) NOT NULL,
    adi varchar(40) NOT NULL,
    uretimTarihi  date default '1.1.2000',
    birimFiyati money,
    miktari SMALLINT default 0,
    CONSTRAINT UrunlerPK1 PRIMARY KEY(urunNo),
    CONSTRAINT UrunlerUnique2 UNIQUE (kodu),
    CONSTRAINT UrunlerCheck1 CHECK (miktari>=0)
 )

-------------------

ALTER TABLE "orders"
	ADD CONSTRAINT "lnk_employees_orders" FOREIGN KEY ( "EmployeeID" )
	REFERENCES "employees" ( "EmployeeID" ) MATCH FULL
	ON DELETE Restrict
	ON UPDATE Restrict;	

-------------------
CREATE TABLE "public"."Musteriler" ( 
	"musteriNo" Serial NOT NULL,
	"adi" Character Varying( 40 ) COLLATE "pg_catalog"."default" NOT NULL,
	"soyadi" Character Varying( 40 ) COLLATE "pg_catalog"."default" NOT NULL,
	PRIMARY KEY ( "musteriNo" ) );
 
CREATE INDEX "index_adi" ON "public"."Musteriler" USING btree( "adi" );


CREATE INDEX "index_soyadi" ON "public"."Musteriler" USING btree( "soyadi" );

-----------
ALTER TABLE "SiparisDetay" 
ADD CONSTRAINT "UrunSiparisUnique" UNIQUE ("urunNo","siparisNo");
-----


select sum("UnitPrice")/count("ProductID") from "products"

select avg("UnitPrice") from "products"
select * from "products" order by "ProductID" DESC limit 4
--------
select "CategoryID", count("CategoryID") as "Ürün Sayısı" from "products"
group by "CategoryID"

select "CategoryID", sum("UnitPrice") as "Toplam B. Fiyat" from "products"
group by "CategoryID"


select "CategoryID", count("CategoryID") as "Ürün Sayısı" from "products"
group by "CategoryID"
having count("CategoryID")>7


select "CategoryID", count("CategoryID") as "Ürün Sayısı" from "products"
group by "CategoryID"
having "CategoryID"=2

select "Country", count("CustomerID") as "Müşteri Sayısı" from "customers"
group by "Country"
having count("CustomerID")>5

SELECT   "public"."customers"."CompanyName", count("OrderID")
FROM     "orders" 
INNER JOIN "customers"  ON "orders"."CustomerID" = "customers"."CustomerID" 
group by "CompanyName" 
order by "CompanyName" 