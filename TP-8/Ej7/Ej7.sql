CREATE VIEW EJ7 (CUIT, RAZON_SOCIAL, CANTIDAD_TOTAL)

/* Seleccionamos el maximo valor de cant de producto de la tabla con los proveedores y el total de los productos vendidos */

AS select v.cuit, v.razon_social, v.cantidad from CANTIDAD_PRODUCTO_PROVEEDOR v
    where v.CANTIDAD = (select max(vv.cantidad) from CANTIDAD_PRODUCTO_PROVEEDOR vv);

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ7 TO  SYSDBA WITH GRANT OPTION;

