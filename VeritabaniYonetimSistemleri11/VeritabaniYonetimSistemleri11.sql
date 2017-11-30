
-- *** SQL Programlama: Fonksiyon / Saklı Yordam, Koşullu İfadeler,
-- Döngüler, İmleç (Cursor), Tetikleyici (Trigger), Hazır Fonksiyonlar *** --



-- Pagila Örnek Veri Tabanını Kullanmaktadır.



-- ** Fonksiyon / Saklı Yordam ** --



-- Fonksiyonlar / saklı yordamlar, veri tabanı kataloğunda saklanan SQL 
-- ifadeleridir. Uygulama yazılımları, tetikleyici ya da başka bir 
-- fonksiyon / saklı yordam tarafından çağrılabilirler.



-- * Avantajları * --

-- Uygulamanın başarımını iyileştirir. 
--     Fonksiyonlar / saklı yordamlar, bir defa oluşturulduktan sonra 
--     derlenerek veritabanı kataloğunda saklanır. Her çağrıldıklarında 
--     SQL motoru tarafından derlenmek zorunda olan SQL ifadelerine göre
--     çok daha hızlıdır.

-- Uygulama ile veritabanı sunucusu arasındaki trafiği azaltır.
--     Uzun SQL ifadeleri yerine fonksiyonun / saklı yordamın adını ve 
--     parametrelerini göndermek yeterlidir. Ara sonuçların istemci ve 
--     sunucu arasında gönderilmesi önlenir.

-- Yeniden kullanılabilir (reusable).
--     Tasarım ve uygulama geliştirme sürecini hızlandırır.

-- Güvenliğin sağlanması açısından çok kullanışlıdır. 
--     Veritabanı yöneticisi, fonksiyonlara / saklı yordamlara hangi 
--     uygulamalar tarafından erişileceğini, tabloların güvenlik 
--     düzeyleriyle uğraşmadan, kolayca belirleyebilir.



-- * Dezavantajları * --

-- Fonksiyon / saklı yordam ile program yazmak, değiştirmek 
-- (sürüm kontrolü) ve hata bulmak zordur.

-- Veritabanı Yönetim Sistemi, veri depolama ve listeleme işlerine ek 
-- olarak farklı işler yapmak zorunda da kalacağı için bellek kullanımı 
-- ve işlem zamanı açısından olumsuz sonuçlara neden olabilir.

-- Fonksiyonların / saklı yordamların yapacağı işler uygulama 
-- yazılımlarına da yaptırılabilir.

-- Uygulamanın iş mantığı veritabanı sunucusuna kaydırıldığı için uygulama 
-- ile veritabanı arasındaki bağımlılık artar ve veritabanından bağımsız 
-- kodlama yapmak gitgide imkansızlaşır.



-- * Fonksiyon Örneği 1 * --

CREATE OR REPLACE FUNCTION inch2m(sayiInch REAL)
RETURNS REAL
AS
$$ -- Fonksiyon govdesinin (tanımının) başlangıcı
BEGIN
    RETURN 2.54 * sayiINCH / 100;
END;
$$ -- Fonksiyon govdesinin (tanımının) sonu
LANGUAGE plpgsql;



-- Fonksiyon çağrısı

SELECT * FROM inch2m(10);



-- * Koşullu İfadeler * --

-- http://www.iotlab.sakarya.edu.tr/Storage/VYS/VYS111.png 



-- * Döngüler * --

-- http://www.iotlab.sakarya.edu.tr/Storage/VYS/VYS112.png 



-- * Fonksiyon Örneği 2 * --

CREATE OR REPLACE FUNCTION fonksiyonTanimlama(mesaj text, altKarakterSayisi SMALLINT, tekrarSayisi integer)
RETURNS TEXT -- SETOF TEXT, SETOF RECORD diyerek çok sayıda değerin döndürülmesi de mümkündür
AS  
$$
DECLARE
    sonuc TEXT; -- Değişken tanımlama bloğu
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
$$
LANGUAGE 'plpgsql' IMMUTABLE SECURITY DEFINER;

-- IMMUTABLE: Aynı girişler için aynı çıkışları üretir. Optimizasyon
-- mümkün olabilir.
-- Varsayılan VOLATILE: Fonksiyon değeri değişebilir dolayısıyla
-- optimizasyon yapılamaz.

-- SECURITY DEFINER: Fonksiyon, oluşturan kullanıcının yetkileriyle 
-- çalıştırılır.
-- Varsayılan SECURITY INVOKER: Fonksiyon, çağıran kullanıcının yetkileri 
-- ile çalıştırılır.


-- Fonksiyon çağrısı

SELECT fonksiyonTanimlama('Deneme', 2::SMALLINT, 10);



-- * Dil Desteği Ekleme * --


-- Linux
-- plperl diliyle program yazabilmek için plperl dil desteğini ekleme.
-- BilgisayarAdi@KullaniciAdi:~$ sudo apt-get install postgresql-plperl-9.6 


-- Application Stack Builder uygulaması mevcutsa bu uygulama aracılığı 
-- ile de EDB Language Pack yüklenerek ek dil paketleri eklenebilir.

-- Dil paketi yüklendikten sonra dilin oluşturulması gerekir.

CREATE LANGUAGE "plperl";


-- Ekli dilleri göster.

SELECT * FROM "pg_language";



-- * Fonksiyon Örneği 3 * --

-- plperl dili ile örnek bir fonksiyon örneği aşağıda görülmektedir.

CREATE FUNCTION kucukOlaniDondur (INT, INT)
RETURNS INTEGER 
AS
$$
    if ($_[0] > $_[1]) 
    { 
		return $_[1]; 
    }
    return $_[0];
$$
LANGUAGE "plperl";



-- * Fonksiyon Örneği 4 * --

-- Bir SELECT sorgusu sonuç kümesi içerisinde dolanımın nasıl 
-- yapılacağını gösteren bir fonksiyon örneği aşağıda gösterilmektedir.

CREATE OR REPLACE FUNCTION kayitDolanimi()
RETURNS TEXT
AS
$$
DECLARE
    musteriler customer%ROWTYPE; -- customer."CustomerID"%TYPE
    sonuc TEXT;
BEGIN
    sonuc := '';
    FOR musteriler IN SELECT * FROM customer LOOP
        sonuc := sonuc || musteriler."customer_id" || E'\t' || musteriler."first_name" || E'\r\n';
    END LOOP;
    RETURN sonuc;
END;
$$
LANGUAGE 'plpgsql';


-- Fonksiyon çağrısı

SELECT  kayitDolanimi();



-- * Fonksiyon Örneği 5 * --

-- Tablo döndüren fonksiyon örneği aşağıdadır.

CREATE OR REPLACE FUNCTION personelAra(personelNo INT)
RETURNS TABLE(numara INT, adi VARCHAR(40), soyadi VARCHAR(40)) 
AS 
$$
BEGIN
    RETURN QUERY SELECT "staff_id", "first_name", "last_name" FROM staff
                 WHERE "staff_id" = personelNo;
END;
$$
LANGUAGE "plpgsql";


-- Fonksiyon çağrısı

SELECT * FROM personelAra(1);



-- * Fonksiyon Örneği 6 * --

-- Argüman listesinde çıkış parametresi tanımlanan fonksiyon örneği 
-- aşağıdadır.

CREATE OR REPLACE FUNCTION inch2cm(sayiInch REAL, OUT sayiCM REAL)
AS 
$$
BEGIN
    sayiCM := 2.54 * sayiINCH;
END;
$$
LANGUAGE "plpgsql";


-- Fonksiyon çağrısı

SELECT * FROM inch2cm(2);



-- * Fonksiyon Örneği 7 * --

-- Fonksiyon içerisinden fonksiyon çağırma örneği aşağıdadır.

CREATE OR REPLACE FUNCTION public.odemetoplami(personelno INTEGER)
RETURNS TEXT
LANGUAGE "plpgsql"
AS
$$
DECLARE
    sonuc TEXT;
    personel record;
    miktar NUMERIC;
BEGIN
    personel := personelAra(personelNo);
    FOR miktar IN SELECT SUM(amount) FROM payment WHERE staff_id = personelNo LOOP
    END LOOP;

    RETURN personel."numara" || E'\t' || personel."adi" || E'\t' || miktar;
END
$$;


-- Fonksiyon çağrısı

SELECT odemeToplami(2);



-- ** İmleç (Cursor) ** --

-- İmleç (cursor), sorgunun sonuç kümesinin toplu olarak getirilmesi 
-- yerine veritabanı sunucusundan satır satır getirilmesini sağlar. 
-- LIMIT ve OFFSET yapılarının da benzer bir işi yaptığını hatırlayın.

-- Yük dengeleme, uygulama sunucusunun belleğinin verimli kullanımı vb.
-- amaçlar ile kullanılabilir.



-- ** İmleç Örneği ** --

CREATE OR REPLACE FUNCTION filmAra(yapimYili INTEGER, filmAdi TEXT)
RETURNS TEXT
AS
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
END;
$$
LANGUAGE 'plpgsql';


-- Fonksiyon çağrısı

SELECT * FROM filmAra(2006, 'T');



-- ** Tetikleyici (Trigger) ** --

-- http://www.iotlab.sakarya.edu.tr/Storage/VYS/VYS113.png 

-- INSERT, UPDATE ve DELETE (PostgreSQL'de TRUNCATE için de tanımlanabilir) 
-- işlemleri ile birlikte otomatik olarak çalıştırılabilen fonksiyonlardır.



-- * Avantajları * --

-- Veri bütünlüğünün sağlanması için alternatif bir yoldur.

-- İş mantığındaki hataları veritabanı düzeyinde yakalar.

-- Zamanlanmış görevler için alternatif bir yoldur. 
--     Görevler beklenmeden INSERT, UPDATE ve DELETE işlemlerinden önce 
--     ya da sonra otomatik olarak yerine getirilebilir.

-- Tablolardaki değişikliklerin günlüğünün tutulması (logging) 
-- işlemlerinde oldukça faydalıdır.



-- * Dezavantajları * --

-- Veritabanı tasarımının anlaşılabilirliğini düşürür. 
--     Fonksiyonlarla / saklı yordamlarla birlikte görünür veritabanı 
--     yapısının arkasında başka bir yapı oluştururlar.

-- Ek iş yükü oluştururlar ve dolayısıyla işlem gecikmeleri artabilir. 
--     Tablolarla ilgili her değişiklikte çalıştıkları için ek iş yükü 
--     oluştururlar ve bunun sonucu olarak işlem gecikmeleri artabilir.



-- * Tetikleyici Örneği * --

-- NorthWind veritabanındaki ürünlerin birim fiyat değişimlerini izlemek
-- için kullanılan bir tetikleyici örneği aşağıdadır.

CREATE TABLE "public"."UrunDegisikligiIzle" (
	"kayitNo" serial,
	"urunNo" SmallInt NOT NULL,
	"eskiBirimFiyat" Real NOT NULL,
	"yeniBirimFiyat" Real NOT NULL,
	"degisiklikTarihi" TIMESTAMP NOT NULL,
	CONSTRAINT "PK" PRIMARY KEY ("kayitNo")
);
	
CREATE OR REPLACE FUNCTION "urunDegisikligiTR1"()
RETURNS TRIGGER 
AS
$$
BEGIN
    IF NEW."UnitPrice" <> OLD."UnitPrice" THEN
        INSERT INTO "UrunDegisikligiIzle"("urunNo", "eskiBirimFiyat", "yeniBirimFiyat", "degisiklikTarihi")
        VALUES(OLD."ProductID", OLD."UnitPrice", NEW."UnitPrice", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "urunBirimFiyatDegistiginde"
BEFORE UPDATE ON "products"
FOR EACH ROW
EXECUTE PROCEDURE "urunDegisikligiTR1"();

UPDATE "products"
SET "UnitPrice" = 100
WHERE "ProductID" = 4 


ALTER TABLE "products"
DISABLE TRIGGER "urunBirimFiyatDegistiginde";

ALTER TABLE "products"
ENABLE TRIGGER "urunBirimFiyatDegistiginde";

ALTER TABLE "products"
DISABLE TRIGGER ALL;

ALTER TABLE "products"
ENABLE TRIGGER ALL;


DROP TRIGGER "urunBirimFiyatDegistiginde" ON "products";

DROP TRIGGER IF EXISTS "urunBirimFiyatDegistiginde" ON "products";



-- ** PostgreSQL Hazır Fonksiyonları ** --



-- * Matematiksel Fonksiyonlar * --

-- https://www.postgresql.org/docs/9.6/static/functions-math.html



-- * Karakter Katarı (String) Fonksiyonları * --

-- https://www.postgresql.org/docs/9.6/static/functions-string.html



-- * Tarih ve Zaman Fonksiyonları * --

-- https://www.postgresql.org/docs/9.6/static/functions-datetime.html



-- * Veri Tipi Biçimlendirme Fonksiyonları * --

-- https://www.postgresql.org/docs/9.6/static/functions-formatting.html
