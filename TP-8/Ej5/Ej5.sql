CREATE VIEW EJ5 (ID_CLIENTE, APELLIDO_Y_NOMBRE)

/* hacemos un inner join entre cliente y poliza, con eso hacemos un left join a accidente y nos quedamos con los que no han tenido accidentes (aquellos con campos de accidente nulos) */

AS select distinct c.ID_CLIENTE, c.APE_NOM 
    from CLIENTE c INNER JOIN POLIZA p ON c.ID_CLIENTE = p.ID_CLIENTE
    LEFT JOIN ACCIDENTE a on p.NUMERO_POLIZA = a.NUMERO_POLIZA 
    where a.DESCRIPCION is null;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ5 TO  SYSDBA WITH GRANT OPTION;

