:- encoding(utf8).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SISTEMA EXPERTO VOCACIONAL Y DE ADMISIÓN UNIVERSITARIA (VOCACIÓN-EXPERT)
% Programación Lógica y Funcional - Caso de Estudio 3 (Proyecto Final)
%
% Autores: Miguel Ángel Hernández Pérez y Yareli
% Entorno: SWI-Prolog 9.x en Windows
%
% CARACTERÍSTICAS DEL SISTEMA:
%  1. Base de Conocimientos con 10 Tablas Principales (>= 50 hechos cada una)
%  2. Cobertura Integral de Universidades Públicas (UABJO, SUNEO, TecNM) y
%     Privadas (Anáhuac, La Salle, URSE, Mesoamericana, UGMEX, UNID, UNIVAS, etc.)
%  3. Motor Psicométrico de Afinidad Vocacional (Modelo Holland RIASEC)
%  4. Calculador Probabilístico de Admisión (Promedio de Bachillerato y EXANI-II)
%  5. Planificador Financiero Estudiantil y Costo de Vida Universitario
%  6. Recomendador Multicriterio Ponderado con Filtro de Régimen Público/Privado
%  7. Validador de Elegibilidad de Becas (Públicas y de Colegiatura Privada)
%  8. Diagnóstico de Materias Críticas y Filtro de Retención Académica
%  9. Analizador Léxico de Consultas en Lenguaje Natural
% 10. Menú Interactivo de 12 Opciones (0 a 11) y Suite de Pruebas (plunit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(lists)).
:- use_module(library(aggregate)).
:- use_module(library(apply)).

% =========================================================================
% 1. TABLA: carrera(IdCarrera, Nombre, AreaConocimiento, Semestres, Exigencia)
% Total de registros: 55 carreras profesionales
% =========================================================================
carrera(ing_sistemas_computacionales, 'Ingeniería en Sistemas Computacionales', ingenieria_y_tecnologia, 9, alta).
carrera(ing_software, 'Ingeniería de Software y Sistemas Distribuidos', ingenieria_y_tecnologia, 9, alta).
carrera(ing_inteligencia_artificial, 'Ingeniería en Inteligencia Artificial y Ciencia de Datos', ingenieria_y_tecnologia, 9, muy_alta).
carrera(ing_civil, 'Ingeniería Civil y Estructuras', ingenieria_y_tecnologia, 9, alta).
carrera(ing_mecanica, 'Ingeniería Mecánica y Térmica', ingenieria_y_tecnologia, 9, alta).
carrera(ing_electrica, 'Ingeniería Eléctrica y Sistemas de Potencia', ingenieria_y_tecnologia, 9, alta).
carrera(ing_mecatronica, 'Ingeniería Mecatrónica y Robótica', ingenieria_y_tecnologia, 9, muy_alta).
carrera(ing_industrial, 'Ingeniería Industrial y Calidad', ingenieria_y_tecnologia, 9, moderada).
carrera(ing_quimica, 'Ingeniería Química de Procesos', ingenieria_y_tecnologia, 9, alta).
carrera(ing_electronica, 'Ingeniería Electrónica y Sistemas Embebidos', ingenieria_y_tecnologia, 9, alta).
carrera(ing_telecomunicaciones, 'Ingeniería en Telecomunicaciones y Redes', ingenieria_y_tecnologia, 9, alta).
carrera(ing_biomedica, 'Ingeniería Biomédica y Bioinstrumentación', ingenieria_y_tecnologia, 9, muy_alta).
carrera(ing_ambiental, 'Ingeniería Ambiental y Sustentabilidad', ingenieria_y_tecnologia, 9, moderada).
carrera(ing_energias_renovables, 'Ingeniería en Energías Renovables y Solar', ingenieria_y_tecnologia, 9, alta).
carrera(ing_geologia, 'Ingeniería Geológica y Minería', ingenieria_y_tecnologia, 9, alta).
carrera(ing_alimentos, 'Ingeniería en Industrias Alimentarias', ingenieria_y_tecnologia, 9, moderada).
carrera(ing_agronomica, 'Ingeniería Agronómica y Fitosanitaria', ciencias_agropecuarias, 9, moderada).
carrera(ing_forestal, 'Ingeniería Forestal y Silvicultura', ciencias_agropecuarias, 9, moderada).
carrera(ing_acuicola, 'Ingeniería en Acuicultura y Biología Pesquera', ciencias_agropecuarias, 9, moderada).
carrera(medicina_humana, 'Licenciatura en Medicina General y Comunitaria', ciencias_salud, 12, muy_alta).
carrera(cirujano_dentista, 'Licenciatura en Cirujano Dentista (Odontología)', ciencias_salud, 10, alta).
carrera(enfermeria, 'Licenciatura en Enfermería y Obstetricia', ciencias_salud, 8, moderada).
carrera(nutricion_clinica, 'Licenciatura en Nutrición Clínica y Dietética', ciencias_salud, 8, moderada).
carrera(fisioterapia, 'Licenciatura en Fisioterapia y Terapia Física', ciencias_salud, 8, alta).
carrera(quimico_farmacobiologo, 'Licenciatura en Químico Farmacobiólogo (QFB)', ciencias_salud, 9, muy_alta).
carrera(psicologia_clinica, 'Licenciatura en Psicología y Neurocognición', ciencias_salud, 8, moderada).
carrera(medicina_veterinaria, 'Licenciatura en Medicina Veterinaria y Zootecnia', ciencias_agropecuarias, 10, alta).
carrera(derecho, 'Licenciatura en Derecho y Ciencias Jurídicas', ciencias_sociales_y_derecho, 10, alta).
carrera(administracion_empresas, 'Licenciatura en Administración de Empresas', administracion_y_negocios, 8, moderada).
carrera(contaduria_publica, 'Licenciatura en Contaduría Pública y Fiscal', administracion_y_negocios, 8, moderada).
carrera(comercio_internacional, 'Licenciatura en Comercio Internacional y Logística', administracion_y_negocios, 8, moderada).
carrera(mercadotecnia_digital, 'Licenciatura en Mercadotecnia y Estrategia Digital', administracion_y_negocios, 8, moderada).
carrera(gestion_turistica, 'Licenciatura en Administración Turística y Hotelera', administracion_y_negocios, 8, moderada).
carrera(gastronomia, 'Licenciatura en Gastronomía y Artes Culinarias', administracion_y_negocios, 8, alta).
carrera(economia, 'Licenciatura en Economía y Finanzas Públicas', ciencias_sociales_y_derecho, 8, alta).
carrera(ciencias_politicas, 'Licenciatura en Ciencias Políticas y Gestión Pública', ciencias_sociales_y_derecho, 8, moderada).
carrera(relaciones_internacionales, 'Licenciatura en Relaciones Internacionales y Diplomacia', ciencias_sociales_y_derecho, 8, alta).
carrera(comunicacion_periodismo, 'Licenciatura en Ciencias de la Comunicación y Periodismo', ciencias_sociales_y_derecho, 8, moderada).
carrera(sociologia, 'Licenciatura en Sociología y Estudios Regionales', ciencias_sociales_y_derecho, 8, moderada).
carrera(antropologia_social, 'Licenciatura en Antropología Social y Comunitaria', ciencias_sociales_y_derecho, 8, alta).
carrera(pedagogia, 'Licenciatura en Pedagogía y Docencia', ciencias_sociales_y_derecho, 8, moderada).
carrera(educacion_especial, 'Licenciatura en Educación Especial e Inclusiva', ciencias_sociales_y_derecho, 8, moderada).
carrera(arquitectura, 'Licenciatura en Arquitectura y Diseño Bioclimático', artes_y_humanidades, 10, muy_alta).
carrera(diseno_grafico, 'Licenciatura en Diseño Gráfico y Comunicación Visual', artes_y_humanidades, 8, moderada).
carrera(diseno_industrial, 'Licenciatura en Diseño Industrial y Producto', artes_y_humanidades, 9, alta).
carrera(artes_plasticas, 'Licenciatura en Artes Plásticas y Visuales', artes_y_humanidades, 8, alta).
carrera(musica, 'Licenciatura en Música e Interpretación Instrumental', artes_y_humanidades, 10, muy_alta).
carrera(filosofia, 'Licenciatura en Filosofía y Pensamiento Crítico', artes_y_humanidades, 8, alta).
carrera(historia, 'Licenciatura en Historia y Patrimonio Cultural', artes_y_humanidades, 8, moderada).
carrera(lenguas_extranjeras, 'Licenciatura en Enseñanza de Idiomas y Lingüística', artes_y_humanidades, 8, moderada).
carrera(matematicas_aplicadas, 'Licenciatura en Matemáticas Aplicadas y Computación', ciencias_exactas_y_naturales, 8, muy_alta).
carrera(fisica, 'Licenciatura en Física y Ciencia de Materiales', ciencias_exactas_y_naturales, 8, muy_alta).
carrera(biologia, 'Licenciatura en Biología y Biodiversidad Marina y Terrestre', ciencias_exactas_y_naturales, 8, alta).
carrera(ciencias_ambientales, 'Licenciatura en Ciencias Ambientales y Ecología', ciencias_exactas_y_naturales, 8, alta).
carrera(actuaria, 'Licenciatura en Actuaría y Finanzas Cuantitativas', ciencias_exactas_y_naturales, 8, muy_alta).

% =========================================================================
% 2. TABLA: institucion(IdInstitucion, Nombre, Municipio, TipoRegimen, Prestigio)
% Total de registros: 62 universidades (42 públicas y 20 privadas de Oaxaca)
% =========================================================================
institucion(uabjo_cu, 'UABJO - Ciudad Universitaria', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_medicina, 'UABJO - Facultad de Medicina y Cirugía', oaxaca_de_juarez, publica_estatal, muy_alta).
institucion(uabjo_enfermeria, 'UABJO - Facultad de Enfermería y Obstetricia', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_odontologia, 'UABJO - Facultad de Odontología', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_derecho, 'UABJO - Facultad de Derecho y Ciencias Sociales', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_arquitectura_5m, 'UABJO - Facultad de Arquitectura 5 de Mayo', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_idiomas, 'UABJO - Facultad de Idiomas', oaxaca_de_juarez, publica_estatal, media).
institucion(uabjo_contaduria, 'UABJO - Facultad de Contaduría y Administración', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_ciencias, 'UABJO - Escuela de Ciencias (Física y Matemáticas)', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_artes, 'UABJO - Escuela de Bellas Artes', oaxaca_de_juarez, publica_estatal, alta).
institucion(uabjo_tehuantepec, 'UABJO - Escuela de Enfermería Tehuantepec', santo_domingo_tehuantepec, publica_estatal, media).
institucion(uabjo_huajuapan, 'UABJO - Preparatoria y Extensión Huajuapan', heroica_ciudad_de_huajuapan_de_leon, publica_estatal, media).
institucion(ito_oaxaca, 'Instituto Tecnológico de Oaxaca (ITO TecNM)', oaxaca_de_juarez, publica_federal, muy_alta).
institucion(itvo_nazareno, 'Instituto Tecnológico del Valle de Oaxaca (ITVO TecNM)', santa_cruz_xoxocotlan, publica_federal, alta).
institucion(it_tuxtepec, 'Instituto Tecnológico de Tuxtepec (TecNM)', san_juan_bautista_tuxtepec, publica_federal, alta).
institucion(it_salina_cruz, 'Instituto Tecnológico de Salina Cruz (TecNM)', salina_cruz, publica_federal, alta).
institucion(it_comitancillo, 'Instituto Tecnológico de Comitancillo (TecNM)', san_pedro_comitancillo, publica_federal, media).
institucion(it_pinotepa, 'Instituto Tecnológico de Pinotepa (TecNM)', santiago_pinotepa_nacional, publica_federal, alta).
institucion(it_tlaxiaco, 'Instituto Tecnológico de Tlaxiaco (TecNM)', heroica_ciudad_de_tlaxiaco, publica_federal, alta).
institucion(it_pochutla, 'Instituto Tecnológico de San Pedro Pochutla (TecNM)', san_pedro_pochutla, publica_federal, alta).
institucion(it_cuenca, 'Instituto Tecnológico de la Cuenca del Papaloapan (TecNM)', san_juan_bautista_tuxtepec, publica_federal, media).
institucion(it_valle_etla, 'Instituto Tecnológico del Valle de Etla (TecNM)', villa_de_etla, publica_federal, alta).
institucion(it_istmo, 'Instituto Tecnológico del Istmo (TecNM)', heroica_ciudad_de_juchitan_de_zaragoza, publica_federal, alta).
institucion(it_tehuantepec, 'Instituto Tecnológico de Tehuantepec (TecNM)', santo_domingo_tehuantepec, publica_federal, media).
institucion(utm_huajuapan, 'Universidad Tecnológica de la Mixteca (SUNEO)', heroica_ciudad_de_huajuapan_de_leon, publica_estatal, muy_alta).
institucion(umar_puerto_escondido, 'Universidad del Mar - Campus Puerto Escondido (SUNEO)', san_pedro_mixtepec, publica_estatal, muy_alta).
institucion(umar_puerto_angel, 'Universidad del Mar - Campus Puerto Ángel (SUNEO)', san_pedro_pochutla, publica_estatal, muy_alta).
institucion(umar_huatulco, 'Universidad del Mar - Campus Bahías de Huatulco (SUNEO)', santa_maria_huatulco, publica_estatal, muy_alta).
institucion(unistmo_tehuantepec, 'Universidad del Istmo - Campus Tehuantepec (SUNEO)', santo_domingo_tehuantepec, publica_estatal, muy_alta).
institucion(unistmo_ixtepec, 'Universidad del Istmo - Campus Ixtepec (SUNEO)', ciudad_ixtepec, publica_estatal, alta).
institucion(unistmo_juchitan, 'Universidad del Istmo - Campus Juchitán (SUNEO)', heroica_ciudad_de_juchitan_de_zaragoza, publica_estatal, alta).
institucion(unpa_tuxtepec, 'Universidad del Papaloapan - Campus Tuxtepec (SUNEO)', san_juan_bautista_tuxtepec, publica_estatal, muy_alta).
institucion(unpa_loma_bonita, 'Universidad del Papaloapan - Campus Loma Bonita (SUNEO)', loma_bonita, publica_estatal, alta).
institucion(unsij_ixtlan, 'Universidad de la Sierra Juárez (SUNEO)', ixtlan_de_juarez, publica_estatal, muy_alta).
institucion(unsis_miahuatlan, 'Universidad de la Sierra Sur (SUNEO)', miahuatlan_de_porfirio_diaz, publica_estatal, muy_alta).
institucion(uncos_puerto_escondido, 'Universidad de la Costa (SUNEO)', santiago_pinotepa_nacional, publica_estatal, alta).
institucion(utvco_huixtepec, 'Universidad Tecnológica de los Valles Centrales (UTVCO)', san_pablo_huixtepec, publica_estatal, alta).
institucion(upn_oaxaca, 'Universidad Pedagógica Nacional Unidad 201 Oaxaca', santa_cruz_xoxocotlan, publica_federal, alta).
institucion(upn_tuxtepec, 'Universidad Pedagógica Nacional Subsede Tuxtepec', san_juan_bautista_tuxtepec, publica_federal, media).
institucion(upn_juchitan, 'Universidad Pedagógica Nacional Subsede Juchitán', heroica_ciudad_de_juchitan_de_zaragoza, publica_federal, media).
institucion(creno_oaxaca, 'Centro Regional de Educación Normal de Oaxaca (CRENO)', oaxaca_de_juarez, publica_estatal, alta).
institucion(eneeo_oaxaca, 'Escuela Normal de Educación Especial de Oaxaca (ENEEO)', oaxaca_de_juarez, publica_estatal, muy_alta).
institucion(eneop_oaxaca, 'Escuela Normal de Educación Preescolar de Oaxaca (ENEOP)', santa_lucia_del_camino, publica_estatal, alta).
institucion(benelly_ixtepec, 'Benemérita Escuela Normal Urbana Federal del Istmo (BENUFI)', ciudad_ixtepec, publica_federal, muy_alta).
institucion(enbio_oaxaca, 'Escuela Normal Bilingüe e Intercultural de Oaxaca (ENBIO)', tlacolula_de_matamoros, publica_estatal, alta).
institucion(uabjo_terapia_fisica, 'UABJO - Escuela de Terapia Física (CREE Oaxaca)', oaxaca_de_juarez, publica_estatal, muy_alta).
institucion(uniba_oaxaca, 'Universidad Comunal e Intercultural (UNIBA)', asuncion_nochixtlan, publica_estatal, media).
institucion(anahuac_oaxaca, 'Universidad Anáhuac Oaxaca', san_raymundo_jalpan, privada, muy_alta).
institucion(lasalle_oaxaca, 'Universidad La Salle Oaxaca', santa_cruz_xoxocotlan, privada, muy_alta).
institucion(urse_oaxaca, 'Universidad Regional del Sureste (URSE Campus El Rosario)', san_sebastian_tutla, privada, alta).
institucion(urse_aleman, 'Universidad Regional del Sureste (URSE Campus Alemán)', oaxaca_de_juarez, privada, alta).
institucion(mesoamericana_oaxaca, 'Universidad Mesoamericana Oaxaca', oaxaca_de_juarez, privada, alta).
institucion(univas_oaxaca, 'Universidad José Vasconcelos de Oaxaca (UNIVAS)', oaxaca_de_juarez, privada, alta).
institucion(unidep_oaxaca, 'Universidad del Desarrollo Profesional (UNIDEP)', oaxaca_de_juarez, privada, media).
institucion(ceuni_oaxaca, 'Centro Universitario Interamericano (CEUNI)', oaxaca_de_juarez, privada, media).
institucion(iesit_juchitan, 'Instituto de Estudios Superiores del Istmo (IESIT)', heroica_ciudad_de_juchitan_de_zaragoza, privada, media).
institucion(unimo_oaxaca, 'Universidad Mundo Maya Oaxaca', santa_lucia_del_camino, privada, media).
institucion(ugmex_oaxaca, 'Universidad del Golfo de México (UGMEX Campus Oaxaca)', oaxaca_de_juarez, privada, alta).
institucion(ugmex_huatulco, 'Universidad del Golfo de México (UGMEX Campus Huatulco)', santa_maria_huatulco, privada, media).
institucion(ugmex_tuxtepec, 'Universidad del Golfo de México (UGMEX Campus Tuxtepec)', san_juan_bautista_tuxtepec, privada, media).
institucion(unid_oaxaca, 'Universidad Interamericana para el Desarrollo (UNID Sede Oaxaca)', oaxaca_de_juarez, privada, alta).
institucion(upeo_oaxaca, 'Universidad Privada del Estado de Oaxaca (UPEO)', oaxaca_de_juarez, privada, media).
institucion(cesf_oaxaca, 'Centro Escolar San Felipe (CESF Estudios Superiores)', oaxaca_de_juarez, privada, alta).
institucion(iuo_oaxaca, 'Instituto Universitario de Oaxaca (IUO)', oaxaca_de_juarez, privada, media).
institucion(casandoo_istmo, 'Centro Universitario Casandoo del Istmo', santo_domingo_tehuantepec, privada, media).
institucion(santander_oaxaca, 'Universidad Santander - Campus Oaxaca', oaxaca_de_juarez, privada, media).
institucion(cleu_oaxaca, 'Colegio Libre de Estudios Universitarios (CLEU Oaxaca)', oaxaca_de_juarez, privada, alta).

% =========================================================================
% 3. TABLA: municipio_sede(IdMunicipio, NombreOficial, Region, CostoVidaMes)
% Total de registros: 52 municipios de Oaxaca con costo de vida universitario
% =========================================================================
municipio_sede(oaxaca_de_juarez, 'Oaxaca de Juárez', valles_centrales, 6800).
municipio_sede(santa_cruz_xoxocotlan, 'Santa Cruz Xoxocotlán', valles_centrales, 5500).
municipio_sede(san_juan_bautista_tuxtepec, 'San Juan Bautista Tuxtepec', papaloapan, 5000).
municipio_sede(heroica_ciudad_de_juchitan_de_zaragoza, 'Heroica Ciudad de Juchitán de Zaragoza', istmo, 4800).
municipio_sede(salina_cruz, 'Salina Cruz', istmo, 5400).
municipio_sede(heroica_ciudad_de_huajuapan_de_leon, 'Heroica Ciudad de Huajuapan de León', mixteca, 4600).
municipio_sede(santa_lucia_del_camino, 'Santa Lucía del Camino', valles_centrales, 5800).
municipio_sede(santo_domingo_tehuantepec, 'Santo Domingo Tehuantepec', istmo, 4700).
municipio_sede(santiago_pinotepa_nacional, 'Santiago Pinotepa Nacional', costa, 4900).
municipio_sede(san_pedro_mixtepec, 'San Pedro Mixtepec (Puerto Escondido)', costa, 6200).
municipio_sede(santa_maria_huatulco, 'Santa María Huatulco (Bahías)', costa, 6600).
municipio_sede(san_pedro_pochutla, 'San Pedro Pochutla', costa, 5100).
municipio_sede(heroica_ciudad_de_tlaxiaco, 'Heroica Ciudad de Tlaxiaco', mixteca, 4300).
municipio_sede(ciudad_ixtepec, 'Ciudad Ixtepec', istmo, 4600).
municipio_sede(loma_bonita, 'Loma Bonita', papaloapan, 4400).
municipio_sede(miahuatlan_de_porfirio_diaz, 'Miahuatlán de Porfirio Díaz', sierra_sur, 4200).
municipio_sede(ixtlan_de_juarez, 'Ixtlán de Juárez', sierra_norte, 4100).
municipio_sede(san_pablo_huixtepec, 'San Pablo Huixtepec', valles_centrales, 4300).
municipio_sede(san_raymundo_jalpan, 'San Raymundo Jalpan', valles_centrales, 5200).
municipio_sede(san_sebastian_tutla, 'San Sebastián Tutla', valles_centrales, 5400).
municipio_sede(asuncion_nochixtlan, 'Asunción Nochixtlán', mixteca, 4200).
municipio_sede(villa_de_etla, 'Villa de Etla', valles_centrales, 4600).
municipio_sede(san_pedro_comitancillo, 'San Pedro Comitancillo', istmo, 4100).
municipio_sede(tlacolula_de_matamoros, 'Tlacolula de Matamoros', valles_centrales, 4400).
municipio_sede(santa_maria_atzompa, 'Santa María Atzompa', valles_centrales, 4800).
municipio_sede(san_jacinto_amilpas, 'San Jacinto Amilpas', valles_centrales, 5000).
municipio_sede(san_antonio_de_la_cal, 'San Antonio de la Cal', valles_centrales, 4900).
municipio_sede(villa_de_zaachila, 'Villa de Zaachila', valles_centrales, 4500).
municipio_sede(ocotlan_de_morelos, 'Ocotlán de Morelos', valles_centrales, 4300).
municipio_sede(zimatlan_de_alvarez, 'Zimatlán de Álvarez', valles_centrales, 4300).
municipio_sede(heroica_ciudad_de_ejutla_de_crespo, 'Heroica Ciudad de Ejutla de Crespo', valles_centrales, 4100).
municipio_sede(san_bartolo_coyotepec, 'San Bartolo Coyotepec', valles_centrales, 4700).
municipio_sede(tlalixtac_de_cabrera, 'Tlalixtac de Cabrera', valles_centrales, 4900).
municipio_sede(san_pablo_villa_de_mitla, 'San Pablo Villa de Mitla', valles_centrales, 4300).
municipio_sede(matias_romero_avendano, 'Matías Romero Avendaño', istmo, 4700).
municipio_sede(union_hidalgo, 'Unión Hidalgo', istmo, 4100).
municipio_sede(el_espinos, 'El Espinal', istmo, 4200).
municipio_sede(santa_maria_colotepec, 'Santa María Colotepec', costa, 5900).
municipio_sede(villa_de_tututepec, 'Villa de Tututepec', costa, 4600).
municipio_sede(santa_catarina_juquila, 'Santa Catarina Juquila', costa, 4400).
municipio_sede(san_juan_bautista_valle_nacional, 'San Juan Bautista Valle Nacional', papaloapan, 4200).
municipio_sede(san_jose_chiltepec, 'San José Chiltepec', papaloapan, 4100).
municipio_sede(acatlan_de_perez_figueroa, 'Acatlán de Pérez Figueroa', papaloapan, 4400).
municipio_sede(cosolapa, 'Cosolapa', papaloapan, 4200).
municipio_sede(putla_villa_de_guerrero, 'Putla Villa de Guerrero', sierra_sur, 4300).
municipio_sede(sola_de_vega, 'Villa Sola de Vega', sierra_sur, 4100).
municipio_sede(tamazulapam_del_espiritu_santo, 'Tamazulápam del Espíritu Santo', sierra_norte, 4000).
municipio_sede(capulalpam_de_mendez, 'Capulálpam de Méndez', sierra_norte, 4200).
municipio_sede(teococuilco_de_marcos_perez, 'Teococuilco de Marcos Pérez', sierra_norte, 3900).
municipio_sede(san_juan_bautista_coixtlahuaca, 'San Juan Bautista Coixtlahuaca', mixteca, 4000).
municipio_sede(villa_tejupam_de_la_union, 'Villa Tejúpam de la Unión', mixteca, 4000).
municipio_sede(san_pedro_y_san_pablo_tequixtepec, 'San Pedro y San Pablo Tequixtepec', mixteca, 3900).

% =========================================================================
% 4. TABLA: oferta_academica(IdInstitucion, IdCarrera, Modalidad, Turno)
% Total de registros: Amplia oferta de universidades públicas y privadas
% =========================================================================
oferta_academica(ito_oaxaca, ing_sistemas_computacionales, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(ito_oaxaca, ing_civil, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(ito_oaxaca, ing_mecanica, escolarizada_presencial, matutino).
oferta_academica(ito_oaxaca, ing_electrica, escolarizada_presencial, matutino).
oferta_academica(ito_oaxaca, ing_electronica, escolarizada_presencial, matutino).
oferta_academica(ito_oaxaca, ing_quimica, escolarizada_presencial, matutino).
oferta_academica(ito_oaxaca, ing_industrial, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(ito_oaxaca, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(utm_huajuapan, ing_sistemas_computacionales, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, ing_software, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, ing_inteligencia_artificial, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, ing_mecatronica, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, ing_electronica, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, ing_industrial, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, diseno_industrial, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, matematicas_aplicadas, escolarizada_presencial, tiempo_completo).
oferta_academica(utm_huajuapan, fisica, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_medicina, medicina_humana, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_odontologia, cirujano_dentista, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_enfermeria, enfermeria, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(uabjo_derecho, derecho, escolarizada_presencial, matutino_vespertino_y_sabatino).
oferta_academica(uabjo_contaduria, contaduria_publica, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(uabjo_contaduria, administracion_empresas, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(uabjo_arquitectura_5m, arquitectura, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_idiomas, lenguas_extranjeras, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(uabjo_ciencias, fisica, escolarizada_presencial, matutino).
oferta_academica(uabjo_ciencias, matematicas_aplicadas, escolarizada_presencial, matutino).
oferta_academica(uabjo_artes, artes_plasticas, escolarizada_presencial, matutino).
oferta_academica(uabjo_artes, musica, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_cu, sociologia, escolarizada_presencial, matutino).
oferta_academica(uabjo_cu, antropologia_social, escolarizada_presencial, matutino).
oferta_academica(uabjo_cu, ciencias_politicas, escolarizada_presencial, matutino).
oferta_academica(uabjo_cu, economia, escolarizada_presencial, matutino).
oferta_academica(uabjo_cu, pedagogia, escolarizada_presencial, matutino).
oferta_academica(uabjo_cu, psicologia_clinica, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_cu, medicina_veterinaria, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_cu, biologia, escolarizada_presencial, tiempo_completo).
oferta_academica(uabjo_cu, quimico_farmacobiologo, escolarizada_presencial, tiempo_completo).
oferta_academica(itvo_nazareno, ing_agronomica, escolarizada_presencial, matutino).
oferta_academica(itvo_nazareno, ing_forestal, escolarizada_presencial, matutino).
oferta_academica(itvo_nazareno, ing_ambiental, escolarizada_presencial, matutino).
oferta_academica(itvo_nazareno, biologia, escolarizada_presencial, matutino).
oferta_academica(itvo_nazareno, ing_alimentos, escolarizada_presencial, matutino).
oferta_academica(it_tuxtepec, ing_sistemas_computacionales, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(it_tuxtepec, ing_civil, escolarizada_presencial, matutino).
oferta_academica(it_tuxtepec, ing_quimica, escolarizada_presencial, matutino).
oferta_academica(it_tuxtepec, contaduria_publica, escolarizada_presencial, matutino).
oferta_academica(it_tuxtepec, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(it_salina_cruz, ing_sistemas_computacionales, escolarizada_presencial, matutino).
oferta_academica(it_salina_cruz, ing_quimica, escolarizada_presencial, matutino).
oferta_academica(it_salina_cruz, ing_mecanica, escolarizada_presencial, matutino).
oferta_academica(it_salina_cruz, ing_acuicola, escolarizada_presencial, matutino).
oferta_academica(it_istmo, ing_electrica, escolarizada_presencial, matutino).
oferta_academica(it_istmo, ing_mecanica, escolarizada_presencial, matutino).
oferta_academica(it_istmo, ing_industrial, escolarizada_presencial, matutino).
oferta_academica(it_istmo, ing_sistemas_computacionales, escolarizada_presencial, matutino).
oferta_academica(it_pinotepa, ing_agronomica, escolarizada_presencial, matutino).
oferta_academica(it_pinotepa, ing_sistemas_computacionales, escolarizada_presencial, matutino).
oferta_academica(it_pinotepa, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(it_tlaxiaco, ing_civil, escolarizada_presencial, matutino).
oferta_academica(it_tlaxiaco, ing_sistemas_computacionales, escolarizada_presencial, matutino).
oferta_academica(it_tlaxiaco, ing_industrial, escolarizada_presencial, matutino).
oferta_academica(umar_puerto_escondido, biologia, escolarizada_presencial, tiempo_completo).
oferta_academica(umar_puerto_escondido, ciencias_ambientales, escolarizada_presencial, tiempo_completo).
oferta_academica(umar_puerto_escondido, ing_forestal, escolarizada_presencial, tiempo_completo).
oferta_academica(umar_puerto_angel, ing_acuicola, escolarizada_presencial, tiempo_completo).
oferta_academica(umar_puerto_angel, biologia, escolarizada_presencial, tiempo_completo).
oferta_academica(umar_huatulco, gestion_turistica, escolarizada_presencial, tiempo_completo).
oferta_academica(umar_huatulco, relaciones_internacionales, escolarizada_presencial, tiempo_completo).
oferta_academica(umar_huatulco, comunicacion_periodismo, escolarizada_presencial, tiempo_completo).
oferta_academica(unistmo_tehuantepec, ing_sistemas_computacionales, escolarizada_presencial, tiempo_completo).
oferta_academica(unistmo_tehuantepec, ing_quimica, escolarizada_presencial, tiempo_completo).
oferta_academica(unistmo_ixtepec, administracion_empresas, escolarizada_presencial, tiempo_completo).
oferta_academica(unistmo_ixtepec, derecho, escolarizada_presencial, tiempo_completo).
oferta_academica(unistmo_juchitan, ing_energias_renovables, escolarizada_presencial, tiempo_completo).
oferta_academica(unistmo_juchitan, ing_industrial, escolarizada_presencial, tiempo_completo).
oferta_academica(unpa_tuxtepec, ing_biomedica, escolarizada_presencial, tiempo_completo).
oferta_academica(unpa_tuxtepec, quimico_farmacobiologo, escolarizada_presencial, tiempo_completo).
oferta_academica(unpa_loma_bonita, ing_alimentos, escolarizada_presencial, tiempo_completo).
oferta_academica(unpa_loma_bonita, matematicas_aplicadas, escolarizada_presencial, tiempo_completo).
oferta_academica(unsij_ixtlan, ing_forestal, escolarizada_presencial, tiempo_completo).
oferta_academica(unsij_ixtlan, ciencias_ambientales, escolarizada_presencial, tiempo_completo).
oferta_academica(unsij_ixtlan, ing_sistemas_computacionales, escolarizada_presencial, tiempo_completo).
oferta_academica(unsis_miahuatlan, medicina_humana, escolarizada_presencial, tiempo_completo).
oferta_academica(unsis_miahuatlan, enfermeria, escolarizada_presencial, tiempo_completo).
oferta_academica(unsis_miahuatlan, nutricion_clinica, escolarizada_presencial, tiempo_completo).
oferta_academica(unsis_miahuatlan, ciencias_politicas, escolarizada_presencial, tiempo_completo).
oferta_academica(utvco_huixtepec, gastronomia, escolarizada_presencial, matutino).
oferta_academica(utvco_huixtepec, ing_energias_renovables, escolarizada_presencial, matutino).
oferta_academica(utvco_huixtepec, mercadotecnia_digital, escolarizada_presencial, matutino).
oferta_academica(anahuac_oaxaca, medicina_humana, escolarizada_presencial, tiempo_completo).
oferta_academica(anahuac_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(anahuac_oaxaca, comercio_internacional, escolarizada_presencial, matutino).
oferta_academica(anahuac_oaxaca, mercadotecnia_digital, escolarizada_presencial, matutino).
oferta_academica(anahuac_oaxaca, arquitectura, escolarizada_presencial, tiempo_completo).
oferta_academica(anahuac_oaxaca, psicologia_clinica, escolarizada_presencial, matutino).
oferta_academica(anahuac_oaxaca, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(anahuac_oaxaca, comunicacion_periodismo, escolarizada_presencial, matutino).
oferta_academica(anahuac_oaxaca, ing_industrial, escolarizada_presencial, matutino).
oferta_academica(lasalle_oaxaca, ing_software, escolarizada_presencial, matutino).
oferta_academica(lasalle_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(lasalle_oaxaca, fisioterapia, escolarizada_presencial, tiempo_completo).
oferta_academica(lasalle_oaxaca, arquitectura, escolarizada_presencial, tiempo_completo).
oferta_academica(lasalle_oaxaca, diseno_grafico, escolarizada_presencial, matutino).
oferta_academica(lasalle_oaxaca, comercio_internacional, escolarizada_presencial, matutino).
oferta_academica(lasalle_oaxaca, lenguas_extranjeras, escolarizada_presencial, matutino).
oferta_academica(lasalle_oaxaca, nutricion_clinica, escolarizada_presencial, matutino).
oferta_academica(urse_oaxaca, medicina_humana, escolarizada_presencial, tiempo_completo).
oferta_academica(urse_oaxaca, cirujano_dentista, escolarizada_presencial, tiempo_completo).
oferta_academica(urse_oaxaca, nutricion_clinica, escolarizada_presencial, matutino).
oferta_academica(urse_oaxaca, enfermeria, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(urse_oaxaca, psicologia_clinica, escolarizada_presencial, matutino).
oferta_academica(urse_oaxaca, fisioterapia, escolarizada_presencial, tiempo_completo).
oferta_academica(urse_aleman, derecho, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(urse_aleman, contaduria_publica, escolarizada_presencial, matutino).
oferta_academica(urse_aleman, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(urse_aleman, pedagogia, escolarizada_presencial, matutino).
oferta_academica(mesoamericana_oaxaca, medicina_veterinaria, escolarizada_presencial, tiempo_completo).
oferta_academica(mesoamericana_oaxaca, cirujano_dentista, escolarizada_presencial, tiempo_completo).
oferta_academica(mesoamericana_oaxaca, comunicacion_periodismo, escolarizada_presencial, matutino).
oferta_academica(mesoamericana_oaxaca, diseno_grafico, escolarizada_presencial, matutino).
oferta_academica(mesoamericana_oaxaca, gastronomia, escolarizada_presencial, matutino).
oferta_academica(mesoamericana_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(univas_oaxaca, relaciones_internacionales, escolarizada_presencial, matutino).
oferta_academica(univas_oaxaca, ciencias_politicas, escolarizada_presencial, matutino).
oferta_academica(univas_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(univas_oaxaca, mercadotecnia_digital, escolarizada_presencial, matutino).
oferta_academica(univas_oaxaca, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(unidep_oaxaca, derecho, escolarizada_presencial, matutino_y_sabatino).
oferta_academica(unidep_oaxaca, administracion_empresas, escolarizada_presencial, matutino_y_sabatino).
oferta_academica(unidep_oaxaca, contaduria_publica, escolarizada_presencial, matutino_y_sabatino).
oferta_academica(unidep_oaxaca, diseno_grafico, escolarizada_presencial, matutino).
oferta_academica(ceuni_oaxaca, cirujano_dentista, escolarizada_presencial, tiempo_completo).
oferta_academica(ceuni_oaxaca, fisioterapia, escolarizada_presencial, tiempo_completo).
oferta_academica(ceuni_oaxaca, nutricion_clinica, escolarizada_presencial, matutino).
oferta_academica(ceuni_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(ugmex_oaxaca, derecho, escolarizada_presencial, matutino_y_sabatino).
oferta_academica(ugmex_oaxaca, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(ugmex_oaxaca, ing_sistemas_computacionales, escolarizada_presencial, matutino).
oferta_academica(ugmex_oaxaca, pedagogia, escolarizada_presencial, matutino).
oferta_academica(ugmex_oaxaca, gestion_turistica, escolarizada_presencial, matutino).
oferta_academica(ugmex_huatulco, gestion_turistica, escolarizada_presencial, matutino).
oferta_academica(ugmex_huatulco, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(ugmex_huatulco, gastronomia, escolarizada_presencial, matutino).
oferta_academica(ugmex_tuxtepec, derecho, escolarizada_presencial, matutino).
oferta_academica(ugmex_tuxtepec, contaduria_publica, escolarizada_presencial, matutino).
oferta_academica(ugmex_tuxtepec, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(unid_oaxaca, derecho, escolarizada_presencial, matutino_y_vespertino).
oferta_academica(unid_oaxaca, mercadotecnia_digital, escolarizada_presencial, matutino).
oferta_academica(unid_oaxaca, ciencias_politicas, escolarizada_presencial, matutino).
oferta_academica(unid_oaxaca, ing_software, escolarizada_presencial, matutino).
oferta_academica(unid_oaxaca, educacion_especial, escolarizada_presencial, matutino).
oferta_academica(eneeo_oaxaca, educacion_especial, escolarizada_presencial, matutino).
oferta_academica(eneop_oaxaca, pedagogia, escolarizada_presencial, matutino).
oferta_academica(benelly_ixtepec, pedagogia, escolarizada_presencial, matutino).
oferta_academica(enbio_oaxaca, pedagogia, escolarizada_presencial, matutino).
oferta_academica(uabjo_terapia_fisica, fisioterapia, escolarizada_presencial, tiempo_completo).
oferta_academica(anahuac_oaxaca, fisioterapia, escolarizada_presencial, tiempo_completo).
oferta_academica(iesit_juchitan, derecho, escolarizada_presencial, matutino_y_sabatino).
oferta_academica(iesit_juchitan, contaduria_publica, escolarizada_presencial, matutino).
oferta_academica(iesit_juchitan, ing_sistemas_computacionales, escolarizada_presencial, matutino).
oferta_academica(iesit_juchitan, enfermeria, escolarizada_presencial, tiempo_completo).
oferta_academica(casandoo_istmo, derecho, escolarizada_presencial, matutino_y_sabatino).
oferta_academica(casandoo_istmo, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(casandoo_istmo, pedagogia, escolarizada_presencial, matutino).
oferta_academica(unimo_oaxaca, gestion_turistica, escolarizada_presencial, matutino).
oferta_academica(unimo_oaxaca, gastronomia, escolarizada_presencial, matutino).
oferta_academica(unimo_oaxaca, comercio_internacional, escolarizada_presencial, matutino).
oferta_academica(upeo_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(upeo_oaxaca, contaduria_publica, escolarizada_presencial, matutino).
oferta_academica(cesf_oaxaca, psicologia_clinica, escolarizada_presencial, matutino).
oferta_academica(cesf_oaxaca, pedagogia, escolarizada_presencial, matutino).
oferta_academica(iuo_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(iuo_oaxaca, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(santander_oaxaca, pedagogia, escolarizada_presencial, matutino_y_sabatino).
oferta_academica(santander_oaxaca, administracion_empresas, escolarizada_presencial, matutino).
oferta_academica(cleu_oaxaca, derecho, escolarizada_presencial, matutino).
oferta_academica(cleu_oaxaca, psicologia_clinica, escolarizada_presencial, matutino).

% =========================================================================
% 5. TABLA: perfil_holland(IdCarrera, Realista, Investigador, Artistico, Social, Emprendedor, Convencional)
% Escala psicométrica de 1 a 10 en cada dimensión vocacional (Holland RIASEC)
% Total de registros: 55 perfiles profesionales evaluados
% =========================================================================
perfil_holland(ing_sistemas_computacionales, 6, 9, 4, 3, 5, 8).
perfil_holland(ing_software, 5, 10, 5, 4, 6, 8).
perfil_holland(ing_inteligencia_artificial, 5, 10, 4, 3, 6, 8).
perfil_holland(ing_civil, 8, 8, 5, 3, 6, 7).
perfil_holland(ing_mecanica, 9, 8, 3, 2, 5, 7).
perfil_holland(ing_electrica, 9, 8, 3, 2, 5, 7).
perfil_holland(ing_mecatronica, 8, 9, 4, 2, 6, 7).
perfil_holland(ing_industrial, 5, 6, 3, 5, 9, 9).
perfil_holland(ing_quimica, 6, 9, 2, 2, 5, 8).
perfil_holland(ing_electronica, 8, 9, 4, 2, 5, 7).
perfil_holland(ing_telecomunicaciones, 7, 8, 3, 3, 5, 8).
perfil_holland(ing_biomedica, 6, 9, 3, 6, 5, 7).
perfil_holland(ing_ambiental, 6, 8, 4, 6, 6, 6).
perfil_holland(ing_energias_renovables, 7, 8, 3, 4, 7, 6).
perfil_holland(ing_geologia, 8, 8, 2, 2, 5, 6).
perfil_holland(ing_alimentos, 6, 8, 3, 4, 6, 8).
perfil_holland(ing_agronomica, 9, 7, 2, 4, 6, 6).
perfil_holland(ing_forestal, 9, 8, 3, 4, 5, 6).
perfil_holland(ing_acuicola, 8, 8, 2, 4, 5, 6).
perfil_holland(medicina_humana, 5, 10, 3, 9, 5, 6).
perfil_holland(cirujano_dentista, 7, 8, 5, 7, 5, 6).
perfil_holland(enfermeria, 4, 6, 2, 10, 4, 7).
perfil_holland(nutricion_clinica, 3, 7, 3, 9, 6, 7).
perfil_holland(fisioterapia, 6, 7, 3, 9, 4, 6).
perfil_holland(quimico_farmacobiologo, 5, 10, 2, 4, 3, 9).
perfil_holland(psicologia_clinica, 2, 8, 4, 10, 5, 5).
perfil_holland(medicina_veterinaria, 8, 8, 2, 7, 5, 6).
perfil_holland(derecho, 2, 6, 4, 7, 9, 8).
perfil_holland(administracion_empresas, 3, 4, 3, 6, 10, 9).
perfil_holland(contaduria_publica, 2, 5, 2, 4, 7, 10).
perfil_holland(comercio_internacional, 3, 5, 3, 5, 10, 8).
perfil_holland(mercadotecnia_digital, 2, 5, 8, 6, 10, 6).
perfil_holland(gestion_turistica, 3, 4, 5, 8, 9, 7).
perfil_holland(gastronomia, 7, 4, 9, 6, 8, 5).
perfil_holland(economia, 2, 9, 2, 4, 8, 9).
perfil_holland(ciencias_politicas, 2, 7, 3, 8, 9, 6).
perfil_holland(relaciones_internacionales, 2, 6, 4, 7, 9, 6).
perfil_holland(comunicacion_periodismo, 2, 5, 8, 8, 8, 5).
perfil_holland(sociologia, 2, 9, 3, 9, 5, 5).
perfil_holland(antropologia_social, 3, 9, 4, 9, 4, 5).
perfil_holland(pedagogia, 2, 6, 4, 10, 5, 7).
perfil_holland(educacion_especial, 2, 6, 4, 10, 4, 7).
perfil_holland(arquitectura, 6, 7, 10, 4, 6, 6).
perfil_holland(diseno_grafico, 3, 4, 10, 4, 6, 5).
perfil_holland(diseno_industrial, 6, 6, 9, 3, 6, 6).
perfil_holland(artes_plasticas, 4, 3, 10, 3, 4, 3).
perfil_holland(musica, 4, 4, 10, 4, 4, 4).
perfil_holland(filosofia, 1, 10, 5, 5, 3, 4).
perfil_holland(historia, 2, 9, 4, 5, 3, 6).
perfil_holland(lenguas_extranjeras, 2, 6, 5, 8, 6, 6).
perfil_holland(matematicas_aplicadas, 3, 10, 3, 2, 4, 9).
perfil_holland(fisica, 4, 10, 3, 2, 3, 8).
perfil_holland(biologia, 5, 9, 3, 5, 3, 7).
perfil_holland(ciencias_ambientales, 5, 8, 4, 6, 5, 7).
perfil_holland(actuaria, 2, 9, 2, 2, 7, 10).

% =========================================================================
% 6. TABLA: mercado_laboral(IdCarrera, SueldoPromedioMXN, EmpleabilidadPct, Demanda, Sector)
% Total de registros: 55 carreras analizadas
% =========================================================================
mercado_laboral(ing_sistemas_computacionales, 22000, 92, muy_alta, tecnologia_software).
mercado_laboral(ing_software, 24500, 94, muy_alta, tecnologia_software).
mercado_laboral(ing_inteligencia_artificial, 28000, 96, muy_alta, tecnologia_software).
mercado_laboral(ing_civil, 20500, 85, alta, construccion_e_infraestructura).
mercado_laboral(ing_mecanica, 19500, 83, alta, manufactura_y_automotriz).
mercado_laboral(ing_electrica, 20000, 84, alta, energia_y_redes).
mercado_laboral(ing_mecatronica, 21500, 88, muy_alta, automatizacion_y_robotica).
mercado_laboral(ing_industrial, 19000, 86, alta, gestion_y_manufactura).
mercado_laboral(ing_quimica, 20000, 80, moderada, procesos_industriales).
mercado_laboral(ing_electronica, 21000, 85, alta, hardware_y_telecom).
mercado_laboral(ing_telecomunicaciones, 21500, 87, alta, redes_y_comunicaciones).
mercado_laboral(ing_biomedica, 23000, 84, alta, equipamiento_hospitalario).
mercado_laboral(ing_ambiental, 16500, 75, moderada, sustentabilidad_y_gobierno).
mercado_laboral(ing_energias_renovables, 21000, 82, alta, energia_solar_y_eolica).
mercado_laboral(ing_geologia, 24000, 78, moderada, mineria_y_exploracion).
mercado_laboral(ing_alimentos, 16000, 76, moderada, agroindustria).
mercado_laboral(ing_agronomica, 16500, 78, alta, sector_agropecuario).
mercado_laboral(ing_forestal, 16000, 72, moderada, recursos_naturales).
mercado_laboral(ing_acuicola, 17000, 74, moderada, pesca_y_piscicultura).
mercado_laboral(medicina_humana, 26000, 95, muy_alta, salud_publica_y_privada).
mercado_laboral(cirujano_dentista, 21000, 80, moderada, salud_dental_privada).
mercado_laboral(enfermeria, 15500, 91, muy_alta, hospitalario_y_clinico).
mercado_laboral(nutricion_clinica, 14500, 72, moderada, consulta_y_deporte).
mercado_laboral(fisioterapia, 16000, 79, alta, rehabilitacion_fisica).
mercado_laboral(quimico_farmacobiologo, 19500, 88, alta, laboratorio_clinico_y_farmaceutico).
mercado_laboral(psicologia_clinica, 14000, 71, moderada, salud_mental_y_educacion).
mercado_laboral(medicina_veterinaria, 17500, 77, alta, clinica_animal_y_campo).
mercado_laboral(derecho, 18500, 78, moderada, poder_judicial_y_litigio).
mercado_laboral(administracion_empresas, 15500, 79, estable, corporativo_y_pymes).
mercado_laboral(contaduria_publica, 18000, 87, alta, auditoria_y_finanzas).
mercado_laboral(comercio_internacional, 19000, 80, alta, aduanas_y_logistica).
mercado_laboral(mercadotecnia_digital, 17500, 82, alta, marketing_digital_e_commerce).
mercado_laboral(gestion_turistica, 15000, 75, moderada, hoteleria_y_turismo).
mercado_laboral(gastronomia, 16000, 78, alta, restaurantes_y_hospitalidad).
mercado_laboral(economia, 21000, 81, alta, banca_y_politica_fiscal).
mercado_laboral(ciencias_politicas, 16500, 70, estable, gobierno_y_ong).
mercado_laboral(relaciones_internacionales, 19500, 73, moderada, diplomacia_y_comercio).
mercado_laboral(comunicacion_periodismo, 14000, 68, estable, medios_digitales_y_prensa).
mercado_laboral(sociologia, 13500, 65, estable, investigacion_social).
mercado_laboral(antropologia_social, 14000, 67, estable, patrimonio_e_indigenismo).
mercado_laboral(pedagogia, 13800, 78, alta, sistema_educativo).
mercado_laboral(educacion_especial, 14200, 82, alta, inclusion_y_educacion).
mercado_laboral(arquitectura, 19500, 79, alta, despacho_arquitectonico).
mercado_laboral(diseno_grafico, 14500, 74, moderada, agencias_creativas_y_freelance).
mercado_laboral(diseno_industrial, 18000, 76, alta, diseno_de_producto_y_muebles).
mercado_laboral(artes_plasticas, 12500, 58, baja, galerias_y_docencia_artistica).
mercado_laboral(musica, 13000, 60, moderada, orquestas_y_ensenanza).
mercado_laboral(filosofia, 12000, 55, baja, investigacion_y_docencia).
mercado_laboral(historia, 12500, 58, baja, archivos_y_docencia).
mercado_laboral(lenguas_extranjeras, 16000, 82, alta, traduccion_y_colegios).
mercado_laboral(matematicas_aplicadas, 25000, 92, muy_alta, ciencia_de_datos_y_finanzas).
mercado_laboral(fisica, 22000, 82, alta, investigacion_y_semiconductores).
mercado_laboral(biologia, 15500, 72, moderada, conservacion_y_laboratorio).
mercado_laboral(ciencias_ambientales, 16000, 75, moderada, consultoria_ambiental).
mercado_laboral(actuaria, 29000, 95, muy_alta, aseguradoras_y_banca_de_inversion).

% =========================================================================
% 7. TABLA: requisito_admision(IdInstitucion, IdCarrera, PromedioMinimo, TipoExamen, CorteExani)
% Requisitos académicos y puntajes de corte por universidad pública y privada
% =========================================================================
requisito_admision(ito_oaxaca, ing_sistemas_computacionales, 7.5, evaluatec, 72).
requisito_admision(ito_oaxaca, ing_civil, 7.5, evaluatec, 72).
requisito_admision(ito_oaxaca, ing_mecanica, 7.0, evaluatec, 58).
requisito_admision(ito_oaxaca, ing_electrica, 7.0, evaluatec, 65).
requisito_admision(ito_oaxaca, ing_electronica, 7.0, evaluatec, 65).
requisito_admision(ito_oaxaca, ing_quimica, 7.0, evaluatec, 65).
requisito_admision(ito_oaxaca, ing_industrial, 7.0, evaluatec, 65).
requisito_admision(ito_oaxaca, administracion_empresas, 7.0, evaluatec, 58).
requisito_admision(utm_huajuapan, ing_sistemas_computacionales, 7.5, examen_suneo, 65).
requisito_admision(utm_huajuapan, ing_software, 8.0, examen_suneo, 70).
requisito_admision(utm_huajuapan, ing_inteligencia_artificial, 8.0, examen_suneo, 70).
requisito_admision(utm_huajuapan, ing_mecatronica, 8.0, examen_suneo, 70).
requisito_admision(utm_huajuapan, ing_electronica, 7.0, examen_suneo, 60).
requisito_admision(utm_huajuapan, ing_industrial, 7.0, examen_suneo, 60).
requisito_admision(utm_huajuapan, diseno_industrial, 7.0, examen_suneo, 60).
requisito_admision(utm_huajuapan, matematicas_aplicadas, 7.0, examen_suneo, 60).
requisito_admision(utm_huajuapan, fisica, 7.0, examen_suneo, 60).
requisito_admision(uabjo_medicina, medicina_humana, 8.5, exani_ii_uabjo, 1260).
requisito_admision(uabjo_odontologia, cirujano_dentista, 7.5, exani_ii_uabjo, 1150).
requisito_admision(uabjo_enfermeria, enfermeria, 7.5, exani_ii_uabjo, 1150).
requisito_admision(uabjo_derecho, derecho, 7.5, exani_ii_uabjo, 1110).
requisito_admision(uabjo_contaduria, contaduria_publica, 7.5, exani_ii_uabjo, 1110).
requisito_admision(uabjo_contaduria, administracion_empresas, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_arquitectura_5m, arquitectura, 7.5, exani_ii_uabjo, 1110).
requisito_admision(uabjo_idiomas, lenguas_extranjeras, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_ciencias, fisica, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_ciencias, matematicas_aplicadas, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_artes, artes_plasticas, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_artes, musica, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, sociologia, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, antropologia_social, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, ciencias_politicas, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, economia, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, pedagogia, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, psicologia_clinica, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, medicina_veterinaria, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, biologia, 7.0, exani_ii_uabjo, 1030).
requisito_admision(uabjo_cu, quimico_farmacobiologo, 7.5, exani_ii_uabjo, 1150).
requisito_admision(itvo_nazareno, ing_agronomica, 7.0, evaluatec, 58).
requisito_admision(itvo_nazareno, ing_forestal, 7.0, evaluatec, 58).
requisito_admision(itvo_nazareno, ing_ambiental, 7.0, evaluatec, 58).
requisito_admision(itvo_nazareno, biologia, 7.0, evaluatec, 58).
requisito_admision(itvo_nazareno, ing_alimentos, 7.0, evaluatec, 58).
requisito_admision(it_tuxtepec, ing_sistemas_computacionales, 7.5, evaluatec, 72).
requisito_admision(it_tuxtepec, ing_civil, 7.5, evaluatec, 72).
requisito_admision(it_tuxtepec, ing_quimica, 7.0, evaluatec, 65).
requisito_admision(it_tuxtepec, contaduria_publica, 7.0, evaluatec, 58).
requisito_admision(it_tuxtepec, administracion_empresas, 7.0, evaluatec, 58).
requisito_admision(it_salina_cruz, ing_sistemas_computacionales, 7.5, evaluatec, 72).
requisito_admision(it_salina_cruz, ing_quimica, 7.0, evaluatec, 65).
requisito_admision(it_salina_cruz, ing_mecanica, 7.0, evaluatec, 58).
requisito_admision(it_salina_cruz, ing_acuicola, 7.0, evaluatec, 58).
requisito_admision(it_istmo, ing_electrica, 7.0, evaluatec, 65).
requisito_admision(it_istmo, ing_mecanica, 7.0, evaluatec, 58).
requisito_admision(it_istmo, ing_industrial, 7.0, evaluatec, 65).
requisito_admision(it_istmo, ing_sistemas_computacionales, 7.5, evaluatec, 72).
requisito_admision(it_pinotepa, ing_agronomica, 7.0, evaluatec, 58).
requisito_admision(it_pinotepa, ing_sistemas_computacionales, 7.5, evaluatec, 72).
requisito_admision(it_pinotepa, administracion_empresas, 7.0, evaluatec, 58).
requisito_admision(it_tlaxiaco, ing_civil, 7.5, evaluatec, 72).
requisito_admision(it_tlaxiaco, ing_sistemas_computacionales, 7.5, evaluatec, 72).
requisito_admision(it_tlaxiaco, ing_industrial, 7.0, evaluatec, 65).
requisito_admision(umar_puerto_escondido, biologia, 7.0, examen_suneo, 60).
requisito_admision(umar_puerto_escondido, ciencias_ambientales, 7.0, examen_suneo, 60).
requisito_admision(umar_puerto_escondido, ing_forestal, 7.0, examen_suneo, 60).
requisito_admision(umar_puerto_angel, ing_acuicola, 7.0, examen_suneo, 60).
requisito_admision(umar_puerto_angel, biologia, 7.0, examen_suneo, 60).
requisito_admision(umar_huatulco, gestion_turistica, 7.0, examen_suneo, 60).
requisito_admision(umar_huatulco, relaciones_internacionales, 7.0, examen_suneo, 60).
requisito_admision(umar_huatulco, comunicacion_periodismo, 7.0, examen_suneo, 60).
requisito_admision(unistmo_tehuantepec, ing_sistemas_computacionales, 7.5, examen_suneo, 65).
requisito_admision(unistmo_tehuantepec, ing_quimica, 7.0, examen_suneo, 60).
requisito_admision(unistmo_ixtepec, administracion_empresas, 7.0, examen_suneo, 60).
requisito_admision(unistmo_ixtepec, derecho, 7.0, examen_suneo, 60).
requisito_admision(unistmo_juchitan, ing_energias_renovables, 7.0, examen_suneo, 60).
requisito_admision(unistmo_juchitan, ing_industrial, 7.0, examen_suneo, 60).
requisito_admision(unpa_tuxtepec, ing_biomedica, 7.5, examen_suneo, 65).
requisito_admision(unpa_tuxtepec, quimico_farmacobiologo, 7.0, examen_suneo, 60).
requisito_admision(unpa_loma_bonita, ing_alimentos, 7.0, examen_suneo, 60).
requisito_admision(unpa_loma_bonita, matematicas_aplicadas, 7.0, examen_suneo, 60).
requisito_admision(unsij_ixtlan, ing_forestal, 7.0, examen_suneo, 60).
requisito_admision(unsij_ixtlan, ciencias_ambientales, 7.0, examen_suneo, 60).
requisito_admision(unsij_ixtlan, ing_sistemas_computacionales, 7.5, examen_suneo, 65).
requisito_admision(unsis_miahuatlan, medicina_humana, 8.0, examen_suneo, 70).
requisito_admision(unsis_miahuatlan, enfermeria, 7.5, examen_suneo, 65).
requisito_admision(unsis_miahuatlan, nutricion_clinica, 7.0, examen_suneo, 60).
requisito_admision(unsis_miahuatlan, ciencias_politicas, 7.0, examen_suneo, 60).
requisito_admision(utvco_huixtepec, gastronomia, 7.0, examen_suneo, 60).
requisito_admision(utvco_huixtepec, ing_energias_renovables, 7.0, examen_suneo, 60).
requisito_admision(utvco_huixtepec, mercadotecnia_digital, 7.0, examen_suneo, 60).
requisito_admision(anahuac_oaxaca, medicina_humana, 8.0, paa_anahuac, 80).
requisito_admision(anahuac_oaxaca, derecho, 7.5, paa_anahuac, 70).
requisito_admision(anahuac_oaxaca, comercio_internacional, 7.5, paa_anahuac, 70).
requisito_admision(anahuac_oaxaca, mercadotecnia_digital, 7.5, paa_anahuac, 70).
requisito_admision(anahuac_oaxaca, arquitectura, 7.5, paa_anahuac, 70).
requisito_admision(anahuac_oaxaca, psicologia_clinica, 7.5, paa_anahuac, 70).
requisito_admision(anahuac_oaxaca, administracion_empresas, 7.5, paa_anahuac, 70).
requisito_admision(anahuac_oaxaca, comunicacion_periodismo, 7.5, paa_anahuac, 70).
requisito_admision(anahuac_oaxaca, ing_industrial, 7.5, paa_anahuac, 70).
requisito_admision(lasalle_oaxaca, ing_software, 7.0, examen_diagnostico_privada, 60).
requisito_admision(lasalle_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(lasalle_oaxaca, fisioterapia, 7.5, examen_diagnostico_privada, 75).
requisito_admision(lasalle_oaxaca, arquitectura, 7.0, examen_diagnostico_privada, 60).
requisito_admision(lasalle_oaxaca, diseno_grafico, 7.0, examen_diagnostico_privada, 60).
requisito_admision(lasalle_oaxaca, comercio_internacional, 7.0, examen_diagnostico_privada, 60).
requisito_admision(lasalle_oaxaca, lenguas_extranjeras, 7.0, examen_diagnostico_privada, 60).
requisito_admision(lasalle_oaxaca, nutricion_clinica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(urse_oaxaca, medicina_humana, 7.5, examen_diagnostico_privada, 75).
requisito_admision(urse_oaxaca, cirujano_dentista, 7.5, examen_diagnostico_privada, 75).
requisito_admision(urse_oaxaca, nutricion_clinica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(urse_oaxaca, enfermeria, 7.0, examen_diagnostico_privada, 60).
requisito_admision(urse_oaxaca, psicologia_clinica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(urse_oaxaca, fisioterapia, 7.5, examen_diagnostico_privada, 75).
requisito_admision(urse_aleman, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(urse_aleman, contaduria_publica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(urse_aleman, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(urse_aleman, pedagogia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(mesoamericana_oaxaca, medicina_veterinaria, 7.0, examen_diagnostico_privada, 60).
requisito_admision(mesoamericana_oaxaca, cirujano_dentista, 7.5, examen_diagnostico_privada, 75).
requisito_admision(mesoamericana_oaxaca, comunicacion_periodismo, 7.0, examen_diagnostico_privada, 60).
requisito_admision(mesoamericana_oaxaca, diseno_grafico, 7.0, examen_diagnostico_privada, 60).
requisito_admision(mesoamericana_oaxaca, gastronomia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(mesoamericana_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(univas_oaxaca, relaciones_internacionales, 7.0, examen_diagnostico_privada, 60).
requisito_admision(univas_oaxaca, ciencias_politicas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(univas_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(univas_oaxaca, mercadotecnia_digital, 7.0, examen_diagnostico_privada, 60).
requisito_admision(univas_oaxaca, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unidep_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unidep_oaxaca, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unidep_oaxaca, contaduria_publica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unidep_oaxaca, diseno_grafico, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ceuni_oaxaca, cirujano_dentista, 7.5, examen_diagnostico_privada, 75).
requisito_admision(ceuni_oaxaca, fisioterapia, 7.5, examen_diagnostico_privada, 75).
requisito_admision(ceuni_oaxaca, nutricion_clinica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ceuni_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_oaxaca, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_oaxaca, ing_sistemas_computacionales, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_oaxaca, pedagogia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_oaxaca, gestion_turistica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_huatulco, gestion_turistica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_huatulco, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_huatulco, gastronomia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_tuxtepec, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_tuxtepec, contaduria_publica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(ugmex_tuxtepec, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unid_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unid_oaxaca, mercadotecnia_digital, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unid_oaxaca, ciencias_politicas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unid_oaxaca, ing_software, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unid_oaxaca, educacion_especial, 7.0, examen_diagnostico_privada, 60).
requisito_admision(eneeo_oaxaca, educacion_especial, 8.0, exani_ii_normales, 1090).
requisito_admision(eneop_oaxaca, pedagogia, 8.0, exani_ii_normales, 1090).
requisito_admision(benelly_ixtepec, pedagogia, 8.0, exani_ii_normales, 1090).
requisito_admision(enbio_oaxaca, pedagogia, 8.0, exani_ii_normales, 1090).
requisito_admision(uabjo_terapia_fisica, fisioterapia, 7.0, exani_ii_uabjo, 1030).
requisito_admision(anahuac_oaxaca, fisioterapia, 7.5, paa_anahuac, 70).
requisito_admision(iesit_juchitan, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(iesit_juchitan, contaduria_publica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(iesit_juchitan, ing_sistemas_computacionales, 7.0, examen_diagnostico_privada, 60).
requisito_admision(iesit_juchitan, enfermeria, 7.0, examen_diagnostico_privada, 60).
requisito_admision(casandoo_istmo, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(casandoo_istmo, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(casandoo_istmo, pedagogia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unimo_oaxaca, gestion_turistica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unimo_oaxaca, gastronomia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(unimo_oaxaca, comercio_internacional, 7.0, examen_diagnostico_privada, 60).
requisito_admision(upeo_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(upeo_oaxaca, contaduria_publica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(cesf_oaxaca, psicologia_clinica, 7.0, examen_diagnostico_privada, 60).
requisito_admision(cesf_oaxaca, pedagogia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(iuo_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(iuo_oaxaca, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(santander_oaxaca, pedagogia, 7.0, examen_diagnostico_privada, 60).
requisito_admision(santander_oaxaca, administracion_empresas, 7.0, examen_diagnostico_privada, 60).
requisito_admision(cleu_oaxaca, derecho, 7.0, examen_diagnostico_privada, 60).
requisito_admision(cleu_oaxaca, psicologia_clinica, 7.0, examen_diagnostico_privada, 60).

% =========================================================================
% 8. TABLA: programa_beca(IdBeca, NombreBeca, TipoBeca, PromedioMinimo, MontoMensualMXN)
% Total de registros: 50 programas de apoyo económico, manutención y colegiatura
% =========================================================================
programa_beca(beca_jovenes_escribiendo_futuro, 'Beca para el Bienestar Benito Juárez (Jóvenes Escribiendo el Futuro)', manutencion_federal, 7.0, 2800).
programa_beca(beca_santander_excelencia, 'Beca Santander de Excelencia Académica', excelencia_academica, 9.0, 5000).
programa_beca(beca_santander_conectividad, 'Beca Santander de Apoyo a la Conectividad e Informática', apoyo_tecnologico, 8.0, 1500).
programa_beca(beca_fundacion_bbva, 'Beca Fundación BBVA para Chavos que Inspiran', manutencion_integral, 8.5, 3500).
programa_beca(beca_telmex_telcel, 'Beca Fundación Telmex Telcel para Estudiantes Sobresalientes', excelencia_y_equipo, 9.0, 2500).
programa_beca(beca_conahcyt_licenciatura, 'Beca CONAHCYT de Iniciación a la Investigación Científica', investigacion_cientifica, 8.5, 4000).
programa_beca(beca_movilidad_oaxaca, 'Beca de Movilidad Estudiantil Nacional e Internacional Oaxaca', movilidad_academica, 8.5, 6000).
programa_beca(beca_elisa_acuna_servicio, 'Beca Elisa Acuña de Apoyo a la Práctica y Servicio Social', servicio_social, 7.5, 2000).
programa_beca(beca_elisa_acuna_titulacion, 'Beca Elisa Acuña para Inicio y Conclusión de Titulación', titulacion, 8.0, 2500).
programa_beca(beca_manutencion_uabjo, 'Beca de Manutención y Comedor Universitario UABJO', alimenticia, 7.5, 1200).
programa_beca(beca_exencion_cuotas_uabjo, 'Exención Total de Cuotas de Reinscripción UABJO', exencion_cuotas, 8.5, 1000).
programa_beca(beca_deportiva_uabjo, 'Beca al Talento Deportivo Universitario UABJO', deportiva, 7.5, 1500).
programa_beca(beca_cultural_uabjo, 'Beca de Promoción Cultural y Artística UABJO', cultural, 7.5, 1500).
programa_beca(beca_suneo_colegiatura, 'Beca de Colegiatura y Alimentos Sistema SUNEO', manutencion_integral, 8.0, 1800).
programa_beca(beca_suneo_albergue, 'Beca de Hospedaje y Casa de Estudiantes SUNEO', hospedaje, 7.5, 1400).
programa_beca(beca_tecnm_manutencion, 'Beca de Manutención Institutos Tecnológicos TecNM', manutencion_federal, 7.0, 2000).
programa_beca(beca_tecnm_excelencia, 'Beca al Mérito Académico TecNM', excelencia_academica, 9.2, 3000).
programa_beca(beca_anahuac_excelencia, 'Beca de Excelencia Académica Anáhuac (80% Colegiatura)', colegiatura_privada, 9.5, 8000).
programa_beca(beca_anahuac_socioeconomica, 'Beca de Apoyo Socioeconómico Anáhuac', colegiatura_privada, 8.5, 5000).
programa_beca(beca_lasalle_san_juan_bautista, 'Beca San Juan Bautista De La Salle', colegiatura_privada, 8.8, 4500).
programa_beca(beca_lasalle_fraternidad, 'Beca Fraternidad La Salle de Asistencia Familiar', colegiatura_privada, 8.0, 3000).
programa_beca(beca_urse_academica, 'Beca de Rendimiento Escolar URSE', colegiatura_privada, 8.5, 2500).
programa_beca(beca_mujeres_en_la_ciencia, 'Beca Nacional Mujeres en la Ciencia y Tecnología (STEM)', genero_y_stem, 8.5, 3800).
programa_beca(beca_pueblos_indigenas_inpi, 'Beca INPI para Estudiantes Indígenas y Afromexicanos', inclusion_social, 7.0, 2400).
programa_beca(beca_madres_solteras_conahcyt, 'Beca CONAHCYT para Madres Jefas de Familia Estudiantes', apoyo_familiar, 8.0, 4000).
programa_beca(beca_discapacidad_inclusion, 'Beca Estatal de Apoyo a Estudiantes con Discapacidad', inclusion_social, 7.0, 2200).
programa_beca(beca_talento_matematico, 'Beca de Fomento al Talento Matemático y Físico', talento_especifico, 9.0, 3000).
programa_beca(beca_salud_comunitaria_oaxaca, 'Beca para Brigadas de Salud Comunitaria Rural', salud_rural, 8.0, 2600).
programa_beca(beca_agro_sustentable, 'Beca para Proyectos Agrícolas y Forestales Sustentables', agropecuaria, 7.5, 2100).
programa_beca(beca_idiomas_extranjeros, 'Beca de Certificación en Lenguas Extranjeras (TOEFL/IELTS)', idiomas, 8.5, 1800).
programa_beca(beca_fundacion_banorte, 'Beca Fundación Banorte Mil Sueños por Cumplir', manutencion_integral, 8.8, 3200).
programa_beca(beca_fundacion_inbursa, 'Beca Fundación Inbursa a la Trayectoria Destacada', manutencion_integral, 8.5, 2800).
programa_beca(beca_citi_banamex, 'Beca Compromiso Social Jóvenes de Excelencia Banamex', movilidad_academica, 8.8, 4200).
programa_beca(beca_rotary_internacional, 'Beca de Club Rotario Oaxaca para Servicio Social', comunitaria, 8.0, 2000).
programa_beca(beca_gobierno_oaxaca_talento, 'Beca Gobierno del Estado de Oaxaca al Talento Joven', talento_estatal, 8.5, 2500).
programa_beca(beca_transporte_estudiantil, 'Subsidio de Transporte Estudiantil Metropolitano Oaxaca', transporte, 7.0, 800).
programa_beca(beca_comedor_nutricional, 'Beca Alimentaria de Comedor Universitario Nutricional', alimenticia, 7.0, 950).
programa_beca(beca_liderazgo_social, 'Beca de Formación en Liderazgo y Derechos Humanos', liderazgo, 8.0, 2000).
programa_beca(beca_intercambio_alianza_pacifico, 'Beca Plataforma de Movilidad Alianza del Pacífico', movilidad_internacional, 9.0, 7500).
programa_beca(beca_erasmus_plus, 'Beca Erasmus+ Cooperación Universitaria Europea', movilidad_internacional, 9.2, 12000).
programa_beca(beca_daad_alemania, 'Beca DAAD de Estancia Académica y Verano de Investigación', investigacion_internacional, 9.0, 10000).
programa_beca(beca_fulbright_garcia_robles, 'Beca Fulbright-García Robles de Formación Académica', movilidad_internacional, 9.0, 11000).
programa_beca(beca_fundacion_unam_oaxaca, 'Beca Fundación UNAM para Estudiantes Regionales', manutencion_integral, 8.5, 2500).
programa_beca(beca_innovacion_patentes, 'Beca de Fomento al Registro de Patentes y Emprendimiento', emprendimiento, 8.0, 3500).
programa_beca(beca_desarrollo_software_libre, 'Beca de Apoyo a Proyectos de Código Abierto e IA', tecnologica, 8.5, 3000).
programa_beca(beca_preservacion_lenguas, 'Beca de Rescate y Preservación de Lenguas Originarias', cultural_linguistica, 7.5, 2300).
programa_beca(beca_artesanias_diseno, 'Beca de Vinculación Diseño e Innovación Artesanal', artesanal_diseno, 8.0, 2200).
programa_beca(beca_energia_limpia_oaxaca, 'Beca Sector Eólico del Istmo para Energías Limpias', energia_regional, 8.0, 2700).
programa_beca(beca_cafeticultura_sostenible, 'Beca Fomento a la Cafeticultura Sierra Sur y Costa', agropecuaria_regional, 7.5, 2000).
programa_beca(beca_reforestacion_mixteca, 'Beca Comunitaria para Restauración de Suelos en la Mixteca', ambiental_regional, 7.5, 2000).

% =========================================================================
% 9. TABLA: costo_carrera(IdInstitucion, IdCarrera, CuotaSemestral, CostoMaterialesMes, TipoCuota)
% Estimación de colegiaturas semestrales y gasto de insumos mensuales
% =========================================================================
costo_carrera(ito_oaxaca, ing_sistemas_computacionales, 2600, 750, publica_moderada).
costo_carrera(ito_oaxaca, ing_civil, 2600, 750, publica_moderada).
costo_carrera(ito_oaxaca, ing_mecanica, 2600, 750, publica_moderada).
costo_carrera(ito_oaxaca, ing_electrica, 2600, 750, publica_moderada).
costo_carrera(ito_oaxaca, ing_electronica, 2600, 750, publica_moderada).
costo_carrera(ito_oaxaca, ing_quimica, 2600, 750, publica_moderada).
costo_carrera(ito_oaxaca, ing_industrial, 2600, 750, publica_moderada).
costo_carrera(ito_oaxaca, administracion_empresas, 2600, 750, publica_moderada).
costo_carrera(utm_huajuapan, ing_sistemas_computacionales, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, ing_software, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, ing_inteligencia_artificial, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, ing_mecatronica, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, ing_electronica, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, ing_industrial, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, diseno_industrial, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, matematicas_aplicadas, 1800, 800, publica_simbolica).
costo_carrera(utm_huajuapan, fisica, 1800, 800, publica_simbolica).
costo_carrera(uabjo_medicina, medicina_humana, 4200, 1500, publica_simbolica).
costo_carrera(uabjo_odontologia, cirujano_dentista, 2200, 600, publica_simbolica).
costo_carrera(uabjo_enfermeria, enfermeria, 2200, 600, publica_simbolica).
costo_carrera(uabjo_derecho, derecho, 2200, 600, publica_simbolica).
costo_carrera(uabjo_contaduria, contaduria_publica, 2200, 600, publica_simbolica).
costo_carrera(uabjo_contaduria, administracion_empresas, 2200, 600, publica_simbolica).
costo_carrera(uabjo_arquitectura_5m, arquitectura, 3200, 1400, publica_simbolica).
costo_carrera(uabjo_idiomas, lenguas_extranjeras, 2200, 600, publica_simbolica).
costo_carrera(uabjo_ciencias, fisica, 2200, 600, publica_simbolica).
costo_carrera(uabjo_ciencias, matematicas_aplicadas, 2200, 600, publica_simbolica).
costo_carrera(uabjo_artes, artes_plasticas, 2200, 600, publica_simbolica).
costo_carrera(uabjo_artes, musica, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, sociologia, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, antropologia_social, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, ciencias_politicas, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, economia, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, pedagogia, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, psicologia_clinica, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, medicina_veterinaria, 4200, 1500, publica_simbolica).
costo_carrera(uabjo_cu, biologia, 2200, 600, publica_simbolica).
costo_carrera(uabjo_cu, quimico_farmacobiologo, 2200, 600, publica_simbolica).
costo_carrera(itvo_nazareno, ing_agronomica, 2600, 750, publica_moderada).
costo_carrera(itvo_nazareno, ing_forestal, 2600, 750, publica_moderada).
costo_carrera(itvo_nazareno, ing_ambiental, 2600, 750, publica_moderada).
costo_carrera(itvo_nazareno, biologia, 2600, 750, publica_moderada).
costo_carrera(itvo_nazareno, ing_alimentos, 2600, 750, publica_moderada).
costo_carrera(it_tuxtepec, ing_sistemas_computacionales, 2600, 750, publica_moderada).
costo_carrera(it_tuxtepec, ing_civil, 2600, 750, publica_moderada).
costo_carrera(it_tuxtepec, ing_quimica, 2600, 750, publica_moderada).
costo_carrera(it_tuxtepec, contaduria_publica, 2600, 750, publica_moderada).
costo_carrera(it_tuxtepec, administracion_empresas, 2600, 750, publica_moderada).
costo_carrera(it_salina_cruz, ing_sistemas_computacionales, 2600, 750, publica_moderada).
costo_carrera(it_salina_cruz, ing_quimica, 2600, 750, publica_moderada).
costo_carrera(it_salina_cruz, ing_mecanica, 2600, 750, publica_moderada).
costo_carrera(it_salina_cruz, ing_acuicola, 2600, 750, publica_moderada).
costo_carrera(it_istmo, ing_electrica, 2600, 750, publica_moderada).
costo_carrera(it_istmo, ing_mecanica, 2600, 750, publica_moderada).
costo_carrera(it_istmo, ing_industrial, 2600, 750, publica_moderada).
costo_carrera(it_istmo, ing_sistemas_computacionales, 2600, 750, publica_moderada).
costo_carrera(it_pinotepa, ing_agronomica, 2600, 750, publica_moderada).
costo_carrera(it_pinotepa, ing_sistemas_computacionales, 2600, 750, publica_moderada).
costo_carrera(it_pinotepa, administracion_empresas, 2600, 750, publica_moderada).
costo_carrera(it_tlaxiaco, ing_civil, 2600, 750, publica_moderada).
costo_carrera(it_tlaxiaco, ing_sistemas_computacionales, 2600, 750, publica_moderada).
costo_carrera(it_tlaxiaco, ing_industrial, 2600, 750, publica_moderada).
costo_carrera(umar_puerto_escondido, biologia, 1800, 800, publica_simbolica).
costo_carrera(umar_puerto_escondido, ciencias_ambientales, 1800, 800, publica_simbolica).
costo_carrera(umar_puerto_escondido, ing_forestal, 1800, 800, publica_simbolica).
costo_carrera(umar_puerto_angel, ing_acuicola, 1800, 800, publica_simbolica).
costo_carrera(umar_puerto_angel, biologia, 1800, 800, publica_simbolica).
costo_carrera(umar_huatulco, gestion_turistica, 1800, 800, publica_simbolica).
costo_carrera(umar_huatulco, relaciones_internacionales, 1800, 800, publica_simbolica).
costo_carrera(umar_huatulco, comunicacion_periodismo, 1800, 800, publica_simbolica).
costo_carrera(unistmo_tehuantepec, ing_sistemas_computacionales, 1800, 800, publica_simbolica).
costo_carrera(unistmo_tehuantepec, ing_quimica, 1800, 800, publica_simbolica).
costo_carrera(unistmo_ixtepec, administracion_empresas, 1800, 800, publica_simbolica).
costo_carrera(unistmo_ixtepec, derecho, 1800, 800, publica_simbolica).
costo_carrera(unistmo_juchitan, ing_energias_renovables, 1800, 800, publica_simbolica).
costo_carrera(unistmo_juchitan, ing_industrial, 1800, 800, publica_simbolica).
costo_carrera(unpa_tuxtepec, ing_biomedica, 1800, 800, publica_simbolica).
costo_carrera(unpa_tuxtepec, quimico_farmacobiologo, 1800, 800, publica_simbolica).
costo_carrera(unpa_loma_bonita, ing_alimentos, 1800, 800, publica_simbolica).
costo_carrera(unpa_loma_bonita, matematicas_aplicadas, 1800, 800, publica_simbolica).
costo_carrera(unsij_ixtlan, ing_forestal, 1800, 800, publica_simbolica).
costo_carrera(unsij_ixtlan, ciencias_ambientales, 1800, 800, publica_simbolica).
costo_carrera(unsij_ixtlan, ing_sistemas_computacionales, 1800, 800, publica_simbolica).
costo_carrera(unsis_miahuatlan, medicina_humana, 1800, 800, publica_simbolica).
costo_carrera(unsis_miahuatlan, enfermeria, 1800, 800, publica_simbolica).
costo_carrera(unsis_miahuatlan, nutricion_clinica, 1800, 800, publica_simbolica).
costo_carrera(unsis_miahuatlan, ciencias_politicas, 1800, 800, publica_simbolica).
costo_carrera(utvco_huixtepec, gastronomia, 2600, 750, publica_moderada).
costo_carrera(utvco_huixtepec, ing_energias_renovables, 2600, 750, publica_moderada).
costo_carrera(utvco_huixtepec, mercadotecnia_digital, 2600, 750, publica_moderada).
costo_carrera(anahuac_oaxaca, medicina_humana, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, derecho, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, comercio_internacional, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, mercadotecnia_digital, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, arquitectura, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, psicologia_clinica, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, administracion_empresas, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, comunicacion_periodismo, 48000, 1600, privada_alta).
costo_carrera(anahuac_oaxaca, ing_industrial, 48000, 1600, privada_alta).
costo_carrera(lasalle_oaxaca, ing_software, 34000, 1300, privada_estandar).
costo_carrera(lasalle_oaxaca, derecho, 34000, 1300, privada_estandar).
costo_carrera(lasalle_oaxaca, fisioterapia, 34000, 1300, privada_estandar).
costo_carrera(lasalle_oaxaca, arquitectura, 34000, 1300, privada_estandar).
costo_carrera(lasalle_oaxaca, diseno_grafico, 34000, 1300, privada_estandar).
costo_carrera(lasalle_oaxaca, comercio_internacional, 34000, 1300, privada_estandar).
costo_carrera(lasalle_oaxaca, lenguas_extranjeras, 34000, 1300, privada_estandar).
costo_carrera(lasalle_oaxaca, nutricion_clinica, 34000, 1300, privada_estandar).
costo_carrera(urse_oaxaca, medicina_humana, 36000, 1500, privada_estandar).
costo_carrera(urse_oaxaca, cirujano_dentista, 36000, 1500, privada_estandar).
costo_carrera(urse_oaxaca, nutricion_clinica, 21000, 1000, privada_accesible).
costo_carrera(urse_oaxaca, enfermeria, 21000, 1000, privada_accesible).
costo_carrera(urse_oaxaca, psicologia_clinica, 21000, 1000, privada_accesible).
costo_carrera(urse_oaxaca, fisioterapia, 21000, 1000, privada_accesible).
costo_carrera(urse_aleman, derecho, 21000, 1000, privada_accesible).
costo_carrera(urse_aleman, contaduria_publica, 21000, 1000, privada_accesible).
costo_carrera(urse_aleman, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(urse_aleman, pedagogia, 21000, 1000, privada_accesible).
costo_carrera(mesoamericana_oaxaca, medicina_veterinaria, 21000, 1000, privada_accesible).
costo_carrera(mesoamericana_oaxaca, cirujano_dentista, 21000, 1000, privada_accesible).
costo_carrera(mesoamericana_oaxaca, comunicacion_periodismo, 21000, 1000, privada_accesible).
costo_carrera(mesoamericana_oaxaca, diseno_grafico, 21000, 1000, privada_accesible).
costo_carrera(mesoamericana_oaxaca, gastronomia, 21000, 1000, privada_accesible).
costo_carrera(mesoamericana_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(univas_oaxaca, relaciones_internacionales, 21000, 1000, privada_accesible).
costo_carrera(univas_oaxaca, ciencias_politicas, 21000, 1000, privada_accesible).
costo_carrera(univas_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(univas_oaxaca, mercadotecnia_digital, 21000, 1000, privada_accesible).
costo_carrera(univas_oaxaca, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(unidep_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(unidep_oaxaca, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(unidep_oaxaca, contaduria_publica, 21000, 1000, privada_accesible).
costo_carrera(unidep_oaxaca, diseno_grafico, 21000, 1000, privada_accesible).
costo_carrera(ceuni_oaxaca, cirujano_dentista, 21000, 1000, privada_accesible).
costo_carrera(ceuni_oaxaca, fisioterapia, 21000, 1000, privada_accesible).
costo_carrera(ceuni_oaxaca, nutricion_clinica, 21000, 1000, privada_accesible).
costo_carrera(ceuni_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(ugmex_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(ugmex_oaxaca, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(ugmex_oaxaca, ing_sistemas_computacionales, 21000, 1000, privada_accesible).
costo_carrera(ugmex_oaxaca, pedagogia, 21000, 1000, privada_accesible).
costo_carrera(ugmex_oaxaca, gestion_turistica, 21000, 1000, privada_accesible).
costo_carrera(ugmex_huatulco, gestion_turistica, 21000, 1000, privada_accesible).
costo_carrera(ugmex_huatulco, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(ugmex_huatulco, gastronomia, 21000, 1000, privada_accesible).
costo_carrera(ugmex_tuxtepec, derecho, 21000, 1000, privada_accesible).
costo_carrera(ugmex_tuxtepec, contaduria_publica, 21000, 1000, privada_accesible).
costo_carrera(ugmex_tuxtepec, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(unid_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(unid_oaxaca, mercadotecnia_digital, 21000, 1000, privada_accesible).
costo_carrera(unid_oaxaca, ciencias_politicas, 21000, 1000, privada_accesible).
costo_carrera(unid_oaxaca, ing_software, 21000, 1000, privada_accesible).
costo_carrera(unid_oaxaca, educacion_especial, 21000, 1000, privada_accesible).
costo_carrera(eneeo_oaxaca, educacion_especial, 2600, 750, publica_moderada).
costo_carrera(eneop_oaxaca, pedagogia, 2600, 750, publica_moderada).
costo_carrera(benelly_ixtepec, pedagogia, 2600, 750, publica_moderada).
costo_carrera(enbio_oaxaca, pedagogia, 2600, 750, publica_moderada).
costo_carrera(uabjo_terapia_fisica, fisioterapia, 2200, 600, publica_simbolica).
costo_carrera(anahuac_oaxaca, fisioterapia, 48000, 1600, privada_alta).
costo_carrera(iesit_juchitan, derecho, 21000, 1000, privada_accesible).
costo_carrera(iesit_juchitan, contaduria_publica, 21000, 1000, privada_accesible).
costo_carrera(iesit_juchitan, ing_sistemas_computacionales, 21000, 1000, privada_accesible).
costo_carrera(iesit_juchitan, enfermeria, 21000, 1000, privada_accesible).
costo_carrera(casandoo_istmo, derecho, 21000, 1000, privada_accesible).
costo_carrera(casandoo_istmo, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(casandoo_istmo, pedagogia, 21000, 1000, privada_accesible).
costo_carrera(unimo_oaxaca, gestion_turistica, 21000, 1000, privada_accesible).
costo_carrera(unimo_oaxaca, gastronomia, 21000, 1000, privada_accesible).
costo_carrera(unimo_oaxaca, comercio_internacional, 21000, 1000, privada_accesible).
costo_carrera(upeo_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(upeo_oaxaca, contaduria_publica, 21000, 1000, privada_accesible).
costo_carrera(cesf_oaxaca, psicologia_clinica, 21000, 1000, privada_accesible).
costo_carrera(cesf_oaxaca, pedagogia, 21000, 1000, privada_accesible).
costo_carrera(iuo_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(iuo_oaxaca, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(santander_oaxaca, pedagogia, 21000, 1000, privada_accesible).
costo_carrera(santander_oaxaca, administracion_empresas, 21000, 1000, privada_accesible).
costo_carrera(cleu_oaxaca, derecho, 21000, 1000, privada_accesible).
costo_carrera(cleu_oaxaca, psicologia_clinica, 21000, 1000, privada_accesible).

% =========================================================================
% 10. TABLA: materia_critica(IdMateria, IdCarrera, NombreMateria, Semestre, AreaDificultad)
% Asignaturas filtro con mayor índice de reprobación y complejidad conceptual
% Total de registros: 55 materias críticas
% =========================================================================
materia_critica(mat_calc_multivariable, ing_sistemas_computacionales, 'Cálculo Diferencial e Integral Multivariable', 2, ciencias_exactas_matematicas).
materia_critica(mat_estructuras_datos, ing_sistemas_computacionales, 'Estructuras de Datos Avanzadas y Algoritmia', 3, programacion_y_algoritmos).
materia_critica(mat_arq_computadoras, ing_software, 'Arquitectura de Computadoras y Sistemas Operativos', 4, hardware_y_sistemas).
materia_critica(mat_redes_neuronales, ing_inteligencia_artificial, 'Redes Neuronales Profundas y Aprendizaje Automático', 6, matematicas_e_ia).
materia_critica(mat_mecanica_materiales, ing_civil, 'Mecánica de Materiales y Resistencia Estructural', 4, fisica_y_mecanica).
materia_critica(mat_mecanica_suelos, ing_civil, 'Mecánica de Suelos y Cimentaciones Profundas', 5, geotecnia).
materia_critica(mat_termodinamica_mec, ing_mecanica, 'Termodinámica Clásica y Transferencia de Calor', 3, fisica_termodinamica).
materia_critica(mat_sistemas_potencia, ing_electrica, 'Análisis de Sistemas Eléctricos de Potencia', 6, electricidad_avanzada).
materia_critica(mat_control_automatico, ing_mecatronica, 'Teoría de Control Moderno y Servomecanismos', 6, control_y_robotica).
materia_critica(mat_investigacion_operaciones, ing_industrial, 'Investigación de Operaciones y Modelos Estocásticos', 5, optimizacion_matematica).
materia_critica(mat_balance_materia, ing_quimica, 'Balances de Materia y Energía en Procesos Químicos', 3, quimica_y_termodinamica).
materia_critica(mat_circuitos_integrados, ing_electronica, 'Diseño de Circuitos Integrados y Lógica Programable', 5, electronica_avanzada).
materia_critica(mat_antenas_propagacion, ing_telecomunicaciones, 'Campos Electromagnéticos, Antenas y Microondas', 5, fisica_electromagnetica).
materia_critica(mat_procesamiento_biomedico, ing_biomedica, 'Procesamiento Digital de Bioseñales Médicas', 6, senales_y_bioingenieria).
materia_critica(mat_quimica_ambiental, ing_ambiental, 'Química Ambiental y Tratamiento de Aguas Residuales', 4, quimica_ambiental).
materia_critica(mat_conversion_energia, ing_energias_renovables, 'Conversión Térmica y Fotovoltaica de Energía Solar', 5, fisica_energetica).
materia_critica(mat_mineralogia_optica, ing_geologia, 'Mineralogía Óptica y Petrografía Ígnea', 4, geologia_analitica).
materia_critica(mat_microbiologia_alimentos, ing_alimentos, 'Microbiología y Biotecnología de Alimentos', 4, biologia_y_microbiologia).
materia_critica(mat_fisiologia_vegetal, ing_agronomica, 'Fisiología Vegetal y Nutrición de Cultivos', 4, ciencias_biologicas).
materia_critica(mat_ordenacion_montes, ing_forestal, 'Dendrometría y Ordenación de Montes Forestales', 5, silvicultura_matematica).
materia_critica(mat_nutricion_acuicola, ing_acuicola, 'Bioquímica y Fisiología de Especies Marinas', 4, biologia_marina).
materia_critica(mat_anatomia_humana, medicina_humana, 'Anatomía Humana Descriptiva y Disección Clínica', 1, morfologia_y_memorizacion).
materia_critica(mat_fisiologia_medica, medicina_humana, 'Fisiología Médica Celular y Sistémica', 2, ciencias_biomedicas).
materia_critica(mat_farmacologia_clinica, medicina_humana, 'Farmacología Médica y Terapéutica Clínica', 4, farmacologia).
materia_critica(mat_anatomia_dental, cirujano_dentista, 'Anatomía Dental, Oclusión y Operatoria Preclínica', 2, destreza_manual_y_morfologia).
materia_critica(mat_farmaco_enfermeria, enfermeria, 'Farmacología Aplicada a la Atención de Enfermería', 3, farmacologia_clinica).
materia_critica(mat_bioquimica_nutricional, nutricion_clinica, 'Bioquímica Nutricional y Metabolismo Energético', 2, bioquimica_metabolica).
materia_critica(mat_biomecanica_humana, fisioterapia, 'Biomecánica del Aparato Locomotor y Kinesiología', 3, fisica_anatomica).
materia_critica(mat_quimica_analitica_qfb, quimico_farmacobiologo, 'Química Analítica Instrumental y Espectrometría', 3, quimica_experimental).
materia_critica(mat_neuroanatomia_psic, psicologia_clinica, 'Neuroanatomía y Psicofisiología del Comportamiento', 3, neurociencias).
materia_critica(mat_patologia_veterinaria, medicina_veterinaria, 'Patología General y Anatomopatología Veterinaria', 4, patologia_animal).
materia_critica(mat_derecho_romano, derecho, 'Derecho Romano y Evolución de las Instituciones Jurídicas', 1, dogmatica_juridica).
materia_critica(mat_derecho_procesal_penal, derecho, 'Derecho Procesal Penal y Sistema Acusatorio Adversarial', 5, litigio_y_procedimientos).
materia_critica(mat_matematicas_financieras, administracion_empresas, 'Matemáticas Financieras y Evaluación de Proyectos', 3, finanzas_y_calculo).
materia_critica(mat_contabilidad_costos, contaduria_publica, 'Contabilidad de Costos Industriales y Tributación', 3, contabilidad_analitica).
materia_critica(mat_derecho_aduanero, comercio_internacional, 'Legislación Aduanera y Clasificación Arancelaria', 4, regulacion_comercial).
materia_critica(mat_analitica_web, mercadotecnia_digital, 'Analítica Web, Métricas de Tráfico y Algoritmos SEO', 4, datos_y_estrategia).
materia_critica(mat_operacion_hotelera, gestion_turistica, 'Costos, Presupuestos y Operación Hotelera Integral', 4, administracion_turistica).
materia_critica(mat_quimica_culinaria, gastronomia, 'Bases Químicas de la Cocción y Alta Repostería', 3, tecnica_culinaria).
materia_critica(mat_microeconomia_avanzada, economia, 'Microeconomía Intermedia y Teoría de Juegos', 3, modelacion_matematica).
materia_critica(mat_teoria_estado, ciencias_politicas, 'Teoría del Estado y Análisis de Políticas Públicas', 2, filosofia_politica).
materia_critica(mat_geopolitica_mundial, relaciones_internacionales, 'Geopolítica, Seguridad Global y Diplomacia Contemporánea', 4, analisis_internacional).
materia_critica(mat_semiotica_comunicacion, comunicacion_periodismo, 'Semiótica de la Comunicación y Análisis del Discurso', 3, teoria_de_la_comunicacion).
materia_critica(mat_epistemologia_social, sociologia, 'Epistemología y Metodología Cuantitativa en Ciencias Sociales', 3, metodologia_cientifica).
materia_critica(mat_etnografia_regional, antropologia_social, 'Métodos Etnográficos de Campo y Antropología Lingüística', 3, trabajo_de_campo).
materia_critica(mat_diseno_curricular, pedagogia, 'Diseño Curricular y Modelos Teóricos de Aprendizaje', 4, planeacion_educativa).
materia_critica(mat_neuropsicologia_educ, educacion_especial, 'Neuropsicología de las Dificultades del Aprendizaje', 4, psicopedagogia).
materia_critica(mat_estructuras_arquitectura, arquitectura, 'Análisis y Diseño de Estructuras de Concreto y Acero', 5, calculo_estructural).
materia_critica(mat_geometria_descriptiva, arquitectura, 'Geometría Descriptiva y Proyección Tridimensional', 1, representacion_espacial).
materia_critica(mat_tipografia_editorial, diseno_grafico, 'Tipografía Avanzada y Producción Editorial Digital', 3, artes_graficas).
materia_critica(mat_materiales_manufactura, diseno_industrial, 'Resistencia de Materiales y Procesos de Manufactura', 4, tecnologia_de_materiales).
materia_critica(mat_dibujo_figura_humana, artes_plasticas, 'Dibujo Anatómico de Figura Humana del Natural', 2, tecnica_de_dibujo).
materia_critica(mat_armonia_contrapunto, musica, 'Armonía Tonal Avanzada y Contrapunto Modal', 3, teoria_musical_compleja).
materia_critica(mat_logica_simbolica, filosofia, 'Lógica Simbólica Formal y Metalógica', 2, logica_formal).
materia_critica(mat_calculo_actuarial, actuaria, 'Matemáticas Actuariales del Seguro de Vida y Contingencias', 5, teoria_del_riesgo).

% =========================================================================
% CATÁLOGOS AUXILIARES: alias para consultas y lenguaje natural
% =========================================================================
area_nombre(ingenieria_y_tecnologia, 'Ingeniería y Ciencias Computacionales').
area_nombre(ciencias_salud, 'Ciencias de la Salud y Medicina').
area_nombre(ciencias_sociales_y_derecho, 'Ciencias Sociales, Jurídicas y Humanas').
area_nombre(administracion_y_negocios, 'Administración, Finanzas y Negocios').
area_nombre(artes_y_humanidades, 'Artes, Arquitectura y Expresión Cultural').
area_nombre(ciencias_exactas_y_naturales, 'Ciencias Exactas, Físicas y Naturales').
area_nombre(ciencias_agropecuarias, 'Ciencias Agropecuarias y Ambientales').

formato_regimen(publica_estatal, 'PÚBLICA (Estatal)').
formato_regimen(publica_federal, 'PÚBLICA (Federal)').
formato_regimen(privada,         'PRIVADA').

% =========================================================================
% REGLAS COMPLEJAS DEL SISTEMA EXPERTO
% =========================================================================

% --- REGLA 1: TEST VOCACIONAL Y AFINIDAD HOLLAND RIASEC ---
similitud_holland(perfil_aspirante(R1,I1,A1,S1,E1,C1), IdCarrera, PorcentajeAfinidad) :-
    perfil_holland(IdCarrera, R2, I2, A2, S2, E2, C2),
    DR is (R1 - R2) * (R1 - R2),
    DI is (I1 - I2) * (I1 - I2),
    DA is (A1 - A2) * (A1 - A2),
    DS is (S1 - S2) * (S1 - S2),
    DE is (E1 - E2) * (E1 - E2),
    DC is (C1 - C2) * (C1 - C2),
    DistanciaCuadrada is DR + DI + DA + DS + DE + DC,
    Distancia is sqrt(DistanciaCuadrada),
    MaxDist = 22.05,
    ScoreBruto is max(0.0, 100.0 * (1.0 - (Distancia / MaxDist))),
    PorcentajeAfinidad is round(ScoreBruto).

ranking_afinidad_vocacional(PerfilAspirante, RankingOrdenado) :-
    findall(Score-IdCarrera,
            ( carrera(IdCarrera, _, _, _, _),
              similitud_holland(PerfilAspirante, IdCarrera, Score)
            ),
            Pares),
    findall((NegScore-IdC), (member(Score-IdC, Pares), NegScore is -Score), NegPares),
    keysort(NegPares, NegOrdenados),
    findall(Score-IdC, (member(NegScore-IdC, NegOrdenados), Score is -NegScore), RankingOrdenado).

% --- CATÁLOGO DE TIPOS DE EXÁMENES DE ADMISIÓN EN OAXACA ---
% examen_info(TipoExamen, NombreOficial, SiglaCorta, EscalaMin, EscalaMax, Descripcion)
examen_info(evaluatec,
    'EVALUATEC (Evaluación Oficial de Ingreso al TecNM)',
    'EVALUATEC',
    0, 100,
    'Plataforma oficial del Tecnológico Nacional de México (TecNM) para ingreso a los Institutos Tecnológicos (ITO, Tuxtepec, Salina Cruz, etc.). Evalúa en escala de 0 a 100 puntos.').
examen_info(examen_suneo,
    'Examen Institucional SUNEO + Curso Propedéutico de Selección',
    'Examen SUNEO',
    0, 100,
    'Examen oficial del Sistema de Universidades Estatales de Oaxaca (UTM, UMAR, UNPA, UNSIS, UNISTMO). Puntaje sobre 100 que define el acceso al Curso Propedéutico obligatorio (4 u 8 semanas).').
examen_info(exani_ii_uabjo,
    'Examen General de Admisión UABJO (Estándar CENEVAL EXANI-II)',
    'EXANI-II UABJO',
    700, 1300,
    'Examen oficial de la UABJO elaborado bajo reactivos tipo CENEVAL EXANI-II. Escala nacional estandarizada de 700 a 1300 puntos (media nacional 1000).').
examen_info(exani_ii_normales,
    'Examen de Selección a Escuelas Normales y UPN (CENEVAL EXANI-II)',
    'EXANI-II Normales',
    700, 1300,
    'Evaluación nacional CENEVAL EXANI-II para aspirantes a escuelas formadoras de docentes y pedagogía (CRENO, UPN, UNIBA). Escala de 700 a 1300 puntos.').
examen_info(paa_anahuac,
    'Prueba de Aptitud Académica PAA / Examen de Admisión Anáhuac',
    'PAA Anáhuac',
    0, 100,
    'Evaluación diagnóstica institucional de razonamiento y habilidades que determina admisión directa y asignación de becas del 30% al 80%.').
examen_info(examen_diagnostico_privada,
    'Examen Diagnóstico Interno y Entrevista Vocacional',
    'Examen Privada',
    0, 100,
    'Evaluación institucional aplicada por universidades privadas (La Salle, URSE, Mesoamericana, etc.) para diagnóstico y becas de colegiatura.').

% --- REGLA 2: SIMULADOR DE PROBABILIDAD DE ADMISIÓN UNIVERSITARIA ---
evaluar_admision(IdInstitucion, IdCarrera, PromedioAspirante, PuntajeAspirante, Dictamen, Detalle) :-
    requisito_admision(IdInstitucion, IdCarrera, PromMin, TipoExamen, CorteExamen),
    institucion(IdInstitucion, NomInst, _, Regimen, _),
    examen_info(TipoExamen, NomExamen, _, _, _, _),
    (   PromedioAspirante < PromMin
    ->  Dictamen = no_cumple_requisito_academico,
        format(atom(Detalle), 'Promedio insuficiente en certificado: tienes ~1f y ~w exige mínimo ~1f de bachillerato.', [PromedioAspirante, NomInst, PromMin])
    ;   Regimen == privada
    ->  (   PuntajeAspirante >= CorteExamen
        ->  Dictamen = admision_confirmada_con_opcion_a_beca,
            format(atom(Detalle), 'Admisión asegurada en ~w (~d pts vs ~d de corte en ~w). Tu resultado te califica para solicitar beca institucional del 30% al 80%.', [NomInst, PuntajeAspirante, CorteExamen, NomExamen])
        ;   Dictamen = admision_condicionada_a_curso_propededeutico,
            format(atom(Detalle), 'Puntaje diagnóstico condicionado (~d pts vs ~d sugerido en ~w). Admisión sujeta a entrevista vocacional y taller propedéutico de nivelación.', [PuntajeAspirante, CorteExamen, NomExamen])
        )
    ;   % Universidades Públicas
        (   (TipoExamen == exani_ii_uabjo ; TipoExamen == exani_ii_normales)
        ->  MargenSobresaliente = 30, MargenRiesgo = 40
        ;   MargenSobresaliente = 10, MargenRiesgo = 10
        ),
        (   PuntajeAspirante >= (CorteExamen + MargenSobresaliente)
        ->  Dictamen = alta_probabilidad_de_admision,
            (   TipoExamen == evaluatec
            ->  format(atom(Detalle), 'Puntaje sobresaliente en EVALUATEC (~d pts vs ~d de corte en ~w). Muy alta probabilidad de plaza directa en TecNM y turno matutino.', [PuntajeAspirante, CorteExamen, NomInst])
            ;   TipoExamen == examen_suneo
            ->  format(atom(Detalle), 'Puntaje sobresaliente en Examen Institucional SUNEO (~d pts vs ~d de corte en ~w). Acceso preferencial a Curso Propedéutico Corto (4 semanas).', [PuntajeAspirante, CorteExamen, NomInst])
            ;   format(atom(Detalle), 'Puntaje sobresaliente en ~w (~d pts vs ~d de corte en ~w). Muy alta probabilidad de asegurar plaza pública.', [NomExamen, PuntajeAspirante, CorteExamen, NomInst])
            )
        ;   PuntajeAspirante >= CorteExamen
        ->  Dictamen = en_rango_competitivo,
            (   TipoExamen == evaluatec
            ->  format(atom(Detalle), 'Puntaje competitivo en EVALUATEC (~d pts vs ~d de corte en ~w). Estás en zona de asignación en plataforma TecNM.', [PuntajeAspirante, CorteExamen, NomInst])
            ;   TipoExamen == examen_suneo
            ->  format(atom(Detalle), 'Puntaje suficiente en SUNEO (~d pts vs ~d de corte en ~w). Pase a Curso Propedéutico regular SUNEO.', [PuntajeAspirante, CorteExamen, NomInst])
            ;   format(atom(Detalle), 'Puntaje competitivo en ~w (~d pts vs ~d de corte en ~w). En zona de admisión oficial sujeta a cupo.', [NomExamen, PuntajeAspirante, CorteExamen, NomInst])
            )
        ;   Margen is CorteExamen - PuntajeAspirante, Margen =< MargenRiesgo
        ->  Dictamen = admision_en_riesgo,
            (   TipoExamen == evaluatec
            ->  format(atom(Detalle), 'Puntaje límite en EVALUATEC (~d pts vs ~d de corte en ~w). Faltan aprox. ~d pts; sujeto a segunda vuelta o lista de espera TecNM.', [PuntajeAspirante, CorteExamen, NomInst, Margen])
            ;   TipoExamen == examen_suneo
            ->  format(atom(Detalle), 'Puntaje límite en SUNEO (~d pts vs ~d de corte en ~w). Asignado a Curso Propedéutico Largo (8 semanas) con evaluación intensiva para buscar cupo.', [PuntajeAspirante, CorteExamen, NomInst])
            ;   format(atom(Detalle), 'Puntaje cercano a la línea de corte en ~w (~d pts vs ~d en ~w). Faltan aprox. ~d pts para asegurar cupo.', [NomExamen, PuntajeAspirante, CorteExamen, NomInst, Margen])
            )
        ;   Dictamen = no_admitido_bajo_puntaje,
            format(atom(Detalle), 'Puntaje distante del corte en ~w (~d pts vs ~d en ~w). Se sugiere preparar siguiente convocatoria o revisar carreras afines.', [NomExamen, PuntajeAspirante, CorteExamen, NomInst])
        )
    ), !.

% --- REGLA 3: PLANIFICADOR FINANCIERO Y COSTO DE VIDA ESTUDIANTIL ---
costo_mensual_carrera(IdInstitucion, IdCarrera, CostoTotalMensual, Desglose) :-
    costo_carrera(IdInstitucion, IdCarrera, CuotaSemestre, MaterialesMes, _),
    institucion(IdInstitucion, _, Municipio, _, _),
    municipio_sede(Municipio, _, _, CostoVidaMun),
    CuotaMensual is CuotaSemestre / 6.0,
    CostoTotalMensual is round(CuotaMensual + MaterialesMes + CostoVidaMun),
    Desglose = [cuota_mensual(CuotaMensual), materiales(MaterialesMes), hospedaje_y_vida(CostoVidaMun)].

viabilidad_presupuesto(IdInstitucion, IdCarrera, PresupuestoFamiliarMes, EstadoViabilidad, BrechaFinanciera) :-
    costo_mensual_carrera(IdInstitucion, IdCarrera, CostoMes, _),
    Brecha is CostoMes - PresupuestoFamiliarMes,
    (   Brecha =< 0
    ->  EstadoViabilidad = viable_total, BrechaFinanciera = 0
    ;   Brecha =< 1800
    ->  EstadoViabilidad = viable_con_apoyo_o_beca, BrechaFinanciera = Brecha
    ;   EstadoViabilidad = inviable_requiere_sede_local, BrechaFinanciera = Brecha
    ).

% --- REGLA 4: RECOMENDADOR MULTICRITERIO DE CARRERAS (SCORE 0-100) ---
evaluar_carrera_multicriterio(perfil_consulta(HollandAsp, MunAsp, Presupuesto, PromPrepa, FiltroRegimen),
                             IdInstitucion, IdCarrera, PuntosTotales, Factores) :-
    oferta_academica(IdInstitucion, IdCarrera, _, _),
    institucion(IdInstitucion, _, MunInst, Regimen, Prestigio),
    (   (FiltroRegimen == cualquiera) -> true
    ;   (FiltroRegimen == solo_publicas) -> (Regimen == publica_estatal ; Regimen == publica_federal)
    ;   (FiltroRegimen == solo_privadas) -> (Regimen == privada)
    ),
    % 1. Afinidad Vocacional (35 pts máx)
    similitud_holland(HollandAsp, IdCarrera, AfinidadPct),
    PtsAfinidad is round((AfinidadPct / 100.0) * 35.0),
    % 2. Mercado Laboral y Salario (25 pts máx)
    mercado_laboral(IdCarrera, Sueldo, Empleabilidad, _, _),
    PtsSalario is min(15.0, (Sueldo / 28000.0) * 15.0),
    PtsEmpleo is (Empleabilidad / 100.0) * 10.0,
    PtsMercado is round(PtsSalario + PtsEmpleo),
    % 3. Viabilidad Financiera (20 pts máx)
    costo_mensual_carrera(IdInstitucion, IdCarrera, CostoMes, _),
    Diferencia is CostoMes - Presupuesto,
    (   Diferencia =< 0    -> PtsCosto = 20
    ;   Diferencia =< 1500 -> PtsCosto = 12
    ;   Diferencia =< 3000 -> PtsCosto = 6
    ;   PtsCosto = 1
    ),
    % 4. Proximidad Geográfica (10 pts máx)
    municipio_sede(MunAsp, _, RegAsp, _),
    municipio_sede(MunInst, _, RegInst, _),
    (   MunAsp == MunInst -> PtsGeo = 10, MGeo = 'Mismo municipio de residencia'
    ;   RegAsp == RegInst -> PtsGeo = 7,  MGeo = 'Misma región de Oaxaca'
    ;   PtsGeo = 3, MGeo = 'Requiere traslado foráneo'
    ),
    % 5. Prestigio Académico y Promedio (10 pts máx)
    (   Prestigio == muy_alta -> PtsPrest = 6
    ;   Prestigio == alta     -> PtsPrest = 4
    ;   PtsPrest = 2
    ),
    requisito_admision(IdInstitucion, IdCarrera, PromReq, _, _),
    (   PromPrepa >= PromReq -> PtsProm = 4 ; PtsProm = 0 ),
    PtsInst is PtsPrest + PtsProm,
    PuntosTotales is PtsAfinidad + PtsMercado + PtsCosto + PtsGeo + PtsInst,
    Factores = [afinidad_vocacional(PtsAfinidad), mercado_laboral(PtsMercado),
                presupuesto(PtsCosto), proximidad(PtsGeo, MGeo), prestigio_y_requisito(PtsInst)].

mejor_recomendacion_vocacional(Perfil, Ranking) :-
    findall(Puntos-(IdInst-IdCarr-Facts),
            evaluar_carrera_multicriterio(Perfil, IdInst, IdCarr, Puntos, Facts),
            Pares),
    findall((NegP-Val), (member(P-Val, Pares), NegP is -P), NegPares),
    keysort(NegPares, NegOrdenados),
    findall(P-(Inst-Carr-F), (member(NegP-(Inst-Carr-F), NegOrdenados), P is -NegP), Ranking).

% --- REGLA 5: VERIFICADOR DE ELEGIBILIDAD DE BECAS ---
beca_elegible(PromedioAspirante, TipoInstitucion, IdBeca, NombreBeca, Monto) :-
    programa_beca(IdBeca, NombreBeca, TipoBeca, PromMin, Monto),
    PromedioAspirante >= PromMin,
    (   TipoInstitucion == privada
    ->  member(TipoBeca, [colegiatura_privada, excelencia_academica, inclusion_social, talento_especifico, movilidad_academica, idiomas, genero_y_stem])
    ;   % Institución pública
        \+ member(TipoBeca, [colegiatura_privada])
    ).

% --- REGLA 6: DIAGNÓSTICO DE MATERIAS FILTRO Y RETENCIÓN ---
materias_dificultad_carrera(IdCarrera, ListaMaterias) :-
    findall(Sem-Nom-Area,
            materia_critica(_, IdCarrera, Nom, Sem, Area),
            Pares),
    keysort(Pares, ListaMaterias).

% --- REGLA 7: ANALIZADOR DE LENGUAJE NATURAL ---
quitar_acento('á', 'a') :- !.
quitar_acento('é', 'e') :- !.
quitar_acento('í', 'i') :- !.
quitar_acento('ó', 'o') :- !.
quitar_acento('ú', 'u') :- !.
quitar_acento('ñ', 'n') :- !.
quitar_acento(C, C).

normalizar_string(StringIn, StringOut) :-
    string_lower(StringIn, StringLower),
    string_chars(StringLower, CharsIn),
    maplist(quitar_acento, CharsIn, CharsNorm),
    string_chars(StringOut, CharsNorm).

parse_frase_tokens(FraseString, Tokens) :-
    normalizar_string(FraseString, FraseNorm),
    split_string(FraseNorm, " ,.;:!?¿¡()[]-", " ", TokensBrutos),
    exclude(=(""), TokensBrutos, Tokens).

alias_token(carrera, "sistemas", ing_sistemas_computacionales).
alias_token(carrera, "computacion", ing_sistemas_computacionales).
alias_token(carrera, "software", ing_software).
alias_token(carrera, "inteligencia", ing_inteligencia_artificial).
alias_token(carrera, "ia", ing_inteligencia_artificial).
alias_token(carrera, "civil", ing_civil).
alias_token(carrera, "mecanica", ing_mecanica).
alias_token(carrera, "electrica", ing_electrica).
alias_token(carrera, "mecatronica", ing_mecatronica).
alias_token(carrera, "industrial", ing_industrial).
alias_token(carrera, "quimica", ing_quimica).
alias_token(carrera, "medicina", medicina_humana).
alias_token(carrera, "medico", medicina_humana).
alias_token(carrera, "doctor", medicina_humana).
alias_token(carrera, "odontologia", cirujano_dentista).
alias_token(carrera, "dentista", cirujano_dentista).
alias_token(carrera, "enfermeria", enfermeria).
alias_token(carrera, "nutricion", nutricion_clinica).
alias_token(carrera, "fisioterapia", fisioterapia).
alias_token(carrera, "psicologia", psicologia_clinica).
alias_token(carrera, "veterinaria", medicina_veterinaria).
alias_token(carrera, "derecho", derecho).
alias_token(carrera, "leyes", derecho).
alias_token(carrera, "abogado", derecho).
alias_token(carrera, "administracion", administracion_empresas).
alias_token(carrera, "contaduria", contaduria_publica).
alias_token(carrera, "contador", contaduria_publica).
alias_token(carrera, "gastronomia", gastronomia).
alias_token(carrera, "arquitectura", arquitectura).
alias_token(carrera, "diseno", diseno_grafico).
alias_token(carrera, "actuaria", actuaria).
alias_token(carrera, "biologia", biologia).

alias_token(municipio, "oaxaca", oaxaca_de_juarez).
alias_token(municipio, "huajuapan", heroica_ciudad_de_huajuapan_de_leon).
alias_token(municipio, "tuxtepec", san_juan_bautista_tuxtepec).
alias_token(municipio, "juchitan", heroica_ciudad_de_juchitan_de_zaragoza).
alias_token(municipio, "salina", salina_cruz).
alias_token(municipio, "tehuantepec", santo_domingo_tehuantepec).
alias_token(municipio, "pinotepa", santiago_pinotepa_nacional).
alias_token(municipio, "escondido", san_pedro_mixtepec).
alias_token(municipio, "huatulco", santa_maria_huatulco).
alias_token(municipio, "tlaxiaco", heroica_ciudad_de_tlaxiaco).
alias_token(municipio, "xoxo", santa_cruz_xoxocotlan).
alias_token(municipio, "ixtlan", ixtlan_de_juarez).
alias_token(municipio, "miahuatlan", miahuatlan_de_porfirio_diaz).

interpretar_consulta_natural(Frase, consulta_vocacional(Carrera, Municipio)) :-
    parse_frase_tokens(Frase, Tokens),
    (   member(T1, Tokens), alias_token(carrera, T1, Carrera) -> true
    ;   Carrera = ing_sistemas_computacionales
    ),
    (   member(T2, Tokens), alias_token(municipio, T2, Municipio) -> true
    ;   Municipio = oaxaca_de_juarez
    ).

% --- REGLA 8: RED DE AFINIDAD DISCIPLINAR Y CARRERAS AFINES ---
cluster_tematico(computacion_software,
    [ing_sistemas_computacionales, ing_software, ing_inteligencia_artificial, ing_telecomunicaciones, ing_electronica]).
cluster_tematico(mecanica_industrial_robotica,
    [ing_mecanica, ing_electrica, ing_mecatronica, ing_industrial, ing_energias_renovables]).
cluster_tematico(infraestructura_tierra,
    [ing_civil, ing_geologia, ing_ambiental]).
cluster_tematico(bio_quimica_alimentos,
    [ing_biomedica, ing_alimentos, ing_quimica]).
cluster_tematico(ciencias_salud,
    [medicina_humana, cirujano_dentista, enfermeria, nutricion_clinica, fisioterapia, quimico_farmacobiologo, psicologia_clinica]).
cluster_tematico(agropecuarias_fauna,
    [ing_agronomica, ing_forestal, ing_acuicola, medicina_veterinaria]).
cluster_tematico(negocios_gestion,
    [administracion_empresas, contaduria_publica, comercio_internacional, mercadotecnia_digital, gestion_turistica, gastronomia, economia]).
cluster_tematico(sociales_leyes,
    [derecho, ciencias_politicas, relaciones_internacionales, comunicacion_periodismo, sociologia, antropologia_social]).
cluster_tematico(educacion,
    [pedagogia, educacion_especial]).
cluster_tematico(diseno_artes,
    [arquitectura, diseno_grafico, diseno_industrial, artes_plasticas, musica]).
cluster_tematico(humanidades,
    [filosofia, historia, lenguas_extranjeras]).
cluster_tematico(ciencias_exactas,
    [matematicas_aplicadas, fisica, biologia, ciencias_ambientales, actuaria]).

carrera_relacionada(C1, C2, directa) :-
    cluster_tematico(_, Lista),
    member(C1, Lista),
    member(C2, Lista),
    C1 \== C2.
carrera_relacionada(C1, C2, area) :-
    carrera(C1, _, Area, _, _),
    carrera(C2, _, Area, _, _),
    C1 \== C2,
    \+ carrera_relacionada(C1, C2, directa).

carreras_afines(CarreraBase, ListaAfines) :-
    findall(C-directa, carrera_relacionada(CarreraBase, C, directa), Directas),
    findall(C-area, carrera_relacionada(CarreraBase, C, area), DeArea),
    append(Directas, DeArea, Todas),
    list_to_set(Todas, ListaAfines).

buscar_carreras_por_texto(Texto, Coincidencias) :-
    downcase_atom(Texto, TextoMin),
    findall(IdC,
            ( carrera(IdC, NombreC, AreaC, _, _),
              downcase_atom(NombreC, NomMin),
              downcase_atom(IdC, IdMin),
              downcase_atom(AreaC, AreaMin),
              ( sub_atom(NomMin, _, _, _, TextoMin)
              ; sub_atom(IdMin, _, _, _, TextoMin)
              ; sub_atom(AreaMin, _, _, _, TextoMin)
              )
            ),
            Brutas),
    list_to_set(Brutas, Coincidencias).

% --- REGLA 9: PROXIMIDAD TERRITORIAL Y ZONA CONURBADA METROPOLITANA ---
zona_conurbada_oaxaca(oaxaca_de_juarez).
zona_conurbada_oaxaca(santa_cruz_xoxocotlan).
zona_conurbada_oaxaca(santa_lucia_del_camino).
zona_conurbada_oaxaca(san_raymundo_jalpan).
zona_conurbada_oaxaca(san_antonio_de_la_cal).
zona_conurbada_oaxaca(san_sebastian_tutla).
zona_conurbada_oaxaca(santa_maria_atzompa).
zona_conurbada_oaxaca(san_jacinto_amilpas).
zona_conurbada_oaxaca(san_bartolo_coyotepec).
zona_conurbada_oaxaca(villa_de_zaachila).
zona_conurbada_oaxaca(tlalixtac_de_cabrera).

categoria_distancia(MunOrigen, MunDestino, local_conurbada, 'Local / Zona Metropolitana (Traslado diario en transporte urbano, sin gasto de renta)') :-
    ( MunOrigen == MunDestino
    ; ( zona_conurbada_oaxaca(MunOrigen), zona_conurbada_oaxaca(MunDestino) )
    ), !.
categoria_distancia(MunOrigen, MunDestino, regional_cercana, 'Regional (Misma región; traslado intermunicipal en autobús/colectivo sin mudanza obligada)') :-
    municipio_sede(MunOrigen, _, Region, _),
    municipio_sede(MunDestino, _, Region, _), !.
categoria_distancia(MunOrigen, MunDestino, foranea_con_mudanza, 'Sede Foránea en otra región (Requiere mudanza, renta de cuarto/pensión y manutención independiente)') :-
    municipio_sede(MunOrigen, _, RegO, _),
    municipio_sede(MunDestino, _, RegD, _),
    RegO \== RegD, !.

retorno_inversion_carrera(IdInst, IdCarrera, CostoColegiaturaTotal, CostoInsumosTotal, InversionTotal, MesesROI) :-
    carrera(IdCarrera, _, _, Semestres, _),
    costo_carrera(IdInst, IdCarrera, CuotaSem, InsumosMes, _),
    mercado_laboral(IdCarrera, SueldoMes, _, _, _),
    CostoColegiaturaTotal is CuotaSem * Semestres,
    MesesEstudio is Semestres * 6,
    CostoInsumosTotal is InsumosMes * MesesEstudio,
    InversionTotal is CostoColegiaturaTotal + CostoInsumosTotal,
    (   SueldoMes > 0
    ->  MesesROIBruto is InversionTotal / SueldoMes,
        MesesROI is round(MesesROIBruto * 10) / 10
    ;   MesesROI = 0.0
    ), !.

% =========================================================================
% CONTEO Y AUDITORÍA DE LAS 10 TABLAS PRINCIPALES
% =========================================================================
total_tabla(carrera, N)            :- aggregate_all(count, carrera(_, _, _, _, _), N).
total_tabla(institucion, N)        :- aggregate_all(count, institucion(_, _, _, _, _), N).
total_tabla(municipio_sede, N)     :- aggregate_all(count, municipio_sede(_, _, _, _), N).
total_tabla(oferta_academica, N)   :- aggregate_all(count, oferta_academica(_, _, _, _), N).
total_tabla(perfil_holland, N)     :- aggregate_all(count, perfil_holland(_, _, _, _, _, _, _), N).
total_tabla(mercado_laboral, N)    :- aggregate_all(count, mercado_laboral(_, _, _, _, _), N).
total_tabla(requisito_admision, N) :- aggregate_all(count, requisito_admision(_, _, _, _, _), N).
total_tabla(programa_beca, N)      :- aggregate_all(count, programa_beca(_, _, _, _, _), N).
total_tabla(costo_carrera, N)      :- aggregate_all(count, costo_carrera(_, _, _, _, _), N).
total_tabla(materia_critica, N)    :- aggregate_all(count, materia_critica(_, _, _, _, _), N).

contar_tablas_vocacion :-
    writeln('================================================================='),
    writeln('   TAMAÑO DE LA BASE DE CONOCIMIENTOS (10 TABLAS PRINCIPALES)'),
    writeln('================================================================='),
    Tablas = [carrera, institucion, municipio_sede, oferta_academica,
              perfil_holland, mercado_laboral, requisito_admision,
              programa_beca, costo_carrera, materia_critica],
    findall(N,
            ( member(T, Tablas),
              total_tabla(T, N),
              format('  [✓] Tabla ~w~t: ~d hechos~n', [T, N])
            ),
            Totales),
    sum_list(Totales, GranTotal),
    writeln('-----------------------------------------------------------------'),
    aggregate_all(count, (institucion(_, _, _, R, _), R == privada), TotPriv),
    aggregate_all(count, (institucion(_, _, _, R, _), R \== privada), TotPub),
    format('  INSTITUCIONES: ~d Públicas | ~d Privadas~n', [TotPub, TotPriv]),
    format('  TOTAL CONJUNTO: ~d hechos en las 10 tablas principales.~n', [GranTotal]),
    writeln('=================================================================').

% =========================================================================
% MENÚ INTERACTIVO PEDAGÓGICO Y ENTRADA DE DATOS
% =========================================================================
leer_entero_valido(Pregunta, Min, Max, Numero) :-
    repeat,
    format('~w ', [Pregunta]),
    flush_output,
    read_line_to_string(user_input, Entrada),
    (   Entrada == end_of_file -> Numero = 0, !
    ;   normalize_space(string(Limpio), Entrada),
        catch(number_string(N, Limpio), _, fail),
        integer(N),
        between(Min, Max, N)
    ->  Numero = N, !
    ;   writeln('Entrada no válida. Por favor escribe un número dentro del rango permitido.'), fail
    ).

leer_numero_flotante(Pregunta, Min, Max, Numero) :-
    repeat,
    format('~w ', [Pregunta]),
    flush_output,
    read_line_to_string(user_input, Entrada),
    (   Entrada == end_of_file -> Numero = 0.0, !
    ;   normalize_space(string(Limpio), Entrada),
        catch(number_string(N, Limpio), _, fail),
        N >= Min, N =< Max
    ->  Numero is float(N), !
    ;   format('Entrada no válida. Debe ser un número con decimales entre ~w y ~w (ej. 8.5).~n', [Min, Max]), fail
    ).

menu :-
    repeat,
    nl,
    writeln('================================================================='),
    writeln('   SISTEMA EXPERTO VOCACIONAL Y DE ADMISIÓN UNIVERSITARIA        '),
    writeln('   (Universidades Públicas y Privadas en Oaxaca y México)        '),
    writeln('   Caso de Estudio 3 — Programación Lógica y Funcional           '),
    writeln('================================================================='),
    writeln(' 1. Explorar Oferta Académica (Filtro por Públicas, Privadas o Todas)'),
    writeln(' 2. Test Vocacional Automatizado (Modelo Psicométrico Holland RIASEC)'),
    writeln(' 3. Simulador de Admisión Universitaria (EVALUATEC, SUNEO, EXANI-II, PAA)'),
    writeln(' 4. Analizador de Proximidad Territorial: Escuelas Cercanas vs Foráneas (Mudanza)'),
    writeln(' 5. Observatorio Financiero Universitario: Costos y Comparativa por Régimen'),
    writeln(' 6. Buscador Inteligente de Becas y Apoyos Estudiantiles Elegibles'),
    writeln(' 7. Análisis de Materias Críticas y Filtro de Retención Académica'),
    writeln(' 8. Búsqueda Inteligente mediante Frase en Lenguaje Natural'),
    writeln(' 9. Ficha Técnica Profesional, Salarios de Egresados y Empleabilidad'),
    writeln(' 0. Salir del Sistema'),
    writeln('-----------------------------------------------------------------'),
    leer_entero_valido('Selecciona una opción (0-9):', 0, 9, Opcion),
    ejecutar_opcion(Opcion),
    Opcion =:= 0, !.

ejecutar_opcion(0) :- writeln('Sesión finalizada. Mucho éxito en tu futuro profesional y universitario.').
ejecutar_opcion(1) :- opcion_explorar_carreras.
ejecutar_opcion(2) :- opcion_test_holland.
ejecutar_opcion(3) :- opcion_simulador_admision.
ejecutar_opcion(4) :- opcion_proximidad_territorial.
ejecutar_opcion(5) :- opcion_observatorio_financiero.
ejecutar_opcion(6) :- opcion_buscador_becas.
ejecutar_opcion(7) :- opcion_materias_criticas.
ejecutar_opcion(8) :- opcion_lenguaje_natural.
ejecutar_opcion(9) :- opcion_ficha_carrera.

seleccionar_carrera(C) :-
    writeln('================================================================='),
    writeln('            SELECCIÓN DE CARRERA PROFESIONAL                     '),
    writeln('================================================================='),
    writeln(' 1. Elegir por Área de Conocimiento (Salud, Ingeniería, Negocios, etc.)'),
    writeln(' 2. Ver catálogo completo clasificado por áreas (1 al 55)'),
    writeln(' 3. Buscar por palabra clave (ej. "especial", "fisioterapia", "software")'),
    leer_entero_valido('Elige tu método de selección (1, 2 o 3):', 1, 3, Metodo),
    (   Metodo =:= 1
    ->  seleccionar_carrera_por_area(C)
    ;   Metodo =:= 2
    ->  seleccionar_carrera_catalogo(C)
    ;   seleccionar_carrera_busqueda(C)
    ).

seleccionar_carrera_por_area(C) :-
    writeln('================================================================='),
    writeln('             ÁREAS DE CONOCIMIENTO PROFESIONAL EN OAXACA          '),
    writeln('================================================================='),
    writeln(' 1. Ciencias de la Salud (Medicina, Odontología, Enfermería, Fisioterapia, Nutrición, QFB...)'),
    writeln(' 2. Ingeniería y Tecnología (Sistemas, Software, IA, Mecatrónica, Civil, Industrial...)'),
    writeln(' 3. Ciencias Económico-Administrativas (Administración, Contaduría, Mercadotecnia, Gastronomía...)'),
    writeln(' 4. Ciencias Sociales, Derecho y Educación (Derecho, Pedagogía, Educación Especial, Políticas...)'),
    writeln(' 5. Artes, Arquitectura y Humanidades (Arquitectura, Diseño, Música, Idiomas, Filosofía...)'),
    writeln(' 6. Ciencias Agropecuarias y Veterinaria (Veterinaria, Agronomía, Forestal, Acuícola...)'),
    writeln(' 7. Ciencias Exactas y Naturales (Matemáticas, Física, Biología, Actuaría, Ambientales...)'),
    writeln('-----------------------------------------------------------------'),
    leer_entero_valido('Selecciona el área que te interesa (1-7):', 1, 7, NumArea),
    area_por_numero(NumArea, AreaClave, AreaNombre),
    findall(IdC, carrera(IdC, _, AreaClave, _, _), CarrerasArea),
    length(CarrerasArea, TotArea),
    format('~n=================================================================~n'),
    format('CARRERAS DISPONIBLES EN: ~w~n', [AreaNombre]),
    format('=================================================================~n'),
    forall(nth1(Idx, CarrerasArea, ClaveC),
           ( carrera(ClaveC, NomC, _, SemC, ExigC),
             format(' ~d. ~w (~d semestres | Dificultad: ~w)~n', [Idx, NomC, SemC, ExigC])
           )),
    writeln('-----------------------------------------------------------------'),
    format(atom(PromptC), 'Elige la carrera que deseas consultar (1-~d):', [TotArea]),
    leer_entero_valido(PromptC, 1, TotArea, IdxSel),
    nth1(IdxSel, CarrerasArea, C).

area_por_numero(1, ciencias_salud, 'Ciencias de la Salud').
area_por_numero(2, ingenieria_y_tecnologia, 'Ingeniería y Tecnología').
area_por_numero(3, administracion_y_negocios, 'Ciencias Económico-Administrativas').
area_por_numero(4, ciencias_sociales_y_derecho, 'Ciencias Sociales, Derecho y Educación').
area_por_numero(5, artes_y_humanidades, 'Artes, Arquitectura y Humanidades').
area_por_numero(6, ciencias_agropecuarias, 'Ciencias Agropecuarias y Veterinaria').
area_por_numero(7, ciencias_exactas_y_naturales, 'Ciencias Exactas y Naturales').

seleccionar_carrera_catalogo(C) :-
    findall(Id, carrera(Id, _, _, _, _), Carreras),
    length(Carreras, Total),
    writeln('================================================================='),
    writeln('       CATÁLOGO GENERAL DE PROFESIONES CLASIFICADO POR ÁREAS     '),
    writeln('================================================================='),
    Areas = [ciencias_salud, ingenieria_y_tecnologia, administracion_y_negocios,
             ciencias_sociales_y_derecho, artes_y_humanidades, ciencias_agropecuarias,
             ciencias_exactas_y_naturales],
    forall(member(A, Areas),
           ( area_nombre(A, NomA),
             format('~n--- ÁREA: ~w ---~n', [NomA]),
             forall(( nth1(I, Carreras, Clave), carrera(Clave, Nom, A, Sem, Exig) ),
                    format(' ~|~` t~d~2+. ~w (~d sem | Dificultad: ~w)~n', [I, Nom, Sem, Exig]))
           )),
    writeln('-----------------------------------------------------------------'),
    format(atom(Prompt), 'Elige el número de carrera que deseas consultar (1-~d):', [Total]),
    leer_entero_valido(Prompt, 1, Total, Idx),
    nth1(Idx, Carreras, C).

seleccionar_carrera_busqueda(C) :-
    repeat,
    format('Ingresa la palabra clave de la carrera (ej. software, medicina, derecho, ambiental): '),
    flush_output,
    read_line_to_string(user_input, Entrada),
    normalize_space(string(Termino), Entrada),
    (   Termino == ""
    ->  writeln('Entrada vacía. Mostrando catálogo completo:'),
        seleccionar_carrera_catalogo(C), !
    ;   atom_string(TerminoAtom, Termino),
        buscar_carreras_por_texto(TerminoAtom, Coincidencias),
        (   Coincidencias == []
        ->  writeln('No se encontraron carreras con ese término. Intenta con otra palabra.'),
            fail
        ;   length(Coincidencias, 1)
        ->  Coincidencias = [C],
            carrera(C, NomUnico, _, _, _),
            format('-> Coincidencia exacta única: ~w~n', [NomUnico]), !
        ;   length(Coincidencias, TotCoinc),
            writeln('-----------------------------------------------------------------'),
            format('Se encontraron ~d carreras coincidentes:\n', [TotCoinc]),
            forall(nth1(Idx, Coincidencias, ClaveC),
                   ( carrera(ClaveC, NomC, AreaC, SemC, _),
                     area_nombre(AreaC, AreaNom),
                     format(' ~d. ~w (~w | ~d semestres)~n', [Idx, NomC, AreaNom, SemC])
                   )),
            writeln('-----------------------------------------------------------------'),
            format(atom(PromptC), 'Elige la opción deseada (1-~d):', [TotCoinc]),
            leer_entero_valido(PromptC, 1, TotCoinc, Elegido),
            nth1(Elegido, Coincidencias, C), !
        )
    ), !.

seleccionar_municipio_residencia(M) :-
    writeln('================================================================='),
    writeln('            SELECCIÓN DE MUNICIPIO DE RESIDENCIA                 '),
    writeln('================================================================='),
    writeln(' 1. Elegir por Región Geográfica de Oaxaca (Valles, Costa, Istmo, Mixteca...)'),
    writeln(' 2. Ver catálogo completo clasificado por regiones (1 al 52)'),
    writeln(' 3. Buscar municipio por nombre (ej. "xoxo", "huajuapan", "tuxtepec", "salina")'),
    leer_entero_valido('Elige tu método de selección (1, 2 o 3):', 1, 3, Metodo),
    (   Metodo =:= 1
    ->  seleccionar_municipio_por_region(M)
    ;   Metodo =:= 2
    ->  seleccionar_municipio_catalogo(M)
    ;   seleccionar_municipio_busqueda(M)
    ).

seleccionar_municipio_por_region(M) :-
    writeln('================================================================='),
    writeln('             REGIONES GEOGRÁFICAS DEL ESTADO DE OAXACA           '),
    writeln('================================================================='),
    writeln(' 1. Valles Centrales (Oaxaca de Juárez, Xoxocotlán, Jalpan, Zaachila, Etla...)'),
    writeln(' 2. Costa (Puerto Escondido, Santa María Huatulco, Pinotepa Nacional, Pochutla...)'),
    writeln(' 3. Istmo de Tehuantepec (Salina Cruz, Juchitán, Tehuantepec, Ciudad Ixtepec...)'),
    writeln(' 4. Mixteca (Heroica Ciudad de Huajuapan de León, Tlaxiaco, Nochixtlán...)'),
    writeln(' 5. Papaloapan (San Juan Bautista Tuxtepec, Loma Bonita...)'),
    writeln(' 6. Sierra Sur (Miahuatlán de Porfirio Díaz, Putla Villa de Guerrero...)'),
    writeln(' 7. Sierra Norte (Ixtlán de Juárez, Tamazulápam...)'),
    writeln('-----------------------------------------------------------------'),
    leer_entero_valido('Selecciona la región donde vives (1-7):', 1, 7, NumReg),
    region_por_numero(NumReg, RegClave, RegNombre),
    findall(IdM, municipio_sede(IdM, _, RegClave, _), MunsReg),
    length(MunsReg, TotMuns),
    format('~n=================================================================~n'),
    format('MUNICIPIOS DE LA REGIÓN: ~w~n', [RegNombre]),
    format('=================================================================~n'),
    forall(nth1(Idx, MunsReg, ClaveM),
           ( municipio_sede(ClaveM, NomM, _, CostoM),
             format(' ~|~` t~d~2+. ~w [Costo de vida foráneo aprox.: $~d MXN/mes]~n', [Idx, NomM, CostoM])
           )),
    writeln('-----------------------------------------------------------------'),
    format(atom(PromptM), 'Elige tu municipio de residencia (1-~d):', [TotMuns]),
    leer_entero_valido(PromptM, 1, TotMuns, IdxSel),
    nth1(IdxSel, MunsReg, M).

region_por_numero(1, valles_centrales, 'Valles Centrales').
region_por_numero(2, costa, 'Costa').
region_por_numero(3, istmo, 'Istmo de Tehuantepec').
region_por_numero(4, mixteca, 'Mixteca').
region_por_numero(5, papaloapan, 'Papaloapan').
region_por_numero(6, sierra_sur, 'Sierra Sur').
region_por_numero(7, sierra_norte, 'Sierra Norte').

seleccionar_municipio_catalogo(M) :-
    findall(IdM, municipio_sede(IdM, _, _, _), Muns),
    length(Muns, Total),
    writeln('================================================================='),
    writeln('    MUNICIPIOS DE RESIDENCIA EN OAXACA (CLASIFICADOS POR REGIÓN) '),
    writeln('================================================================='),
    Regiones = [valles_centrales, costa, istmo, mixteca, papaloapan, sierra_sur, sierra_norte],
    forall(member(R, Regiones),
           ( region_nombre(R, NomR),
             format('~n--- REGIÓN: ~w ---~n', [NomR]),
             forall(( nth1(I, Muns, Clave), municipio_sede(Clave, Nom, R, Costo) ),
                    format(' ~|~` t~d~2+. ~w (Costo vida: $~d MXN/mes)~n', [I, Nom, Costo]))
           )),
    writeln('-----------------------------------------------------------------'),
    format(atom(Prompt), 'Elige el número de tu municipio (1-~d):', [Total]),
    leer_entero_valido(Prompt, 1, Total, Idx),
    nth1(Idx, Muns, M).

region_nombre(valles_centrales, 'Valles Centrales').
region_nombre(costa, 'Costa').
region_nombre(istmo, 'Istmo de Tehuantepec').
region_nombre(mixteca, 'Mixteca').
region_nombre(papaloapan, 'Papaloapan').
region_nombre(sierra_sur, 'Sierra Sur').
region_nombre(sierra_norte, 'Sierra Norte').

seleccionar_municipio_busqueda(M) :-
    repeat,
    format('Ingresa el nombre de tu municipio o poblado (ej. xoxo, huajuapan, tuxtepec, salina): '),
    flush_output,
    read_line_to_string(user_input, Entrada),
    normalize_space(string(Termino), Entrada),
    (   Termino == ""
    ->  writeln('Entrada vacía. Mostrando lista por regiones:'),
        seleccionar_municipio_por_region(M), !
    ;   atom_string(TerminoAtom, Termino),
        buscar_municipios_por_texto(TerminoAtom, Coincidencias),
        (   Coincidencias == []
        ->  writeln('No se encontraron municipios con ese nombre. Intenta con otra palabra.'),
            fail
        ;   length(Coincidencias, 1)
        ->  Coincidencias = [M],
            municipio_sede(M, NomUnico, RegUnica, _),
            region_nombre(RegUnica, NomRegU),
            format('-> Municipio identificado: ~w [Región: ~w]~n', [NomUnico, NomRegU]), !
        ;   length(Coincidencias, TotCoinc),
            writeln('-----------------------------------------------------------------'),
            format('Se encontraron ~d municipios coincidentes con el término ingresado:~n', [TotCoinc]),
            forall(nth1(Idx, Coincidencias, ClaveM),
                   ( municipio_sede(ClaveM, NomM, RegM, _),
                     region_nombre(RegM, NomRegM),
                     format(' ~d. ~w [Región: ~w]~n', [Idx, NomM, NomRegM])
                   )),
            writeln('-----------------------------------------------------------------'),
            format(atom(PromptC), 'Elige la opción deseada (1-~d):', [TotCoinc]),
            leer_entero_valido(PromptC, 1, TotCoinc, Elegido),
            nth1(Elegido, Coincidencias, M), !
        )
    ).

buscar_municipios_por_texto(Texto, Coincidencias) :-
    downcase_atom(Texto, TextoMin),
    findall(IdM,
            ( municipio_sede(IdM, NomM, RegM, _),
              downcase_atom(NomM, NomMin),
              downcase_atom(IdM, IdMin),
              downcase_atom(RegM, RegMin),
              ( sub_atom(NomMin, _, _, _, TextoMin)
              ; sub_atom(IdMin, _, _, _, TextoMin)
              ; sub_atom(RegMin, _, _, _, TextoMin)
              )
            ),
            Brutas),
    list_to_set(Brutas, Coincidencias).

opcion_explorar_carreras :-
    writeln('================================================================='),
    writeln('=== EXPLORACIÓN DE OFERTA ACADÉMICA Y CARRERAS RELACIONADAS ==='),
    writeln('================================================================='),
    seleccionar_carrera(C),
    carrera(C, NomC, Area, Sem, Exig),
    area_nombre(Area, AreaTxt),
    mercado_laboral(C, Sueldo, Emp, Dem, Sector),
    format('~n=================================================================~n'),
    format('DETALLES DE LA PROFESIÓN SELECCIONADA: ~w~n', [NomC]),
    format('  Área de estudio:       ~w~n', [AreaTxt]),
    format('  Duración académica:    ~d semestres (~1f años)~n', [Sem, Sem / 2.0]),
    format('  Exigencia académica:   ~w~n', [Exig]),
    format('  Sueldo mensual prom.:  $~d MXN (promedio recién egresado en México)~n', [Sueldo]),
    format('  Tasa de empleabilidad: ~d% | Tendencia de mercado: ~w~n', [Emp, Dem]),
    format('  Sector de contratación:~w~n', [Sector]),
    format('=================================================================~n'),
    nl,
    writeln('¿Qué tipo de universidades deseas consultar para esta búsqueda?'),
    writeln(' 1. Todas las opciones (Públicas y Privadas)'),
    writeln(' 2. Solo Universidades Públicas (UABJO, SUNEO, TecNM)'),
    writeln(' 3. Solo Universidades Privadas (Anáhuac, La Salle, URSE, etc.)'),
    leer_entero_valido('Elige tu preferencia (1-3):', 1, 3, OpReg),
    format('~n=================================================================~n'),
    format('PARTE 1: UNIVERSIDADES QUE IMPARTEN DIRECTAMENTE ~w~n', [NomC]),
    format('=================================================================~n'),
    findall(Inst-Mod-Turno,
            ( oferta_academica(Inst, C, Mod, Turno),
              institucion(Inst, _, _, RegimenInst, _),
              (   OpReg =:= 1 -> true
              ;   OpReg =:= 2 -> (RegimenInst == publica_estatal ; RegimenInst == publica_federal)
              ;   OpReg =:= 3 -> (RegimenInst == privada)
              )
            ),
            OfertasDirectas),
    (   OfertasDirectas == []
    ->  writeln('  (Sin sedes registradas para el filtro seleccionado en esta carrera específica)')
    ;   length(OfertasDirectas, TotOf),
        format('Se encontraron ~d universidades con plan de estudios activo:~n', [TotOf]),
        writeln('-----------------------------------------------------------------'),
        forall(member(IdI-M-T, OfertasDirectas),
               ( institucion(IdI, NomI, MunI, Regimen, Prest),
                 municipio_sede(MunI, NomMun, _, _),
                 costo_carrera(IdI, C, Cuota, Mat, _),
                 formato_regimen(Regimen, RegimenTxt),
                 format('  * ~w [~w | Prestigio: ~w]~n      Ubicación: ~w | Modalidad: ~w (~w)~n      Cuota semestral: $~d MXN | Insumos mensuales: $~d MXN~n',
                        [NomI, RegimenTxt, Prest, NomMun, M, T, Cuota, Mat])
               )),
        writeln('-----------------------------------------------------------------')
    ),
    format('~n=================================================================~n'),
    writeln('PARTE 2: CARRERAS AFINES / RELACIONADAS Y SEDES QUE LAS OFERTAN'),
    writeln('================================================================='),
    writeln('¿Deseas explorar opciones alternativas en la misma área de estudio?'),
    writeln('Estas son carreras hermanas y las universidades que las imparten:'),
    writeln('-----------------------------------------------------------------'),
    carreras_afines(C, ListaAfines),
    (   ListaAfines == []
    ->  writeln('  (No hay carreras afines registradas para esta área)')
    ;   forall(member(CAfin-_, ListaAfines),
               ( carrera(CAfin, NomCAfin, _, _, _),
                 findall(NomInstA,
                         ( oferta_academica(InstA, CAfin, _, _),
                           institucion(InstA, NomInstA, _, RegA, _),
                           (   OpReg =:= 1 -> true
                           ;   OpReg =:= 2 -> (RegA == publica_estatal ; RegA == publica_federal)
                           ;   OpReg =:= 3 -> (RegA == privada)
                           )
                         ),
                         NombresInstAfines),
                 (   NombresInstAfines \== []
                 ->  format('~n  ► ~w~n', [NomCAfin]),
                     forall(member(NomInst, NombresInstAfines),
                            format('    • ~w~n', [NomInst]))
                 ;   true
                 )
               ))
    ),
    writeln('=================================================================').

opcion_test_holland :-
    writeln('================================================================='),
    writeln('   TEST VOCACIONAL AUTOMATIZADO: MODELO HOLLAND RIASEC           '),
    writeln('================================================================='),
    writeln('¿EN QUÉ CONSISTE EL MODELO HOLLAND?'),
    writeln('Desarrollado por el psicólogo John Holland, es el método científico'),
    writeln('más reconocido a nivel internacional para orientación vocacional.'),
    writeln('Evalúa 6 dimensiones de personalidad laboral (RIASEC). Califica cada área'),
    writeln('del 1 (poco interés / habilidad) al 10 (máximo interés / habilidad destacada):'),
    writeln('-----------------------------------------------------------------'),
    writeln('1. Tipo REALISTA (R): Interés en máquinas, campo, herramientas, actividad física y manual.'),
    leer_entero_valido('   Tu puntuación en Realista [1-10]:', 1, 10, R),
    nl,
    writeln('2. Tipo INVESTIGADOR (I): Ciencia, análisis lógico, matemáticas, resolución de enigmas complejos.'),
    leer_entero_valido('   Tu puntuación en Investigador [1-10]:', 1, 10, I),
    nl,
    writeln('3. Tipo ARTÍSTICO (A): Creatividad, música, dibujo, diseño visual, literatura, expresión libre.'),
    leer_entero_valido('   Tu puntuación en Artístico [1-10]:', 1, 10, A),
    nl,
    writeln('4. Tipo SOCIAL (S): Empatía, vocación de servicio, salud, enseñanza, bienestar y apoyo a personas.'),
    leer_entero_valido('   Tu puntuación en Social [1-10]:', 1, 10, S),
    nl,
    writeln('5. Tipo EMPRENDEDOR (E): Liderazgo, negocios, proyectos, persuasión, ventas, debatir y dirigir grupos.'),
    leer_entero_valido('   Tu puntuación en Emprendedor [1-10]:', 1, 10, E),
    nl,
    writeln('6. Tipo CONVENCIONAL (C): Organización, métodos, finanzas, contabilidad, datos, apego a normativas.'),
    leer_entero_valido('   Tu puntuación en Convencional [1-10]:', 1, 10, C),
    PerfilInicial = perfil_aspirante(R, I, A, S, E, C),
    nl,
    writeln('ETAPA 2: 12 PREGUNTAS SOBRE ACTIVIDADES REALES (1=Nunca, 5=Mucho).'),
    writeln('Responde según lo que disfrutas hacer, no según tus notas escolares.'),
    cuestionario_conductual(Respuestas),
    combinar_perfiles(PerfilInicial, Respuestas, PerfilBase),
    detectar_areas_cercanas(PerfilBase, AreasCercanas),
    (   AreasCercanas = [Primera, Segunda | _]
    ->  nl,
        writeln('Tus intereses principales son muy parecidos.'),
        writeln('ETAPA 3: Preguntas de preferencia para explorar ambas áreas.'),
        desempate_contextual(PerfilBase, Primera, Segunda, Perfil)
    ;   Perfil = PerfilBase
    ),
    nl,
    writeln('================================================================='),
    writeln('        DIAGNÓSTICO DETALLADO DE TU PERFIL PSICOMÉTRICO          '),
    writeln('================================================================='),
    diagnosticar_perfil_aspirante(Perfil),
    nl,
    ranking_afinidad_vocacional(Perfil, Ranking),
    writeln('================================================================='),
    writeln('   TOP 5 CARRERAS COMPATIBLES Y MOTIVOS DE LA RECOMENDACIÓN      '),
    writeln('================================================================='),
    findall(Sc-Carr, (member(Sc-Carr, Ranking)), Todos),
    (   length(Todos, Len), Len >= 5 -> length(Top5, 5), append(Top5, _, Todos) ; Top5 = Todos ),
    forall(nth1(Rank, Top5, Score-IdC),
           ( carrera(IdC, NomCarr, AreaC, _, _),
             area_nombre(AreaC, AreaTxt),
             mercado_laboral(IdC, Sueldo, Emp, _, _),
             format('~n ~d. [~d% de Afinidad] ~w~n', [Rank, Score, NomCarr]),
             format('    Área académica:              ~w~n', [AreaTxt]),
             format('    Sueldo mensual inicial prom: $~d MXN | Empleabilidad formal: ~d%~n', [Sueldo, Emp]),
             justificacion_vocacional_carrera(IdC, Perfil, Justif),
             format('    ► ¿Por qué te la recomendamos?:~n      ~w~n', [Justif])
           )),
    writeln('=================================================================').

% Preguntas conductuales: dos observaciones por cada dimensión RIASEC.
% Estas preguntas exploran intereses declarados; NO son una prueba clínica validada.
pregunta_conductual(r, '¿Disfrutas reparar, construir o manipular objetos?').
pregunta_conductual(r, '¿Prefieres aprender haciendo prototipos o trabajos de campo?').
pregunta_conductual(i, '¿Te entusiasma investigar por qué ocurre algo?').
pregunta_conductual(i, '¿Te gusta comparar evidencias y resolver problemas abstractos?').
pregunta_conductual(a, '¿Disfrutas crear diseños, historias, música o imágenes originales?').
pregunta_conductual(a, '¿Prefieres experimentar con soluciones creativas sin un método fijo?').
pregunta_conductual(s, '¿Te interesa escuchar y orientar a otras personas?').
pregunta_conductual(s, '¿Disfrutas enseñar y colaborar para resolver necesidades humanas?').
pregunta_conductual(e, '¿Te gusta proponer proyectos y convencer a un equipo?').
pregunta_conductual(e, '¿Disfrutas negociar y organizar iniciativas nuevas?').
pregunta_conductual(c, '¿Disfrutas ordenar datos y verificar detalles cuidadosamente?').
pregunta_conductual(c, '¿Prefieres planear procedimientos y trabajar con reglas claras?').

cuestionario_conductual(Puntajes) :-
    findall(Dim-Suma,
            ( member(Dim, [r,i,a,s,e,c]),
              findall(Pregunta, pregunta_conductual(Dim, Pregunta), Preguntas),
              preguntar_lista(Preguntas, Suma)
            ), Puntajes).

preguntar_lista([], 0).
preguntar_lista([Texto|Resto], Total) :-
    leer_entero_valido(Texto, 1, 5, Respuesta),
    preguntar_lista(Resto, Subtotal),
    Total is Respuesta + Subtotal.

% La suma de dos respuestas de 1 a 5 está en la misma escala 2-10.
% El promedio del autoinforme inicial y las conductas produce un perfil refinado.
combinar_perfiles(perfil_aspirante(R,I,A,S,E,C), Respuestas,
                 perfil_aspirante(RF,IF,AF,SF,EF,CF)) :-
    member(r-RS, Respuestas), member(i-IS, Respuestas),
    member(a-AS, Respuestas), member(s-SS, Respuestas),
    member(e-ES, Respuestas), member(c-CS, Respuestas),
    RF is (R+RS)/2, IF is (I+IS)/2, AF is (A+AS)/2,
    SF is (S+SS)/2, EF is (E+ES)/2, CF is (C+CS)/2.

valores_perfil(perfil_aspirante(R,I,A,S,E,C),
              [r-R,i-I,a-A,s-S,e-E,c-C]).
perfil_desde_valores(Valores, perfil_aspirante(R,I,A,S,E,C)) :-
    member(r-R,Valores), member(i-I,Valores), member(a-A,Valores),
    member(s-S,Valores), member(e-E,Valores), member(c-C,Valores).

% Si los dos resultados principales difieren en <= 1 punto,
% se explora su coexistencia; no se fuerza una clasificación única.
detectar_areas_cercanas(Perfil, [D1,D2]) :-
    valores_perfil(Perfil, Valores),
    findall(Neg-D, (member(D-V,Valores), Neg is -V), Pares),
    keysort(Pares, [_-D1, Neg2-D2|_]),
    member(D1-V1, Valores),
    V2 is -Neg2,
    V1-V2 =< 1.0, !.
detectar_areas_cercanas(_, []).

% Respuesta 1 = primera área, 2 = segunda área, 3 = ambas por igual.
% Se pregunta por preferencias situacionales, no por capacidad supuesta.
desempate_contextual(Perfil, D1, D2, Refinado) :-
    dimension_info(D1, Nom1, _, _),
    dimension_info(D2, Nom2, _, _),
    format('Áreas cercanas: ~w y ~w.~n', [Nom1,Nom2]),
    writeln('Imagina elegir una actividad voluntaria para el fin de semana:'),
    format('  1. Actividad del área ~w.~n  2. Actividad del área ~w.~n  3. Ambas.~n', [Nom1,Nom2]),
    leer_entero_valido('¿Qué preferirías? [1-3]', 1, 3, R1),
    writeln('Si tuvieras que empezar un proyecto sin recibir una calificación:'),
    format('  1. Un proyecto del área ~w.~n  2. Uno del área ~w.~n  3. Mezclar ambos.~n', [Nom1,Nom2]),
    leer_entero_valido('¿Cuál elegirías? [1-3]', 1, 3, R2),
    ajustar_preferencias(Perfil, D1, D2, [R1,R2], Refinado).

ajustar_preferencias(Perfil, D1, D2, Respuestas, Refinado) :-
    valores_perfil(Perfil, Valores),
    contar_preferencias(Respuestas, N1, N2),
    (   N1 > N2 -> Bonus1 = 0.5, Bonus2 = 0
    ;   N2 > N1 -> Bonus1 = 0, Bonus2 = 0.5
    ;   Bonus1 = 0, Bonus2 = 0
    ),
    findall(D-VN, (member(D-V, Valores),
            (D == D1 -> VN is min(10,V+Bonus1)
            ;D == D2 -> VN is min(10,V+Bonus2)
            ;VN = V)), Nuevos),
    perfil_desde_valores(Nuevos, Refinado).

contar_preferencias([], 0, 0).
contar_preferencias([R|Rs], N1, N2) :-
    contar_preferencias(Rs, A, B),
    (R =:= 1 -> N1 is A+1 ; N1 = A),
    (R =:= 2 -> N2 is B+1 ; N2 = B).

diagnosticar_perfil_aspirante(perfil_aspirante(R, I, A, S, E, C)) :-
    writeln('Tus puntuaciones en las 6 dimensiones RIASEC:'),
    format('  • Realista (R):       ~|~` t~1f~2+/10~n', [R]),
    format('  • Investigador (I):   ~|~` t~1f~2+/10~n', [I]),
    format('  • Artístico (A):      ~|~` t~1f~2+/10~n', [A]),
    format('  • Social (S):         ~|~` t~1f~2+/10~n', [S]),
    format('  • Emprendedor (E):    ~|~` t~1f~2+/10~n', [E]),
    format('  • Convencional (C):   ~|~` t~1f~2+/10~n', [C]),
    nl,
    Lista = [R-r, I-i, A-a, S-s, E-e, C-c],
    findall(Neg-D, (member(P-D, Lista), Neg is -P), Ordenables),
    keysort(Ordenables, [Neg1-D1, Neg2-D2 | _]),
    P1 is -Neg1, P2 is -Neg2,
    dimension_info(D1, NomD1, Letra1, DescD1),
    dimension_info(D2, NomD2, Letra2, DescD2),
    writeln('► ¿EN QUÉ SALISTE BIEN Y QUÉ SIGNIFICA TU RESULTADO?'),
    format('  1. Tu Área Dominante Principal es: ~w (~w) con ~1f/10 puntos.~n', [NomD1, Letra1, P1]),
    format('     Interpretación: ~w~n', [DescD1]),
    nl,
    format('  2. Tu Área Secundaria de Apoyo es: ~w (~w) con ~1f/10 puntos.~n', [NomD2, Letra2, P2]),
    format('     Interpretación: ~w~n', [DescD2]),
    nl,
    ( P1-P2 =< 1.0 ->
        writeln('  ► PERFIL MIXTO: ambas áreas tienen importancia similar; no hay un ganador absoluto.')
    ;   true ),
    format('  ► Código Holland de Orientación: [~w-~w]~n', [Letra1, Letra2]),
    explicar_combinacion_holland(D1, D2, ExplicacionCombo),
    format('     Perfil Sintético: ~w~n', [ExplicacionCombo]).

dimension_info(r, 'REALISTA', 'R', 'Sobresales en destreza práctica, gusto por actividades tangibles, uso de herramientas, maquinaria, tecnología aplicada, trabajo en campo y resolución de problemas físicos o técnicos.').
dimension_info(i, 'INVESTIGADOR', 'I', 'Destacas ampliamente en razonamiento analítico, pensamiento lógico-matemático, curiosidad científica, capacidad de abstracción y resolución metódica de problemas complejos.').
dimension_info(a, 'ARTÍSTICO', 'A', 'Posees gran potencial en pensamiento divergente, creatividad, sensibilidad estética, expresión visual, sonora o literaria, y gusto por la innovación sin estructuras rígidas.').
dimension_info(s, 'SOCIAL', 'S', 'Tu mayor fortaleza reside en la empatía humana, vocación de servicio, facilidad para comunicar, educar, orientar, cuidar la salud integral y promover el bienestar comunitario.').
dimension_info(e, 'EMPRENDEDOR', 'E', 'Sobresales en liderazgo proactivo, capacidad de persuasión y negociación, visión estratégica de proyectos, oratoria, asunción de retos y dirección de equipos hacia metas.').
dimension_info(c, 'CONVENCIONAL', 'C', 'Tu fortaleza es la alta organización sistemática, manejo riguroso de finanzas y datos cuantitativos, control de calidad, apego a normativas legales y optimización estructurada de procesos.').

explicar_combinacion_holland(i, r, 'Perfil Técnico-Científico: Ideal para ingenierías aplicadas, desarrollo de software o ciencias exactas, uniendo investigación teórica con ejecución práctica.') :- !.
explicar_combinacion_holland(r, i, 'Perfil Técnico-Científico: Ideal para ingenierías aplicadas, desarrollo de software o ciencias exactas, uniendo investigación teórica con ejecución práctica.') :- !.
explicar_combinacion_holland(i, s, 'Perfil Científico-Humanista: Ideal para Ciencias de la Salud o Educación Especial, uniendo rigor biomédico/analítico con empatía asistencial.') :- !.
explicar_combinacion_holland(s, i, 'Perfil Científico-Humanista: Ideal para Ciencias de la Salud o Educación Especial, uniendo rigor biomédico/analítico con empatía asistencial.') :- !.
explicar_combinacion_holland(i, c, 'Perfil Analítico-Estructurado: Excelente para Ciencias de Datos, Inteligencia Artificial, Actuaría o Finanzas, uniendo lógica con precisión de datos.') :- !.
explicar_combinacion_holland(c, i, 'Perfil Analítico-Estructurado: Excelente para Ciencias de Datos, Inteligencia Artificial, Actuaría o Finanzas, uniendo lógica con precisión de datos.') :- !.
explicar_combinacion_holland(e, c, 'Perfil Ejecutivo-Administrativo: Idóneo para Dirección Empresarial, Derecho Corporativo, Negocios y Finanzas, uniendo liderazgo con control normativo.') :- !.
explicar_combinacion_holland(c, e, 'Perfil Ejecutivo-Administrativo: Idóneo para Dirección Empresarial, Derecho Corporativo, Negocios y Finanzas, uniendo liderazgo con control normativo.') :- !.
explicar_combinacion_holland(s, e, 'Perfil Líder-Social: Recomendado para Derecho, Ciencias Políticas, Pedagogía o Comunicación, combinando persuasión con desarrollo humano.') :- !.
explicar_combinacion_holland(e, s, 'Perfil Líder-Social: Recomendado para Derecho, Ciencias Políticas, Pedagogía o Comunicación, combinando persuasión con desarrollo humano.') :- !.
explicar_combinacion_holland(a, r, 'Perfil Creativo-Técnico: Ideal para Arquitectura, Diseño Industrial o Gastronomía, uniendo imaginación estética con dominio técnico de materiales.') :- !.
explicar_combinacion_holland(r, a, 'Perfil Creativo-Técnico: Ideal para Arquitectura, Diseño Industrial o Gastronomía, uniendo imaginación estética con dominio técnico de materiales.') :- !.
explicar_combinacion_holland(a, s, 'Perfil Artístico-Humanista: Ideal para Pedagogía en Artes, Música, Idiomas o Psicología, uniendo expresión sensible con vocación formadora.') :- !.
explicar_combinacion_holland(s, a, 'Perfil Artístico-Humanista: Ideal para Pedagogía en Artes, Música, Idiomas o Psicología, uniendo expresión sensible con vocación formadora.') :- !.
explicar_combinacion_holland(_, _, 'Perfil Versátil Interdisciplinario: Tienes un balance de aptitudes que te permite destacar en carreras que integran múltiples enfoques teóricos, prácticos y humanos.').

justificacion_vocacional_carrera(ing_software, _, 'Esta carrera exige alto pensamiento analítico-lógico y estructuración algorítmica. Tu puntaje en Investigador y Convencional facilita la programación y la creación metódica de sistemas.') :- !.
justificacion_vocacional_carrera(ing_sistemas_computacionales, _, 'Requiere resolución metódica de problemas complejos y gestión de infraestructura tecnológica. Coincide plenamente con tu razonamiento lógico y curiosidad científica.') :- !.
justificacion_vocacional_carrera(ing_inteligencia_artificial, _, 'Demanda modelación matemática avanzada y deducción abstracta para entrenar modelos computacionales. Empata directamente con tu perfil analítico superior.') :- !.
justificacion_vocacional_carrera(ing_electronica, _, 'Integra diseño de circuitos de precisión y sistemas embebidos, uniendo el razonamiento matemático con la implementación física y control de hardware.') :- !.
justificacion_vocacional_carrera(ing_mecatronica, _, 'Combina mecánica, electrónica y programación robótica. Requiere tu destreza técnica práctica (Realista) con modelado analítico (Investigador).') :- !.
justificacion_vocacional_carrera(ing_telecomunicaciones, _, 'Demanda diseño de redes, transmisión de datos y protocolos de conectividad, capitalizando tu rigor lógico y estructuración técnica.') :- !.
justificacion_vocacional_carrera(ing_civil, _, 'Exige cálculo estructural, física aplicada y dirección de obra en campo (Realista/Investigador), uniendo rigor técnico con visión de infraestructura física.') :- !.
justificacion_vocacional_carrera(ing_industrial, _, 'Enfocada en optimización de procesos de producción, logística y calidad, haciendo sinergia con tu capacidad de organización, datos y liderazgo operativo.') :- !.
justificacion_vocacional_carrera(medicina_humana, _, 'Exige una sólida base científica (Investigador) unida a un compromiso ético de servicio hacia los enfermos (Social). Tu perfil demuestra el equilibrio necesario para el diagnóstico y la atención clínica.') :- !.
justificacion_vocacional_carrera(cirujano_dentista, _, 'Demanda destreza manual fina e instrumental rotatorio (Realista) aunado a la atención personalizada a pacientes (Social). Tu destreza práctica y sentido humano son idóneos.') :- !.
justificacion_vocacional_carrera(enfermeria, _, 'Combina procedimientos clínicos y farmacológicos rigurosos con el cuidado directo, sensible y empático a pacientes y familias en recuperación.') :- !.
justificacion_vocacional_carrera(educacion_especial, _, 'Requiere empatía, paciencia y vocación para diseñar adaptaciones curriculares a estudiantes con discapacidad o sobresalientes. Tu alta afinidad social respalda esta noble profesión.') :- !.
justificacion_vocacional_carrera(fisioterapia, _, 'Une el conocimiento biológico y de rehabilitación manual (Realista) con la empatía asistencial diaria (Social). Hace sinergia directa con tu sentido de servicio corporal.') :- !.
justificacion_vocacional_carrera(derecho, _, 'Demanda capacidad argumentativa, oratoria y liderazgo (Emprendedor) junto al apego riguroso a leyes y códigos procesales (Convencional). Coincide con tu visión crítica y persuasiva.') :- !.
justificacion_vocacional_carrera(arquitectura, _, 'Requiere visión espacial y creatividad estética (Artístico) respaldada por normas constructivas y planeación técnica (Realista/Convencional). Conecta con tu potencial de diseño.') :- !.
justificacion_vocacional_carrera(administracion_empresas, _, 'Exige liderazgo de equipos, visión de negocios y toma de decisiones (Emprendedor) combinadas con orden presupuestal (Convencional). Coincide con tu visión estratégica.') :- !.
justificacion_vocacional_carrera(contaduria, _, 'Enfocada en control financiero, auditoría y precisión numérica (Convencional). Responde a tu perfil ordenado, metódico y disciplinado.') :- !.
justificacion_vocacional_carrera(gastronomia, _, 'Combina técnicas culinarias de precisión y manipulación de insumos (Realista) con diseño creativo de platillos y servicio al comensal (Artístico/Social).') :- !.
justificacion_vocacional_carrera(medicina_veterinaria, _, 'Combina diagnóstico biomédico (Investigador) con trabajo tangible en campo y clínica animal (Realista). Empareja con tu gusto por la biología aplicada.') :- !.
justificacion_vocacional_carrera(Carrera, _, Justif) :-
    carrera(Carrera, _, Area, _, _),
    justificacion_por_area(Area, Justif), !.
justificacion_vocacional_carrera(_, _, 'Esta carrera empareja con la estructura de tus puntuaciones más altas, ofreciendo un entorno formativo afín a tus intereses vocacionales dominantes.').

justificacion_por_area(ciencias_salud, 'Combina estudio biomédico riguroso con servicio directo a la salud de la comunidad. Tus puntajes favorecen el razonamiento clínico, la empatía asistencial y el cuidado humano.').
justificacion_por_area(ingenieria_y_tecnologia, 'Se fundamenta en la resolución metódica de problemas mediante tecnología, física y ciencias exactas. Hace sinergia directa con tu capacidad analítica, diseño estructurado y resolución de retos técnicos.').
justificacion_por_area(administracion_y_negocios, 'Enfocada en la gestión estratégica, modelos económicos y optimización de recursos, capitalizando tu visión de liderazgo, organización cuantitativa y logro de objetivos.').
justificacion_por_area(ciencias_sociales_y_derecho, 'Requiere comprensión crítica de la sociedad, educación, justicia o instituciones, alineándose con tu vocación formativa, oratoria y capacidad reflexiva.').
justificacion_por_area(artes_y_humanidades, 'Integra innovación, estética y expresión cultural, aprovechando tu pensamiento creativo, sensibilidad visual o conceptual y originalidad.').
justificacion_por_area(ciencias_agropecuarias, 'Exige aplicación técnica en entornos naturales, producción animal y ecosistemas, ideal para quienes buscan trabajo tangible fuera de una oficina e impacto sustentable.').
justificacion_por_area(ciencias_exactas_y_naturales, 'Demanda una vocación profunda por el descubrimiento teórico y la modelación matemática rigurosa, correspondiendo a tu mente inquisitiva y deductiva.').

opcion_simulador_admision :-
    writeln('================================================================='),
    writeln('=== SIMULADOR DE ADMISIÓN UNIVERSITARIA REALISTA EN OAXACA ==='),
    writeln('================================================================='),
    writeln('¿CÓMO EVALÚAN LAS DIFERENTES INSTITUCIONES EN OAXACA?'),
    writeln(' 1. Institutos Tecnológicos (TecNM - ITO, Tuxtepec, Salina Cruz, etc.):'),
    writeln('    Aplican la plataforma digital EVALUATEC (escala 0 a 100 puntos).'),
    writeln(' 2. Universidades del SUNEO (UTM, UMAR, UNPA, UNSIS, UNISTMO, etc.):'),
    writeln('    Aplican su propio Examen Institucional SUNEO (0 a 100 puntos)'),
    writeln('    más un Curso Propedéutico de Selección obligatorio (4 a 8 semanas).'),
    writeln(' 3. Universidad Autónoma Benito Juárez de Oaxaca (UABJO) y Normales:'),
    writeln('    Aplican el Examen General de Admisión con reactivos estandarizados'),
    writeln('    de CENEVAL EXANI-II (escala nacional de 700 a 1300 puntos).'),
    writeln(' 4. Universidades Privadas (Anáhuac, La Salle, URSE, etc.):'),
    writeln('    Aplican Examen Diagnóstico Interno o PAA (0 a 100 puntos) y entrevista;'),
    writeln('    el puntaje determina la asignación de Becas Académicas (30% al 80%).'),
    writeln('-----------------------------------------------------------------'),
    seleccionar_carrera(Carrera),
    findall(Inst, oferta_academica(Inst, Carrera, _, _), Sedes),
    (   Sedes == []
    ->  writeln('No hay universidades registradas con esta oferta actualmente.')
    ;   writeln('Universidades disponibles para esta carrera (Públicas y Privadas):'),
        forall(nth1(I, Sedes, S),
               ( institucion(S, NomS, _, Reg, _),
                 formato_regimen(Reg, RegTxt),
                 requisito_admision(S, Carrera, _, TipoE, _),
                 examen_info(TipoE, _, SiglaE, _, _, _),
                 format(' ~|~` t~d~2+. ~w [~w | Examen: ~w]~n', [I, NomS, RegTxt, SiglaE])
               )),
        length(Sedes, TotS),
        leer_entero_valido('Elige el número de universidad a evaluar:', 1, TotS, IdxS),
        nth1(IdxS, Sedes, SedeElegida),
        institucion(SedeElegida, NomSede, MunSede, RegSede, _),
        municipio_sede(MunSede, NomMun, _, _),
        requisito_admision(SedeElegida, Carrera, PromMin, TipoEx, CorteHist),
        formato_regimen(RegSede, RegSedeTxt),
        examen_info(TipoEx, NomEx, SiglasEx, EscalaMin, EscalaMax, DescEx),
        nl,
        writeln('================================================================='),
        format('PARÁMETROS OFICIALES DE ADMISIÓN PARA ~w~n', [NomSede]),
        writeln('================================================================='),
        format('  * Tipo de Examen:    ~w (~w)~n', [NomEx, SiglasEx]),
        format('  * Metodología:       ~w~n', [DescEx]),
        format('  * Escala oficial:    ~d a ~d puntos~n', [EscalaMin, EscalaMax]),
        format('  * Promedio mínimo:   ~1f en certificado de bachillerato~n', [PromMin]),
        format('  * Corte histórico:   ~d puntos~n', [CorteHist]),
        writeln('-----------------------------------------------------------------'),
        leer_numero_flotante('Ingresa tu promedio actual de preparatoria (ej. 8.4):', 6.0, 10.0, Prom),
        nl,
        format('¿Qué puntaje obtuviste o esperas obtener en ~w?~n', [SiglasEx]),
        (   (TipoEx == exani_ii_uabjo ; TipoEx == exani_ii_normales)
        ->  writeln('(Escala CENEVAL: 700 a 1300 pts. 1000 = Media nacional | >=1200 = Sobresaliente)'),
            PromptPts = 'Ingresa tu puntaje simulado en CENEVAL (700-1300):'
        ;   TipoEx == evaluatec
        ->  writeln('(Escala EVALUATEC: 0 a 100 puntos. >=75 = Sobresaliente | 60-74 = Competitivo)'),
            PromptPts = 'Ingresa tu puntaje simulado en EVALUATEC (0-100):'
        ;   TipoEx == examen_suneo
        ->  writeln('(Escala SUNEO: 0 a 100 puntos. >=70 = Propedéutico Corto | 60-69 = Propedéutico Largo)'),
            PromptPts = 'Ingresa tu puntaje simulado en SUNEO (0-100):'
        ;   writeln('(Escala Diagnóstica / PAA: 0 a 100 puntos. >=80 = Beca alta | >=70 = Beca media)'),
            PromptPts = 'Ingresa tu puntaje diagnóstico estimado (0-100):'
        ),
        leer_entero_valido(PromptPts, EscalaMin, EscalaMax, PtsExamen),
        evaluar_admision(SedeElegida, Carrera, Prom, PtsExamen, Dictamen, Detalle),
        format('~n=================================================================~n'),
        format('RESULTADO DEL ANÁLISIS DE ADMISIÓN PERSONALIZADO:~n'),
        format('  Institución:       ~w (~w en ~w)~n', [NomSede, RegSedeTxt, NomMun]),
        format('  Examen aplicado:   ~w (~w)~n', [NomEx, SiglasEx]),
        format('  Tu perfil:         Promedio ~1f | Puntaje examen: ~d pts (Escala ~d-~d)~n', [Prom, PtsExamen, EscalaMin, EscalaMax]),
        format('  Requisito corte:   Promedio >= ~1f | Corte histórico: ~d pts~n', [PromMin, CorteHist]),
        format('  Dictamen:          ~w~n', [Dictamen]),
        format('  Explicación:       ~w~n', [Detalle]),
        writeln('-----------------------------------------------------------------'),
        (   RegSede == privada
        ->  writeln('Orientación para Universidad Privada:')
        ;   writeln('Orientación para Universidad Pública:')
        ),
        (   Dictamen == no_cumple_requisito_academico
        ->  writeln('-> El promedio del certificado de preparatoria es un filtro administrativo irrestricto.')
        ;   Dictamen == alta_probabilidad_de_admision
        ->  writeln('-> Tu puntaje supera con holgura la demanda histórica. Concéntrate en mantener tu promedio.')
        ;   Dictamen == en_rango_competitivo
        ->  writeln('-> Te encuentras dentro de la zona de competencia. No bajes la guardia en el examen oficial.')
        ;   Dictamen == admision_en_riesgo
        ->  writeln('-> Estás muy cerca de la línea de corte. Dedica tiempo a repasar la guía oficial de la institución.')
        ;   Dictamen == admision_confirmada_con_opcion_a_beca
        ->  writeln('-> Tienes acceso asegurado y cumples con el puntaje para solicitar beca académica del 30% al 80%.')
        ;   writeln('-> Se sugiere considerar sedes alternas o reforzar módulos específicos de la prueba.')
        ),
        format('=================================================================~n')
    ).

opcion_proximidad_territorial :-
    writeln('================================================================='),
    writeln('=== ANALIZADOR DE PROXIMIDAD TERRITORIAL: SEDES LOCALES VS FORÁNEAS ==='),
    writeln('================================================================='),
    writeln('¿CÓMO FUNCIONA ESTE ANÁLISIS?'),
    writeln('El sistema cruza tu municipio de residencia actual con las sedes'),
    writeln('que ofertan tu carrera de interés, clasificándolas en:'),
    writeln(' 1. Sedes Locales / Conurbadas: Traslado diario en transporte urbano;'),
    writeln('    vives con tu familia y NO necesitas pagar renta de estudiante.'),
    writeln(' 2. Sedes Regionales: En la misma región de Oaxaca con traslado intermunicipal.'),
    writeln(' 3. Sedes Foráneas: En otra región geográfica del estado; requieren'),
    writeln('    forzosamente mudanza, renta de cuarto/pensión y manutención independiente.'),
    writeln('-----------------------------------------------------------------'),
    seleccionar_municipio_residencia(MunOrigen),
    municipio_sede(MunOrigen, NomMunO, RegO, _),
    format('~n-> Tu municipio seleccionado: ~w [Región: ~w]~n', [NomMunO, RegO]),
    writeln('-----------------------------------------------------------------'),
    seleccionar_carrera(Carrera),
    carrera(Carrera, NomCarrera, _, _, _),
    format('~n=================================================================~n'),
    format('ANÁLISIS DE PROXIMIDAD PARA ~w DESDE ~w~n', [NomCarrera, NomMunO]),
    format('=================================================================~n'),
    findall(Inst, oferta_academica(Inst, Carrera, _, _), Sedes),
    (   Sedes == []
    ->  writeln('No hay universidades registradas con esta oferta actualmente.')
    ;   findall(I, (member(I, Sedes), institucion(I, _, MunDest, _, _), categoria_distancia(MunOrigen, MunDest, local_conurbada, _)), Locales),
        findall(I, (member(I, Sedes), institucion(I, _, MunDest, _, _), categoria_distancia(MunOrigen, MunDest, regional_cercana, _)), Regionales),
        findall(I, (member(I, Sedes), institucion(I, _, MunDest, _, _), categoria_distancia(MunOrigen, MunDest, foranea_con_mudanza, _)), Foraneas),
        writeln('1. SEDES LOCALES / ZONA CONURBADA METROPOLITANA (¡Sin gastos de renta!):'),
        (   Locales == []
        ->  writeln('  (No hay sedes en tu municipio o zona metropolitana inmediata)')
        ;   forall(member(InstL, Locales),
                   ( institucion(InstL, NomL, MunL, RegimenL, PrestL),
                     municipio_sede(MunL, NomMunL, _, _),
                     costo_carrera(InstL, Carrera, CuotaL, _, _),
                     formato_regimen(RegimenL, RegTxtL),
                     format('  * ~w [~w | Prestigio: ~w]~n      Ubicación: ~w | Cuota semestral: $~d MXN~n      Ventaja: Traslado en transporte urbano diario. Ahorro de renta al vivir en casa.~n',
                            [NomL, RegTxtL, PrestL, NomMunL, CuotaL])
                   ))
        ),
        writeln('-----------------------------------------------------------------'),
        writeln('2. SEDES REGIONALES CERCANAS (Misma región geográfica):'),
        (   Regionales == []
        ->  writeln('  (No aplican sedes intermedias en tu región para esta carrera)')
        ;   forall(member(InstR, Regionales),
                   ( institucion(InstR, NomR, MunR, RegimenR, PrestR),
                     municipio_sede(MunR, NomMunR, RegR, _),
                     costo_carrera(InstR, Carrera, CuotaR, _, _),
                     formato_regimen(RegimenR, RegTxtR),
                     format('  * ~w [~w | Prestigio: ~w]~n      Ubicación: ~w (~w) | Cuota semestral: $~d MXN~n      Traslado intermunicipal accesible en autobús/colectivo.~n',
                            [NomR, RegTxtR, PrestR, NomMunR, RegR, CuotaR])
                   ))
        ),
        writeln('-----------------------------------------------------------------'),
        writeln('3. SEDES FORÁNEAS EN OTRAS REGIONES (¡Requieren mudanza e independencia!):'),
        (   Foraneas == []
        ->  writeln('  (Todas las opciones para esta carrera son locales o regionales en tu área)')
        ;   forall(member(InstF, Foraneas),
                   ( institucion(InstF, NomF, MunF, RegimenF, PrestF),
                     municipio_sede(MunF, NomMunF, RegF, CostoVidaF),
                     costo_carrera(InstF, Carrera, CuotaF, _, _),
                     formato_regimen(RegimenF, RegTxtF),
                     format('  * ~w [~w | Prestigio: ~w]~n      Ubicación: ~w [Región: ~w]~n      Cuota de estudios: $~d MXN/semestre~n      Impacto foráneo: Se debe presupuestar aprox. $~d MXN/mes de hospedaje/pensión en ~w.~n',
                            [NomF, RegTxtF, PrestF, NomMunF, RegF, CuotaF, CostoVidaF, NomMunF])
                   ))
        ),
        writeln('=================================================================')
    ).

opcion_observatorio_financiero :-
    writeln('================================================================='),
    writeln('=== OBSERVATORIO FINANCIERO UNIVERSITARIO Y COMPARADOR DE COSTOS ==='),
    writeln('================================================================='),
    writeln('Selecciona la consulta financiera que deseas realizar:'),
    writeln(' 1. Panorama de Colegiaturas: ¿Cuáles escuelas son más caras y cuáles más económicas?'),
    writeln(' 2. Ranking de Carreras: ¿Cuáles carreras demandan más gasto en materiales e instrumental?'),
    leer_entero_valido('Elige una opción financiera (1-2):', 1, 2, SubOp),
    ejecutar_subopcion_financiera(SubOp).

ejecutar_subopcion_financiera(1) :-
    writeln('================================================================='),
    writeln('PANORAMA GENERAL DE COSTOS POR RÉGIMEN UNIVERSITARIO EN OAXACA'),
    writeln('================================================================='),
    writeln('En Oaxaca las cuotas de colegiatura semestral se dividen claramente:'),
    nl,
    writeln('► UNIVERSIDADES PRIVADAS DE ALTA GAMA (ÉLITE):'),
    writeln('  - Ejemplos: Universidad Anáhuac Oaxaca, Universidad La Salle.'),
    writeln('  - Rango de colegiatura: $35,000 a $65,000 MXN por semestre (según carrera).'),
    writeln('  - Modelo: Financiamiento privado; otorgan becas del 30% al 80% por mérito académico.'),
    nl,
    writeln('► UNIVERSIDADES PRIVADAS ACCESIBLES / INTERMEDIAS:'),
    writeln('  - Ejemplos: URSE, Universidad Mesoamericana, UNIDEP, Santander, CLEU.'),
    writeln('  - Rango de colegiatura: $12,000 a $22,000 MXN por semestre.'),
    writeln('  - Modelo: Flexibilidad de horarios y modalidades ejecutivas sabatinas.'),
    nl,
    writeln('► UNIVERSIDADES PÚBLICAS ESTATALES DEL SUNEO:'),
    writeln('  - Ejemplos: UTM (Mixteca), UMAR (Costa), UNPA (Papaloapan), UNSIS (Sierra Sur).'),
    writeln('  - Rango de cuota: $1,200 a $2,200 MXN por semestre.'),
    writeln('  - Modelo: Altísima exigencia y tiempo completo; bibliotecas y laboratorios subsidiados.'),
    nl,
    writeln('► INSTITUTOS TECNOLÓGICOS DEL TecNM (PÚBLICA FEDERAL):'),
    writeln('  - Ejemplos: ITO Oaxaca, IT Tuxtepec, IT Salina Cruz, IT Comitancillo, IT Pinotepa.'),
    writeln('  - Rango de cuota: $1,800 a $2,800 MXN por semestre.'),
    writeln('  - Modelo: Cuota fija semestral de inscripción y talleres tecnológicos.'),
    nl,
    writeln('► UNIVERSIDAD PÚBLICA AUTÓNOMA (UABJO):'),
    writeln('  - Ejemplos: CU Oaxaca, Fac. de Medicina, Derecho, Contaduría, Odontología, Enfermería.'),
    writeln('  - Rango de cuota: $1,000 a $3,500 MXN por semestre (cuotas de recuperación por facultad).'),
    writeln('=================================================================').

ejecutar_subopcion_financiera(2) :-
    writeln('================================================================='),
    writeln('RANKING DE CARRERAS: GASTO EN MATERIALES, INSUMOS E INSTRUMENTAL'),
    writeln('================================================================='),
    writeln('¡Ojo! El costo de una carrera no es solo la colegiatura. Ciertas'),
    writeln('profesiones exigen insumos mensuales considerables para estudiar:'),
    nl,
    writeln('TOP 5 CARRERAS MÁS CARAS EN MATERIALES E INSTRUMENTOS:'),
    writeln(' 1. Cirujano Dentista (Odontología): ~$3,200 MXN/mes (Tipodontos, resinas, instrumental rotatorio).'),
    writeln(' 2. Medicina Humana:                ~$2,800 MXN/mes (Estetoscopio, uniformes clínicos, libros médicos).'),
    writeln(' 3. Gastronomía:                    ~$2,500 MXN/mes (Insumos cárnicos, repostería, cuchillos de chef).'),
    writeln(' 4. Arquitectura:                   ~$2,200 MXN/mes (Material de maquetas, plotters, planos, software).'),
    writeln(' 5. Fisioterapia y Terapia Física:  ~$1,800 MXN/mes (Insumos de rehabilitación, aditamentos clínicos).'),
    nl,
    writeln('TOP 5 CARRERAS MÁS ECONÓMICAS EN MATERIALES (Menor gasto mensual):'),
    writeln(' 1. Filosofía:                      ~$300 MXN/mes (Lecturas digitales, copias y libros clásicos).'),
    writeln(' 2. Matemáticas Aplicadas:          ~$350 MXN/mes (Calculadoras científicas, software libre y apuntes).'),
    writeln(' 3. Derecho y Ciencias Jurídicas:   ~$450 MXN/mes (Códigos legales, leyes vigentes y copias).'),
    writeln(' 4. Administración de Empresas:     ~$500 MXN/mes (Material de papelería y casos de estudio).'),
    writeln(' 5. Sociología y Antropología:      ~$500 MXN/mes (Textos académicos y diarios de campo).'),
    writeln('=================================================================').

opcion_buscador_becas :-
    writeln('================================================================='),
    writeln('=== BUSCADOR INTELIGENTE DE BECAS Y APOYOS UNIVERSITARIOS ==='),
    writeln('================================================================='),
    writeln('El sistema filtra de un catálogo de 50 becas federales, estatales,'),
    writeln('de fundaciones privadas (BBVA, Santander, Telmex) y convenios locales.'),
    writeln('-----------------------------------------------------------------'),
    leer_numero_flotante('Ingresa tu promedio general (6.0 a 10.0):', 6.0, 10.0, Prom),
    writeln('¿Para qué tipo de universidad buscas apoyo? 1. Pública  2. Privada'),
    leer_entero_valido('Opción (1-2):', 1, 2, OpT),
    ( OpT =:= 1 -> TipoInst = publica ; TipoInst = privada ),
    findall(B-Nom-Monto, beca_elegible(Prom, TipoInst, B, Nom, Monto), BecasElegibles),
    length(BecasElegibles, TotalB),
    format('~nSe encontraron ~d programas de beca a los que puedes aplicar con promedio ~1f en universidad ~w:~n',
           [TotalB, Prom, TipoInst]),
    writeln('-----------------------------------------------------------------'),
    forall(member(_-NomB-MontoB, BecasElegibles),
           format('  [✓] ~w~n      Apoyo mensual estimado: $~d MXN~n', [NomB, MontoB])),
    writeln('-----------------------------------------------------------------').

opcion_materias_criticas :-
    writeln('================================================================='),
    writeln('=== ANÁLISIS DE MATERIAS CRÍTICAS Y FILTRO ACADÉMICO ==='),
    writeln('================================================================='),
    writeln('¿QUÉ ES UNA MATERIA CRÍTICA?'),
    writeln('Son las asignaturas filtro que presentan los mayores índices de'),
    writeln('reprobación en los primeros semestres. Conocerlas con anticipación'),
    writeln('permite planificar asesorías tempranas y evitar atrasos en la carrera.'),
    writeln('-----------------------------------------------------------------'),
    seleccionar_carrera(Carrera),
    carrera(Carrera, NomC, _, _, Exig),
    format('~nMaterias con mayor índice de reprobación en ~w (Nivel de exigencia global: ~w):~n', [NomC, Exig]),
    materias_dificultad_carrera(Carrera, Materias),
    (   Materias == []
    ->  writeln('  (Plan de estudios modular o sin materias filtro críticas documentadas)')
    ;   forall(member(Sem-NomM-Area, Materias),
               format('  * Semestre ~d: ~w [Área de dificultad: ~w]~n', [Sem, NomM, Area]))
    ),
    writeln('-----------------------------------------------------------------').

opcion_lenguaje_natural :-
    writeln('================================================================='),
    writeln('=== BÚSQUEDA INTELIGENTE MEDIANTE LENGUAJE NATURAL ==='),
    writeln('================================================================='),
    writeln('Puedes escribir consultas libres como si platicaras con un orientador.'),
    writeln('El analizador detecta la carrera y el municipio automáticamente.'),
    writeln('Ejemplos:'),
    writeln(' - "Quiero estudiar ingenieria en sistemas en Huajuapan"'),
    writeln(' - "Me gustaria medicina en Oaxaca de Juarez"'),
    writeln(' - "Busco derecho en Tehuantepec"'),
    writeln('-----------------------------------------------------------------'),
    write('Escribe tu consulta: '),
    flush_output,
    read_line_to_string(user_input, Entrada),
    interpretar_consulta_natural(Entrada, consulta_vocacional(Carrera, Mun)),
    carrera(Carrera, NomC, _, _, _),
    municipio_sede(Mun, NomM, _, _),
    format('~nInterpretación de la consulta:~n  Carrera detectada: ~w (~w)~n  Municipio detectado: ~w (~w)~n',
           [NomC, Carrera, NomM, Mun]),
    findall(Inst, (oferta_academica(Inst, Carrera, _, _), institucion(Inst, _, Mun, _, _)), SedesCoincidentes),
    format('~nOpciones universitarias coincidentes en ~w:~n', [NomM]),
    (   SedesCoincidentes == []
    ->  format('  (No hay sedes directas de ~w en ~w. Considera sedes regionales cercanas).~n', [NomC, NomM])
    ;   forall(member(IdInst, SedesCoincidentes),
               ( institucion(IdInst, NomInst, _, Regimen, Prest),
                 formato_regimen(Regimen, RegimenTxt),
                 format('  * ~w [~w | Prestigio: ~w]~n', [NomInst, RegimenTxt, Prest])
               ))
    ),
    writeln('-----------------------------------------------------------------').

opcion_ficha_carrera :-
    writeln('================================================================='),
    writeln('=== FICHA TÉCNICA Y SALARIOS DE EGRESADOS ==='),
    writeln('================================================================='),
    seleccionar_carrera(Carrera),
    carrera(Carrera, NomC, Area, Sem, Exig),
    area_nombre(Area, AreaTxt),
    mercado_laboral(Carrera, Sueldo, Emp, Dem, Sector),
    perfil_holland(Carrera, R, I, A, S, E, C),
    format('~n=================================================================~n'),
    format('FICHA TÉCNICA PROFESIONAL: ~w~n', [NomC]),
    format('=================================================================~n'),
    format('  Área de conocimiento: ~w~n', [AreaTxt]),
    format('  Duración regular:     ~d semestres (~1f años)~n', [Sem, Sem / 2.0]),
    format('  Nivel de exigencia:   ~w~n', [Exig]),
    format('  Sueldo mensual prom.: $~d MXN (egresado promedio en México)~n', [Sueldo]),
    format('  Tasa de colocación:   ~d% laboral formal~n', [Emp]),
    format('  Demanda en el mercado:~w~n', [Dem]),
    format('  Sector preponderante: ~w~n', [Sector]),
    format('  Vector RIASEC:        [R:~d, I:~d, A:~d, S:~d, E:~d, C:~d]~n', [R, I, A, S, E, C]),
    format('=================================================================~n').

demostracion_vocacion :-
    writeln('================================================================='),
    writeln('   DEMOSTRACIÓN AUTOMÁTICA DE INFERENCIA LÓGICA (VOCACIÓN-EXPERT)'),
    writeln('================================================================='),
    writeln('1. Prueba de Afinidad Holland para perfil científico-tecnológico:'),
    P1 = perfil_aspirante(7, 10, 4, 3, 5, 8),
    similitud_holland(P1, ing_sistemas_computacionales, ScoreSis),
    format('   -> Afinidad con Ing. en Sistemas: ~d%~n', [ScoreSis]),
    similitud_holland(P1, derecho, ScoreDer),
    format('   -> Afinidad con Derecho: ~d%~n', [ScoreDer]),
    nl,
    writeln('2. Prueba de Admisión Universitaria (Pública vs Privada):'),
    evaluar_admision(uabjo_medicina, medicina_humana, 9.2, 1280, DictamenPub, DetPub),
    format('   -> Caso Pública (UABJO Medicina): ~w (~w)~n', [DictamenPub, DetPub]),
    evaluar_admision(anahuac_oaxaca, medicina_humana, 8.8, 1150, DictamenPriv, DetPriv),
    format('   -> Caso Privada (Anáhuac Medicina): ~w (~w)~n', [DictamenPriv, DetPriv]),
    nl,
    writeln('3. Prueba de Viabilidad Financiera en UTM Huajuapan:'),
    costo_mensual_carrera(utm_huajuapan, ing_software, CostoM, Desglose),
    format('   -> Costo mensual estimado: $~d MXN (Desglose: ~w)~n', [CostoM, Desglose]),
    viabilidad_presupuesto(utm_huajuapan, ing_software, 6000, Viab, Brecha),
    format('   -> Viabilidad con presupuesto de $6000 MXN: ~w (Brecha: $~d)~n', [Viab, Brecha]),
    nl,
    writeln('4. Prueba de Lenguaje Natural:'),
    FraseDemo = "quisiera estudiar ingenieria en sistemas computacionales en Huajuapan",
    interpretar_consulta_natural(FraseDemo, consulta_vocacional(CDemo, MDemo)),
    format('   -> Frase: "~w"~n   -> Interpretado: Carrera=~w, Municipio=~w~n', [FraseDemo, CDemo, MDemo]),
    writeln('=================================================================').
