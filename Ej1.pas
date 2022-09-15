program Ej1;
uses crt, dos, sysutils;

type
	regCliente = record
		//Posicion: Integer;
		Apellido: String[50];
		Nombre: String[50];
		Codigo: String[4];
		Activo: Boolean;
	end;

type
	archivoClientes = file of regCliente;

//--------------------------------------------------------------------
//VALIDAR OPCION

function ValorEntero(texto: string): integer;
var
  valor, codigoDeError: integer;
begin
  valor:= 0;
  val(texto, valor, codigoDeError);
  ValorEntero := valor;
end;

Function ValidarOpcion(Op: String): Boolean;
var
	i, codigoDeError: integer;
begin
  
	ValidarOpcion:= False;
	i:= 0;
	val(Op, i, codigoDeError);
	if (codigoDeError = 0) then begin
		if ((i >= 0) and (i <= 4)) then
	  		ValidarOpcion:= True;
	end;		

end;


//--------------------------------------------------------------------
//ValidarCodigo

Function VCod(Cod: String): Boolean;
var
	i, codigoDeError: integer;
begin

	VCod:= False;
	i:= 0;
	val(Cod, i, codigoDeError);
	if (codigoDeError = 0) then begin
	  if (Length(Cod) <= 4) then
		  if ((i >= 0) and (i <= 9999)) then
			VCod:= True;
	end;

end;

Procedure ValidarCodigo(var Codigo: String);
begin
  
	while (VCod(Codigo) = False) do begin
	  WriteLn('Error, ingrese un numero de hasta 4 digitos');
	  readln(Codigo);
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


//--------------------------------------------------------------------
//ValidarQueSeaUnoDos
Procedure ValidarUnoDos(var dato: String);
begin
  
	while ((dato <> '1') and (dato <> '2')) do begin
	  writeln('Error, ingrese 1 o 2');
	  readln(dato);
	end;

end;


//--------------------------------------------------------------------
//MOSTRAR DATOS DEL ARCHIVO

Procedure MostrarDatos(var Client: archivoClientes);
var	
	Cliente: regCliente;
	Posicion: Integer;
begin

	Posicion:= 1;
	reset(Client);
	WriteLn('--------------------------------------');
	writeln('Datos del archivo');
	WriteLn('--------------------------------------');
	writeln(' ');
	while (not EOF(Client)) do begin
	  	read(Client, Cliente);
		if (Cliente.Activo <> False) then begin
	  		WriteLn('Posicion:   ', Posicion);
	 		WriteLn('Apellido:   ', Cliente.Apellido);
	  		WriteLn('Nombre:     ', Cliente.Nombre);
	  		WriteLn('Cliente:     ', Cliente.Codigo);
			WriteLn('  ');
			WriteLn('--------------------------------------');
			WriteLn('  ');
			Posicion:= Posicion + 1;
		end;
	end;
	close(Client);

end;


//--------------------------------------------------------------------
//BUSCAR SI ESTA EN EL ARCHIVO

Function Esta(Var Client: archivoClientes; Cliente: regCliente): Boolean;
var
	Flag: Boolean;
	ClienteAux: regCliente;
begin

	Flag:= False;
	reset(Client);
	while ((not EOF(Client)) and (Flag = False)) do begin
		Read(Client, ClienteAux);
		if ((Cliente.Apellido = ClienteAux.Apellido) and (Cliente.Nombre = ClienteAux.Nombre) and (Cliente.Codigo = ClienteAux.Codigo) and (ClienteAux.Activo = True)) then
			Flag:= True;
	end;
	Close(Client);
	Esta:= Flag;

end;


//--------------------------------------------------------------------
//ALTA

Procedure Alta(var Client: archivoClientes);
var
	Ape, Nom, Cod: String;
	Cliente: regCliente;
begin
  
	writeln('Alta: ');
	writeln('Ingrese apellido del cliente');
	readln(Ape);
	ValidarPalabra(Ape);

	writeln('Ingrese nombre del cliente');
	readln(Nom);
	ValidarPalabra(Nom);

	writeln('Ingrese codigo del cliente');
	readln(Cod);
	ValidarCodigo(Cod);

	Cliente.Apellido:= Ape;
	Cliente.Nombre:= Nom;
	Cliente.Codigo:= Cod;
	Cliente.Activo:= True;
	reset(Client);
	Seek(Client, FileSize(Client));
	write(Client, Cliente);
	WriteLn('Cliente dado de alta con exito');
	Close(Client);

end;


//--------------------------------------------------------------------
//BAJA

Procedure Baja(var Client: archivoClientes);
var	
	Cliente, ClienteAux: regCliente;
	Nom, Ape, Cod: String;
	Flag: Boolean;
begin

	Flag:= False;
	WriteLn('Ingrese los datos del cliente');
	WriteLn('Apellido: ');
	ReadLn(Ape);
	ValidarPalabra(Ape);
	WriteLn('Nombre: ');
	readln(Nom);
	ValidarPalabra(Nom);
	WriteLn('Codigo: ');
	ReadLn(Cod);
	ValidarCodigo(Cod);
	Cliente.Apellido:= Ape;
	Cliente.Nombre:= Nom;
	Cliente.Codigo:= Cod;
	reset(Client);
	while (not EOF(Client)) do begin
	  Read(Client, ClienteAux);
	  if ((Cliente.Apellido = ClienteAux.Apellido) and (Cliente.Nombre = ClienteAux.Nombre) and (Cliente.Codigo = ClienteAux.Codigo) and (ClienteAux.Activo = True)) then begin
		ClienteAux.Activo:= False;
		Seek(Client, (FilePos(Client) - 1));
		write(Client, ClienteAux);
		Flag:= True;
	  end;
	end;
	Close(Client);
	if (Flag = True) then begin
	  writeln('Cliente dado de baja con exito');
	end else 
		WriteLn('El cliente indicado no fue encontrado');

end;


//--------------------------------------------------------------------
//MODIFICACION

Function ValidarOpcionMod(Op: String): Boolean;
var
	i, codigoDeError: integer;
begin

	ValidarOpcionMod:= False;
	i:= 0;
	val(Op, i, codigoDeError);
	if (codigoDeError = 0) then begin
		if ((i >= 0) and (i <= 3)) then
	  		ValidarOpcionMod:= True;
	end;

end;

Procedure Modificacion(var Client: archivoClientes);
var	
	Cliente, ClienteAux: regCliente;
	seguir: Boolean;
	OpcAux: String;
	Opc: Integer;
	Nom, Ape, Cod: String;
	a: char;
	Pos: Integer;
	bandera: Boolean;
begin
  
	seguir:= True;
	bandera:= False;
	WriteLn('Ingrese los datos del cliente');
	WriteLn('Apellido: ');
	ReadLn(Ape);
	ValidarPalabra(Ape);
	WriteLn('Nombre: ');
	readln(Nom);
	ValidarPalabra(Nom);
	WriteLn('Codigo: ');
	ReadLn(Cod);
	ValidarCodigo(Cod);
	Cliente.Apellido:= Ape;
	Cliente.Nombre:= Nom;
	Cliente.Codigo:= Cod;
	if (esta(Client, Cliente) = True) then begin
		while (seguir = true) do begin
	 		writeln('Indique lo que desea modificar');
	  		writeln('1: Apellido');
	  		writeln('2: Nombre');
	  		writeln('3: Codigo');
	  		writeln('0: Salir');
	  		ReadLn(OpcAux);
	  	if (ValidarOpcionMod(OpcAux) = True) then begin
			Opc:= ValorEntero(OpcAux);
			case (Opc) of
				1:begin
			 		writeln('Ingrese el nuevo apellido');
			  		readln(Ape);
			  		ValidarPalabra(Ape);
				end;  
				2:begin
			  		writeln('Ingrese el nuevo nombre');
			  		readln(Nom);
			  		ValidarPalabra(Nom);
				end;
				3:begin
			  		writeln('Ingrese nuevo codigo');
			  		readln(Cod);
			  		ValidarCodigo(Cod);
				end;
				0:begin
			  		clrscr;
			  		seguir:= False;
			  		writeln('Saliendo del menu de modificacion');
				end;
			end;
			if (Opc <> 0) then begin
				writeln('Presiones una tecla para continuar');
				a:= readkey;
				clrscr;
	  		end;
	  	end else begin
			clrscr;
			writeln('Error, ', OpcAux, ' no es un dato permitido, por favor ingrese un numero que corresponda a las opcines en pantalla');
	  		end;
		end;

		reset(Client);
		while (not EOF(Client)) do begin
		  read(Client, ClienteAux);
		  if ((Cliente.Apellido = ClienteAux.Apellido) and (Cliente.Nombre = ClienteAux.Nombre) and (Cliente.Codigo = ClienteAux.Codigo) and (ClienteAux.Activo = True)) then begin
			ClienteAux.Apellido:= Ape;
			ClienteAux.Nombre:= Nom;
			ClienteAux.Codigo:= Cod;
			Seek(Client, (FilePos(Client) - 1));
			Write(Client, ClienteAux);
		  end;
		end;
		Close(Client);
	end else 
		WriteLn('No se encontro al cliente dado');

end;


//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
var
	Clientes: archivoClientes;
	Opcion: Integer;
	Sigo: Boolean;
	OpcionAux: String;
	c: char;
BEGIN 

	Sigo:= True;
	assign(Clientes, 'clientes.dat');
	if (not fileexists('clientes.dat')) then begin
	  writeln('El archivo no existe, se procede a crear uno');
	  rewrite(Clientes);
	end; 
	while (Sigo = True) do begin
	  writeln('1 Alta');
	  writeln('2 Baja');
	  writeln('3 Modificacion');
	  writeln('4 Mostrar datos');
	  writeln('0 Salir');
	  readln(OpcionAux);
	  if (ValidarOpcion(OpcionAux) = True) then begin
	  	Opcion:= ValorEntero(OpcionAux);
	  	case (Opcion) of
				1:begin
			  		clrscr;
			  		Alta(Clientes);
				end;

				2:begin
			  		clrscr;
			  		Baja(Clientes);
				end;

				3:begin
			  		clrscr;
			 	 	Modificacion(Clientes);
				end;

				4:begin
			  		clrscr;
			  		MostrarDatos(Clientes);
				end;

				0:begin
			  		clrscr;
			  		Sigo:= False;
			  		writeln('Fin del programa');
				end;
	  	end;
	  	if (Opcion <> 0) then begin
			writeln('Presiones una tecla para continuar');
			c:= readkey;
			clrscr;
	  	end;

	   end else begin
	   		clrscr;
		 	writeln('Error, ', OpcionAux, ' no es un dato permitido, por favor ingrese un numero que corresponda a las opcines en pantalla');
	   end;
	end;

END.
