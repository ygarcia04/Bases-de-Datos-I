--CREACION DE SECUENCIAS
CREATE SEQUENCE USUARIO INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_ACCESO INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_CANAL INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_CATEGORIA INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_LUGAR INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_PUBLICACION INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_COMENTARIO INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_MENSAJE INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_VIDEO INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CODIGO_INHABILITAR_CUENTA INCREMENT BY 1 START WITH 1;

--PROCEDIMIENTOS ALMACENADOS
--NUEVO USUARIO
CREATE OR REPLACE PROCEDURE P_AGREGAR_USUARIO(
    P_CORREO_USUARIO TBL_USUARIO.CORREO_USUARIO%TYPE,
    P_NOMBRE_PERFIL_USUARIO TBL_USUARIO.NOMBRE_PERFIL_USUARIO%TYPE,
    P_PASSWORD TBL_USUARIO.PASSWORD%TYPE,
    P_FECHA_REGISTRO TBL_USUARIO.FECHA_REGISTRO%TYPE,
    P_NOMBRE_USUARIO TBL_USUARIO.NOMBRE_USUARIO%TYPE,
    P_APELLIDO_USUARIO TBL_USUARIO.APELLIDO_USUARIO%TYPE,
    P_NUMERO_TELEFONO TBL_USUARIO.NUMERO_TELEFONO%TYPE,
    p_mensaje out varchar2,
    p_codigo_resultado out integer
) AS
    v_cantidad number;
BEGIN
    select count(*)
    into v_cantidad
    from TBL_USUARIO
    where CORREO_USUARIO = P_CORREO_USUARIO OR
          NOMBRE_PERFIL_USUARIO = P_NOMBRE_PERFIL_USUARIO;

    IF (v_cantidad = 0) THEN
        INSERT INTO TBL_USUARIO (
            CODIGO_USUARIO,
            CORREO_USUARIO,
            NOMBRE_PERFIL_USUARIO,
            PASSWORD,
            FECHA_REGISTRO,
            NOMBRE_USUARIO,
            APELLIDO_USUARIO,
            NUMERO_TELEFONO
        ) VALUES (
            USUARIO.nextval,
            P_CORREO_USUARIO,
            P_NOMBRE_PERFIL_USUARIO,
            P_PASSWORD,
            P_FECHA_REGISTRO,
            P_NOMBRE_USUARIO,
            P_APELLIDO_USUARIO,
            P_NUMERO_TELEFONO
        );
        commit;
        p_mensaje := 'Registro almanceado con éxito';
        p_codigo_resultado:=1;
    ELSE
        p_mensaje := 'El correo o nombre de usuario está duplicado, no se pudo guardar';
        p_codigo_resultado:=0;
    END IF;
    --LOREM IPSUM
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || '-'||SQLERRM);
        ROLLBACK;
        p_mensaje:= 'Error al guardar el usuario: ' || SQLCODE || '-'||SQLERRM;
        p_codigo_resultado:=0;
END;

--ELIMINAR USUARIO
CREATE OR REPLACE PROCEDURE P_ELIMINAR_USUARIO(
    P_NOMBRE_PERFIL_USUARIO TBL_USUARIO.NOMBRE_PERFIL_USUARIO%TYPE)
    IS
    BEGIN
        DELETE TBL_USUARIO WHERE NOMBRE_PERFIL_USUARIO = P_NOMBRE_PERFIL_USUARIO;
    COMMIT;
END;

--NUEVO COMENTARIO
CREATE  OR REPLACE PROCEDURE P_NUEVO_COMENTARIO(
    P_CODIGO_USUARIO TBL_COMENTARIO.CODIGO_USUARIO%TYPE,
    P_CODIGO_PUBLICACION TBL_COMENTARIO.CODIGO_PUBLICACION%TYPE,
    P_FECHA_PUBLICACION TBL_COMENTARIO.FECHA_PUBLICACION%TYPE,
    P_COMENTARIO TBL_COMENTARIO.COMENTARIO%TYPE)
    IS
    BEGIN
        INSERT INTO TBL_COMENTARIO (
            CODIGO_COMENTARIO,
            CODIGO_USUARIO,
            CODIGO_PUBLICACION,
            FECHA_PUBLICACION, --ES DEL COMENTARIO
            COMENTARIO
        ) VALUES (
            CODIGO_COMENTARIO.nextval,
            P_CODIGO_USUARIO,
            P_CODIGO_PUBLICACION,
            P_FECHA_PUBLICACION,
            P_COMENTARIO
        );
        commit;
    END;

--ACTUALIZAR COMENTARIO
CREATE OR REPLACE PROCEDURE P_ACTUALIZAR_COMENTARIO(
    P_CODIGO_COMENTARIO TBL_COMENTARIO.CODIGO_COMENTARIO%TYPE,
    P_FECHA_PUBLICACION TBL_COMENTARIO.FECHA_PUBLICACION%TYPE,
    P_COMENTARIO TBL_COMENTARIO.COMENTARIO%TYPE)
    IS
    BEGIN
         UPDATE TBL_COMENTARIO
      SET   COMENTARIO = P_COMENTARIO,
            FECHA_PUBLICACION = P_FECHA_PUBLICACION
        WHERE CODIGO_COMENTARIO = P_CODIGO_COMENTARIO;
END;

--BORRAR COMENTARIO
CREATE OR REPLACE PROCEDURE P_ELIMINAR_COMENTARIO(
    P_CODIGO_COMENTARIO TBL_COMENTARIO.CODIGO_COMENTARIO%TYPE)
    IS
    BEGIN
        DELETE TBL_COMENTARIO where CODIGO_COMENTARIO = P_CODIGO_COMENTARIO;
    COMMIT;
END;

--NUEVA PUBLICACION
CREATE  OR REPLACE PROCEDURE P_NUEVA_PUBLICACION(
    P_CODIGO_TIPO_PUBLICACION TBL_PUBLICACIONES.CODIGO_TIPO_PUBLICACION%TYPE,
    P_CODIGO_USUARIO TBL_PUBLICACIONES.CODIGO_USUARIO%TYPE,
    P_CODIGO_EXTENSION_PUBLICACION TBL_PUBLICACIONES.CODIGO_EXTENSION_PUBLICACION%TYPE,
    P_CODIGO_CATEGORIA TBL_PUBLICACIONES.CODIGO_CATEGORIA%TYPE,
    P_NOMBRE_ARCHIVO TBL_PUBLICACIONES.NOMBRE_ARCHIVO%TYPE,
    P_ARCHIVO TBL_PUBLICACIONES.ARCHIVO%TYPE,
    P_FECHA_SUBIDA_ARCHIVO TBL_PUBLICACIONES.FECHA_SUBIDA_ARCHIVO%TYPE)
    IS
    BEGIN
        INSERT INTO TBL_PUBLICACIONES (
            CODIGO_PUBLICACION,
            CODIGO_TIPO_PUBLICACION,
            CODIGO_USUARIO,
            CODIGO_EXTENSION_PUBLICACION,
            CODIGO_CATEGORIA,
            NOMBRE_ARCHIVO,
            ARCHIVO,
            FECHA_SUBIDA_ARCHIVO
        ) VALUES (
            CODIGO_PUBLICACION.nextval,
            P_CODIGO_TIPO_PUBLICACION,
            P_CODIGO_USUARIO,
            P_CODIGO_EXTENSION_PUBLICACION,
            P_CODIGO_CATEGORIA,
            P_NOMBRE_ARCHIVO,
            P_ARCHIVO,
            P_FECHA_SUBIDA_ARCHIVO
        );
        commit;
    END;
	
--ACTUALIZAR PUBLICACION
CREATE OR REPLACE PROCEDURE P_ACTUALIZAR_PUBLICACION(
    P_CODIGO_PUBLICACION TBL_PUBLICACIONES.CODIGO_PUBLICACION%TYPE,
    P_NOMBRE_ARCHIVO TBL_PUBLICACIONES.NOMBRE_ARCHIVO%TYPE,
    P_FECHA_SUBIDA_ARCHIVO TBL_PUBLICACIONES.FECHA_SUBIDA_ARCHIVO%TYPE,
    P_ARCHIVO TBL_PUBLICACIONES.ARCHIVO%TYPE)
    IS
    BEGIN
         UPDATE TBL_PUBLICACIONES
      SET   NOMBRE_ARCHIVO = P_NOMBRE_ARCHIVO,
            FECHA_SUBIDA_ARCHIVO = P_FECHA_SUBIDA_ARCHIVO,
            ARCHIVO = P_ARCHIVO
        WHERE CODIGO_PUBLICACION = P_CODIGO_PUBLICACION;
	END;

--BORRAR PUBLICACION
CREATE OR REPLACE PROCEDURE P_ELIMINAR_PUBLICACION(
    P_CODIGO_PUBLICACION TBL_PUBLICACIONES.CODIGO_PUBLICACION%TYPE)
    IS
    BEGIN
        DELETE TBL_PUBLICACIONES WHERE CODIGO_PUBLICACION = P_CODIGO_PUBLICACION;
    COMMIT;
	END;

--NUEVO CANAL
CREATE  OR REPLACE PROCEDURE P_NUEVO_CANAL(
    P_DESCRIPCION_ACTIVACION TBL_CANAL_VIDEOS.DESCRIPCION_ACTIVACION%TYPE)
    IS
    BEGIN
        INSERT INTO TBL_CANAL_VIDEOS (
            CODIGO_CANAL,
            DESCRIPCION_ACTIVACION
        ) VALUES (
            CODIGO_CANAL.nextval,
            P_DESCRIPCION_ACTIVACION
        );
        commit;
    END;
	
--ACTUALIZAR CANAL
CREATE OR REPLACE PROCEDURE P_ACTUALIZAR_CANAL(
    P_CODIGO_CANAL TBL_CANAL_VIDEOS.CODIGO_CANAL%TYPE,
    P_DESCRIPCION_ACTIVACION TBL_CANAL_VIDEOS.DESCRIPCION_ACTIVACION%TYPE)
    IS
    BEGIN
         UPDATE TBL_CANAL_VIDEOS
      SET   DESCRIPCION_ACTIVACION = P_DESCRIPCION_ACTIVACION
        WHERE CODIGO_CANAL = P_CODIGO_CANAL;
	END;

--BORRAR CANAL
CREATE OR REPLACE PROCEDURE P_ELIMINAR_CANAL(
    P_CODIGO_CANAL TBL_CANAL_VIDEOS.CODIGO_CANAL%TYPE)
    IS
    BEGIN
        DELETE TBL_CANAL_VIDEOS WHERE CODIGO_CANAL = P_CODIGO_CANAL;
    COMMIT;
	END;

--NUEVO VIDEO
CREATE  OR REPLACE PROCEDURE P_NUEVO_VIDEO(
    P_CODIGO_CANAL TBL_IGTV.CODIGO_CANAL%TYPE,
    P_CODIGO_VISTA_PREVIA TBL_IGTV.CODIGO_VISTA_PREVIA%TYPE,
    P_FOTO_PORTADA TBL_IGTV.FOTO_PORTADA%TYPE,
    P_VIDEO TBL_IGTV.VIDEO%TYPE,
    P_TITULO TBL_IGTV.TITULO%TYPE,
    P_DESCRIPCION TBL_IGTV.DESCRIPCION%TYPE)
    IS
    BEGIN
        INSERT INTO TBL_IGTV (
            CODIGO_VIDEO,
            CODIGO_CANAL,
            CODIGO_VISTA_PREVIA,
            FOTO_PORTADA,
            VIDEO,
            TITULO,
            DESCRIPCION
        ) VALUES (
            CODIGO_VIDEO.nextval,
            P_CODIGO_CANAL,
            P_CODIGO_VISTA_PREVIA,
            P_FOTO_PORTADA,
            P_VIDEO,
            P_TITULO,
            P_DESCRIPCION
        );
        commit;
    END;

--BORRAR VIDEO
CREATE OR REPLACE PROCEDURE P_ELIMINAR_VIDEO(
    P_CODIGO_VIDEO TBL_IGTV.CODIGO_VIDEO%TYPE)
    IS
    BEGIN
        DELETE TBL_IGTV WHERE CODIGO_VIDEO = P_CODIGO_VIDEO;
    COMMIT;
	END;

--ACTIVACION INHABILITAR CUENTA
CREATE  OR REPLACE PROCEDURE P_INHABILITAR_CUENTA(
    P_DESCRIPCION_INHABILITAR TBL_INHABILITAR_CUENTA.DESCRIPCION_INHABILITAR%TYPE,
    P_FECHA_INHABILITAR TBL_INHABILITAR_CUENTA.FECHA_INHABILITAR%TYPE,
    P_FECHA_HABILITAR TBL_INHABILITAR_CUENTA.FECHA_HABILITAR%TYPE)
    IS
    BEGIN
        INSERT INTO TBL_INHABILITAR_CUENTA (
            CODIGO_INHABILITAR_CUENTA,
            DESCRIPCION_INHABILITAR,
            FECHA_INHABILITAR,
            FECHA_HABILITAR
        ) VALUES (
            CODIGO_INHABILITAR_CUENTA.nextval,
            P_DESCRIPCION_INHABILITAR,
            P_FECHA_INHABILITAR,
            P_FECHA_HABILITAR
        );
        commit;
    END;

--ACTUALIZACION ACTIVACION INHABILITAR CUENTA
CREATE OR REPLACE PROCEDURE P_ACTUALIZAR_INHABILITAR_CUENTA(
    P_CODIGO_INHABILITAR_CUENTA TBL_INHABILITAR_CUENTA.CODIGO_INHABILITAR_CUENTA%TYPE,
    P_FECHA_INHABILITAR TBL_INHABILITAR_CUENTA.FECHA_INHABILITAR%TYPE,
    P_FECHA_HABILITAR TBL_INHABILITAR_CUENTA.FECHA_HABILITAR%TYPE)
    IS
    BEGIN
         UPDATE TBL_INHABILITAR_CUENTA
      SET   FECHA_INHABILITAR = P_FECHA_INHABILITAR,
            FECHA_HABILITAR = P_FECHA_HABILITAR
        WHERE CODIGO_INHABILITAR_CUENTA = P_CODIGO_INHABILITAR_CUENTA;
    END;

--BORRADO INHABILITAR CUENTA
CREATE OR REPLACE PROCEDURE P_ELIMINAR_INHABILITAR_CUENTA(
    P_CODIGO_INHABILITAR_CUENTA TBL_INHABILITAR_CUENTA.CODIGO_INHABILITAR_CUENTA%TYPE)
    IS
    BEGIN
        DELETE TBL_INHABILITAR_CUENTA WHERE CODIGO_INHABILITAR_CUENTA = P_CODIGO_INHABILITAR_CUENTA;
    COMMIT;
END;

--NUEVA AUTENTICACION
CREATE  OR REPLACE PROCEDURE P_AUTENTICACION(
    P_CODIGO_TIPO_AUTENTICACION TBL_AUTENTICACION.CODIGO_TIPO_AUTENTICACION%TYPE,
    P_CODIGO_USUARIO TBL_AUTENTICACION.CODIGO_USUARIO%TYPE,
    P_FECHA_ACTIVACION TBL_AUTENTICACION.FECHA_ACTIVACION%TYPE,
    P_APP_O_CEL TBL_AUTENTICACION.APP_O_NUM_CEL%TYPE)
    IS
    BEGIN
        INSERT INTO TBL_AUTENTICACION (
            CODIGO_TIPO_AUTENTICACION,
            CODIGO_USUARIO,
            FECHA_ACTIVACION, APP_O_NUM_CEL
        ) VALUES (
            P_CODIGO_TIPO_AUTENTICACION,
            P_CODIGO_USUARIO, P_FECHA_ACTIVACION, P_APP_O_CEL
        );
        commit;
    END;
	
--ACTUALIZACION AUTENTICACION
    CREATE OR REPLACE PROCEDURE P_ACTUALIZAR_AUTENTICACION(
    P_CODIGO_TIPO_AUTENTICACION TBL_AUTENTICACION.CODIGO_TIPO_AUTENTICACION%TYPE,
    P_CODIGO_USUARIO TBL_AUTENTICACION.CODIGO_USUARIO%TYPE,
    P_FECHA_ACTIVACION TBL_AUTENTICACION.FECHA_ACTIVACION%TYPE,
    P_APP_O_CEL TBL_AUTENTICACION.APP_O_NUM_CEL%TYPE)
    IS
    BEGIN
         UPDATE TBL_AUTENTICACION
      SET   CODIGO_TIPO_AUTENTICACION = P_CODIGO_TIPO_AUTENTICACION,
            FECHA_ACTIVACION = P_FECHA_ACTIVACION,
            APP_O_NUM_CEL = P_APP_O_CEL
        WHERE CODIGO_USUARIO = P_CODIGO_USUARIO;
    END;

--ELIMINACION AUTENTICACION
CREATE OR REPLACE PROCEDURE P_ELIMINAR_AUTENTICACION(
    P_CODIGO_USUARIO TBL_AUTENTICACION.CODIGO_USUARIO%TYPE)
    IS
    BEGIN
        DELETE TBL_AUTENTICACION WHERE CODIGO_USUARIO = P_CODIGO_USUARIO;
    COMMIT;
END;





















 

