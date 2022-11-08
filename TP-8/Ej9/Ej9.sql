CREATE VIEW EJ9 (IDGUIA, CANTTOUR, CANTPASAJEROS, MONTO)
/*En este caso usamos la vista MONTO_GUIAS para obtener los datos de un viaje para poder
identificar al guia que estuvo en el viaje con mayor monto*/
AS select m.IDGUIA, m.CANTTOUR, m.CANTPASAJEROS, m.MONTO from MONTO_GUIAS m
where m.MONTO = (select max(m.MONTO) from MONTO_GUIAS m);

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ9 TO  SYSDBA WITH GRANT OPTION;

