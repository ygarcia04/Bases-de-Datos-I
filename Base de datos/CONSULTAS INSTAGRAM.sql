
--CAMBIO DE CONTRASEÑA
UPDATE TBL_USUARIO SET PASSWORD = 'CAMBIO123' WHERE NOMBRE_PERFIL_USUARIO = 'YGARCIA'; --HIRIAN LAS VARIABLES EN VEZ DE LOS DATOS

--BUSCAR USUARIOS
SELECT NOMBRE_PERFIL_USUARIO, NOMBRE_USUARIO||' ' ||APELLIDO_USUARIO
FROM TBL_USUARIO WHERE NOMBRE_USUARIO LIKE 'M%'; --VARIABLES EN VEZ DE DATOS

--CANTIDAD DE USUARIOS SEGUIDORES
SELECT CODIGO_USUARIO, COUNT(*) FROM TBL_SEGUIDOS
WHERE CODIGO_USUARIO = 7 AND CODIGO_SOLICITUD = 1  --VARIABLES EN VEZ DE DATOS EN EL CODIGO USUARIO 
GROUP BY CODIGO_USUARIO;

--CANTIDAD DE USUARIOS SEGUIDOS
SELECT CODIGO_SEGUIDOR, COUNT(*) FROM TBL_SEGUIDOS
WHERE CODIGO_SEGUIDOR = 7 AND CODIGO_SOLICITUD = 1  --VARIABLES EN VEZ DE DATOS EN CODIGO SEGUIDOR
GROUP BY CODIGO_SEGUIDOR;

--LISTA DE USUARIOS SEGUIDOS
SELECT A.CODIGO_USUARIO, B.NOMBRE_PERFIL_USUARIO, B.NOMBRE_USUARIO||' ' ||B.APELLIDO_USUARIO
FROM TBL_SEGUIDOS A LEFT JOIN TBL_USUARIO B
    ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
    WHERE CODIGO_SEGUIDOR = 7 AND CODIGO_SOLICITUD = 1;  --VARIABLES EN VEZ DE DATOS EN CODIGO SEGUIDOR

--LISTA DE USUARIOS SEGUIDORES
SELECT A.CODIGO_SEGUIDOR, B.NOMBRE_PERFIL_USUARIO, B.NOMBRE_USUARIO||' ' ||B.APELLIDO_USUARIO
FROM TBL_SEGUIDOS A LEFT JOIN TBL_USUARIO B
    ON (A.CODIGO_SEGUIDOR = B.CODIGO_USUARIO)
    WHERE A.CODIGO_USUARIO = 7 AND CODIGO_SOLICITUD = 1;  --VARIABLES EN VEZ DE DATOS EN CODIGO USUARIO 

--CANTIDAD LIKE PUBLICACION
SELECT CODIGO_PUBLICACION, COUNT(*) FROM TBL_LIKES
HAVING CODIGO_PUBLICACION = 1 --CAMBIAR NUMERO POR VARIABLE
GROUP BY CODIGO_PUBLICACION;

--CANTIDAD LIKE COMENTARIO
SELECT CODIGO_COMENTARIO, COUNT(*) FROM TBL_LIKES
HAVING CODIGO_COMENTARIO = 1 --CAMBIAR NUMERO POR VARIABLE
GROUP BY CODIGO_COMENTARIO;

--PUBLICACIONES POR TIPO Y CANTIDAD LIKE
SELECT A.CODIGO_PUBLICACION, A.ARCHIVO, B.CANTIDAD_LIKES FROM TBL_PUBLICACIONES A
LEFT JOIN (
    SELECT CODIGO_PUBLICACION, COUNT(*) AS CANTIDAD_LIKES
    FROM TBL_LIKES
    GROUP BY CODIGO_PUBLICACION
    ) B
ON (A.CODIGO_PUBLICACION = B.CODIGO_PUBLICACION)
WHERE CODIGO_CATEGORIA = 8; --CAMBIAR POR VARIABLE

--SUGERENCIAS DE AMIGOS
WITH USUARIO_SEGUIDOR AS (
    SELECT CODIGO_SEGUIDOR FROM TBL_SEGUIDOS
    WHERE CODIGO_USUARIO = 7 AND CODIGO_SOLICITUD = 1
    ) SELECT A.CODIGO_USUARIO, B.CODIGO_SEGUIDOR, C.NOMBRE_PERFIL_USUARIO,
             C.NOMBRE_USUARIO || ' ' || APELLIDO_USUARIO AS NOMBRE_USUARIO
    FROM TBL_SEGUIDOS A, USUARIO_SEGUIDOR B, TBL_USUARIO C
    WHERE A.CODIGO_SEGUIDOR = B.CODIGO_SEGUIDOR AND CODIGO_SOLICITUD = 1
      AND A.CODIGO_USUARIO != 7 AND A.CODIGO_USUARIO = C.CODIGO_USUARIO
    ORDER BY DBMS_RANDOM.VALUE; --CAMBIAR NUMERO POR VARIABLE
	
	
	
	