CREATE VIEW EJ3 (CODIGO)

/* Hacemos una diferencia entre los articulos que se venden en la sucursal 1 y la sucursal 2 */

AS select a.ARTICULOS FROM ARTICULOS_SUCURSAL_1 a LEFT JOIN ARTICULOS_SUCURSAL_2 b 
    ON a.ARTICULOS = b.ARTICULOS
    WHERE b.ARTICULOS IS NULL;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ3 TO  SYSDBA WITH GRANT OPTION;

