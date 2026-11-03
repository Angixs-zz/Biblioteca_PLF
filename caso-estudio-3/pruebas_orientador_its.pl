:- use_module(library(plunit)).
:- use_module(library(debug)).
:- use_module(library(lists)).
:- use_module(library(aggregate)).
:- encoding(utf8).
:- consult('orientador_its.pl').

:- begin_tests(orientador_its_experto).

% =========================================================================
% 1. PRUEBAS DE TAMAÑO Y VOLUMEN DE LA BASE DE CONOCIMIENTOS (10 TABLAS)
%    Mínimo 50 hechos en cada una de las 10 tablas principales
% =========================================================================

test(conteo_minimo_50_registros_por_tabla) :-
    total_tabla(sede, NSedes), assertion(NSedes >= 50),
    total_tabla(municipio, NMun), assertion(NMun >= 50),
    total_tabla(region_municipio, NRegMun), assertion(NRegMun >= 50),
    total_tabla(deteccion_its, NDet), assertion(NDet >= 50),
    total_tabla(horario_semanal, NHor), assertion(NHor >= 50),
    total_tabla(contacto_directo, NCon), assertion(NCon >= 50),
    total_tabla(fuente_oficial, NFue), assertion(NFue >= 50),
    total_tabla(protocolo_sede, NProt), assertion(NProt >= 50),
    total_tabla(guia_clinica_its, NGuia), assertion(NGuia >= 50),
    total_tabla(sintoma_sindromico_its, NSint), assertion(NSint >= 50).

test(gran_total_hechos_supera_700) :-
    Tablas = [sede, municipio, region_municipio, deteccion_its,
              horario_semanal, contacto_directo, fuente_oficial,
              protocolo_sede, guia_clinica_its, sintoma_sindromico_its],
    findall(N, (member(T, Tablas), total_tabla(T, N)), Totales),
    sum_list(Totales, GranTotal),
    assertion(GranTotal >= 700).

% =========================================================================
% 2. PRUEBAS DE INTEGRIDAD REFERENCIAL ENTRE TABLAS
% =========================================================================

test(integridad_municipios_y_regiones) :-
    forall(municipio(IdM, _), region_municipio(IdM, _)),
    forall(region_municipio(IdM, Reg), (municipio(IdM, _), region(Reg, _))).

test(integridad_sedes_municipio_contacto_fuente_protocolo) :-
    forall(sede(IdS, _, Mun, _),
           ( municipio(Mun, _),
             contacto_directo(IdS, _),
             fuente_oficial(IdS, _),
             protocolo_sede(IdS, _, _, _, _)
           )).

test(integridad_horarios_y_dias) :-
    forall(horario_semanal(IdS, Dia, Ini, Fin),
           ( sede(IdS, _, _, _),
             dia(Dia),
             atom(Ini),
             atom(Fin)
           )).

test(integridad_pruebas_en_sedes) :-
    forall(deteccion_its(IdS, Prueba),
           ( sede(IdS, _, _, _),
             guia_clinica_its(Prueba, _, _, _, _)
           )).

test(integridad_sintomas_sindromicos) :-
    forall(sintoma_sindromico_its(Sint, Sind, ITS, Urg, _),
           ( atom(Sint),
             atom(Sind),
             guia_clinica_its(ITS, _, _, _, _),
             memberchk(Urg, [leve, moderada, alta, muy_alta, urgente_72h])
           )).

% =========================================================================
% 3. CASOS DE PRUEBA HISTÓRICOS DEL PROTOTIPO ORIGINAL (COMPATIBILIDAD)
% =========================================================================

test(busqueda_con_dia_publicado, [nondet]) :-
    opcion_con_horario(huajuapan, huajuapan, sifilis, sabado, '09:00', '14:00').

test(busqueda_horario_semanal_completo) :-
    with_output_to(string(Salida), mostrar_busqueda_triple(huajuapan, sifilis, todos)),
    assertion(sub_string(Salida, _, _, _, "HORARIO SEMANAL COMPLETO DE DETECCIÓN")),
    assertion(sub_string(Salida, _, _, _, "Módulo COESIDA Huajuapan")),
    assertion(sub_string(Salida, _, _, _, "Lunes: 08:00 a 16:00")).

test(dia_sin_horario_no_es_cierre, [nondet]) :-
    estado_horario(imedi, martes, por_confirmar),
    opcion_sin_horario_confirmado(imedi, oaxaca_de_juarez, vih, martes).

test(no_inventar_horario, [fail]) :-
    opcion_con_horario(imedi, oaxaca_de_juarez, vih, martes, _, _).

test(no_hay_horario_sabado_tlalixtac, [fail]) :-
    opcion_con_horario(tlalixtac, tlalixtac, vih, sabado, _, _).

test(no_inventar_servicio, [fail]) :-
    ofrece_en(_, huajuapan, clamidia).

% =========================================================================
% 4. PRUEBAS DE LA REGLA COMPLEJA 1: MOTOR SINDRÓMICO
% =========================================================================

test(diagnostico_sindromico_chancro_sifilitico) :-
    diagnostico_sindromico(ulcera_genital_indolora, Sind, ITS, Urg, _),
    assertion(Sind == ulcera_genital),
    assertion(ITS == sifilis),
    assertion(Urg == alta).

test(diagnostico_sindromico_secrecion_gonorrea) :-
    diagnostico_sindromico(secrecion_uretral_purulenta, Sind, ITS, Urg, _),
    assertion(Sind == descarga_uretral),
    assertion(ITS == gonorrea),
    assertion(Urg == alta).

test(deteccion_de_sintomas_urgentes) :-
    assertion(requiere_atencion_urgente(dolor_o_edema_testicular)),
    assertion(requiere_atencion_urgente(erupcion_cutanea_palmo_plantar)),
    assertion(requiere_atencion_urgente(ruptura_de_preservativo_reciente)),
    assertion(\+ requiere_atencion_urgente(prurito_uretral_matutino)).

% =========================================================================
% 5. PRUEBAS DE LA REGLA COMPLEJA 2: PERIODO DE VENTANA Y URGENCIA PEP
% =========================================================================

test(periodo_ventana_falso_negativo_vih) :-
    evaluar_periodo_ventana(vih, 10, Estado, _),
    assertion(Estado == dentro_del_periodo_de_ventana).

test(periodo_ventana_superado_confiable_vih) :-
    evaluar_periodo_ventana(vih, 30, Estado, _),
    assertion(Estado == ventana_superada_resultado_confiable).

test(urgencia_pep_dentro_de_72_horas) :-
    evaluar_periodo_ventana(pep_profilaxis_post_exposicion, 1.5, Estado, _),
    assertion(Estado == dentro_de_tiempo_urgencia_pep).

test(urgencia_pep_fuera_de_72_horas) :-
    evaluar_periodo_ventana(pep_profilaxis_post_exposicion, 4.0, Estado, _),
    assertion(Estado == fuera_de_ventana_pep).

% =========================================================================
% 6. PRUEBAS DE LA REGLA COMPLEJA 3: RANKING MULTICRITERIO
% =========================================================================

test(ranking_multicriterio_prioriza_cercania_y_horario) :-
    Perfil = perfil_consulta(huajuapan, sifilis, sabado, sin_cita, si),
    mejor_recomendacion_sede(Perfil, Ranking),
    Ranking = [datos_recomendacion(MejorSede, Puntos, _)|_],
    assertion(memberchk(MejorSede, [huajuapan, cessa_huajuapan, hosp_huajuapan])),
    assertion(Puntos >= 80).

% =========================================================================
% 7. PRUEBAS DE LA REGLA COMPLEJA 4: TIEMPOS Y HORAS
% =========================================================================

test(calculo_de_duracion_en_horas, [nondet]) :-
    duracion_atencion_horas(huajuapan, lunes, 8.0, jornada_completa),
    duracion_atencion_horas(tlalixtac, martes, 4.0, turno_reducido).

test(verificacion_de_hora_exacta) :-
    abierto_en_hora_exacta(huajuapan, sabado, '11:00', '09:00'-'14:00'),
    \+ abierto_en_hora_exacta(huajuapan, sabado, '17:00', _).

% =========================================================================
% 8. PRUEBAS DE LA REGLA COMPLEJA 5: RUTA MULTI-PRUEBA Y DERIVACIÓN
% =========================================================================

test(ruta_atencion_completa_en_sede_unica, [nondet]) :-
    ruta_atencion_completa(huajuapan, [vih, sifilis, hepatitis_c],
                           atencion_integral_en_sede_unica,
                           sede_completa(huajuapan, huajuapan, _)).

% =========================================================================
% 9. PRUEBAS DE LA REGLA COMPLEJA 6: DIAGNÓSTICO REGIONAL
% =========================================================================

test(diagnostico_regional_valles_centrales) :-
    diagnostico_regional(valles_centrales, stats(_, total_sedes(TS), deteccion_vih(TV), deteccion_sifilis(TSif), deteccion_hepatitis_c(THepC), urgencias_pep(TPEP), apertura_sabado(TSab), acceso_sin_cita(TSinCita))),
    assertion(TS >= 15),
    assertion(TV >= 15),
    assertion(TSif >= 15),
    assertion(THepC >= 10),
    assertion(TPEP >= 3),
    assertion(TSab >= 3),
    assertion(TSinCita >= 5).

% =========================================================================
% 10. PRUEBAS DE LA REGLA COMPLEJA 7: ANALIZADOR LÉXICO
% =========================================================================

test(analizador_lexico_lenguaje_natural) :-
    interpretar_consulta_natural("Quiero prueba rapida de sifilis en Huajuapan el sabado",
                                 consulta(huajuapan, sifilis, sabado)),
    interpretar_consulta_natural("Donde hacerme prueba rapida de vih en Oaxaca los martes",
                                 consulta(oaxaca_de_juarez, vih, martes)),
    interpretar_consulta_natural("Necesito deteccion de hepatitis en Tuxtepec el viernes",
                                 consulta(tuxtepec, hepatitis_c, viernes)).

:- end_tests(orientador_its_experto).
