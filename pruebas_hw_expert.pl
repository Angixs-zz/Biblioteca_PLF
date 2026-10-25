%% ==================================================================
%%  Pruebas automatizadas de HW-Expert (Caso de Estudio 2)
%%
%%  Ejecución:
%%      swipl pruebas_hw_expert.pl
%%
%%  El archivo de pruebas carga hw_expert.pl con ensure_loaded/1.
%%  Gracias a initialization(main, main), esa carga NO abre el menú.
%% ==================================================================

:- use_module(library(plunit)).
:- use_module(library(lists)).
:- use_module(library(aggregate)).

:- ensure_loaded(hw_expert).

% ------------------------------------------------------------------
%  Utilidades de prueba
% ------------------------------------------------------------------

ids_de(cpu, Ids) :-
    findall(I, procesador(I, _, _, _, _, _, _, _), Ids).
ids_de(placa, Ids) :-
    findall(I, placa_madre(I, _, _, _, _, _, _), Ids).
ids_de(ram, Ids) :-
    findall(I, memoria_ram(I, _, _, _, _, _), Ids).
ids_de(gpu, Ids) :-
    findall(I, tarjeta_grafica(I, _, _, _, _, _, _), Ids).
ids_de(fuente, Ids) :-
    findall(I, fuente_poder(I, _, _, _, _, _), Ids).

% Ejecuta el menú con una entrada de texto y captura su salida.
ejecutar_menu_con(Texto, Salida) :-
    tmp_file(prueba_menu_hw, Archivo),
    setup_call_cleanup(
        ( open(Archivo, write, S),
          write(S, Texto),
          close(S),
          see(Archivo)
        ),
        with_output_to(string(Salida), menu),
        ( seen,
          catch(delete_file(Archivo), _, true)
        )
    ).

validar_config(Perfil, Presupuesto) :-
    mejor_configuracion(Perfil, Presupuesto, config(Cpu, Mb, Ram, Gpu, Psu, Total)),
    assertion(procesador(Cpu, _, _, _, _, _, _, _)),
    assertion(placa_madre(Mb, _, _, _, _, _, _)),
    assertion(memoria_ram(Ram, _, _, _, _, _)),
    assertion(tarjeta_grafica(Gpu, _, _, _, _, _, _)),
    assertion(fuente_poder(Psu, _, _, _, _, _)),
    assertion(compatibles(Cpu, Mb, Ram)),
    assertion(fuente_suficiente(Cpu, Mb, Gpu, Psu)),
    assertion(Total =< Presupuesto),
    assertion(\+ cuello_botella(Cpu, Gpu, _)),
    assertion(configuracion_equilibrada(Cpu, Gpu)).

% ------------------------------------------------------------------
%  Base de conocimientos
% ------------------------------------------------------------------
:- begin_tests(hw_expert_base).

test(conteo_exacto_de_registros) :-
    aggregate_all(count, procesador(_, _, _, _, _, _, _, _), 59),
    aggregate_all(count, placa_madre(_, _, _, _, _, _, _), 64),
    aggregate_all(count, memoria_ram(_, _, _, _, _, _), 52),
    aggregate_all(count, tarjeta_grafica(_, _, _, _, _, _, _), 53),
    aggregate_all(count, fuente_poder(_, _, _, _, _, _), 57).

test(ids_unicos_y_contiguos) :-
    forall(member(Tipo-N, [cpu-59, placa-64, ram-52, gpu-53, fuente-57]),
           ( ids_de(Tipo, Ids),
             sort(Ids, Ordenados),
             length(Ordenados, N),
             numlist(1, N, Ordenados)
           )).

test(salida_contar_registros) :-
    with_output_to(string(Out), contar_registros),
    assertion(sub_string(Out, _, _, _, "procesador: 59")),
    assertion(sub_string(Out, _, _, _, "placa_madre: 64")),
    assertion(sub_string(Out, _, _, _, "memoria_ram: 52")),
    assertion(sub_string(Out, _, _, _, "tarjeta_grafica: 53")),
    assertion(sub_string(Out, _, _, _, "fuente_poder: 57")),
    assertion(sub_string(Out, _, _, _, "TOTAL: 285 hechos")).

:- end_tests(hw_expert_base).

% ------------------------------------------------------------------
%  Regla 1: compatibilidad
% ------------------------------------------------------------------
:- begin_tests(hw_expert_regla1).

test(caso_9_10_28_es_compatible) :-
    assertion(compatibles(9, 10, 28)).

test(caso_9_10_2_es_incompatible_por_ddr) :-
    assertion(\+ compatibles(9, 10, 2)).

test(am5_ddr5_compatible) :-
    assertion(compatibles(51, 54, 30)).

test(socket_distinto_es_incompatible) :-
    assertion(\+ compatibles(9, 20, 1)).

test(motivo_de_ram) :-
    once(incompatibilidad(9, 10, 2, Motivo)),
    assertion(sub_string(Motivo, _, _, _, "Memoria incompatible")).

test(motivo_de_socket) :-
    once(incompatibilidad(9, 20, 1, Motivo)),
    assertion(sub_string(Motivo, _, _, _, "Socket incompatible")).

test(id_inexistente_no_es_compatible) :-
    assertion(\+ compatibles(999, 10, 28)).

test(aviso_de_limites_fisicos) :-
    advertencia_compatibilidad_fisica(Aviso),
    assertion(sub_string(Aviso, _, _, _, "BIOS")),
    assertion(sub_string(Aviso, _, _, _, "conectores")).

:- end_tests(hw_expert_regla1).

% ------------------------------------------------------------------
%  Regla 2: seguridad energética
% ------------------------------------------------------------------
:- begin_tests(hw_expert_regla2).

test(consumo_51_54_23) :-
    consumo_total(51, 54, 23, Total),
    assertion(Total =:= 675),
    consumo_con_margen(51, 54, 23, Requerido),
    assertion(Requerido =:= 843.75).

test(fuente_750_insuficiente) :-
    assertion(\+ fuente_suficiente(51, 54, 23, 8)).

test(fuente_1000_suficiente) :-
    assertion(fuente_suficiente(51, 54, 23, 10)).

test(limite_igualdad_es_suficiente) :-
    consumo_con_margen(8, 1, 23, Requerido),
    assertion(Requerido =:= 750.0),
    fuente_poder(6, _, _, Potencia, _, _),
    assertion(Potencia =:= 750),
    assertion(fuente_suficiente(8, 1, 23, 6)),
    assertion(\+ fuente_suficiente(8, 1, 23, 5)).

test(psu_mas_barata_para_843_75) :-
    psu_mas_barata(51, 54, 23, Psu, Precio),
    assertion(Psu == 20),
    assertion(Precio == 2160),
    fuente_poder(20, _, _, 850, _, 2160),
    assertion(fuente_suficiente(51, 54, 23, 20)),
    forall(( fuente_poder(_, _, _, Pot, _, PrecioOtro),
             Pot >= 844
           ),
           PrecioOtro >= Precio).

test(psu_mas_barata_para_bajo_consumo) :-
    psu_mas_barata(1, 1, 1, Psu, Precio),
    assertion(Psu == 15),
    assertion(Precio == 720),
    fuente_poder(15, _, _, 500, _, 720).

test(advertencias_de_holgura_y_alcance) :-
    advertencias_energeticas(51, 54, 23, 20, Advertencias),
    length(Advertencias, 2),
    assertion((member(Aviso, Advertencias),
               sub_string(Aviso, _, _, _, "menor al 10%"))),
    assertion((member(General, Advertencias),
               sub_string(General, _, _, _, "no incluye RAM"))).

test(sin_advertencia_de_holgura_con_1000w) :-
    advertencias_energeticas(51, 54, 23, 10, Advertencias),
    length(Advertencias, 1).

:- end_tests(hw_expert_regla2).

% ------------------------------------------------------------------
%  Regla 3: cuellos de botella y equilibrio
% ------------------------------------------------------------------
:- begin_tests(hw_expert_regla3).

test(cuello_37_44) :-
    cuello_botella(37, 44, Mensaje),
    assertion(Mensaje == 'El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas').

test(equilibrada_48_21) :-
    assertion(configuracion_equilibrada(48, 21)),
    assertion(\+ cuello_botella(48, 21, _)).

test(cpu_limitada_con_gpu_16gb_no_es_equilibrada) :-
    assertion(\+ configuracion_equilibrada(37, 44)).

test(equilibrada_ya_no_acepta_cpu_de_2_nucleos) :-
    assertion(\+ configuracion_equilibrada(1, 1)).

test(diagnostico_cuello) :-
    once(diagnostico_balance(37, 44, cuello_botella(_))).

test(diagnostico_equilibrada) :-
    once(diagnostico_balance(48, 21, equilibrada)).

test(diagnostico_no_concluyente) :-
    diagnostico_balance(1, 7, no_concluyente(Mensaje)),
    assertion(sub_string(Mensaje, _, _, _, "no concluyente")).

test(umbrales_de_equilibrio) :-
    assertion(minimo_nucleos_equilibrio(16, 8)),
    assertion(minimo_nucleos_equilibrio(8, 6)),
    assertion(minimo_nucleos_equilibrio(4, 4)),
    assertion(equilibrio_ok(6, 8)),
    assertion(\+ equilibrio_ok(4, 8)).

:- end_tests(hw_expert_regla3).

% ------------------------------------------------------------------
%  Regla 4: recomendaciones y puntaje
% ------------------------------------------------------------------
:- begin_tests(hw_expert_regla4).

test(recomendar_18000_es_valida) :-
    once(recomendar(18000, Cpu, Mb, Ram, Gpu, Psu, Total)),
    assertion(procesador(Cpu, _, _, _, _, _, _, _)),
    assertion(placa_madre(Mb, _, _, _, _, _, _)),
    assertion(memoria_ram(Ram, _, _, _, _, _)),
    assertion(tarjeta_grafica(Gpu, _, _, _, _, _, _)),
    assertion(fuente_poder(Psu, _, _, _, _, _)),
    assertion(compatibles(Cpu, Mb, Ram)),
    assertion(fuente_suficiente(Cpu, Mb, Gpu, Psu)),
    assertion(Total =< 18000).

test(recomendar_sin_presupuesto_falla) :-
    assertion(\+ recomendar(1, _, _, _, _, _, _)).

test(mejor_configuracion_respeta_presupuesto) :-
    mejor_configuracion(gaming, 18000, config(_, _, _, _, _, Total)),
    assertion(Total =< 18000).

test(mejor_configuracion_sin_presupuesto_falla) :-
    assertion(\+ mejor_configuracion(gaming, 1, _)).

test(perfiles_y_presupuestos) :-
    forall(member(Perfil, [gaming, ia, renderizado, servidor_web, desarrollo]),
           forall(member(Presupuesto, [18000, 22000, 27000]),
                  validar_config(Perfil, Presupuesto))).

test(selecciona_el_mejor_puntaje) :-
    Filtros = filtros('AMD', 'Intel', ddr4, 6, 16, 8),
    Presupuesto = 22000,
    mejor_configuracion(gaming, Presupuesto, Filtros,
                        config(Cpu, _, Ram, Gpu, _, Total)),
    puntaje(gaming, Cpu, Ram, Gpu, Puntaje),
    PuntajeSeleccionado is Puntaje - Total / 1000000,
    findall(PuntajeCandidato, (
                candidato(gaming, Presupuesto, Filtros,
                          _, _, _, _, _, TotalCandidato, PuntajeBruto),
                PuntajeCandidato is PuntajeBruto - TotalCandidato / 1000000
            ),
            Puntajes),
    max_list(Puntajes, Maximo),
    assertion(PuntajeSeleccionado >= Maximo - 1.0e-9).

test(puntaje_no_usa_consumo_como_rendimiento) :-
    puntaje(gaming, 48, 30, 16, Puntaje16GB),
    puntaje(gaming, 48, 30, 6, Puntaje11GB),
    assertion(Puntaje16GB > Puntaje11GB).

test(servidor_web_no_premia_gpu) :-
    puntaje(servidor_web, 18, 43, 1, PuntajeGpuBasica),
    puntaje(servidor_web, 18, 43, 13, PuntajeGpuAlta),
    assertion(abs(PuntajeGpuBasica - PuntajeGpuAlta) < 1.0e-9).

test(salida_de_recomendacion) :-
    with_output_to(string(Out), recomendar_perfil(servidor_web, 18000)),
    assertion(sub_string(Out, _, _, _, "Mejor equipo para servidor_web")),
    assertion(sub_string(Out, _, _, _, "CPU")),
    assertion(sub_string(Out, _, _, _, "Placa")),
    assertion(sub_string(Out, _, _, _, "RAM")),
    assertion(sub_string(Out, _, _, _, "GPU")),
    assertion(sub_string(Out, _, _, _, "Fuente")),
    assertion(sub_string(Out, _, _, _, "TOTAL")),
    assertion(sub_string(Out, _, _, _, "[INFO]")).

test(aviso_sin_solucion) :-
    with_output_to(string(Out), recomendar_perfil(gaming, 1)),
    assertion(sub_string(Out, _, _, _, "No existe una configuración válida")).

test(salida_de_diagnostico) :-
    with_output_to(string(Out), diagnosticar(51, 54, 30, 23, 10, ia)),
    assertion(sub_string(Out, _, _, _, "DIAGNÓSTICO")),
    assertion(sub_string(Out, _, _, _, "benchmarks reales")),
    assertion(sub_string(Out, _, _, _, "Cumple los requisitos mínimos")).

:- end_tests(hw_expert_regla4).

% ------------------------------------------------------------------
%  Entradas y menú
% ------------------------------------------------------------------
:- begin_tests(hw_expert_interfaz).

test(parse_entero_valido) :-
    parse_entero("3", 1, 5, 3),
    parse_entero("0", 0, 8, 0).

test(parse_entero_invalido) :-
    assertion(\+ parse_entero("9", 0, 8, _)),
    assertion(\+ parse_entero("3.5", 0, 8, _)),
    assertion(\+ parse_entero("", 0, 8, _)),
    assertion(\+ parse_entero("abc", 0, 8, _)).

test(parse_pesos_valido) :-
    parse_pesos("25000", 25000),
    parse_pesos("25,000", 25000),
    parse_pesos("$25,000", 25000),
    parse_pesos("25 000", 25000),
    parse_pesos("25000.4", 25000).

test(parse_pesos_invalido) :-
    assertion(\+ parse_pesos("0", _)),
    assertion(\+ parse_pesos("-5", _)),
    assertion(\+ parse_pesos("abc", _)),
    assertion(\+ parse_pesos("", _)).

test(menu_muestra_opciones_y_sale) :-
    ejecutar_menu_con("0\n", Out),
    assertion(sub_string(Out, _, _, _, "HW-EXPERT")),
    assertion(sub_string(Out, _, _, _, "1) Recomendarme un equipo completo")),
    assertion(sub_string(Out, _, _, _, "8) Ver demostración")),
    assertion(sub_string(Out, _, _, _, "¡Hasta luego!")).

test(menu_rechaza_entrada_invalida) :-
    ejecutar_menu_con("abc\n0\n", Out),
    assertion(sub_string(Out, _, _, _, "Entrada no válida")).

test(menu_opcion_2_compatibilidad) :-
    ejecutar_menu_con("2\n9\n10\n28\n0\n", Out),
    assertion(sub_string(Out, _, _, _, "Son compatibles")),
    assertion(sub_string(Out, _, _, _, "BIOS")).

test(menu_opcion_3_fuente_insuficiente) :-
    ejecutar_menu_con("3\n51\n54\n23\n8\n0\n", Out),
    assertion(sub_string(Out, _, _, _, "Consumo total: 675 W")),
    assertion(sub_string(Out, _, _, _, "843.8 W")),
    assertion(sub_string(Out, _, _, _, "[PELIGRO]")),
    assertion(sub_string(Out, _, _, _, "Sugerencia:")).

test(menu_opcion_4_cuello) :-
    ejecutar_menu_con("4\n37\n44\n0\n", Out),
    assertion(sub_string(Out, _, _, _, "[ALERTA]")),
    assertion(sub_string(Out, _, _, _, "El procesador limitará")).

test(menu_opcion_5_diagnostico) :-
    ejecutar_menu_con("5\n1\n51\n54\n30\n23\n10\n0\n", Out),
    assertion(sub_string(Out, _, _, _, "DIAGNÓSTICO")),
    assertion(sub_string(Out, _, _, _, "Costo total de la configuración")).

test(menu_opcion_7_registros) :-
    ejecutar_menu_con("7\n0\n", Out),
    assertion(sub_string(Out, _, _, _, "TOTAL: 285 hechos")).

test(menu_opcion_1_sin_solucion) :-
    ejecutar_menu_con("1\n1\n1\n3\n4\n3\n1\n0\n", Out),
    assertion(sub_string(Out, _, _, _, "No existe una configuración válida")).

:- end_tests(hw_expert_interfaz).

% ------------------------------------------------------------------
%  Entrada principal: ejecuta todas las pruebas y devuelve código 0/1.
% ------------------------------------------------------------------
main_pruebas :-
    (   run_tests
    ->  halt(0)
    ;   halt(1)
    ).

:- initialization(main_pruebas, main).
