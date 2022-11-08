CREATE VIEW MONTO_GUIAS (IDGUIA, CANTTOUR, CANTPASAJEROS, MONTO)
/*En esta vista usamos la funcion count para contar la cantidad de pasajeros y
la cantidad de tours en un viaje. Ademas usamos la funcion sum para sumar el monto de
cada viaje */
AS select g.IDG, count(t.IDT) as ct, count(p.IDP) as cp, sum(v.monto) as mont from
GUIA g inner join VIAJE v on g.IDG = v.IDG
    inner join TOUR t on t.IDT = v.IDT
    inner join PARTICIPA part on part.IDV = v.IDV
    inner join PASAJERO p on part.IDP = p.IDP
GROUP by g.IDG;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON MONTO_GUIAS TO  SYSDBA WITH GRANT OPTION;

