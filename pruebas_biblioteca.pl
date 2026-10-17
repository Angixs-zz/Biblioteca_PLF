/* Pruebas reproducibles: swipl -q -s pruebas_biblioteca.pl -g run_tests -t halt */
:- encoding(utf8).
:- consult('biblioteca.pl').
:- use_module(library(plunit)).
:- use_module(library(aggregate)).

:- begin_tests(biblioteca).

test(exactamente_cien_libros) :-
    aggregate_all(count, libro(_, _, _, _, _, _, _), 100).

test(catalogo_integro) :-
    validar_catalogo([]).

test(todas_las_novelas_tienen_justificacion) :-
    forall(libro(Id, _, novela, _, _, _, _),
           justificacion_dificultad(Id, Explicacion)),
    aggregate_all(count, justificacion_dificultad(_, _), 13).

test(niveles_lectura_realistas) :-
    libro(26, _, novela, basico, _, _, _),
    libro(27, _, novela, intermedio, _, _, _),
    libro(28, _, novela, avanzado, _, _, _),
    libro(78, _, novela, intermedio, _, _, _).

test(filtros_novela_no_incluyen_matematicas) :-
    temas_disponibles(novela, Temas),
    \+ memberchk(matematicas, Temas),
    memberchk(amor, Temas),
    memberchk(guerra, Temas),
    memberchk(literatura, Temas).

test(filtros_niveles_compatibles) :-
    niveles_disponibles(novela, guerra, [basico, intermedio]),
    formatos_disponibles(novela, guerra, basico, [fisico]).

test(novelas_son_literatura_incluso_si_ambientadas_en_guerra) :-
    tema_de_libro(25, literatura, 1, _),
    tema_de_libro(71, literatura, 1, _).

test(temas_secundarios_justificados) :-
    tema_de_libro(77, amor, 1, [tema_secundario(amor, Justificacion)]),
    atom(Justificacion).

test(no_se_inventan_temas_secundarios) :-
    \+ tema_de_libro(6, amor, _, _),
    \+ tema_de_libro(28, matematicas, _, _).

test(frase_guerra) :-
    analizar_frase("Quiero libros basicos digitales sobre conflictos belicos",
                   pref(guerra, cualquiera, basico, digital)).

test(frase_novela_romantica) :-
    analizar_frase("Busco novelas romanticas de nivel intermedio",
                   pref(amor, novela, intermedio, cualquiera)).

test(frase_tildes) :-
    analizar_frase("Necesito un manual avanzado de tecnología",
                   pref(tecnologia, manual, avanzado, cualquiera)).

test(frase_ambigua, [fail]) :-
    analizar_frase("Quiero historia y guerra", _).

test(frase_sin_tema, [fail]) :-
    analizar_frase("Un libro digital", _).

test(genero_incompatible, [fail]) :-
    recomendar(pref(matematicas, novela, cualquiera, cualquiera), _, _, _).

test(coincidencias_tienen_tema_y_genero) :-
    recomendaciones(pref(guerra, novela, basico, cualquiera), Resultados),
    Resultados \== [],
    forall(member(recomendacion(Id, _, _, _, _), Resultados),
           ( libro(Id, _, novela, _, _, _, _),
             tema_de_libro(Id, guerra, _, _) )).

test(historial_referenciado) :-
    detalle_recomendacion(1, 1, 1, _, _).

:- end_tests(biblioteca).
