CREATE VIEW GOLES_EQUIPO_LOCAL (IDPARTIDO, CANT_GOLES)
/*ESTA VISTA NOS DEVUELVE LA CANTIDAD DE GOLES QUE HIZO EL EQUIPO LOCAL EN EL PARTIDO*/
AS select p.IDP, sum(jp.GOLES) from PARTIDO p inner join JUGADOR_PARTIDO jp on p.IDP = jp.IDP
    inner join JUGADOR j on j.NOMBRE = jp.NOMBRE
    inner join EQUIPO e on (e.IDE = j.IDE and e.IDE = p.IDE_L)
group by p.IDP;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON GOLES_EQUIPO_LOCAL TO  SYSDBA WITH GRANT OPTION;

