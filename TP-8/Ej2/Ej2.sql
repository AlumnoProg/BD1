CREATE VIEW EJ_2 (NOMBREREVISTA, ANIO, NROARTICULO, CANTIDADARTICULOS)
/*Mostramos los datos de la revista junto a la cantidad de articulos que tiene 
 con la funcion count() y la condicion de que el nombre de la revista sea igual 
 a la revista "Natural Geographics".*/ 
AS select r.Nombre, a.Anio, a.Nro, count(*) 
from Revista r inner join ARTICULO a on r.ID = a.ID
where r.NOMBRE = 'Natural Geographics'
group by r.NOMBRE, a.ANIO, a.NRO;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ_2 TO  SYSDBA WITH GRANT OPTION;