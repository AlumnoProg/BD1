SET TERM ^ ;
CREATE FUNCTION F_RESULTADO (
    GOLES_L integer,
    GOLES_V integer )
RETURNS   DOM_RESULTADO

AS
/*CREAMOS UNA FUNCION QUE PASANDOLE LOS GOLES DE LOS 
EQUIPOS LOCAL Y VISITANTE NOS DEVUELVE UN RESULTADO 
DEL TIPO DE DOMINIO CREADO ANTERIORMENTE, ES DECIR,
LOCAL, EMPATE O VISITANTE*/
DECLARE VARIABLE resultado DOM_RESULTADO;
BEGIN
    if (goles_l > goles_v) then
        resultado = 'LOCAL';
    if (goles_l < goles_v) then
        resultado = 'VISITANTE';
    if (goles_l = goles_v) then
        resultado = 'EMPATE';
    return resultado;
END
^
SET TERM ; ^

GRANT EXECUTE
 ON FUNCTION F_RESULTADO TO  SYSDBA WITH GRANT OPTION;

