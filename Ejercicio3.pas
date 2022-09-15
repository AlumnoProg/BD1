program Ejercicio3;

{$MODE OBJFPC}

uses crt, dos, sysutils;

type 
	metadata = record
		nombre: String[200];
		caracteres: integer;
	end;

	estructura = record
		dato: String[200];
	end;

	archivoClientes = file of estructura;

	archivoMetadata = file of metadata;

var
	Clientes: archivoClientes;
	aMetadata: archivoMetadata;
	Opcion, cantRegistros, cantClientes, cantCampos: Integer;
	Sigo: Boolean;
	OpcionAux, cantCamposAux: String;
	archivoEncontrado: Boolean;
	unCampo, noError: Boolean;
	
//----------------------------------------------------------------------	
//VALIDACIONES

procedure ValidarSinEspacios(var dato:string);
begin 
  	while ((dato = '') or (dato = ' ')) do begin
		WriteLn('Error, ingrese un valor valido');  
		ReadLn(dato);
	end;
end;

function ValorEntero(texto: string): integer;
var
  valor, codigoDeError: integer;
begin
	valor:= 0;
  	val(texto, valor, codigoDeError);
  	ValorEntero := valor;
end;

Procedure ValidarEnterosMayoresACero(var Numero: String);
begin

	while (ValorEntero(Numero) <= 0) do begin
		writeln('Error ingrese un numero entero mayor a 0');
		readln(Numero);
	end;

end;


Function ValidarOpcion(Op: String): Boolean;
var
	i, codigoDeError: integer;
begin
  
	ValidarOpcion:= False;
	i:= 0;
	val(Op, i, codigoDeError);
	if (codigoDeError = 0) then begin
		if ((i >= 0) and (i <= 5)) then
	  		ValidarOpcion:= True;
	end;		

end;


//--------------------------------------------------------------------
//ValidarQueSeaUnoDos
Procedure ValidarSoN(var dato: char);
begin
  
	while ((dato <> 'S') and (dato <> 'N')) do begin
	  writeln('Error, ingrese S o N');
	  readln(dato);
	end;

end;	


//--------------------------------------------------------------------
//VALIDAR QUE SOLO SE INGRESEN LETRAS

function revisarContenido(var Palabra:String) : Boolean;
var
  i:Integer;
  Flag: Boolean;
begin
  Flag:= True;
  if ((Palabra <> '') and (Palabra <> ' ')) then begin
 	for i:=1 to Length(Palabra) do
    	if not (Palabra[i] in ['A'..'Z', 'a'..'z']) then 
  		Flag:= False;
	end else 
		Flag:= False;
  revisarContenido:=Flag;
end;

Procedure ValidarPalabra(Var Palabra: String);
begin
  while (revisarContenido(Palabra) = False) do begin
    writeln('Error, ingrese solo letra');
    readln(Palabra);
  end;

end;

	
//----------------------------------------------------------------------
//CREAR ARCHIVOS

procedure crearArchivoMetaData(var aMetadata: archivoMetadata; var archivoEncontrado: Boolean);
var 
	registro:metadata;
begin
	assign(aMetadata,'.\metadata.dat');
    if not FileExists('.\metadata.dat') then
      Begin
        Writeln('El archivo "metadata" no existe, se procede a crear uno');
        rewrite(aMetadata);
        seek (aMetadata,filesize(aMetadata));
        registro.nombre:='Estado';
        registro.caracteres:=1;
        write(aMetadata,registro);
        close(aMetadata);
      End
    else
    Begin
      Writeln('Se encontro el archivo "metadata"');
      archivoEncontrado:=True;
    End;
end;

Procedure crearArchivoClientes(var Clientes: archivoClientes);
begin

	assign(Clientes, '.\clientes.dat');
	if (not FileExists('.\clientes.dat')) then begin
		writeln('El archivo "Clientes" no existe, se procede a crear uno');
		rewrite(Clientes);
		Close(Clientes);
	end else
		writeln('Se encontro el archivo "Clientes"');
	
end;


//----------------------------------------------------------------------
//CARGAR CAMPOS

Procedure cargarCampos(var aMetadata: archivoMetadata; cantCampos: Integer);
var
	registro: metadata;
	nroCampo: Integer;
	cantCaracteres: String;
begin

	nroCampo:= 1;
	while (cantCampos > 0) do begin
		writeln('Campo numero ', nroCampo);
		writeln('Ingrese el nombre del campo');
		readln(registro.nombre);
		ValidarPalabra(registro.nombre);
		writeln('Ingrese la cantidad de bytes que contiene el campo');
		readln(cantCaracteres);
		ValidarEnterosMayoresACero(cantCaracteres);
		registro.caracteres:= ValorEntero(cantCaracteres);
		reset(aMetadata);
		Seek(aMetadata, FileSize(aMetadata));
		write(aMetadata, registro);
		close(aMetadata);
		cantCampos:= cantCampos - 1;
		nroCampo:= nroCampo + 1;
		clrscr;
	end;
	writeln('Campos creados con exito');
	unCampo:= True;

end;


//----------------------------------------------------------------------
//CONTAR CAMPOS

Procedure contarCampos(var aMetadata: archivoMetadata);
begin

	cantRegistros:= 0;
	reset(aMetadata);
	while (not EOF(aMetadata)) do begin
		Seek(aMetadata, FilePos(aMetadata) + 1);
		cantRegistros:= cantRegistros + 1;
	end;
	close(aMetadata);

end;


//----------------------------------------------------------------------
//CONTAR CLIENTES

Procedure contarClientes();
begin

	reset(Clientes);
	cantClientes:= 1;
	while (not EOF(Clientes)) do begin
		Seek(Clientes, FilePos(Clientes) + 1);
		cantClientes:= cantClientes + 1;
	end;
	cantClientes:= cantClientes div cantRegistros;
	Close(Clientes);

end;

function ValorEnteroBoolean(texto: string): Boolean;
var
  valor, codigoDeError: integer;
  flag:boolean;
begin
	flag := false;
	valor:= 0;
  	val(texto, valor, codigoDeError);
	if codigoDeError = 0 then
		flag := true;
  	ValorEnteroBoolean := flag;
end;
//----------------------------------------------------------------------
//VALIDAR POSICION DE CLIENTE VALIDA

Procedure ValidarPosicionClienteIngresada(var Num: String);
begin
	
	contarClientes();
	while ((not ValorEnteroBoolean(Num)) or (ValorEntero(Num) < 0) or (ValorEntero(Num) > (cantClientes - 1)))  do begin
		writeln('Error ingrese una posicion entre 0 y ', (cantClientes - 1));
		readln(Num);
	end;
	
end;


//----------------------------------------------------------------------
//MOSTRAR

Procedure MostrarEstructuraRegistro(var aMetadata: archivoMetadata);
var
	registro: metadata;
begin

	reset(aMetadata);
	cantRegistros:= 0;
	writeln('======== Estructura ========');
	while (not EOF(aMetadata)) do begin
		read(aMetadata, registro);
		cantRegistros:= cantRegistros + 1;
		if (not(registro.nombre = 'Estado')) then begin
			writeln('Campo numero: ', cantRegistros - 1);
			writeln('Nombre: ', registro.nombre);
			writeln('Cantidad de caracteres: ', registro.caracteres);
			writeln('============================');
		end;
	end;
	Close(aMetadata);
	writeln('Pulse una tecla para continuar');
	readkey;

end;


Procedure MostrarDatos(var aMetadata: archivoMetadata; var Clientes: archivoClientes);
var
	regMeta: metadata;
	registro: estructura;
	contador: Integer;
begin

	contador:= 0;
	reset(Clientes);
	writeln('============================');
	while (not EOF(Clientes)) do begin
		writeln('Cliente numero ', contador);
		reset(aMetadata);
		while (not EOF(aMetadata)) do begin
			read(aMetadata, regMeta);
			if (not(regMeta.nombre = 'Estado')) then begin
				write(regMeta.nombre,': ');
				read(Clientes, registro);
				write(registro.dato);
				writeln('');
			end else
				Seek(Clientes, FilePos(Clientes) + 1);
		end;
		Close(aMetadata);
		writeln('============================');
		contador:= contador + 1;
	end;
	Close(Clientes);
	writeln('Pulse una tecla para continuar');
	readkey;

end;


Procedure mostrarCliente(var Clientes: archivoClientes; Numero: Integer);
var
	regMeta: metadata;
	registro: estructura;
begin

	reset(Clientes);
	Seek(Clientes, Numero);
	//writeln('Cliente ', (Numero div (cantRegistros - 1)));
	reset(aMetadata);
	while (not EOF(aMetadata)) do begin
		read(aMetadata, regMeta);
		if (not(regMeta.nombre = 'Estado')) then begin
			write(regMeta.nombre,': ');
			read(Clientes, registro);
			write(registro.dato);
			writeln('');
			if (EOF(Clientes)) then
			break;
		end else
			Seek(Clientes, FilePos(Clientes) + 1);
	end;
	Close(Clientes);
	Close(aMetadata);
end;


//----------------------------------------------------------------------
//PROCEDIMIENTO REESTRUCTURAR

Procedure Reestructurar();
var
	ClientesB: archivoClientes;
	registro: estructura;
begin

	reset(Clientes);
	assign(ClientesB, '.\clientesB.dat');
	rewrite(ClientesB);
	Seek(Clientes, 0);
	while (not EOF(Clientes)) do begin
		read(Clientes, registro);
		if (registro.dato = '0') then begin
			Seek(Clientes, (FilePos(Clientes) + cantRegistros - 1));
		end else
			write(ClientesB, registro);
	end;
	Close(Clientes);
	rewrite(Clientes);
	Seek(ClientesB, 0);
	while (not EOF(ClientesB)) do begin
		read(ClientesB, registro);
		write(Clientes, registro);
	end;
	Close(ClientesB);

end;

//----------------------------------------------------------------------
//PROCEDIMIENTO DE ALTA

Procedure Alta(var aMetadata: archivoMetadata; var Clientes: archivoClientes);
var
	regMeta: metadata;
	registro: estructura;
begin

	reset(aMetadata);
	reset(Clientes);
	while (not EOF(aMetadata)) do begin
		read(aMetadata, regMeta);
		if (regMeta.nombre = 'Estado') then begin
			registro.dato:= '1';
			Seek(Clientes, FileSize(Clientes));
			write(Clientes, registro);
		end else begin
			writeln('Ingrese ', regMeta.nombre);
			readln(registro.dato);
			ValidarSinEspacios(registro.dato);
			if (Length(registro.dato) > regMeta.caracteres) then begin
				delete(registro.dato, (regMeta.caracteres + 1), Length(registro.dato));
				writeln('En ', regMeta.nombre, ' se pusieron mas caracteres de los permitidos, se proceden a usar los primeros ', regMeta.caracteres, ' caracteres');
			end;
			Seek(Clientes, FileSize(Clientes));
			write(Clientes, registro);
		end;
	end;
	Close(aMetadata);
	Close(Clientes);
	writeln('Registro dado de alta con exito');

end;


//----------------------------------------------------------------------
//PROCEDIMIENTO DE BAJA

Procedure Baja(var Clientes: archivoClientes);
var
	clienteAEliminar: Integer;
	registro: estructura;
	respuesta: char;
	Posicion: String;
begin

	contarClientes();
	if (cantClientes = 0) then begin
		writeln('No hay clientes registrados');
		writeln('Presione una tecla para volver al menu principal');
		readkey;
		exit;
	end;
	writeln('Ingrese el cliente que desea dar de baja');
	readln(Posicion);
	ValidarPosicionClienteIngresada(Posicion);
	clienteAEliminar:= ValorEntero(Posicion);
	clienteAEliminar:= clienteAEliminar * cantRegistros;
	mostrarCliente(Clientes, clienteAEliminar);
	reset(Clientes);
	Seek(Clientes, clienteAEliminar);
	writeln('Desea dar de baja al cliente. (S/N)');
	readln(respuesta);
	respuesta:= UpCase(respuesta);
	ValidarSoN(respuesta);
	if (Respuesta = 'S') then begin
		read(Clientes, registro);
		registro.dato:= '0';
		Seek(Clientes, clienteAEliminar);
		write(Clientes, registro);
		Close(Clientes);
		Reestructurar();
		writeln('Cliente dado de baja con exito');
	end else
		Close(Clientes);

end;


//----------------------------------------------------------------------
//PROCEDIMIENTO DE MODIFICAR

Procedure Modificacion(var aMetadata: archivoMetadata; var Clientes: archivoClientes);
var
	clienteAModificar: Integer;
	regMeta: metadata;
	registro: estructura;
	respuesta: char;
	Posicion: String;
begin

	contarClientes();
	if (cantClientes = 0) then begin
		writeln('No hay clientes registrados');
		writeln('Presione una tecla para volver al menu principal');
		readkey;
		exit;
	end;
	writeln('Ingrese el cliente que desea modificar');
	readln(Posicion);
	ValidarPosicionClienteIngresada(Posicion);
	clienteAModificar:= ValorEntero(Posicion);
	clienteAModificar:= clienteAModificar * cantRegistros;
	mostrarCliente(Clientes, clienteAModificar);
	reset(Clientes);
	Seek(Clientes, clienteAModificar);
	reset(aMetadata);
	Seek(aMetadata, 0);
	while (not EOF(aMetadata)) do begin
		read(aMetadata, regMeta);
		if (not(regMeta.nombre = 'Estado')) then begin
			writeln('Desea modificar ', regMeta.nombre, ' (S/N)');
			readln(respuesta);
			respuesta:= UpCase(respuesta);
			ValidarSoN(respuesta);
			read(Clientes, registro);
			if (respuesta = 'S') then begin
				writeln('Ingrese ', regMeta.nombre);
				readln(registro.dato);
				ValidarSinEspacios(registro.dato);
				if (length(registro.dato) > regMeta.caracteres) then begin
					delete(registro.dato, regMeta.caracteres, length(registro.dato));
				end;
				Seek(Clientes, FilePos(Clientes) - 1);
				write(Clientes, registro);
			end;
		end else
			Seek(Clientes, FilePos(Clientes) + 1);
	end;
	Close(aMetadata);
	Close(Clientes);
	writeln('Registro modificado con exito');

end;


//----------------------------------------------------------------------

BEGIN

	Sigo:= True;
	noError:= True;
	unCampo:= False;
	archivoEncontrado:= False;
	crearArchivoMetadata(aMetadata, archivoEncontrado);
	if (archivoEncontrado = False) then begin
		while (Sigo = True) do begin
	  		writeln('1. Crear campo');
	  		writeln('0. Salir');
	  		readln(OpcionAux);
	  	if (ValidarOpcion(OpcionAux) = True) then begin
	  		Opcion:= ValorEntero(OpcionAux);
	  		case (Opcion) of
				1:begin
					clrscr;
					writeln('Ingrese la cantidad de campos que tendra la lista de clientes');
					readln(cantCamposAux);
					ValidarEnterosMayoresACero(cantCamposAux);
					cantCampos:= ValorEntero(cantCamposAux);
					cargarCampos(aMetadata, cantCampos);
				end;

				0:begin
			  		clrscr;
					if (unCampo = False) then begin
			  			writeln('El archivo de metadata debe contener al menos un campo');
					end else begin
						Sigo:= False;
						archivoEncontrado:= True;
			  			writeln('');
					end;
				end;
	  		end;
	  		if (Opcion <> 0) then begin
				writeln('Presiones una tecla para continuar');
				readkey;
				clrscr;
	  		end;

	   	end else begin
	   		clrscr;
		 	writeln('Error, ', OpcionAux, ' no es un dato permitido, por favor ingrese un numero que corresponda a las opciones en pantalla');
	   	end;
	end;
	end;
	
	Sigo:= True;
	contarCampos(aMetadata);
	crearArchivoClientes(Clientes);
	while (Sigo = True) do begin
	  writeln('1. Alta');
	  writeln('2. Baja');
	  writeln('3. Modificacion');
	  writeln('4. Mostrar datos');
	  writeln('5. Mostrar estructura del registro');
	  writeln('0. Salir');
	  readln(OpcionAux);
	  if (ValidarOpcion(OpcionAux) = True) then begin
	  	Opcion:= ValorEntero(OpcionAux);
	  	case (Opcion) of
				1:begin
			  		clrscr;
			  		Alta(aMetadata, Clientes);
				end;

				2:begin
			  		clrscr;
			  		Baja(Clientes);
				end;

				3:begin
			  		clrscr;
			 	 	Modificacion(aMetadata, Clientes);
				end;

				4:begin
			  		clrscr;
			  		MostrarDatos(aMetadata, Clientes);
				end;

				5:begin
			  		clrscr;
			  		MostrarEstructuraRegistro(aMetadata);
				end;

				0:begin
			  		clrscr;
			  		Sigo:= False;
			  		writeln('Fin del programa');
				end;
	  	end;
	  	if (Opcion <> 0) then begin
			writeln('Presione una tecla para continuar');
			readkey;
			clrscr;
	  	end;
	   end else begin
	   		clrscr;
		 	writeln('Error, ', OpcionAux, ' no es un dato permitido, por favor ingrese un numero que corresponda a las opciones en pantalla');
	   end;
	end;
END.