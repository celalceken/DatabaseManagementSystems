
-- *** Başarım Eniyileme (Performance Tuning) *** --


-- Örnekler İçin Pagila Veri Tabanı Kullanılmaktadır.




-- ** EXPLAIN ANALYSE ** --

-- EXPLAIN ANALYSE ifadesi ile SQL sorgularının başarımına ilişkin 
-- detaylı bilgi edinebiliriz.

EXPLAIN ANALYSE
SELECT * FROM "customer"
WHERE "first_name" = 'Bruce';


EXPLAIN ANALYSE
SELECT * FROM "customer"
WHERE "last_name" = 'Lee';


EXPLAIN ANALYSE
SELECT   "public"."customer"."customer_id",
         "public"."customer"."first_name",
         "public"."customer"."last_name",
         "public"."address"."phone"
FROM     "customer" 
INNER JOIN "address"  ON "customer"."address_id" = "address"."address_id" 




-- ** PROJEKSİYON ** --


-- SELECT ifadesinde bütün alanlara projeksiyon yapmak (* kullanımı) 
-- yerine yalnızca gerekli olan alanlara projeksiyon yapmalıyız. Yani 
-- yalnızca gerekli alanların getirilmesini istemeliyiz. Böylece, işlem 
-- gecikmesi, iletim gecikmesi ve kaynak kullanımı azaltılmış olur.


EXPLAIN ANALYSE
SELECT * 
FROM "customer" 
INNER JOIN "store" ON "customer"."store_id" = "store"."store_id"
INNER JOIN "rental" ON "rental"."customer_id" = "customer"."customer_id" 
INNER JOIN "inventory" ON "inventory"."store_id" = "store"."store_id" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id";

-- 20:52:27 Query time: 12.442 second(s), Number of cursor's records: 23


EXPLAIN ANALYSE
SELECT "customer"."first_name", "customer"."last_name",
    "film"."film_id", "film"."title"
FROM "customer" 
INNER JOIN "store" ON "customer"."store_id" = "store"."store_id" 
INNER JOIN "rental" ON "rental"."customer_id" = "customer"."customer_id" 
INNER JOIN "inventory" ON "inventory"."store_id" = "store"."store_id" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id";

-- 20:52:40 Query time: 7.177 second(s), Number of cursor's records: 24




-- ** LIMIT ve OFFSET ** --


EXPLAIN ANALYSE
SELECT "store"."store_id", "film"."title"
FROM "inventory" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id";

-- 21:04:05 Query time: 5 millisecond(s), Number of cursor's records: 13



-- İlk 39 dan sonra 20 kayıt getirilsin.

EXPLAIN ANALYSE
SELECT "store"."store_id", "film"."title"
FROM "inventory" 
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id"
LIMIT 20  OFFSET 39; 

-- 21:04:16 Query time: 2 millisecond(s), Number of cursor's records: 12



EXPLAIN ANALYSE
SELECT "customer_id", "first_name", "last_name"
FROM "customer" ORDER BY "customer_id" DESC


-- Son 20 den sonraki 10 getirilsin

EXPLAIN ANALYSE
SELECT "customer_id", "first_name", "last_name"
FROM "customer" ORDER BY "customer_id" DESC
LIMIT 10  OFFSET 20;




-- ** SIRALAMA ** --


--Gereksiz sıralama başarımı düşürür.


EXPLAIN ANALYSE
SELECT "store"."store_id", "film"."title"
FROM "inventory"
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id";

-- 21:12:37 Query time: 5 millisecond(s), Number of cursor's records: 13


EXPLAIN ANALYSE 
SELECT "store"."store_id", "film"."title"
FROM "inventory"
INNER JOIN "film" ON "inventory"."film_id" = "film"."film_id" 
INNER JOIN "store" ON "inventory"."store_id" = "store"."store_id" 
ORDER BY "film"."title";

-- 21:12:41 Query time: 7 millisecond(s), Number of cursor's records: 16




-- ** INDEX ** --


-- Index olarak belirlenmiş alanlar üzerinde arama işlemi daha hızlı 
-- gerçekleştirilir. 


-- Aşağıdaki sorgularda “customer” tablosunun “last_name” alanı index 
-- olarak belirlenmiştir.

EXPLAIN ANALYSE
SELECT * FROM "customer"
WHERE "first_name" = 'Jeniffer';

-- Execution time: 0.132 ms


EXPLAIN ANALYSE
SELECT * FROM "customer"
WHERE "last_name" = 'Davis';

-- Execution time: 0.036 ms




-- ** Birleşim (INNER JOIN), IN ve EXIST (İlintili Sorgu) ** --


-- İlintili sorgu, özellikle EXIST ifadesi ile birlikte, daha iyi sonuç 
-- verebilir.


EXPLAIN ANALYSE
SELECT DISTINCT "customer"."first_name", "customer"."last_name" 
FROM "customer"
INNER JOIN "payment"
ON "payment"."customer_id" = "customer"."customer_id";

-- 21:47:16 Query time: 14 millisecond(s), Number of cursor's records: 10


EXPLAIN ANALYSE
SELECT DISTINCT "customer"."first_name", "customer"."last_name"
FROM "customer"
WHERE "customer_id" IN (SELECT "customer_id" FROM "payment"); 

-- 21:34:45 Query time: 5 millisecond(s), Number of cursor's records: 9


EXPLAIN ANALYSE
SELECT "customer"."first_name", "customer"."last_name"
FROM "customer"
WHERE "customer_id" IN (SELECT DISTINCT "customer_id" FROM "payment");

-- 21:34:49 Query time: 6 millisecond(s), Number of cursor's records: 10


EXPLAIN ANALYSE
SELECT "customer"."first_name", "customer"."last_name"
FROM "customer"
WHERE EXISTS 
    (SELECT "customer_id" FROM "payment" 
     WHERE "customer"."customer_id" = "payment"."customer_id");

-- 21:34:53 Query time: 3 millisecond(s), Number of cursor's records: 7




-- ** HAVING ** --


-- HAVING ifadesi seçim işlemi yapılıp gruplandırma işlemi tamamlandıktan
-- sonra filtreleme yapmak için kullanılır. Filtreyi, mümkünse gruplama 
-- işleminden önce eklemek başarımı artırır.


EXPLAIN ANALYSE
SELECT "category"."name", COUNT("film"."film_id") 
FROM "film"
LEFT OUTER JOIN "film_category" ON "film"."film_id" = "film_category"."film_id"
LEFT OUTER JOIN "category" ON "film_category"."category_id" =  "category"."category_id"
GROUP BY "category"."name"
HAVING "category"."name" = 'Horror' OR "category"."name" = 'Comedy';

-- 22:04:45 Query time: 3 millisecond(s), Number of cursor's records: 16


EXPLAIN ANALYSE
SELECT "category"."name", COUNT("film"."film_id") 
FROM "film"
LEFT OUTER JOIN "film_category" ON "film"."film_id" = "film_category"."film_id"
LEFT OUTER JOIN "category" ON "film_category"."category_id" = "category"."category_id"
WHERE "category"."name" = 'Horror' OR "category"."name" = 'Comedy'
GROUP BY "category"."name";

-- 22:05:02 Query time: 2 millisecond(s), Number of cursor's records: 16




-- ** Alt Sorgu Sayısı ** --


-- Bazen ana sorguda birden fazla alt sorgu bulunabilir. Bu durumda alt 
-- sorgu bloklarının sayısını azaltmaya çalışmalıyız.


EXPLAIN ANALYSE
SELECT * FROM "products" 
WHERE "UnitPrice" < (SELECT AVG("UnitPrice") FROM "products")
AND "UnitsInStock" < (SELECT AVG("UnitsInStock") FROM "products");

-- 22:12:27 Query time: 2 millisecond(s), Number of cursor's records: 11


EXPLAIN ANALYSE
SELECT * FROM "products" 
WHERE ("UnitPrice", "UnitsInStock") < 
    (SELECT AVG("UnitPrice"), AVG("UnitsInStock") FROM "products");

-- 22:12:32 Query time: 1 millisecond(s), Number of cursor's records: 8




-- ** UNION ve UNION ALL ** --


-- UNION yerine UNION ALL komutunu kullanmaya çalışmalıyız. UNION komutu 
-- icra edilirken DISTINCT işlemi de gerçekleştirildiği için daha yavaştır.


EXPLAIN ANALYSE
SELECT "rental_id" FROM "rental"
UNION
SELECT "rental_id" FROM "payment";

-- 22:23:50 Query time: 21 millisecond(s), Number of cursor's records: 7


EXPLAIN ANALYSE
SELECT "rental_id" FROM "rental"
UNION ALL
SELECT "rental_id" FROM "payment";

-- 22:23:53 Query time: 11 millisecond(s), Number of cursor's records: 5




-- ** WHERE ** --


-- WHERE koşul ifadeleri yazarken dikkat etmemiz gereken hususlar.


EXPLAIN ANALYSE
SELECT * FROM "payment" WHERE "amount" != 11.99;

-- 22:38:13 Query time: 6 millisecond(s), Number of cursor's records: 5


EXPLAIN ANALYSE
SELECT * FROM "payment" WHERE "amount" < 11.99;

-- 22:38:13 Query time: 6 millisecond(s), Number of cursor's records: 5



EXPLAIN ANALYSE
SELECT * FROM "film" WHERE SUBSTR("title", 2, 2) = 'la';

--22:44:30 Query time: 2 millisecond(s), Number of affected records: 15


EXPLAIN ANALYSE
SELECT * FROM "film" WHERE "title" LIKE '_la%';

-- 22:44:25 Query time: 1 millisecond(s), Number of affected records: 15



EXPLAIN ANALYSE
SELECT * FROM "payment" 
WHERE "amount" - 1 = '1.99';

-- 22:50:54 Query time: 6 millisecond(s), Number of cursor's records: 5


EXPLAIN ANALYSE
SELECT * FROM "payment" 
WHERE "amount" = '2.99';

-- 22:50:56 Query time: 5 millisecond(s), Number of cursor's records: 5




-- ** Genel Kurallar ** --


-- Büyük ikili nesneleri depolamak için ilk önce onları dosyalama 
-- sistemine yerleştiriniz ve veritabanına dosyanın konumunu ekleyiniz.

-- SQL standart kurallarını takip ediniz.




-- ** VAUUM ve ANALYSE ** --


-- PostgreSQL’de bir kayıt silindiği zaman aslında gerçekten silinmez.
-- Yalnızca silindiğine ilişkin bir işaret olur. Dolayısıyla belirli bir 
-- süre sonra depolama alanı problemi oluşabilir. Silinen kayıtların 
-- gerçekten tablodan silinmesini gerçekleştirmek için VACUUM komutu 
-- kullanılır. Bu yapıldığında depolama alanımızda yer açılacaktır.


-- ANALYSE işlemi sonucu, ilgili tablo veya tabloların içeriğine dair 
-- istatistikler "pg_statistic" sistem katalogunda saklanır. Daha sonra
-- bu bilgi, sorgu planlayıcısının (query planner) sorguları en etkin 
-- şekilde nasıl çalıştıracağının belirlenmesi işleminde kullanılır.


-- VACUUM ve ANALYSE işlemini, veritabanı kullanımının az olduğu 
-- zamanlarda, günde bir kez uygulamak sorgu hızını artırır.



-- Seçili veri tabanındaki tüm tablolara vacuum işlemi uygula.

VACUUM;


-- Seçili veri tabanındaki tüm tablolara vacuum full işlemi uygula. 
-- Bu işlem daha uzun sürer. Tabloları kilitleyerek yeni bir kopyasını 
-- oluşturur ve daha sonra eski tabloyu siler.

VACUUM FULL; 


-- customer tablosuna vacuum işlemi uygula.

VACUUM "customer";


-- Eşik (threshold) değeri 5000 kayıt olsun. Bu eşik değerinin üzerine 
-- eşik değeri * ölçek faktörü de eklendikten sonra ulaşılan kayıt
-- sayısı kadar güncelleme veya silme işlemi yapıldıktan sonra vacuum 
-- işlemini başlatılır. Bu ayar postgresql.conf dosyasında da 
-- belirtilebilir.

-- Varsayılan eşik değeri 50 kayıttır.

ALTER TABLE table_name  
SET (autovacuum_vacuum_threshold = 5000);


-- Eşik değerini %40 aştıktan sonra otomatik vakum işlemi yap. Bu ayar
-- postgresql.conf dosyasında da belirtilebilir.

-- Varsayılan ölçek faktörü (scale factor) 0.2'dir.

ALTER TABLE table_name  
SET (autovacuum_vacuum_scale_factor = 0.4);


-- Seçili veritabanındaki tüm tablolara ANALYSE işlemi uygula.

ANALYSE;


-- "payment" tablosuna ANALYSE işlemi uygula.
 
ANALYSE "payment";




SELECT * FROM "pg_statistic"



SELECT "relname", "last_vacuum", "last_autovacuum", "last_analyze", "last_autoanalyze"
FROM "pg_stat_all_tables"
WHERE "schemaname" = 'public';





