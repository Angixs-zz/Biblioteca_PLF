:- encoding(utf8).
%% =========================================================================
%%  SUITE DE PRUEBAS AUTOMATIZADAS (PLUNIT) - VOCACIÓN-EXPERT
%%  Programación Lógica y Funcional - Caso de Estudio 3
%%
%%  Uso:
%%    swipl -q -s pruebas_vocacion_expert.pl -g run_tests -t halt
%% =========================================================================

:- use_module(library(plunit)).

% Cargar la base de conocimientos del sistema experto
:- consult('vocacion_expert.pl').

:- begin_tests(vocacion_expert_suite).

% =========================================================================
% 1. PRUEBA DE VOLUMEN: 10 TABLAS PRINCIPALES CON >= 50 REGISTROS CADA UNA
% =========================================================================

test(conteo_minimo_carrera) :-
    total_tabla(carrera, N),
    assertion(N >= 50).

test(conteo_minimo_institucion) :-
    total_tabla(institucion, N),
    assertion(N >= 50).

test(conteo_minimo_municipio_sede) :-
    total_tabla(municipio_sede, N),
    assertion(N >= 50).

test(conteo_minimo_oferta_academica) :-
    total_tabla(oferta_academica, N),
    assertion(N >= 50).

test(conteo_minimo_perfil_holland) :-
    total_tabla(perfil_holland, N),
    assertion(N >= 50).

test(conteo_minimo_mercado_laboral) :-
    total_tabla(mercado_laboral, N),
    assertion(N >= 50).

test(conteo_minimo_requisito_admision) :-
    total_tabla(requisito_admision, N),
    assertion(N >= 50).

test(conteo_minimo_programa_beca) :-
    total_tabla(programa_beca, N),
    assertion(N >= 50).

test(conteo_minimo_costo_carrera) :-
    total_tabla(costo_carrera, N),
    assertion(N >= 50).

test(conteo_minimo_materia_critica) :-
    total_tabla(materia_critica, N),
    assertion(N >= 50).

test(gran_total_hechos_supera_600) :-
    Tablas = [carrera, institucion, municipio_sede, oferta_academica,
              perfil_holland, mercado_laboral, requisito_admision,
              programa_beca, costo_carrera, materia_critica],
    findall(N, (member(T, Tablas), total_tabla(T, N)), Totales),
    sum_list(Totales, GranTotal),
    assertion(GranTotal >= 600).

% =========================================================================
% 2. INTEGRIDAD REFERENCIAL DE LA BASE DE CONOCIMIENTOS
% =========================================================================

test(integridad_institucion_municipio) :-
    forall(institucion(_, _, Mun, _, _),
           assertion(municipio_sede(Mun, _, _, _))).

test(integridad_oferta_referencias) :-
    forall(oferta_academica(Inst, Carr, _, _),
           ( assertion(institucion(Inst, _, _, _, _)),
             assertion(carrera(Carr, _, _, _, _))
           )).

test(integridad_perfil_holland_carrera) :-
    forall(perfil_holland(Carr, _, _, _, _, _, _),
           assertion(carrera(Carr, _, _, _, _))).

test(integridad_mercado_carrera) :-
    forall(mercado_laboral(Carr, _, _, _, _),
           assertion(carrera(Carr, _, _, _, _))).

test(integridad_requisitos_referencias) :-
    forall(requisito_admision(Inst, Carr, _, _, _),
           ( assertion(institucion(Inst, _, _, _, _)),
             assertion(carrera(Carr, _, _, _, _))
           )).

test(integridad_costos_referencias) :-
    forall(costo_carrera(Inst, Carr, _, _, _),
           ( assertion(institucion(Inst, _, _, _, _)),
             assertion(carrera(Carr, _, _, _, _))
           )).

test(integridad_materias_carrera) :-
    forall(materia_critica(_, Carr, _, _, _),
           assertion(carrera(Carr, _, _, _, _))).

% =========================================================================
% 3. PRUEBAS DE INFERENCIA LÓGICA Y REGLAS COMPLEJAS
% =========================================================================

test(afinidad_holland_sistemas_vs_derecho) :-
    % Perfil fuertemente orientado a ciencia y computación
    PerfilTec = perfil_aspirante(6, 10, 4, 3, 5, 8),
    similitud_holland(PerfilTec, ing_sistemas_computacionales, ScoreSis),
    similitud_holland(PerfilTec, derecho, ScoreDer),
    assertion(ScoreSis >= 85),
    assertion(ScoreDer =< 70),
    assertion(ScoreSis > ScoreDer).

test(simulador_admision_casos_extremos) :-
    % Caso de puntaje sobresaliente
    evaluar_admision(uabjo_medicina, medicina_humana, 9.5, 1295, DictamenAlto, _),
    assertion(DictamenAlto == alta_probabilidad_de_admision),
    % Caso de promedio insuficiente
    evaluar_admision(uabjo_medicina, medicina_humana, 8.2, 1290, DictamenBajoProm, _),
    assertion(DictamenBajoProm == no_cumple_requisito_academico).

test(planificador_financiero_utm_huajuapan, [nondet]) :-
    costo_mensual_carrera(utm_huajuapan, ing_sistemas_computacionales, CostoTotal, Desglose),
    % Cuota semestral 1800/6 = 300, materiales = 800, Huajuapan vida = 4600 -> Total = 5700
    assertion(CostoTotal =:= 5700),
    assertion(member(cuota_mensual(300.0), Desglose)),
    viabilidad_presupuesto(utm_huajuapan, ing_sistemas_computacionales, 6000, ViabTotal, 0),
    assertion(ViabTotal == viable_total),
    viabilidad_presupuesto(utm_huajuapan, ing_sistemas_computacionales, 4500, ViabBeca, Brecha),
    assertion(ViabBeca == viable_con_apoyo_o_beca),
    assertion(Brecha =:= 1200).

test(recomendador_multicriterio_score_rango, [nondet]) :-
    Perfil = perfil_consulta(perfil_aspirante(6,9,3,5,6,8), oaxaca_de_juarez, 8000, 9.0, cualquiera),
    evaluar_carrera_multicriterio(Perfil, ito_oaxaca, ing_sistemas_computacionales, Puntos, _),
    assertion(Puntos >= 60),
    assertion(Puntos =< 100),
    % Probar filtro exclusivo para universidades privadas
    PerfilPriv = perfil_consulta(perfil_aspirante(6,9,3,5,6,8), oaxaca_de_juarez, 50000, 9.0, solo_privadas),
    evaluar_carrera_multicriterio(PerfilPriv, anahuac_oaxaca, ing_industrial, PuntosPriv, _),
    assertion(PuntosPriv >= 50).

test(buscador_becas_elegibilidad) :-
    % Alumno con promedio 9.6 en universidad privada tiene becas de colegiatura y excelencia
    findall(B, beca_elegible(9.6, privada, B, _, _), BecasPriv),
    assertion(member(beca_anahuac_excelencia, BecasPriv)),
    % Alumno en pública no debe recibir beca exclusiva de colegiatura privada
    findall(B2, beca_elegible(9.6, publica, B2, _, _), BecasPub),
    assertion(\+ member(beca_anahuac_excelencia, BecasPub)),
    assertion(member(beca_santander_excelencia, BecasPub)).

test(materias_criticas_retencion) :-
    materias_dificultad_carrera(medicina_humana, MatsMed),
    length(MatsMed, L),
    assertion(L >= 3),
    materias_dificultad_carrera(ing_sistemas_computacionales, MatsSis),
    length(MatsSis, L2),
    assertion(L2 >= 2).

test(analizador_lenguaje_natural_carrera_y_municipio) :-
    interpretar_consulta_natural("Deseo estudiar arquitectura en Huajuapan",
                                 consulta_vocacional(Carrera1, Mun1)),
    assertion(Carrera1 == arquitectura),
    assertion(Mun1 == heroica_ciudad_de_huajuapan_de_leon),
    interpretar_consulta_natural("Me interesa medicina en Tuxtepec",
                                 consulta_vocacional(Carrera2, Mun2)),
    assertion(Carrera2 == medicina_humana),
    assertion(Mun2 == san_juan_bautista_tuxtepec).


test(afinidad_carreras_relacionadas) :-
    carreras_afines(ing_sistemas_computacionales, AfinesSis),
    assertion(member(ing_software-directa, AfinesSis)),
    assertion(member(ing_inteligencia_artificial-directa, AfinesSis)),
    carreras_afines(medicina_humana, AfinesMed),
    assertion(member(enfermeria-directa, AfinesMed)),
    assertion(member(cirujano_dentista-directa, AfinesMed)).

test(busqueda_carreras_por_texto) :-
    buscar_carreras_por_texto('software', CoincSoftware),
    assertion(member(ing_software, CoincSoftware)),
    buscar_carreras_por_texto('medicina', CoincMedicina),
    assertion(member(medicina_humana, CoincMedicina)),
    assertion(member(medicina_veterinaria, CoincMedicina)).


test(evaluar_admision_evaluatec_tecnm, [nondet]) :-
    % TecNM utiliza EVALUATEC (escala 0 a 100)
    requisito_admision(ito_oaxaca, ing_sistemas_computacionales, _, TipoEx, Corte),
    assertion(TipoEx == evaluatec),
    assertion(Corte =:= 72),
    evaluar_admision(ito_oaxaca, ing_sistemas_computacionales, 9.0, 85, DictamenAlto, DetalleAlto),
    assertion(DictamenAlto == alta_probabilidad_de_admision),
    assertion(sub_atom(DetalleAlto, _, _, _, 'EVALUATEC')).

test(evaluar_admision_suneo_propededeutico, [nondet]) :-
    % SUNEO utiliza examen institucional + curso propedéutico (escala 0 a 100)
    requisito_admision(utm_huajuapan, ing_software, _, TipoEx, Corte),
    assertion(TipoEx == examen_suneo),
    assertion(Corte =:= 70),
    evaluar_admision(utm_huajuapan, ing_software, 8.8, 82, DictamenSuneo, DetalleSuneo),
    assertion(DictamenSuneo == alta_probabilidad_de_admision),
    assertion(sub_atom(DetalleSuneo, _, _, _, 'SUNEO')).


test(proximidad_xoxo_conurbada_vs_foranea) :-
    % Desde Santa Cruz Xoxocotlán hacia Oaxaca de Juárez (local conurbada)
    categoria_distancia(santa_cruz_xoxocotlan, oaxaca_de_juarez, Cat1, _),
    assertion(Cat1 == local_conurbada),
    % Desde Santa Cruz Xoxocotlán hacia San Raymundo Jalpan (Anáhuac, local conurbada)
    categoria_distancia(santa_cruz_xoxocotlan, san_raymundo_jalpan, Cat2, _),
    assertion(Cat2 == local_conurbada),
    % Desde Santa Cruz Xoxocotlán hacia Huajuapan de León (UTM, foránea en la Mixteca)
    categoria_distancia(santa_cruz_xoxocotlan, heroica_ciudad_de_huajuapan_de_leon, Cat3, _),
    assertion(Cat3 == foranea_con_mudanza).

test(retorno_inversion_roi_calculo) :-
    retorno_inversion_carrera(ito_oaxaca, ing_sistemas_computacionales, Coleg, Insumos, InvTotal, ROI),
    assertion(Coleg > 0),
    assertion(Insumos > 0),
    assertion(InvTotal =:= Coleg + Insumos),
    assertion(ROI > 0.0),
    assertion(ROI < 10.0).


test(oferta_educacion_especial_eneeo) :-
    % Escuela Normal de Educación Especial de Oaxaca (ENEEO)
    assertion(oferta_academica(eneeo_oaxaca, educacion_especial, _, _)),
    assertion(institucion(eneeo_oaxaca, _, _, publica_estatal, _)).

test(oferta_fisioterapia_uabjo_y_anahuac) :-
    % Fisioterapia en UABJO (CREE) y Anáhuac
    assertion(oferta_academica(uabjo_terapia_fisica, fisioterapia, _, _)),
    assertion(oferta_academica(anahuac_oaxaca, fisioterapia, _, _)),
    assertion(oferta_academica(lasalle_oaxaca, fisioterapia, _, _)),
    assertion(oferta_academica(urse_oaxaca, fisioterapia, _, _)).

% La nueva fase conductual conserva las seis dimensiones.
test(combinar_intereses_conductuales) :-
    combinar_perfiles(perfil_aspirante(8,6,5,4,7,3),
        [r-10,i-8,a-6,s-4,e-7,c-5], P),
    P = perfil_aspirante(9,7,5.5,4,7,4).

test(identificar_empate_real) :-
    detectar_areas_cercanas(perfil_aspirante(8,8,3,2,4,5), [r,i]).

test(identificar_afinidad_cercana) :-
    detectar_areas_cercanas(perfil_aspirante(8,7.5,3,2,4,5), [r,i]).

test(no_desempatar_si_diferencia_amplia) :-
    detectar_areas_cercanas(perfil_aspirante(9,5,3,2,4,5), []).

test(conservar_perfil_mixto_si_prefiere_ambas) :-
    P = perfil_aspirante(8,8,3,2,4,5),
    ajustar_preferencias(P,r,i,[3,3],P).

test(desempate_suave_sin_eliminar_segunda_aptitud) :-
    ajustar_preferencias(perfil_aspirante(8,8,3,2,4,5),r,i,[1,1],P),
    P = perfil_aspirante(8.5,8,3,2,4,5).

:- end_tests(vocacion_expert_suite).
