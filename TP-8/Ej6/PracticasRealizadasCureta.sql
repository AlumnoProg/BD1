CREATE VIEW PRACTICAS_REALIZADAS_CURETA (CODIGO, NOMBRE)

/* Calculamos todas las practicas realizadas por el Dr. Cureta, son varios joins naturales con la condicion de que el Dr. sea Cureta */

AS select p.codigo, p.descripcion from 
    medico m inner join consulta c on m.MATRICULA = c.MATRICULA
    inner join realiza r on c.IDC = r.IDC
    inner join practica p on p.CODIGO = r.CODIGO
    where m.APE_NOM = 'Cureta';

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON PRACTICAS_REALIZADAS_CURETA TO  SYSDBA WITH GRANT OPTION;

