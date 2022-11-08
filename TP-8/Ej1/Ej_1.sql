CREATE VIEW EJ_1 (TITULO, ISBN, N_EJEMPLAR, FECHA_ENTREGA, LEGAJOALUMNO)
/* Damos por entendido que el prestamo tiene una duracion de 7 dias 
y lo que hacemos es poner una condicion donde la fecha en la que se entrega
el prestamo + 7 tiene que ser menor a la fecha de hoy, sino se lo considera 
moroso*/
AS select l.Titulo,l.ISBN, e.ID, p.FechaInicio, a.Legajo from 
Alumno a inner join Prestamo p on a.LEGAJO = p.LEGAJO 
    inner join Ejemplar e on e.ISBN = p.ISBN
    inner join Libro l on l.ISBN = e.ISBN
where ((P.FECHAINICIO + 7) < 'TODAY');

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EJ_1 TO  SYSDBA WITH GRANT OPTION;

