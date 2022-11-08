CREATE VIEW EJ6 (CODIGO, NOMBRE)

/* Hacemos la diferencia entre todas las practicas y las que realizo el Dr. Cureta */

AS select p.codigo, p.descripcion from 
    PRACTICA p left join PRACTICAS_REALIZADAS_CURETA pc
    on p.CODIGO = pc.CODIGO
    where pc.NOMBRE is null;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ6 TO  SYSDBA WITH GRANT OPTION;

