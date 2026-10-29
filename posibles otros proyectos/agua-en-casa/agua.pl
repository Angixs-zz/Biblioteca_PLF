:- encoding(utf8).
:- module(agua, [menu/0, consumo/4, escenario/6, ahorro/4, mayor_consumo/2]).
:- use_module(library(readutil)).
:- use_module(library(lists)).
:- use_module(library(apply)).

% Datos de demostracion inventados, no promedios oficiales.
% actividad(Nombre, LitrosPorMinuto, MinutosPorUso, UsosPorDia).
actividad(ducha, 8, 10, 1).
actividad(lavado_trastes, 5, 12, 1).
actividad(lavado_manos, 3, 1, 8).

no_negativo(N) :- number(N), N >= 0.
consumo(Caudal, Minutos, Usos, Litros) :-
    maplist(no_negativo, [Caudal, Minutos, Usos]),
    Litros is Caudal * Minutos * Usos.
escenario(Caudal, MinutosAntes, MinutosDespues, Usos, Dias, Antes-Despues) :-
    no_negativo(Dias),
    consumo(Caudal, MinutosAntes, Usos, DiarioAntes),
    consumo(Caudal, MinutosDespues, Usos, DiarioDespues),
    Antes is DiarioAntes * Dias, Despues is DiarioDespues * Dias.
ahorro(Antes, Despues, Litros, Porcentaje) :-
    no_negativo(Antes), no_negativo(Despues),
    Litros is Antes - Despues,
    (Antes =:= 0 -> Porcentaje = sin_base ; Porcentaje is Litros * 100 / Antes).
mayor_consumo(Pares, Nombre-Litros) :-
    Pares = [_|_],
    findall(L-N, (member(N-L, Pares), no_negativo(L)), Ordenables),
    length(Pares, Largo), length(Ordenables, Largo),
    sort(Ordenables, Ordenados), last(Ordenados, Litros-Nombre).

numero(Texto, N) :-
    repeat, format('~w ', [Texto]), read_line_to_string(user_input, S),
    (S == end_of_file -> throw(fin)
    ; catch(number_string(V, S), _, fail), no_negativo(V) -> N = V, !
    ; writeln('Escribe un numero igual o mayor a cero.'), fail).
resumen(Antes, Despues) :-
    ahorro(Antes, Despues, Diferencia, P),
    format('Antes: ~2f L. Despues: ~2f L.~nDiferencia (positiva = ahorro): ~2f L.~n',
           [Antes, Despues, Diferencia]),
    (P == sin_base -> writeln('Sin consumo inicial: no hay porcentaje comparable.')
    ; format('Cambio respecto al inicial: ~2f %.~n', [P])).
accion(1) :-
    numero('Caudal medido (litros por minuto):', C),
    numero('Minutos por uso actuales:', A), numero('Minutos por uso propuestos:', D),
    numero('Usos por dia (total de la vivienda):', U), numero('Dias a comparar:', Dias),
    escenario(C, A, D, U, Dias, Antes-Despues), resumen(Antes, Despues).
accion(2) :-
    writeln('Demostracion ficticia: ducha de 8 L/min, 10 a 6 minutos, un uso al dia, 30 dias.'),
    escenario(8, 10, 6, 1, 30, A-D), resumen(A, D),
    findall(N-L, (actividad(N,C,M,U), consumo(C,M,U,L)), Pares),
    mayor_consumo(Pares, Mayor), format('Mayor consumo diario del ejemplo: ~w.~n', [Mayor]).
accion(3) :-
    writeln('Mide el caudal: litros recogidos / minutos medidos.'),
    writeln('Se compara solo la actividad introducida, manteniendo caudal y usos.'),
    writeln('No estima el recibo ni el consumo total de la vivienda.'),
    writeln('Los valores de demostracion son ficticios. No se guardan tus entradas.').
menu :- catch(bucle, fin, true).
bucle :-
    writeln('=== AGUA EN CASA ==='),
    writeln('1. Comparar mi rutina  2. Demostracion  3. Ayuda  0. Salir'),
    numero('Opcion:', O),
    (O =:= 0 -> true
    ; integer(O), between(1,3,O) -> accion(O), bucle
    ; writeln('Opcion invalida.'), bucle).
