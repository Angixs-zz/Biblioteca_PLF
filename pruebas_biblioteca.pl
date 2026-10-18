/* Pruebas reproducibles: swipl -q -s pruebas_biblioteca.pl -g run_tests -t halt */
:- encoding(utf8).
:- consult('biblioteca.pl').
:- use_module(library(plunit)).
:- use_module(library(aggregate)).

:- begin_tests(biblioteca).

test(catalogo_ampliado) :-
    aggregate_all(count, libro(_, _, _, _, _, _, _), 112).

test(catalogo_integro) :-
    validar_catalogo([]).

test(todas_las_novelas_tienen_justificacion) :-
    forall(libro(Id, _, novela, _, _, _, _),
           (justificacion_dificultad(Id, Explicacion), atom(Explicacion))),
    aggregate_all(count, justificacion_dificultad(_, _), 18).

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

test(nuevos_generos_y_temas, [nondet]) :-
    temas_disponibles(cuento, Temas),
    memberchk(naturaleza, Temas),
    memberchk(fantasia, Temas),
    coincidencia_total(pref(amor, poesia, intermedio, cualquiera), 104),
    coincidencia_total(pref(filosofia, teatro, avanzado, cualquiera), 107).

test(frase_ciencia_ficcion, [nondet]) :-
    analizar_frase("Quiero novelas de ciencia ficción", Perfil),
    Perfil = pref(ciencia_ficcion, novela, cualquiera, cualquiera),
    recomendaciones(Perfil, Resultados),
    findall(Id, member(recomendacion(Id, _, _, _, _), Resultados), [111,112]).

test(cada_libro_tiene_fuente) :-
    source_file(user:libro(_,_,_,_,_,_,_), Archivo),
    file_directory_name(Archivo, Carpeta),
    directory_file_path(Carpeta, 'fuentes_editoriales.md', Fuentes),
    read_file_to_string(Fuentes, Texto, []),
    split_string(Texto, "\n", "", Lineas),
    forall(libro(Id, _, _, _, _, _, Editorial),
           (Editorial \== pendiente_de_verificar,
            format(string(Prefijo), '| ~d | ', [Id]),
            findall(Linea, (member(Linea, Lineas), sub_string(Linea, 0, _, _, Prefijo)), [_]))).

% Ejercita el dialogo real con entrada controlada, sin depender de internet.
salida_busqueda(Entrada, Perfil, Salida) :-
    recomendaciones(Perfil, Resultados),
    setup_call_cleanup(open_string(Entrada, In),
        with_output_to(string(Salida),
            con_entrada(In, mostrar(Perfil, Resultados))),
        close(In)).

con_entrada(In, Meta) :-
    stream_property(Anterior, alias(user_input)),
    current_output(Out),
    stream_property(Err, alias(user_error)),
    setup_call_cleanup(set_prolog_IO(In, Out, Err), Meta,
                       set_prolog_IO(Anterior, Out, Err)).

test(salir_oculta_alternativas, [nondet]) :-
    salida_busqueda("0\n", pref(guerra, novela, basico, cualquiera), Salida),
    sub_string(Salida, _, _, _, '=== Coincidencias exactas ==='),
    sub_string(Salida, _, _, _, 'La guerra que salvo mi vida'),
    \+ sub_string(Salida, _, _, _, '=== Posibles recomendaciones'),
    \+ sub_string(Salida, _, _, _, 'Sin novedad en el frente').

test(mostrar_alternativas_solo_al_aceptar, [nondet]) :-
    salida_busqueda("1\n", pref(guerra, novela, basico, cualquiera), Salida),
    sub_string(Salida, InicioExactas, _, _, '=== Coincidencias exactas ==='),
    sub_string(Salida, InicioPosibles, _, _, '=== Posibles recomendaciones'),
    InicioExactas < InicioPosibles,
    sub_string(Salida, _, _, _, 'Sin novedad en el frente'),
    sub_string(Salida, _, _, _, 'difiere en: nivel intermedio').

test(sin_exactas_tambien_pide_permiso, [nondet]) :-
    salida_busqueda("0\n", pref(guerra, novela, avanzado, cualquiera), Salida),
    sub_string(Salida, _, _, _, 'No hay coincidencias exactas'),
    sub_string(Salida, _, _, _, 'Elige una opcion'),
    \+ sub_string(Salida, _, _, _, '=== Posibles recomendaciones').

test(solo_exactas_no_pregunta_por_alternativas, [nondet]) :-
    salida_busqueda("", pref(guerra, novela, cualquiera, cualquiera), Salida),
    \+ sub_string(Salida, _, _, _, 'Elige una opcion'),
    sub_string(Salida, _, _, _, 'No hay coincidencias posibles adicionales').

test(eof_cancela_alternativas) :-
    salida_busqueda("", pref(guerra, novela, basico, cualquiera), Salida),
    \+ sub_string(Salida, _, _, _, '=== Posibles recomendaciones').

test(reintenta_respuesta_invalida, [nondet]) :-
    salida_busqueda("otra\n1\n", pref(guerra, novela, basico, cualquiera), Salida),
    sub_string(Salida, _, _, _, 'Valor no valido'),
    sub_string(Salida, _, _, _, '=== Posibles recomendaciones').

test(sin_resultados_no_pregunta_por_alternativas, [nondet]) :-
    salida_busqueda("", pref(matematicas, novela, cualquiera, cualquiera), Salida),
    sub_string(Salida, _, _, _, 'No hay libros con esa combinacion'),
    \+ sub_string(Salida, _, _, _, 'Elige una opcion').

:- end_tests(biblioteca).
