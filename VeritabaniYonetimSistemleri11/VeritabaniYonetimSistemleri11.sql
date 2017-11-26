--*** SQL Programlama: Fonksiyon/Saklı Yordam Tanımlama, Cursor, Trigger, Hazır Fonksiyonlar ***--

--Pagila Örnek Veri Tabanını Kullanmaktadır

--** Fonksiyon (Saklı Yordam) Tanımlama **--

Veri tabanı kataloğunda saklanan SQL ifadeleridir. Fonksiyonlar / saklı yordamlar; uygulama yazılımları, tetikleyici ya da başka bir 
fonksiyon / saklı yordam tarafından çağrılabilirler.

--* Avantajları *--

Uygulamanın başarımını iyileştirir. Fonksiyonlar / saklı yordamlar, bir defa oluşturulduktan sonra derlenerek veri tabanı kataloğunda saklanır. 
Her çağrıldığında SQL motoru tarafından derlenmek zorunda olan SQL ifadelerine göre çok daha hızlıdır.

Uygulama ile veri tabanı sunucusu arasındaki trafiği azaltır.
Uzun SQL ifadeleri yerine fonkiyonun / saklı yordamın adını ve parametrelerini göndermek yeterlidir. 
Ara sonuçların istemci/sunucu arasında gönderilmesi önlenir.

Yeniden kullanılabilir (reusable). Tasarım ve uygulama geliştirme sürecini hızlandırır.

Güvenliğin sağlanması açısından çok kullanışlıdır. Veri tabanı yöneticisi, fonksiyonlara / saklı yordamlara hangi uygulamalar tarafından 
erişileceğini, tabloların güvenlik düzeyleriyle uğraşmadan, kolayca belirleyebilir.

--* Dezavantajları*--

Fonksiyon / saklı yordam ile program yazmak, değiştirmek (sürüm kontrolü) ve hata bulmak zordur.

VTYS veri depolama ve listeleme işlerine ek olarak farklı işler yapmak zorunda da kalacağı için bellek kullanımı ve işlem zamanı 
açısından olumsuz sonuçlara neden olabilir.

Saklı yordamların yapacağı işler uygulama yazılımlarına da yaptırılabilir.

Uygulamanın iş mantığı veri tabanı sunucuya kaydırıldığı için uygulama ile veri tabanı arasındaki 
bağımlılık artar ve veri tabanından bağımsız kodlama yapma gitgide imkansızlaşır...

--* Koşullu İfadeler *--

http://www.iotlab.sakarya.edu.tr/Storage/VYS/VYS111.png 

--* Tekrarlı İfadeler - Döngüler *--

http://www.iotlab.sakarya.edu.tr/Storage/VYS/VYS112.png 


--* Fonksiyon Örneği 1 *--
CREATE or replace FUNCTION inch2m(sayiInch real)
RETURNS REAL AS
$$
BEGIN
    RETURN 2.54*sayiINCH/100;
END;
$$
LANGUAGE plpgsql;


Select * from inch2m(10);

---------------------------------

CREATE OR REPLACE FUNCTION fonksiyonTanimlama(mesaj text, altKarakterSayisi SMALLINT, tekrarSayisi integer)
RETURNS text AS  -- SETOF TEXT, SETOF record... diyerek çok sayıda değerin döndürülmesi de mümkündür
$$ -- Fonksiyon govdesi başlangici
DECLARE
    sonuc text; --Degisken tanimlama Blogu
BEGIN
    sonuc := '';
    IF tekrarSayisi > 0 THEN
        FOR i IN 1 .. tekrarSayisi LOOP
            sonuc := sonuc || i || '.' || SUBSTRING(mesaj FROM 1 FOR altKarakterSayisi) || E'\r\n';
            -- E: string içerisindeki (E)scape karakterleri için...
        END LOOP;
    END IF;
    RETURN sonuc;
END;
$$ -- Fonksiyon govdesi sonu
LANGUAGE 'plpgsql' IMMUTABLE SECURITY DEFINER ;
--immutable: aynı girişler için aynı çıkışları üretecek
--SECURITY DEFINER: fonksiyonu oluşturanın yetkileriyle çalıştırılsın.


SELECT fonksiyonTanimlama('Deneme', 2::SMALLINT, 10) --fonksiyonun cagrilmasi


-------Dil Desteği Ekleme-------------


-- Linux
-- plperl diliyle program yazabilmek için plperl dil desteğini ekleme.
-- BilgisayarAdi@KullaniciAdi:~$ sudo apt-get install postgresql-plperl-9.5 


-- Application Stack Builder uygulaması mevcutsa bu uygulama aracılığı ile de EDB Language Pack yüklenerek ek dil paketleri eklenebilir.

-- Dil paketi yüklendikten sonra dilin oluşturulması gerekir.
CREATE LANGUAGE "plperl";

-- Ekli dilleri göster.
SELECT * FROM "pg_language";


CREATE FUNCTION kucukOlaniDondur (INT, INT) 
RETURNS INTEGER AS
$$
    if ($_[0] > $_[1]) 
    { 
		return $_[1]; 
    }
    return $_[0];
$$
LANGUAGE "plperl";




-----Select Sorgusu Sonucu Üzerinde Dolanım----------


CREATE OR REPLACE FUNCTION kayitDolanimi()
RETURNS TEXT AS
$$
DECLARE
    musteriler  customer%ROWTYPE; --customer."CustomerID"%TYPE
    sonuc TEXT;
BEGIN
    sonuc:='';
    FOR musteriler IN SELECT * FROM customer LOOP
        sonuc:= sonuc || musteriler."customer_id" || E'\t' || musteriler."first_name"|| E'\r\n';
    END LOOP;
    RETURN sonuc;
END;
$$
LANGUAGE 'plpgsql';

SELECT  kayitDolanimi() --fonksiyonun cagrilmasi



---------- Tablo Döndürme----------

CREATE or replace FUNCTION personelAra(personelNo INT)
RETURNS TABLE(numara INT, adi varchar(40), soyadi VARCHAR(40)) AS $$
BEGIN
    RETURN QUERY SELECT "staff_id","first_name","last_name" FROM staff
                 WHERE "staff_id"=personelNo;
END;
$$
LANGUAGE plpgsql;

Select * from personelAra(1);




--------Çıkış Parametresi-------

CREATE or replace FUNCTION inch2cm(sayiInch real, OUT sayiCM REAL)
AS $$
BEGIN
    sayiCM=2.54*sayiINCH;
END;
$$
LANGUAGE plpgsql;


Select * from inch2cm(2);


-------Fonksiyon içerisinden fonksiyon çağırma-------

CREATE OR REPLACE FUNCTION public.odemetoplami(personelno integer)
 RETURNS text
 LANGUAGE plpgsql
AS $$
DECLARE

    sonuc TEXT;
    personel record;
    miktar NUMERIC;

BEGIN
    personel=personelAra(personelNo);
    FOR miktar IN SELECT SUM(amount) from payment where staff_id=personelNo LOOP
    END LOOP;

    return personel."numara"||E'\t'||personel."adi"||E'\t'||miktar;
END
$$;


select odemeToplami(2);


--* Cursor Kullanımı *--

-- Sorgu sonuçlarının(resultset) toplu olarak gelmesi yerine veri tbanı sunucudan 
-- satır satır getirilmesini sağlar (LIMIT - OFFSET yapısı da benzer işi yapıyordu...).
-- Yük dengeleme, uygulama sunucusunun belleğinin verimli kullanımı v.s.


CREATE OR REPLACE FUNCTION "filmAra"(yapimYili INTEGER, filmAdi TEXT)
RETURNS text AS
$$
DECLARE
    filmAdlari TEXT DEFAULT '';
    film RECORD;
    filmImleci CURSOR(yapimYili INTEGER) FOR SELECT * FROM film WHERE release_year = yapimYili;
BEGIN
   OPEN filmImleci(yapimYili);
   LOOP
      FETCH filmImleci INTO film;
      EXIT WHEN NOT FOUND;
      IF film.title LIKE filmAdi || '%' THEN
         filmAdlari := filmAdlari || ',' || film.title || ':' || film.release_year;
      END IF;
   END LOOP;
   CLOSE filmImleci;

   RETURN filmAdlari;
END; $$
LANGUAGE 'plpgsql';

----------
SELECT * from filmAra(2006,'T');



--** Tetikleyici (Trigger) **--

http://www.iotlab.sakarya.edu.tr/Storage/VYS/VYS111.png 


INSERT, UPDATE  ve DELETE (PostgreSQL de TRUNCATE içinde tanımlanabilir) 
işlemleri ile birlikte otomatik olarak çalıştırılabilen fonksiyonlardır.

--* Avantajları *--
Veri bütünlüğünün sağlanması için alternatif bir yoldur.

İş mantığındaki hataları veritabanı düzeyinde yakalar. 

Zamanlanmış görevler için alternatif bir yoldur. Görevler beklenmeden insert, update ve delete 
işlemlerinden önce ya da sonra otomatik olarak yerine getirilebilir.

Tablolardaki değişikliklerin loglanması işlemlerinde oldukça faydalıdır.

--* Dezavantajları *--
Veritabanı tasarımının anlaşılabilirliğini düşürür. Saklı yordamlarla/fonksiyonlarla birlikte, görünür 
veritabanı yapısının arkasında başka bir yapı oluştururlar

Tablolarla ilgili her değişiklikte çalıştıkları için ek iş yükü oluştururlar ve bunun sonucu olarak işlem 
gecikmeleri artabilir.



--NorthWind veritabanındaki ürünlerin birim fiyat değişimlerini izlemek için kullanılır...

CREATE TABLE "public"."UrunDegisikligiIzle" (
	"kayitNo" serial,
	"urunNo" SmallInt NOT NULL,
	"eskiBirimFiyat" Real NOT NULL,
	"yeniBirimFiyat" Real NOT NULL,
	"degisiklikTarihi" TIMESTAMP NOT NULL,
	CONSTRAINT "PK" PRIMARY KEY ( "kayitNo" ) );
 -------------------
CREATE OR REPLACE FUNCTION "urunDegisikligiTR1"()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."UnitPrice" <> OLD."UnitPrice" THEN
		INSERT INTO "UrunDegisikligiIzle"("urunNo","eskiBirimFiyat","yeniBirimFiyat","degisiklikTarihi")
		VALUES(OLD."ProductID",OLD."UnitPrice",NEW."UnitPrice",CURRENT_TIMESTAMP::TIMESTAMP);
	END IF;

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE  TRIGGER urunBirimFiyatDegistiginde
BEFORE UPDATE  ON products
FOR EACH ROW
EXECUTE PROCEDURE "urunDegisikligiTR1"();


--** PostgreSQL Hazır Fonksiyonları **--


--* Matematiksel Fonksiyonlar *--

https://www.postgresql.org/docs/9.6/static/functions-math.html

--* Karakter Katarı (String) Fonksiyonları *--

https://www.postgresql.org/docs/9.6/static/functions-string.html

--* Tarih ve Zaman Fonksiyonları *--

https://www.postgresql.org/docs/9.6/static/functions-datetime.html
https://www.postgresql.org/docs/9.6/static/functions-formatting.html
