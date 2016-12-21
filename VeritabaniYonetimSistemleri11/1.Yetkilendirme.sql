
--- psql

psql -U postgres -h localhost

psql -U LectureUser -d pagila -h localhost

-- W seçeneği şifre ile giriş için kullanılır.
psql -U testuser -d pagila -h localhost -W


-- psql Açma Örneği

psql -U postgres

VTYS_Comp:~ vtys$ psql -U postgres
Password for user postgres:
psql (9.5.4)
Type "help" for help.

postgres=#


-- psql Çıkış Örneği.

postgres=# \q
postgres=#
VTYS_Comp:~ veysel$



-- psql - Kullanıcı Oluşturma Örnekleri

postgres=# CREATE USER testk1 WITH PASSWORD '111111';
CREATE ROLE
postgres=#
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 testk1    |                                                            | {}

postgres=#


-- CREATE USER, CREATE ROLE ifadesinin bir takma isimdir. Aralarındaki fark LOGIN seçeneğidir.
-- https://www.postgresql.org/docs/9.5/static/sql-createrole.html

postgres=# CREATE ROLE testk2 WITH PASSWORD '111111';
CREATE ROLE
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 testk1    |                                                            | {}
 testk2    | Cannot login                                               | {}

postgres=#


--
postgres=# CREATE ROLE testk3 WITH PASSWORD '111111' LOGIN;
CREATE ROLE
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 testk1    |                                                            | {}
 testk2    | Cannot login                                               | {}
 testk3    |                                                            | {}

postgres=#


--
postgres=# CREATE ROLE testk4 WITH PASSWORD '111111' LOGIN CREATEDB;
CREATE ROLE
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 testk1    |                                                            | {}
 testk2    | Cannot login                                               | {}
 testk3    |                                                            | {}
 testk4    | Create DB                                                  | {}

postgres=#


--
postgres=# ALTER ROLE testk2 WITH LOGIN;
ALTER ROLE
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 testk1    |                                                            | {}
 testk2    |                                                            | {}
 testk3    |                                                            | {}
 testk4    | Create DB                                                  | {}

postgres=#



-- Yetkilendirme İşlemleri
-- Kullanicilarin / rollerin nesneler uzerinde hangi haklara sahip olacaginin belirlenmesine yetkilendirme adı verilir.



-- Yetki listesi

-- Nesnelerin türüne göre (tablo, görünüm, fonksiyon) aşağıdaki yetkiler verilir.
-- SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER, CREATE,
-- CONNECT, TEMPORARY, EXECUTE, USAGE



-- Kullanıcı / Rol  İşlemleri

-- Oturum yetkilendirmesini postgres rolü olarak ayarla.
-- Böylelikle postgres sahip olduğu tüm yetkilerle tüm işlemleri yapabileceğiz.
SET SESSION AUTHORIZATION "postgres";


-- pg_authid ve pg_roles kataloğunu sorgula. Bu kataloglarda roller hakkında bilgi mevcuttur.
SELECT * FROM "pg_authid";
SELECT * FROM "pg_roles";

-- pg_roles kataloğunu sorgula.
SELECT * FROM "pg_user";

-- pg_shadow 8.1 ile birlikte yerini pg_authid kataloğuna bıraktı.
-- Geriye doğru uyumluluk için saklanıyor.
SELECT * FROM "pg_shadow"; --  aldı.


-- Rol Özellikleri (Temel Yetkiler) Listesi

-- SUPERUSER, CREATEDB, CREATEROLE, CREATEUSER, INHERIT, LOGIN, REPLICATION, BYPASSRLS
-- NOSUPERUSER, NOCREATEDB, NOCREATEROLE, NOCREATEUSER, NOINHERIT, NOLOGIN, NOREPLICATION, NOBYPASSRLS

-- Hiç bir yetkisi olmayan rol oluştur.
-- Rolün aynı zamanda şifesi de mevcut değildir.
CREATE ROLE "rol1";


-- SUPERUSER yetkisi olan rol oluştur.
-- SUPERUSER nesnelerle ilgili herseyi yapma yetkisine sahiptir.
CREATE ROLE "rol2" WITH SUPERUSER;


-- Roller oluşturulduktan sonra düzenlenebilir.
ALTER ROLE "rol1" WITH SUPERUSER CREATEDB;
ALTER ROLE "rol1" WITH NOSUPERUSER;

ALTER ROLE "rol1" WITH LOGIN;
ALTER ROLE "rol1" WITH NOLOGIN;


-- abc şifresine sahip "kullanici1" adında bir kullanıcı oluştur.
-- abc şifresi MD5 algoritması ile kodlanır.
CREATE USER "rol2" WITH PASSWORD 'abc';


-- CREATE USER, CREATE ROLE ifadesinin bir takma isimdir. Aralarındaki fark LOGIN seçeneğidir.
-- CREATE USER ifadesi varsayılan olarak LOGIN yetkili rol oluşturur.
-- CREATE ROLE ifadesi varsayılan olarak LOGIN yetkisi olmayan rol oluşturur.
-- 8.1 ile birlikte user ve group kavramı yerine rol kavramı getirildi. 
-- Bir rol, user olabilir, group olabilir veya ikisi birden olabilir.
CREATE ROLE "rol3" WITH PASSWORD 'abc' LOGIN; 


-- Şifre kodlanmadan saklanır.
-- Şifrenin son geçerlilik tarihi de belirtilir. 
CREATE ROLE "rol4" WITH UNENCRYPTED PASSWORD 'abc' VALID UNTIL '2017-01-01';


-- Şifre kodlanarak saklanır.
-- Şifrenin son geçerlilik tarihi de belirtilir. 
CREATE ROLE "kullanici4" WITH PASSWORD 'abc' VALID UNTIL '2017-01-01';


-- Kullanıcı / rol silme işlemleri.
DROP USER "rol1";
DROP ROLE "rol1";


-- Veri tabanı sahibi olan bir rolü silmeden önce veri tabanı sahipliğini başka bir role aktarmalıyız.
-- Bu işlemi ALTER DATABASE ile yapabiliriz.
CREATE ROLE "rol1";
ALTER DATABASE "Uygulama" OWNER to "rol1";
DROP ROLE "rol1";
-- 16:18:33 Kernel error: ERROR:  role "rol1" cannot be dropped because some objects depend on it
-- DETAIL:  owner of database Uygulama
ALTER DATABASE "Uygulama" OWNER to "postgres";
DROP ROLE "rol1";


-- Veri tabanı sahibi olan bir rolü silmeden önce veri tabanı sahipliğini başka bir role aktarmalıyız.
-- Bu işlemi REASSIGN ile yapabiliriz.
CREATE ROLE "rol1";
ALTER DATABASE "Uygulama" owner to "rol1";
DROP ROLE "rol1";
-- 16:18:33 Kernel error: ERROR:  role "rol1" cannot be dropped because some objects depend on it
-- DETAIL:  owner of database Uygulama
REASSIGN OWNED BY "rol1" TO "postgres";
DROP ROLE "rol1";


-- Bir rolü grup gibi kullanabiliriz.
-- Diğer rollerin bu rolden yetkilerini kalıtım olarak almasını temin edebiliriz.

CREATE ROLE "gruprol";

-- rol1 isimli rolün yetkilerine gruprol isimli rolün yetkilerini de ekle.
GRANT "gruprol" TO "rol1";

-- Bunun yapılabilmesi için rol1 isimli rolün kalıtım alma özelliğine sahip olması gerek.
-- Diğer bir deyişle INHERIT yetkisine sahip olması gerek.
-- Bu yetki yoksa, yetkiler kalıtım alınmaz.
ALTER ROLE "rol1" WITH INHERIT;

CREATE ROLE "rol2" WITH INHERIT;
GRANT "gruprol" TO "rol2";


-- rol1 isimli role verilmiş yetkilerin geri alınması.
REVOKE "gruprol" FROM "rol1";



--Yetkilendirme İşlemleri

-- PUBLIC: Tüm roller / kullanıcılar. 
-- kullaniciAdi: tek bir kullanıcı.
-- ALL: Tüm yetkiler.

-- rol1 isimli role customers tablosu üzerinde seçim yapma yetkisi verir.
GRANT SELECT ON "customers" TO "rol1";

-- Tüm rollere customers tablosu üzerinde kayıt ekleme yetkisi verir.
GRANT INSERT ON "customers" TO PUBLIC;

-- rol1 isimli kullanıcıya customers tablosu üzerinde tüm yetkileri ver.
GRANT ALL ON "customers" TO "rol1";

-- rol1 isimli rolün customers tablosu üzerindeki güncelleme yetkisini geri al.
REVOKE UPDATE on "customers" FROM "rol1";

-- rol1 isimli rolün customers tablosu üzerindeki tüm yetkilerini geri al.
REVOKE ALL on "customers" FROM "rol1";

-- rol1 kullanicisinin Sema1 icerisindeki nesnelere ait tum yetkileri alinir.
REVOKE ALL ON SCHEMA "Sema1" FROM "rol1"; 


-- Herhangi bir nesne üzerinde yetkiye sahip olan bir rolü silemeyiz.
-- Silmeden önce yetkilerini silmeliyiz.
CREATE ROLE "rol1";
GRANT SELECT ON "customers" TO "rol1";
DROP ROLE "rol1"; 
-- 16:12:44 Kernel error: ERROR:  role "rol4" cannot be dropped because some objects depend on it
-- DETAIL:  privileges for table customers
DROP OWNED BY "rol1";
DROP ROLE "rol1";



-------Yetkilendirme Örneği1 (Northwind Veri Tabanı) ----------

CREATE ROLE "rol1";

SET SESSION AUTHORIZATION "rol1";

SELECT * FROM "customers"; 
--Kernel error: ERROR:  permission denied for relation customer

-- rol1 yetkilendirme haklarina sahip olmadigi icin hata oluşur.
GRANT SELECT ON "customers" TO "rol1"; 

-- Yetkilendirme yapabilmek için oturum yetkilendirmesini "postgres" kullanıcısı şeklinde ayarla.
SET SESSION AUTHORIZATION "postgres";

GRANT SELECT ON "customers" TO "rol1";

SET SESSION AUTHORIZATION "rol1";

-- Sorgu çalışır.
SELECT * FROM "customers";



-- Dil Desteği Ekleme

-- Linux
-- plperl diliyle program yazabilmek için plperl dil desteğini ekleme.
-- BilgisayarAdi@KullaniciAdi:~$ sudo apt-get install postgresql-plperl-9.5 


-- Application Stack Builder uygulaması mevcutsa bu uygulama aracılığı ile de EDB Language Pack yüklenerek ek dil paketleri eklenebilir.

-- Dil paketi yüklendikten sonra dilin oluşturulması gerekir.
CREATE LANGUAGE "plperl";

-- Ekli dilleri göster.
SELECT * FROM "pg_language";



-- Şifreleme

-- Kullanici şifreleri ve gizli bilgiler açık olarak saklanmamalidir.

-- Linux
-->sudo apt-get install postgresql-contrib

-- Kripto eklentisini oluştur.
CREATE EXTENSION "pgcrypto";

-- "sifrem" şifresini sha512 algoritması ile kodla.
SELECT ENCODE(DIGEST('sifrem', 'sha512'), 'hex');

-- "sifrem" şifresini md5 algoritması ile kodla ve sonucu "md5" ifadesi ile birleştir.
SELECT 'md5'|| MD5('sifrem');
