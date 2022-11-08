CREATE VIEW EJ8 (IDGERENCIA, PRESUPUESTOTOTAL)
/*La gerencia de marketing tiene ID = 1. Lo que hacemos
en este ejercicio es usar la funcion sum() para sumar
los presupuestos de los proyectos de la gerencia de 
marketing */
AS select g.IDG, sum(p.Presupuesto) from
GERENCIA g inner join PROYECTO p on g.IDG = p.IDG 
where g.IDG = 1
group by g.IDG;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ8 TO  SYSDBA WITH GRANT OPTION;

