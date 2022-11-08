CREATE VIEW CANTIDAD_PRODUCTO_PROVEEDOR (CUIT, RAZON_SOCIAL, CANTIDAD)

/* Generamos una tabla con los proveedores y la cantidad total de producto comprado */

AS select p.cuit, p.ape_nom, SUM(distinct c.cant) as sumilla from 
    proveedor p inner join FACT_CMPR f on p.CUIT = f.CUIT
    inner join contiene c on c.CUIT = f.CUIT
    group by p.cuit, p.APE_NOM;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON CANTIDAD_PRODUCTO_PROVEEDOR TO  SYSDBA WITH GRANT OPTION;

