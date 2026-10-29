:- use_module(library(plunit)).
:- use_module(library(debug)).
:- use_module(library(lists)).
:- encoding(utf8).
:- consult('orientador_its.pl').
:- use_module(library(plunit)).

:- begin_tests(orientador_its).

test(busqueda_con_dia_publicado, [nondet]) :-
    opcion_con_horario(huajuapan, huajuapan, sifilis, sabado, '09:00', '14:00').

test(dia_sin_horario_no_es_cierre, [nondet]) :-
    estado_horario(imedi, martes, por_confirmar),
    opcion_sin_horario_confirmado(imedi, oaxaca_de_juarez, vih, martes).

test(no_inventar_horario, [fail]) :-
    opcion_con_horario(imedi, oaxaca_de_juarez, vih, martes, _, _).

test(no_hay_horario_sabado_tlalixtac, [fail]) :-
    opcion_con_horario(tlalixtac, tlalixtac, vih, sabado, _, _).

test(no_inventar_servicio, [fail]) :-
    ofrece_en(_, huajuapan, clamidia).

test(sedes_con_fuente_y_contacto) :-
    forall(sede(Id, _, _, _), (fuente(Id, _), contacto(Id, _))).

test(solo_horarios_para_sedes_existentes) :-
    forall(horario_publicado(Id, Dia, _, _), (sede(Id, _, _, _), dia(Dia))).

test(consultas_enumeran_todos_los_horarios) :-
    findall(Id-Dia, estado_horario(Id, Dia, publicado(_, _)), Lista),
    length(Lista, 8).

test(estado_no_es_ambiguo) :-
    findall(E, estado_horario(tlalixtac, martes, E), Estados),
    assertion(Estados == [publicado('10:00', '14:00')]).

:- end_tests(orientador_its).
