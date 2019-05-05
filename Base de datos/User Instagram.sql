--Crear nuevo usuario(esquema) con el password "PASSWORD"
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER INSTAGRAM
  IDENTIFIED BY oracle
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP;
--asignar cuota ilimitada al tablespace por defecto
ALTER USER INSTAGRAM QUOTA UNLIMITED ON USERS;

--Asignar privilegios basicos
GRANT create session TO INSTAGRAM;
GRANT create table TO INSTAGRAM;
GRANT create view TO INSTAGRAM;
GRANT create any trigger TO INSTAGRAM;
GRANT create any procedure TO INSTAGRAM;
GRANT create sequence TO INSTAGRAM;
GRANT create synonym TO INSTAGRAM;
