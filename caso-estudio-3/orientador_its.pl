:- encoding(utf8).
:- use_module(library(readutil)).
:- use_module(library(lists)).

% Caso de estudio 3: orientador de puntos de deteccion de ITS en Oaxaca.
% Corte documental: 29 de octubre de 2026. Los horarios no son datos en vivo.
% Cargar con: swipl -s orientador_its.pl -g menu -t halt

% sede(Id, Nombre, Municipio, Direccion).
sede(huajuapan, 'Modulo COESIDA Huajuapan', huajuapan,
     'Fray Bartolome de las Casas 2, frente al Parque Bicentenario').
sede(tlalixtac, 'Centro Mujer Tu Espacio', tlalixtac,
     'Ciudad Administrativa, edificio 1, piso 3, carretera Oaxaca-Istmo km 11.5').
sede(imedi, 'Punto de deteccion IMEDI', oaxaca_de_juarez,
     'Blvd. Eduardo Vasconcelos 517, barrio de Jalatlaco').
sede(capasits, 'COESIDA-CAPASITS', san_bartolo_coyotepec,
     'Septima Privada de Aldama Sur s/n, Centro').

% deteccion(IdSede, Prueba). Solo pruebas atribuidas a cada sede por la fuente.
deteccion(huajuapan, vih).
deteccion(huajuapan, sifilis).
deteccion(huajuapan, hepatitis_c).
deteccion(tlalixtac, vih).
deteccion(tlalixtac, sifilis).
deteccion(tlalixtac, hepatitis_c).
deteccion(imedi, vih).
deteccion(imedi, sifilis).
deteccion(imedi, hepatitis_c).
deteccion(capasits, vih).
deteccion(capasits, sifilis).
deteccion(capasits, hepatitis_c).

% horario_publicado/4: antecedente documental, NO disponibilidad en tiempo real.
horario_publicado(huajuapan, lunes, '08:00', '16:00').
horario_publicado(huajuapan, martes, '08:00', '16:00').
horario_publicado(huajuapan, miercoles, '08:00', '16:00').
horario_publicado(huajuapan, jueves, '08:00', '16:00').
horario_publicado(huajuapan, viernes, '08:00', '16:00').
horario_publicado(huajuapan, sabado, '09:00', '14:00').
horario_publicado(tlalixtac, martes, '10:00', '14:00').
horario_publicado(tlalixtac, jueves, '10:00', '14:00').

% Los otros horarios no se afirman: pueden consultarse por telefono.
contacto(huajuapan, '951 502 2200 (COESIDA, consultar el modulo)').
contacto(tlalixtac, '951 501 5000 ext. 10898').
contacto(imedi, '951 502 2200 (COESIDA, consultar IMEDI)').
contacto(capasits, '951 502 2200 ext. 112 (departamento medico)').

fuente(huajuapan, 'https://www.oaxaca.gob.mx/comunicacion/inaugura-coesida-modulo-para-deteccion-de-infecciones-de-transmision-sexual-en-huajuapan-de-leon/').
fuente(tlalixtac, 'https://www.oaxaca.gob.mx/administracion/punto-de-deteccion-de-vih-hepatitis-c-y-sifilis/').
fuente(imedi, 'https://www.oaxaca.gob.mx/comunicacion/abre-coesida-capasits-noveno-punto-de-deteccion-permanente-en-instalaciones-de-imedi-oaxaca/').
fuente(capasits, 'https://www.oaxaca.gob.mx/comunicacion/inaugura-coesida-capasits-nuevo-punto-para-la-deteccion-de-vih-sifilis-y-hepatitis-c-en-la-mixteca/').

% Reglas: se relacionan sede, prueba y horario mediante el mismo Id.
ofrece_en(Id, Municipio, Prueba) :-
    sede(Id, _, Municipio, _), deteccion(Id, Prueba).

opcion_con_horario(Id, Municipio, Prueba, Dia, Inicio, Fin) :-
    ofrece_en(Id, Municipio, Prueba),
    horario_publicado(Id, Dia, Inicio, Fin).

opcion_sin_horario_confirmado(Id, Municipio, Prueba, Dia) :-
    dia(Dia), ofrece_en(Id, Municipio, Prueba),
    \+ horario_publicado(Id, Dia, _, _).

% Ausencia de horario significa "desconocido", no "cerrado".
estado_horario(Id, Dia, publicado(Inicio, Fin)) :-
    horario_publicado(Id, Dia, Inicio, Fin).
estado_horario(Id, Dia, por_confirmar) :-
    sede(Id, _, _, _), dia(Dia),
    \+ horario_publicado(Id, Dia, _, _).

dia(lunes). dia(martes). dia(miercoles). dia(jueves).
dia(viernes). dia(sabado). dia(domingo).

municipio(huajuapan, 'Heroica Ciudad de Huajuapan de Leon').
municipio(tlalixtac, 'Tlalixtac de Cabrera').
municipio(oaxaca_de_juarez, 'Oaxaca de Juarez').
municipio(san_bartolo_coyotepec, 'San Bartolo Coyotepec').

mostrar_sede(Id) :-
    sede(Id, Nombre, Municipio, Direccion), municipio(Municipio, MunicipioTexto),
    contacto(Id, Telefono), fuente(Id, Url),
    format('~n~w (~w)~n  Direccion: ~w~n  Confirmar: ~w~n  Fuente: ~w~n',
           [Nombre, MunicipioTexto, Direccion, Telefono, Url]).

mostrar_resultados(Municipio, Prueba, Dia) :-
    findall(Id-Inicio-Fin,
            opcion_con_horario(Id, Municipio, Prueba, Dia, Inicio, Fin), Publicados),
    findall(Id,
            opcion_sin_horario_confirmado(Id, Municipio, Prueba, Dia), Pendientes),
    ( Publicados = [], Pendientes = [] ->
        writeln('No hay una sede documentada para esta combinacion en el catalogo.')
    ; writeln('Horario publicado para ese dia (confirmar antes de salir):'),
      forall(member(Id-Inicio-Fin, Publicados),
             (mostrar_sede(Id), format('  Horario publicado: ~w-~w~n', [Inicio, Fin]))),
      writeln('Sedes con horario de deteccion sin confirmar para ese dia:'),
      forall(member(Id, Pendientes),
             (mostrar_sede(Id), writeln('  No se puede afirmar que atienda ese dia.')))
    ).

leer_numero(Pregunta, Min, Max, Numero) :-
    repeat,
    format('~w ', [Pregunta]),
    read_line_to_string(user_input, Entrada),
    ( Entrada == end_of_file -> Numero = 0, !
    ; normalize_space(string(Limpia), Entrada),
      catch(number_string(N, Limpia), _, fail), integer(N), between(Min, Max, N) ->
        Numero = N, !
    ; writeln('Opcion invalida; escribe un numero del menu.'), fail
    ).

elegir_municipio(M) :-
    writeln('1. Huajuapan  2. Tlalixtac  3. Oaxaca de Juarez  4. San Bartolo Coyotepec'),
    leer_numero('Municipio (1-4):', 1, 4, N),
    nth1(N, [huajuapan, tlalixtac, oaxaca_de_juarez, san_bartolo_coyotepec], M).

elegir_prueba(P) :-
    writeln('1. VIH  2. Sifilis  3. Hepatitis C'),
    leer_numero('Prueba (1-3):', 1, 3, N),
    nth1(N, [vih, sifilis, hepatitis_c], P).

elegir_dia(D) :-
    writeln('1. Lunes  2. Martes  3. Miercoles  4. Jueves  5. Viernes  6. Sabado  7. Domingo'),
    leer_numero('Dia (1-7):', 1, 7, N),
    nth1(N, [lunes, martes, miercoles, jueves, viernes, sabado, domingo], D).

accion(1) :- elegir_municipio(M), elegir_prueba(P), elegir_dia(D),
             mostrar_resultados(M, P, D).
accion(2) :- elegir_prueba(P),
             forall((sede(Id, _, _, _), deteccion(Id, P)), mostrar_sede(Id)).
accion(3) :- elegir_municipio(M),
             forall(sede(Id, _, M, _), mostrar_sede(Id)).
accion(4) :-
    writeln('Consultas: ofrece_en(Id, Municipio, Prueba).'),
    writeln('opcion_con_horario(Id, Municipio, Prueba, Dia, Inicio, Fin).'),
    writeln('estado_horario(Id, Dia, Estado).'),
    writeln('Fuentes oficiales consultadas al 29/10/2026; disponibilidad por confirmar.'),
    writeln('No registra nombres, sintomas ni resultados de usuarios.'),
    writeln('Para urgencias o consejo clinico, acude a personal de salud.').

menu :-
    repeat,
    nl, writeln('=== Orientador de puntos de deteccion de ITS en Oaxaca ==='),
    writeln('1. Buscar por municipio, prueba y dia'),
    writeln('2. Ver sedes por prueba'),
    writeln('3. Ver sedes por municipio'),
    writeln('4. Ayuda y alcance'),
    writeln('0. Salir'),
    leer_numero('Elige (0-4):', 0, 4, Opcion),
    ( Opcion =:= 0 -> !
    ; accion(Opcion), fail
    ).
