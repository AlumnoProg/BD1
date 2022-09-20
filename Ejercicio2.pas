Program Ejercicio2; //Hashing con desplazamiento interno mediante listas enlazadas. Solo se hacen bajas logicas

uses crt, sysUtils;

const   
    PATH = '.\clientes.dat';
    MIN_ZO = 700; 
    N_PRIMO = 691;
    MAX_REGISTROS = 800; 
    //Tabla Hash: 0-699
    //Zona de OverFlow: 700-800

Type 
    Cliente = Record
        Codigo: integer;
        Nombre: String[50];
        Apellido: String[50];
        ACTIVO: Boolean;
        Ocupado: Boolean;
        Siguiente: integer; //posicion en el registro de la colision en caso de tener
    end;
    ArchivoCliente = File of Cliente;

var
    opcion,Codigo: integer;
    A: ArchivoCliente;
    RegistroCliente: Cliente;
    Aux: string;

//---------------------------METODOS---------------------------------

function funcionHashing(k:integer):integer;
begin
    funcionHashing := k mod N_PRIMO;
end;

procedure continuar();
begin
    WriteLn('');
    WriteLn('-Presione para continuar-');
    readln();
end;

function codigoValido(Codigo:string):boolean;
var
    C: Char;
    B: Boolean;
begin
    for C in Codigo do begin
        B := C in ['0'..'9'];
        if not B then 
            Break;
    end;
    codigoValido := B;
end;

function proximaPosicionLibreZO(): integer;
var
    PosZO:integer;
    Reg:Cliente;
begin
    seek(A,MIN_ZO);  
    PosZO := MIN_ZO; 
    repeat begin
        Read(A,Reg);  
        inc(PosZO);
    end;
    until (not Reg.Ocupado);
    PosZO := PosZO - 1;
    proximaPosicionLibreZO := PosZO;
end;

function ingresarDatos(Codigo:Integer): Cliente;
var 
    RC: Cliente;
begin
    Write('Nombre: ');
    Readln(RC.Nombre);
    Write('Apellido: ');
    ReadLn(RC.Apellido);
    RC.Codigo := Codigo;
    while (RC.Codigo <= 0) or (RC.Codigo > 9999) do begin //validacion maximo 4 digitos
        WriteLn('-Ingrese un codigo valido-');
        Write('Codigo de cliente: ');
        ReadLn(RC.Codigo);
    end;
    RC.ACTIVO := False;
    RC.Ocupado := False;
    RC.Siguiente := -1;
    ingresarDatos := RC;
end;

procedure inicializarArchivo();
var 
    i:integer;
    C: Cliente;
begin
  if not FileExists(PATH) then begin
    Rewrite(A);
    C.Codigo := -1;
    C.Nombre := '';
    C.Apellido := '';
    C.ACTIVO := False;
    C.Ocupado := False;
    C.Siguiente := -1;
    for i := 1 to MAX_REGISTROS do 
        Write(A,C);
    Close(A);
  end;
end;

function existeCodigo(Codigo:integer):boolean;
var
    RegDeArchivo:Cliente;
    valido: Boolean;
begin
    valido := false;
    Reset(A);
    Seek(A,funcionHashing(Codigo));
    Read(A,RegDeArchivo);
    if RegDeArchivo.Codigo = Codigo then 
        valido := true
    else begin
        while (RegDeArchivo.Siguiente <> -1) do begin
            seek(A,RegDeArchivo.Siguiente);
            Read(A,RegDeArchivo);
            if RegDeArchivo.Codigo = Codigo then
                valido := true;
        end;
    end;
    Close(A);
    existeCodigo := valido;
end;

procedure mostrarArchivo();
var
    C:Cliente;
    NReg:integer;
    vacio:boolean;
begin
    NReg := 0;
    vacio := true;
    Reset(A);
    while not EOF(A) do begin
        read(A,C);
        if C.Ocupado then begin
            vacio := false;
            writeln('- - - - - - - - - - - - - - - - - - - - - - -');
            writeln('PosicionRegistro: ' + NReg.ToString);
            Writeln('Nombre: ' + C.Nombre);
            WriteLn('Apellido: ' + C.Apellido);
            Writeln('CodigoCliente: ' + C.Codigo.ToString);
            if C.ACTIVO then //temporal
                WriteLn('Activo?: SI') 
            else
                WriteLn('Activo?: NO');
            if C.Siguiente = -1 then
                WriteLn('Posicion Siguiente (Colision): NA')
            else
                WriteLn('Posicion Siguiente (Colision): ' + C.Siguiente.ToString);
            if NReg >= MIN_ZO then
                WriteLn('-EN LA ZONA DE OVERFLOW-');
            continuar();
        end;
        inc(NReg);
    end;
    if vacio then
        WriteLn('El archivo se encuentra vacio');
    Close(A);
end;

procedure alta(C:Cliente);
var 
    PosReg, PosZO: integer;
    RegDeArchivo: Cliente;
    Existe:Boolean;
begin
    Existe := existeCodigo(C.Codigo);
    Reset(A);
    PosReg := funcionHashing(C.Codigo);
    seek(A,PosReg);
    Read(A,RegDeArchivo);
    if not Existe then begin  // Agregar un nuevo registro 
        if (not RegDeArchivo.Ocupado) then begin //si no esta ocupada en la tabla Hash, agregarla
            seek(A,PosReg);
            C.ACTIVO := True;
            C.Ocupado := True;
            Write(A,C);      
            WriteLn('Registro guardado en la posicion: ' + PosReg.ToString);
        end 
        else if (RegDeArchivo.Siguiente = -1) then begin // ocupada sin colisiones, agregar en ZO
            PosZO := proximaPosicionLibreZO();
            seek(A,PosZO);
            C.ACTIVO := True;
            C.Ocupado := True;
            Write(A,C);
            //Colocar la direccion de la primera colision
            seek(A,PosReg);
            Read(A,C);
            C.Siguiente := PosZO;
            seek(A,PosReg);
            Write(A,C);
            WriteLn('Colision detectada. Se guardara en la Zona de OverFlow');
        end
        else begin //si ya tiene colisiones, agregarla al final de estas
            //meto el registro
            PosZO := proximaPosicionLibreZO();
            seek(A,PosZO);
            C.ACTIVO := True;
            C.Ocupado := True;
            Write(A,C);
            //busco la colision anterior para guardarle la posicion de la actual colision
            seek(A,PosReg);
            Read(A,RegDeArchivo);
            while (RegDeArchivo.Siguiente <> -1) do begin
                seek(A,RegDeArchivo.Siguiente);
                Read(A,RegDeArchivo); 
            end;
            seek(A,FilePos(A) - 1);
            RegDeArchivo.Siguiente := PosZO;
            Write(A,RegDeArchivo);
            WriteLn('Multiples colisiones detectadas. Se guardara en la Zona de OverFlow');
        end;
    end

    else begin // si ya existe buscar el registro y darlo de alta
        if RegDeArchivo.Codigo = C.Codigo then begin //posicion original
            RegDeArchivo.ACTIVO := True;
            Seek(A,PosReg);
            Write(A,RegDeArchivo);
        end else begin
            while RegDeArchivo.Siguiente <> -1 do begin //busca en las colisiones
                Seek(A,RegDeArchivo.Siguiente);
                Read(A,RegDeArchivo);
                if RegDeArchivo.Codigo = C.Codigo then begin
                    RegDeArchivo.ACTIVO := True;
                    Seek(A,RegDeArchivo.Siguiente);
                    Write(A,RegDeArchivo);
                    Break;
                end;
            end; 
        end;
    end;
    Close(A);   
end;

procedure baja(Codigo:integer);
var
    PosReg: integer;
    RegDeArchivo: Cliente;
begin
    Reset(A);
    PosReg := funcionHashing(Codigo);
    Seek(A,PosReg);
    Read(A,RegDeArchivo);
    if RegDeArchivo.Codigo = Codigo then begin //posicion original
        RegDeArchivo.ACTIVO := False;
        Seek(A,PosReg);
        Write(A,RegDeArchivo);
    end else begin
        while RegDeArchivo.Siguiente <> -1 do begin //busca en las colisiones
            Seek(A,RegDeArchivo.Siguiente);
            Read(A,RegDeArchivo);
            if RegDeArchivo.Codigo = Codigo then begin
                RegDeArchivo.ACTIVO := False;
                Seek(A,RegDeArchivo.Siguiente);
                Write(A,RegDeArchivo);
                Break;
            end; 
        end;
    end;
    Close(A);
    WriteLn('Se dio de baja el siguiente registro: ');
    Writeln('Nombre: ' + RegDeArchivo.Nombre);
    WriteLn('Apellido: ' + RegDeArchivo.Apellido);
    Writeln('CodigoCliente: ' + RegDeArchivo.Codigo.ToString);
end;

procedure modificacion(C:Cliente);
var
    PosReg: integer;
    RegDeArchivo: Cliente;
begin
    Reset(A);
    PosReg := funcionHashing(C.Codigo);
    Seek(A,PosReg);
    Read(A,RegDeArchivo);
    if RegDeArchivo.Codigo = C.Codigo then begin
        RegDeArchivo.Nombre := C.Nombre;
        RegDeArchivo.Apellido := C.Apellido;
        Seek(A,PosReg);
        Write(A,RegDeArchivo);
    end else begin
        while RegDeArchivo.Siguiente <> -1 do begin
            Seek(A,RegDeArchivo.Siguiente);
            Read(A,RegDeArchivo);
            if RegDeArchivo.Codigo = C.Codigo then begin
                RegDeArchivo.Nombre := C.Nombre;
                RegDeArchivo.Apellido := C.Apellido;
                Seek(A,RegDeArchivo.Siguiente);
                Write(A,RegDeArchivo);
                Break;
            end;
        end;
    end;
    Close(A);
    WriteLn('Registro modificado con exito');
end;



//-----------------------PROGRAMA PRINCIPAL--------------------------

BEGIN

    Assign(A,PATH);
    inicializarArchivo();
    Opcion := -1;
    while (Opcion <> 0) do begin
        clrscr;
        WriteLn('-------------------------ABM---------------------------');
        WriteLn('');
        WriteLn('1. Dar de alta un cliente'); 
        WriteLn('2. Dar de baja un cliente');
        WriteLn('3. Modificar un cliente');
        WriteLn('4. Mostrar archivo');
        WriteLn('0. Salir');
        WriteLn('');
        Write('Ingrese una opcion: ');
        Readln(Opcion);
        WriteLn('');

        case Opcion of
            1: begin
                Write('Ingrese el codigo a dar de alta: ');
                ReadLn(Aux); 
                while (Aux = '') or (not codigoValido(Aux)) do begin
                    writeln('Ingrese un codigo valido');
                    ReadLn(Aux); 
                end;
                RegistroCliente.Codigo := StrToInt(Aux);
                if not existeCodigo(RegistroCliente.Codigo) then begin
                    RegistroCliente := ingresarDatos(RegistroCliente.Codigo);
                    alta(RegistroCliente);
                    continuar()
                end
                else begin
                    WriteLn('El codigo ingresado existe. Dando de alta...');
                    alta(RegistroCliente); 
                    continuar();    
                end;
            end;
            2: begin
                write('Ingrese el codigo a dar de baja: ');   
                ReadLn(Aux); 
                while (Aux = '') or (not codigoValido(Aux)) do begin
                    writeln('Ingrese un codigo valido');
                    ReadLn(Aux); 
                end;
                Codigo := StrToInt(Aux);
                if existeCodigo(Codigo) then
                    baja(Codigo)
                else
                    WriteLn('El codigo ingresado no se encuentra en el archivo');
                continuar();
            end;
            3: begin
                Write('Ingrese el codigo a modificar: ');
                ReadLn(Aux); 
                while (Aux = '') or (not codigoValido(Aux)) do begin
                    writeln('Ingrese un codigo valido');
                    ReadLn(Aux); 
                end;
                RegistroCliente.Codigo := StrToInt(Aux);
                if existeCodigo(RegistroCliente.Codigo) then begin
                    WriteLn('Ingrese los nuevos datos');
                    Write('Nombre: ');
                    ReadLn(RegistroCliente.Nombre);
                    Write('Apellido: ');
                    ReadLn(RegistroCliente.Apellido);
                    modificacion(RegistroCliente);
                end else
                    WriteLn('El codigo ingresado no se encuentra en el archivo');
                continuar();         
            end;
            4: begin
                mostrarArchivo(); 
                continuar();   
            end;
            0: begin
                writeln('Saliendo...');
                Sleep(1000);
            end;  
        end;
    end;

END.
