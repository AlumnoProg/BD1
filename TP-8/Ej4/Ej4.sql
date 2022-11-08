CREATE VIEW EJ4 (NOMBRE, POCENTAJE)

/* hace una suma de los porcentajes por tipo de vino y compara aquellos resultados menores a 100 */

AS select v.NOMBRE, SUM(c.PORCENTAJE) as S 
    from VINO v INNER JOIN COMPUESTO c ON v.NOMBRE = c.NOMBRE
    group by v.NOMBRE
    having SUM(c.PORCENTAJE) < 100;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ4 TO  SYSDBA WITH GRANT OPTION;

