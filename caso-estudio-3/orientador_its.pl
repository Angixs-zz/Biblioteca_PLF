:- encoding(utf8).
:- use_module(library(readutil)).
:- use_module(library(lists)).
:- use_module(library(aggregate)).

% =========================================================================
% SISTEMA EXPERTO: ORIENTADOR EPIDEMIOLÓGICO Y CLÍNICO DE ITS EN OAXACA
% Programación Lógica y Funcional - Proyecto Final
%
% Contexto y Utilidad Social:
% La prevención, detección oportuna y tratamiento de Infecciones de
% Transmisión Sexual (ITS: VIH, Sífilis, Hepatitis C, Hepatitis B, VPH,
% Gonorrea, Clamidia, etc.) representan una prioridad de salud pública
% en Oaxaca. Este sistema experto implementa el Modelo de Manejo Sindrómico
% de las ITS (avalado por la OPS/OMS y CENSIDA), evaluación de periodos de
% ventana biológica, análisis de urgencia para Profilaxis Post-Exposición (PEP),
% recomendación multicriterio de sedes y análisis de cobertura regional.
%
% Arquitectura de la Base de Conocimientos:
% 10 TABLAS PRINCIPALES (cada una con al menos 50 hechos documentados):
%   1. sede/4                     (55 registros)
%   2. municipio/2                (52 registros)
%   3. region_municipio/2         (52 registros)
%   4. deteccion_its/2            (190 registros)
%   5. horario_semanal/4          (145 registros)
%   6. contacto_directo/2         (55 registros)
%   7. fuente_oficial/2           (55 registros)
%   8. protocolo_sede/5           (55 registros)
%   9. guia_clinica_its/5         (50 registros)
%  10. sintoma_sindromico_its/5   (50 registros)
% =========================================================================

% -------------------------------------------------------------------------
% CATÁLOGOS BASE
% -------------------------------------------------------------------------

dia(lunes). dia(martes). dia(miercoles). dia(jueves).
dia(viernes). dia(sabado). dia(domingo).

nombre_dia(lunes, 'Lunes').
nombre_dia(martes, 'Martes').
nombre_dia(miercoles, 'Miércoles').
nombre_dia(jueves, 'Jueves').
nombre_dia(viernes, 'Viernes').
nombre_dia(sabado, 'Sábado').
nombre_dia(domingo, 'Domingo').

region(valles_centrales, 'Valles Centrales').
region(mixteca, 'Mixteca').
region(istmo, 'Istmo de Tehuantepec').
region(costa, 'Costa').
region(papaloapan, 'Cuenca del Papaloapan').
region(sierra_norte, 'Sierra de Juárez (Norte)').
region(sierra_sur, 'Sierra Sur').
region(canada, 'Cañada (Teotitlán / Huautla)').

% =========================================================================
% 1. TABLA: municipio(IdMunicipio, NombreOficial) - 52 registros
% =========================================================================
municipio(huajuapan, 'Heroica Ciudad de Huajuapan de León').
municipio(tlalixtac, 'Tlalixtac de Cabrera').
municipio(oaxaca_de_juarez, 'Oaxaca de Juárez').
municipio(san_bartolo_coyotepec, 'San Bartolo Coyotepec').
municipio(santa_cruz_xoxocotlan, 'Santa Cruz Xoxocotlán').
municipio(santa_lucia_del_camino, 'Santa Lucía del Camino').
municipio(san_jacinto_amilpas, 'San Jacinto Amilpas').
municipio(villa_de_zaachila, 'Villa de Zaachila').
municipio(zimatlan_de_alvarez, 'Zimatlán de Álvarez').
municipio(ocotlan_de_morelos, 'Ocotlán de Morelos').
municipio(ejutla_de_crespo, 'Heroica Ciudad de Ejutla de Crespo').
municipio(tlacolula_de_matamoros, 'Tlacolula de Matamoros').
municipio(villa_de_etla, 'Villa de Etla').
municipio(san_pablo_villa_de_mitla, 'San Pablo Villa de Mitla').
municipio(san_antonio_de_la_cal, 'San Antonio de la Cal').
municipio(santa_maria_atzompa, 'Santa María Atzompa').
municipio(cuilapam_de_guerrero, 'Cuilápam de Guerrero').
municipio(tlaxiaco, 'Heroica Ciudad de Tlaxiaco').
municipio(nochixtlan, 'Asunción Nochixtlán').
municipio(tamazulapam, 'Villa de Tamazulápam del Progreso').
municipio(juxtlahuaca, 'Santiago Juxtlahuaca').
municipio(chalcatongo, 'Chalcatongo de Hidalgo').
municipio(silacayoapam, 'Silacayoápam').
municipio(teposcolula, 'San Pedro y San Pablo Teposcolula').
municipio(juchitan, 'Heroica Ciudad de Juchitán de Zaragoza').
municipio(salina_cruz, 'Salina Cruz').
municipio(tehuantepec, 'Santo Domingo Tehuantepec').
municipio(ixtepec, 'Ciudad Ixtepec').
municipio(matias_romero, 'Matías Romero Avendaño').
municipio(union_hidalgo, 'Unión Hidalgo').
municipio(espinal, 'El Espinal').
municipio(zanatepec, 'Santo Domingo Zanatepec').
municipio(puerto_escondido, 'San Pedro Mixtepec (Puerto Escondido)').
municipio(huatulco, 'Santa María Huatulco').
municipio(pochutla, 'San Pedro Pochutla').
municipio(pinotepa_nacional, 'Santiago Pinotepa Nacional').
municipio(juquila, 'Santa Catarina Juquila').
municipio(rio_grande, 'Villa de Tututepec (Río Grande)').
municipio(jamiltepec, 'Santiago Jamiltepec').
municipio(tuxtepec, 'San Juan Bautista Tuxtepec').
municipio(loma_bonita, 'Loma Bonita').
municipio(acatlan_perez_figueroa, 'Acatlán de Pérez Figueroa').
municipio(cosolapa, 'Cosolapa').
municipio(valle_nacional, 'San Juan Bautista Valle Nacional').
municipio(jalapa_de_diaz, 'San Felipe Jalapa de Díaz').
municipio(ixtlan_de_juarez, 'Ixtlán de Juárez').
municipio(villa_alta, 'San Ildefonso Villa Alta').
municipio(capulalpam, 'Capulálpam de Méndez').
municipio(miahuatlan, 'Miahuatlán de Porfirio Díaz').
municipio(putla_villa_de_guerrero, 'Putla Villa de Guerrero').
municipio(sola_de_vega, 'Villa Sola de Vega').
municipio(huautla_de_jimenez, 'Huautla de Jiménez').

% =========================================================================
% 2. TABLA: region_municipio(IdMunicipio, Region) - 52 registros
% =========================================================================
region_municipio(huajuapan, mixteca).
region_municipio(tlalixtac, valles_centrales).
region_municipio(oaxaca_de_juarez, valles_centrales).
region_municipio(san_bartolo_coyotepec, valles_centrales).
region_municipio(santa_cruz_xoxocotlan, valles_centrales).
region_municipio(santa_lucia_del_camino, valles_centrales).
region_municipio(san_jacinto_amilpas, valles_centrales).
region_municipio(villa_de_zaachila, valles_centrales).
region_municipio(zimatlan_de_alvarez, valles_centrales).
region_municipio(ocotlan_de_morelos, valles_centrales).
region_municipio(ejutla_de_crespo, valles_centrales).
region_municipio(tlacolula_de_matamoros, valles_centrales).
region_municipio(villa_de_etla, valles_centrales).
region_municipio(san_pablo_villa_de_mitla, valles_centrales).
region_municipio(san_antonio_de_la_cal, valles_centrales).
region_municipio(santa_maria_atzompa, valles_centrales).
region_municipio(cuilapam_de_guerrero, valles_centrales).
region_municipio(tlaxiaco, mixteca).
region_municipio(nochixtlan, mixteca).
region_municipio(tamazulapam, mixteca).
region_municipio(juxtlahuaca, mixteca).
region_municipio(chalcatongo, mixteca).
region_municipio(silacayoapam, mixteca).
region_municipio(teposcolula, mixteca).
region_municipio(juchitan, istmo).
region_municipio(salina_cruz, istmo).
region_municipio(tehuantepec, istmo).
region_municipio(ixtepec, istmo).
region_municipio(matias_romero, istmo).
region_municipio(union_hidalgo, istmo).
region_municipio(espinal, istmo).
region_municipio(zanatepec, istmo).
region_municipio(puerto_escondido, costa).
region_municipio(huatulco, costa).
region_municipio(pochutla, costa).
region_municipio(pinotepa_nacional, costa).
region_municipio(juquila, costa).
region_municipio(rio_grande, costa).
region_municipio(jamiltepec, costa).
region_municipio(tuxtepec, papaloapan).
region_municipio(loma_bonita, papaloapan).
region_municipio(acatlan_perez_figueroa, papaloapan).
region_municipio(cosolapa, papaloapan).
region_municipio(valle_nacional, papaloapan).
region_municipio(jalapa_de_diaz, papaloapan).
region_municipio(ixtlan_de_juarez, sierra_norte).
region_municipio(villa_alta, sierra_norte).
region_municipio(capulalpam, sierra_norte).
region_municipio(miahuatlan, sierra_sur).
region_municipio(putla_villa_de_guerrero, sierra_sur).
region_municipio(sola_de_vega, sierra_sur).
region_municipio(huautla_de_jimenez, canada).

% =========================================================================
% 3. TABLA: sede(IdSede, Nombre, Municipio, Direccion) - 55 registros
%    Conserva las 4 originales históricas (huajuapan, tlalixtac, imedi, capasits)
%    y cubre la red especializada de salud pública en Oaxaca.
% =========================================================================
sede(huajuapan, 'Módulo COESIDA Huajuapan', huajuapan,
     'Fray Bartolomé de las Casas 2, frente al Parque Bicentenario').
sede(tlalixtac, 'Centro Mujer Tu Espacio', tlalixtac,
     'Ciudad Administrativa, edificio 1, piso 3, carretera Oaxaca-Istmo km 11.5').
sede(imedi, 'Punto de Detección IMEDI', oaxaca_de_juarez,
     'Blvd. Eduardo Vasconcelos 517, Barrio de Jalatlaco').
sede(capasits, 'COESIDA-CAPASITS San Bartolo Coyotepec', san_bartolo_coyotepec,
     'Séptima Privada de Aldama Sur s/n, Centro').

sede(cessa_reforma, 'CESSA Colonia Reforma (Centro de Detección Rápida)', oaxaca_de_juarez,
     'Calle Heroico Colegio Militar 905, Col. Reforma').
sede(cs_centro_oax, 'Centro de Salud Urbano No. 1 Dr. Manuel Martínez', oaxaca_de_juarez,
     'Calle Mina 410, Centro Histórico').
sede(jurisdiccion_valles, 'Jurisdicción Sanitaria No. 1 Valles Centrales', oaxaca_de_juarez,
     'Calzada Porfirio Díaz 248, Col. Reforma').
sede(hosp_civil_oax, 'Hospital General Dr. Aurelio Valdivieso (Medicina Preventiva)', oaxaca_de_juarez,
     'Calzada Porfirio Díaz 400, Col. Reforma').
sede(cs_estrella_oax, 'Centro de Salud Urbano Col. Estrella', oaxaca_de_juarez,
     'Calle Venus 112, Col. Estrella').
sede(clinica_universitaria_oax, 'Módulo Universitario de Salud Sexual UABJO', oaxaca_de_juarez,
     'Av. Universidad s/n, Ex-Hacienda Cinco Señores').

sede(hosp_especialidades_coyotepec, 'Hospital Regional de Alta Especialidad de Oaxaca', san_bartolo_coyotepec,
     'Aldama s/n, Paraje El Tule, San Bartolo Coyotepec').
sede(cs_coyotepec, 'Centro de Salud San Bartolo Coyotepec', san_bartolo_coyotepec,
     'Plaza Principal 4, Centro').

sede(cs_tlalixtac, 'Centro de Salud Urbano Tlalixtac de Cabrera', tlalixtac,
     'Calle Hidalgo 15, Barrio San Antonio').
sede(modulo_movil_admon, 'Módulo Preventivo Complejo Administrativo Tlalixtac', tlalixtac,
     'Carretera Oaxaca-Istmo km 11.5, Edificio 4').
sede(cessa_xoxocotlan, 'CESSA Santa Cruz Xoxocotlán (Clínica de Salud Sexual)', santa_cruz_xoxocotlan,
     'Calle Moctezuma s/n, Cabecera Municipal').
sede(cs_santa_lucia, 'Centro de Salud Santa Lucía del Camino', santa_lucia_del_camino,
     'Av. Ferrocarril 312, Cabecera Municipal').
sede(cs_san_jacinto, 'Centro de Salud San Jacinto Amilpas', san_jacinto_amilpas,
     'Av. Independencia 14, Centro').
sede(cs_zaachila, 'Centro de Salud con Servicios Ampliados Zaachila', villa_de_zaachila,
     'Calle Cosijoeza 45, Barrio del Niño').
sede(cs_zimatlan, 'Centro de Salud Zimatlán de Álvarez', zimatlan_de_alvarez,
     'Av. Juárez 110, Centro').
sede(cs_ocotlan, 'Centro de Salud Urbano Ocotlán de Morelos', ocotlan_de_morelos,
     'Prolongación de Morelos 28, Centro').
sede(cs_ejutla, 'Centro de Salud Ejutla de Crespo', ejutla_de_crespo,
     'Calle Porfirio Díaz 19, Centro').
sede(cessa_tlacolula, 'CESSA Tlacolula de Matamoros (Atención y Detección)', tlacolula_de_matamoros,
     'Carretera Internacional Cristóbal Colón km 31.5').
sede(cs_etla, 'Centro de Salud Villa de Etla', villa_de_etla,
     'Calle Miguel Hidalgo 50, Centro').
sede(cs_mitla, 'Centro de Salud San Pablo Villa de Mitla', san_pablo_villa_de_mitla,
     'Av. Morelos 12, Centro').
sede(cs_san_antonio_cal, 'Centro de Salud San Antonio de la Cal', san_antonio_de_la_cal,
     'Calle Monte Albán 8, Sección Primera').
sede(cs_atzompa, 'Centro de Salud Santa María Atzompa', santa_maria_atzompa,
     'Av. Libertad s/n, Centro').
sede(cs_cuilapam, 'Centro de Salud Cuilápam de Guerrero', cuilapam_de_guerrero,
     'Calle Vicente Guerrero 102, Barrio Grande').

sede(hosp_huajuapan, 'Hospital General Pilar Sánchez Villavicencio (Módulo ITS)', huajuapan,
     'Av. Venustiano Carranza s/n, Col. Alta Vista de Juárez').
sede(cessa_huajuapan, 'CESSA Huajuapan de León (Salud Sexual e ITS)', huajuapan,
     'Av. 2 de Abril 140, Col. Aviación').
sede(jurisdiccion_mixteca, 'Jurisdicción Sanitaria No. 5 Mixteca (Brigada Fija)', huajuapan,
     'Calle Trujano 28, Centro, Huajuapan').
sede(cessa_tlaxiaco, 'CESSA Heroica Ciudad de Tlaxiaco', tlaxiaco,
     'Carretera Tlaxiaco-Chalcatongo km 1.5, Barrio San Diego').
sede(hosp_tlaxiaco, 'Hospital General de Tlaxiaco', tlaxiaco,
     'Calle Claudio Cruz s/n, Barrio San Miguel').
sede(hosp_nochixtlan, 'Hospital Básico Comunitario Asunción Nochixtlán', nochixtlan,
     'Calle Porfirio Díaz 88, Barrio de Chocano').
sede(cs_tamazulapam, 'Centro de Salud Tamazulápam del Progreso', tamazulapam,
     'Carretera Cristóbal Colón km 42, Centro').
sede(hosp_juxtlahuaca, 'Hospital General de Santiago Juxtlahuaca', juxtlahuaca,
     'Calle Lázaro Cárdenas s/n, Barrio Santo Domingo').
sede(hosp_chalcatongo, 'Hospital Básico Comunitario Chalcatongo', chalcatongo,
     'Av. Independencia s/n, Barrio El Progreso').
sede(cs_silacayoapam, 'Centro de Salud Silacayoápam', silacayoapam,
     'Calle Morelos 5, Centro').
sede(cs_teposcolula, 'Centro de Salud San Pedro y San Pablo Teposcolula', teposcolula,
     'Av. Hidalgo 18, Centro').

sede(capasits_salina_cruz, 'UNEME CAPASITS Salina Cruz', salina_cruz,
     'Calle Guaymas s/n, Col. Hidalgo Oriente').
sede(hosp_salina_cruz, 'Hospital con Especialidades de Salina Cruz', salina_cruz,
     'Carretera a San Pedro Huilotepec km 2.5').
sede(hosp_juchitan, 'Hospital General Macedonio Benítez Fuentes (Clínica ITS)', juchitan,
     'Av. Efraín R. Gómez s/n, Séptima Sección').
sede(jurisdiccion_istmo, 'Jurisdicción Sanitaria No. 2 Istmo', juchitan,
     'Carretera Juchitán-El Espinal km 1.8').
sede(cessa_tehuantepec, 'CESSA Santo Domingo Tehuantepec', tehuantepec,
     'Carretera Transístmica km 258, Barrio Santa Cruz Tagolaba').
sede(hosp_ixtepec, 'Hospital General de Ciudad Ixtepec', ixtepec,
     'Calzada Joaquín Amaro s/n, Estación').
sede(cs_matias_romero, 'Centro de Salud Urbano Matías Romero', matias_romero,
     'Calle Hombres Ilustres 45, Barrio Juárez').
sede(cs_union_hidalgo, 'Centro de Salud Unión Hidalgo', union_hidalgo,
     'Calle Cinco de Mayo 31, Centro').
sede(cs_espinal, 'Centro de Salud El Espinal', espinal,
     'Av. Benito Juárez 12, Centro').
sede(cs_zanatepec, 'Centro de Salud Santo Domingo Zanatepec', zanatepec,
     'Calle Francisco I. Madero s/n, Centro').

sede(capasits_puerto_escondido, 'Módulo COESIDA-CAPASITS Puerto Escondido', puerto_escondido,
     'Av. Oaxaca 305, Fracc. Bacocho').
sede(hosp_puerto_escondido, 'Hospital General de Puerto Escondido (Medicina Preventiva)', puerto_escondido,
     'Av. Pérez Gasga s/n, Col. Centro').
sede(cessa_huatulco, 'CESSA Santa María Huatulco (La Crucecita)', huatulco,
     'Blvd. Chahué s/n, Sector M, La Crucecita').
sede(hosp_pochutla, 'Hospital General de San Pedro Pochutla', pochutla,
     'Carretera Puerto Ángel km 1.5, Loma Cruz').
sede(hosp_pinotepa, 'Hospital General Dr. Pedro Espinoza Rueda', pinotepa_nacional,
     'Carretera Costera del Pacífico km 2, Barrio El Calvario').
sede(hosp_juquila, 'Hospital Básico Comunitario Santa Catarina Juquila', juquila,
     'Calle 20 de Noviembre s/n, Barrio Grande').
sede(cs_rio_grande, 'Centro de Salud Urbano Río Grande', rio_grande,
     'Av. Alfonso Pérez Gasga 115, Centro').
sede(cs_jamiltepec, 'Centro de Salud Santiago Jamiltepec', jamiltepec,
     'Calle Negrete 10, Centro').

sede(jurisdiccion_tuxtepec, 'Jurisdicción Sanitaria No. 3 Tuxtepec (Módulo CAPASITS)', tuxtepec,
     'Av. Libertad 1490, Col. La Piragua').
sede(hosp_tuxtepec, 'Hospital General de San Juan Bautista Tuxtepec', tuxtepec,
     'Carretera Tuxtepec-Ojitlán km 2, Col. El Reposo').
sede(hosp_loma_bonita, 'Hospital Básico Comunitario Loma Bonita', loma_bonita,
     'Calle Puebla s/n, Col. Josefa Ortiz de Domínguez').
sede(cs_valle_nacional, 'Centro de Salud Valle Nacional', valle_nacional,
     'Av. Benito Juárez s/n, Centro').

sede(hosp_ixtlan, 'Hospital Básico Comunitario Ixtlán de Juárez', ixtlan_de_juarez,
     'Carretera Oaxaca-Tuxtepec km 64, Barrio La Asunción').
sede(hosp_miahuatlan, 'Hospital General de Miahuatlán de Porfirio Díaz', miahuatlan,
     'Calle 3 de Octubre s/n, Barrio Arriba').
sede(hosp_huautla, 'Hospital Básico Comunitario Huautla de Jiménez', huautla_de_jimenez,
     'Av. Juárez s/n, Barrio La Teja').

% =========================================================================
% 4. TABLA: deteccion_its(IdSede, ClavePrueba) - 190+ registros
%    Pruebas: vih, sifilis, hepatitis_c, hepatitis_b, gonorrea, vph,
%             pep_profilaxis_post_exposicion, consejeria_vih
% =========================================================================
deteccion_its(huajuapan, vih).
deteccion_its(huajuapan, sifilis).
deteccion_its(huajuapan, hepatitis_c).
deteccion_its(huajuapan, consejeria_vih).
deteccion_its(huajuapan, pep_profilaxis_post_exposicion).

deteccion_its(tlalixtac, vih).
deteccion_its(tlalixtac, sifilis).
deteccion_its(tlalixtac, hepatitis_c).
deteccion_its(tlalixtac, consejeria_vih).

deteccion_its(imedi, vih).
deteccion_its(imedi, sifilis).
deteccion_its(imedi, hepatitis_c).
deteccion_its(imedi, consejeria_vih).

deteccion_its(capasits, vih).
deteccion_its(capasits, sifilis).
deteccion_its(capasits, hepatitis_c).
deteccion_its(capasits, hepatitis_b).
deteccion_its(capasits, gonorrea).
deteccion_its(capasits, vph).
deteccion_its(capasits, pep_profilaxis_post_exposicion).
deteccion_its(capasits, consejeria_vih).

deteccion_its(cessa_reforma, vih).
deteccion_its(cessa_reforma, sifilis).
deteccion_its(cessa_reforma, hepatitis_c).
deteccion_its(cessa_reforma, hepatitis_b).
deteccion_its(cessa_reforma, vph).
deteccion_its(cessa_reforma, consejeria_vih).

deteccion_its(cs_centro_oax, vih).
deteccion_its(cs_centro_oax, sifilis).
deteccion_its(cs_centro_oax, hepatitis_c).
deteccion_its(cs_centro_oax, vph).
deteccion_its(cs_centro_oax, consejeria_vih).

deteccion_its(jurisdiccion_valles, vih).
deteccion_its(jurisdiccion_valles, sifilis).
deteccion_its(jurisdiccion_valles, hepatitis_c).
deteccion_its(jurisdiccion_valles, hepatitis_b).
deteccion_its(jurisdiccion_valles, pep_profilaxis_post_exposicion).

deteccion_its(hosp_civil_oax, vih).
deteccion_its(hosp_civil_oax, sifilis).
deteccion_its(hosp_civil_oax, hepatitis_c).
deteccion_its(hosp_civil_oax, hepatitis_b).
deteccion_its(hosp_civil_oax, gonorrea).
deteccion_its(hosp_civil_oax, vph).
deteccion_its(hosp_civil_oax, pep_profilaxis_post_exposicion).
deteccion_its(hosp_civil_oax, consejeria_vih).

deteccion_its(cs_estrella_oax, vih).
deteccion_its(cs_estrella_oax, sifilis).
deteccion_its(cs_estrella_oax, hepatitis_c).

deteccion_its(clinica_universitaria_oax, vih).
deteccion_its(clinica_universitaria_oax, sifilis).
deteccion_its(clinica_universitaria_oax, hepatitis_c).
deteccion_its(clinica_universitaria_oax, hepatitis_b).
deteccion_its(clinica_universitaria_oax, consejeria_vih).

deteccion_its(hosp_especialidades_coyotepec, vih).
deteccion_its(hosp_especialidades_coyotepec, sifilis).
deteccion_its(hosp_especialidades_coyotepec, hepatitis_b).
deteccion_its(hosp_especialidades_coyotepec, hepatitis_c).
deteccion_its(hosp_especialidades_coyotepec, pep_profilaxis_post_exposicion).

deteccion_its(cs_coyotepec, vih).
deteccion_its(cs_coyotepec, sifilis).
deteccion_its(cs_coyotepec, hepatitis_c).

deteccion_its(cs_tlalixtac, vih).
deteccion_its(cs_tlalixtac, sifilis).
deteccion_its(cs_tlalixtac, hepatitis_c).
deteccion_its(cs_tlalixtac, vph).

deteccion_its(modulo_movil_admon, vih).
deteccion_its(modulo_movil_admon, sifilis).
deteccion_its(modulo_movil_admon, hepatitis_c).

deteccion_its(cessa_xoxocotlan, vih).
deteccion_its(cessa_xoxocotlan, sifilis).
deteccion_its(cessa_xoxocotlan, hepatitis_c).
deteccion_its(cessa_xoxocotlan, vph).
deteccion_its(cessa_xoxocotlan, consejeria_vih).

deteccion_its(cs_santa_lucia, vih).
deteccion_its(cs_santa_lucia, sifilis).
deteccion_its(cs_santa_lucia, hepatitis_c).

deteccion_its(cs_san_jacinto, vih).
deteccion_its(cs_san_jacinto, sifilis).

deteccion_its(cs_zaachila, vih).
deteccion_its(cs_zaachila, sifilis).
deteccion_its(cs_zaachila, hepatitis_c).
deteccion_its(cs_zaachila, consejeria_vih).

deteccion_its(cs_zimatlan, vih).
deteccion_its(cs_zimatlan, sifilis).
deteccion_its(cs_zimatlan, hepatitis_c).

deteccion_its(cs_ocotlan, vih).
deteccion_its(cs_ocotlan, sifilis).
deteccion_its(cs_ocotlan, hepatitis_c).

deteccion_its(cs_ejutla, vih).
deteccion_its(cs_ejutla, sifilis).

deteccion_its(cessa_tlacolula, vih).
deteccion_its(cessa_tlacolula, sifilis).
deteccion_its(cessa_tlacolula, hepatitis_c).
deteccion_its(cessa_tlacolula, vph).
deteccion_its(cessa_tlacolula, consejeria_vih).

deteccion_its(cs_etla, vih).
deteccion_its(cs_etla, sifilis).
deteccion_its(cs_etla, hepatitis_c).

deteccion_its(cs_mitla, vih).
deteccion_its(cs_mitla, sifilis).

deteccion_its(cs_san_antonio_cal, vih).
deteccion_its(cs_san_antonio_cal, sifilis).

deteccion_its(cs_atzompa, vih).
deteccion_its(cs_atzompa, sifilis).
deteccion_its(cs_atzompa, hepatitis_c).

deteccion_its(cs_cuilapam, vih).
deteccion_its(cs_cuilapam, sifilis).

deteccion_its(hosp_huajuapan, vih).
deteccion_its(hosp_huajuapan, sifilis).
deteccion_its(hosp_huajuapan, hepatitis_c).
deteccion_its(hosp_huajuapan, hepatitis_b).
deteccion_its(hosp_huajuapan, gonorrea).
deteccion_its(hosp_huajuapan, pep_profilaxis_post_exposicion).

deteccion_its(cessa_huajuapan, vih).
deteccion_its(cessa_huajuapan, sifilis).
deteccion_its(cessa_huajuapan, hepatitis_c).
deteccion_its(cessa_huajuapan, vph).
deteccion_its(cessa_huajuapan, consejeria_vih).

deteccion_its(jurisdiccion_mixteca, vih).
deteccion_its(jurisdiccion_mixteca, sifilis).
deteccion_its(jurisdiccion_mixteca, hepatitis_c).
deteccion_its(jurisdiccion_mixteca, hepatitis_b).

deteccion_its(cessa_tlaxiaco, vih).
deteccion_its(cessa_tlaxiaco, sifilis).
deteccion_its(cessa_tlaxiaco, hepatitis_c).
deteccion_its(cessa_tlaxiaco, vph).
deteccion_its(cessa_tlaxiaco, consejeria_vih).

deteccion_its(hosp_tlaxiaco, vih).
deteccion_its(hosp_tlaxiaco, sifilis).
deteccion_its(hosp_tlaxiaco, hepatitis_c).
deteccion_its(hosp_tlaxiaco, gonorrea).

deteccion_its(hosp_nochixtlan, vih).
deteccion_its(hosp_nochixtlan, sifilis).
deteccion_its(hosp_nochixtlan, hepatitis_c).

deteccion_its(cs_tamazulapam, vih).
deteccion_its(cs_tamazulapam, sifilis).

deteccion_its(hosp_juxtlahuaca, vih).
deteccion_its(hosp_juxtlahuaca, sifilis).
deteccion_its(hosp_juxtlahuaca, hepatitis_c).
deteccion_its(hosp_juxtlahuaca, hepatitis_b).

deteccion_its(hosp_chalcatongo, vih).
deteccion_its(hosp_chalcatongo, sifilis).
deteccion_its(hosp_chalcatongo, hepatitis_c).

deteccion_its(cs_silacayoapam, vih).
deteccion_its(cs_silacayoapam, sifilis).

deteccion_its(cs_teposcolula, vih).
deteccion_its(cs_teposcolula, sifilis).
deteccion_its(cs_teposcolula, hepatitis_c).

deteccion_its(capasits_salina_cruz, vih).
deteccion_its(capasits_salina_cruz, sifilis).
deteccion_its(capasits_salina_cruz, hepatitis_c).
deteccion_its(capasits_salina_cruz, hepatitis_b).
deteccion_its(capasits_salina_cruz, gonorrea).
deteccion_its(capasits_salina_cruz, vph).
deteccion_its(capasits_salina_cruz, pep_profilaxis_post_exposicion).
deteccion_its(capasits_salina_cruz, consejeria_vih).

deteccion_its(hosp_salina_cruz, vih).
deteccion_its(hosp_salina_cruz, sifilis).
deteccion_its(hosp_salina_cruz, hepatitis_b).
deteccion_its(hosp_salina_cruz, pep_profilaxis_post_exposicion).

deteccion_its(hosp_juchitan, vih).
deteccion_its(hosp_juchitan, sifilis).
deteccion_its(hosp_juchitan, hepatitis_c).
deteccion_its(hosp_juchitan, hepatitis_b).
deteccion_its(hosp_juchitan, consejeria_vih).

deteccion_its(jurisdiccion_istmo, vih).
deteccion_its(jurisdiccion_istmo, sifilis).
deteccion_its(jurisdiccion_istmo, hepatitis_c).
deteccion_its(jurisdiccion_istmo, pep_profilaxis_post_exposicion).

deteccion_its(cessa_tehuantepec, vih).
deteccion_its(cessa_tehuantepec, sifilis).
deteccion_its(cessa_tehuantepec, hepatitis_c).
deteccion_its(cessa_tehuantepec, vph).
deteccion_its(cessa_tehuantepec, consejeria_vih).

deteccion_its(hosp_ixtepec, vih).
deteccion_its(hosp_ixtepec, sifilis).
deteccion_its(hosp_ixtepec, hepatitis_c).

deteccion_its(cs_matias_romero, vih).
deteccion_its(cs_matias_romero, sifilis).
deteccion_its(cs_matias_romero, hepatitis_c).

deteccion_its(cs_union_hidalgo, vih).
deteccion_its(cs_union_hidalgo, sifilis).

deteccion_its(cs_espinal, vih).
deteccion_its(cs_espinal, sifilis).

deteccion_its(cs_zanatepec, vih).
deteccion_its(cs_zanatepec, sifilis).
deteccion_its(cs_zanatepec, hepatitis_c).

deteccion_its(capasits_puerto_escondido, vih).
deteccion_its(capasits_puerto_escondido, sifilis).
deteccion_its(capasits_puerto_escondido, hepatitis_c).
deteccion_its(capasits_puerto_escondido, hepatitis_b).
deteccion_its(capasits_puerto_escondido, gonorrea).
deteccion_its(capasits_puerto_escondido, pep_profilaxis_post_exposicion).
deteccion_its(capasits_puerto_escondido, consejeria_vih).

deteccion_its(hosp_puerto_escondido, vih).
deteccion_its(hosp_puerto_escondido, sifilis).
deteccion_its(hosp_puerto_escondido, hepatitis_c).
deteccion_its(hosp_puerto_escondido, pep_profilaxis_post_exposicion).

deteccion_its(cessa_huatulco, vih).
deteccion_its(cessa_huatulco, sifilis).
deteccion_its(cessa_huatulco, hepatitis_c).
deteccion_its(cessa_huatulco, vph).
deteccion_its(cessa_huatulco, consejeria_vih).

deteccion_its(hosp_pochutla, vih).
deteccion_its(hosp_pochutla, sifilis).
deteccion_its(hosp_pochutla, hepatitis_c).
deteccion_its(hosp_pochutla, hepatitis_b).
deteccion_its(hosp_pochutla, pep_profilaxis_post_exposicion).

deteccion_its(hosp_pinotepa, vih).
deteccion_its(hosp_pinotepa, sifilis).
deteccion_its(hosp_pinotepa, hepatitis_c).
deteccion_its(hosp_pinotepa, hepatitis_b).
deteccion_its(hosp_pinotepa, pep_profilaxis_post_exposicion).

deteccion_its(hosp_juquila, vih).
deteccion_its(hosp_juquila, sifilis).
deteccion_its(hosp_juquila, hepatitis_c).

deteccion_its(cs_rio_grande, vih).
deteccion_its(cs_rio_grande, sifilis).

deteccion_its(cs_jamiltepec, vih).
deteccion_its(cs_jamiltepec, sifilis).

deteccion_its(jurisdiccion_tuxtepec, vih).
deteccion_its(jurisdiccion_tuxtepec, sifilis).
deteccion_its(jurisdiccion_tuxtepec, hepatitis_c).
deteccion_its(jurisdiccion_tuxtepec, hepatitis_b).
deteccion_its(jurisdiccion_tuxtepec, pep_profilaxis_post_exposicion).

deteccion_its(hosp_tuxtepec, vih).
deteccion_its(hosp_tuxtepec, sifilis).
deteccion_its(hosp_tuxtepec, hepatitis_c).
deteccion_its(hosp_tuxtepec, gonorrea).
deteccion_its(hosp_tuxtepec, pep_profilaxis_post_exposicion).

deteccion_its(hosp_loma_bonita, vih).
deteccion_its(hosp_loma_bonita, sifilis).
deteccion_its(hosp_loma_bonita, hepatitis_c).

deteccion_its(cs_valle_nacional, vih).
deteccion_its(cs_valle_nacional, sifilis).

deteccion_its(hosp_ixtlan, vih).
deteccion_its(hosp_ixtlan, sifilis).
deteccion_its(hosp_ixtlan, hepatitis_c).
deteccion_its(hosp_ixtlan, pep_profilaxis_post_exposicion).

deteccion_its(hosp_miahuatlan, vih).
deteccion_its(hosp_miahuatlan, sifilis).
deteccion_its(hosp_miahuatlan, hepatitis_c).
deteccion_its(hosp_miahuatlan, pep_profilaxis_post_exposicion).

deteccion_its(hosp_huautla, vih).
deteccion_its(hosp_huautla, sifilis).
deteccion_its(hosp_huautla, hepatitis_c).
deteccion_its(hosp_huautla, pep_profilaxis_post_exposicion).

% =========================================================================
% 5. TABLA: horario_semanal(IdSede, Dia, HoraInicio, HoraFin) - 145+ registros
%    (Conservando imedi y capasits como por_confirmar según la fuente histórica)
% =========================================================================
horario_semanal(huajuapan, lunes, '08:00', '16:00').
horario_semanal(huajuapan, martes, '08:00', '16:00').
horario_semanal(huajuapan, miercoles, '08:00', '16:00').
horario_semanal(huajuapan, jueves, '08:00', '16:00').
horario_semanal(huajuapan, viernes, '08:00', '16:00').
horario_semanal(huajuapan, sabado, '09:00', '14:00').

horario_semanal(tlalixtac, martes, '10:00', '14:00').
horario_semanal(tlalixtac, jueves, '10:00', '14:00').

horario_semanal(cessa_reforma, lunes, '08:00', '15:00').
horario_semanal(cessa_reforma, martes, '08:00', '15:00').
horario_semanal(cessa_reforma, miercoles, '08:00', '15:00').
horario_semanal(cessa_reforma, jueves, '08:00', '15:00').
horario_semanal(cessa_reforma, viernes, '08:00', '15:00').
horario_semanal(cessa_reforma, sabado, '08:00', '13:00').

horario_semanal(cs_centro_oax, lunes, '08:00', '14:30').
horario_semanal(cs_centro_oax, martes, '08:00', '14:30').
horario_semanal(cs_centro_oax, miercoles, '08:00', '14:30').
horario_semanal(cs_centro_oax, jueves, '08:00', '14:30').
horario_semanal(cs_centro_oax, viernes, '08:00', '14:30').
horario_semanal(cs_centro_oax, sabado, '09:00', '13:00').

horario_semanal(jurisdiccion_valles, lunes, '09:00', '15:00').
horario_semanal(jurisdiccion_valles, martes, '09:00', '15:00').
horario_semanal(jurisdiccion_valles, miercoles, '09:00', '15:00').
horario_semanal(jurisdiccion_valles, jueves, '09:00', '15:00').
horario_semanal(jurisdiccion_valles, viernes, '09:00', '15:00').

horario_semanal(hosp_civil_oax, lunes, '08:00', '15:00').
horario_semanal(hosp_civil_oax, martes, '08:00', '15:00').
horario_semanal(hosp_civil_oax, miercoles, '08:00', '15:00').
horario_semanal(hosp_civil_oax, jueves, '08:00', '15:00').
horario_semanal(hosp_civil_oax, viernes, '08:00', '15:00').

horario_semanal(cs_estrella_oax, lunes, '08:30', '14:00').
horario_semanal(cs_estrella_oax, martes, '08:30', '14:00').
horario_semanal(cs_estrella_oax, jueves, '08:30', '14:00').

horario_semanal(clinica_universitaria_oax, lunes, '09:00', '16:00').
horario_semanal(clinica_universitaria_oax, martes, '09:00', '16:00').
horario_semanal(clinica_universitaria_oax, miercoles, '09:00', '16:00').
horario_semanal(clinica_universitaria_oax, jueves, '09:00', '16:00').
horario_semanal(clinica_universitaria_oax, viernes, '09:00', '16:00').

horario_semanal(hosp_especialidades_coyotepec, lunes, '08:00', '14:30').
horario_semanal(hosp_especialidades_coyotepec, martes, '08:00', '14:30').
horario_semanal(hosp_especialidades_coyotepec, miercoles, '08:00', '14:30').
horario_semanal(hosp_especialidades_coyotepec, jueves, '08:00', '14:30').
horario_semanal(hosp_especialidades_coyotepec, viernes, '08:00', '14:30').

horario_semanal(cs_coyotepec, lunes, '08:30', '14:00').
horario_semanal(cs_coyotepec, martes, '08:30', '14:00').
horario_semanal(cs_coyotepec, miercoles, '08:30', '14:00').
horario_semanal(cs_coyotepec, jueves, '08:30', '14:00').
horario_semanal(cs_coyotepec, viernes, '08:30', '14:00').

horario_semanal(cs_tlalixtac, lunes, '08:00', '14:30').
horario_semanal(cs_tlalixtac, martes, '08:00', '14:30').
horario_semanal(cs_tlalixtac, miercoles, '08:00', '14:30').
horario_semanal(cs_tlalixtac, jueves, '08:00', '14:30').
horario_semanal(cs_tlalixtac, viernes, '08:00', '14:30').

horario_semanal(modulo_movil_admon, lunes, '09:30', '14:30').
horario_semanal(modulo_movil_admon, martes, '09:30', '14:30').
horario_semanal(modulo_movil_admon, miercoles, '09:30', '14:30').
horario_semanal(modulo_movil_admon, jueves, '09:30', '14:30').

horario_semanal(cessa_xoxocotlan, lunes, '08:00', '16:00').
horario_semanal(cessa_xoxocotlan, martes, '08:00', '16:00').
horario_semanal(cessa_xoxocotlan, miercoles, '08:00', '16:00').
horario_semanal(cessa_xoxocotlan, jueves, '08:00', '16:00').
horario_semanal(cessa_xoxocotlan, viernes, '08:00', '16:00').
horario_semanal(cessa_xoxocotlan, sabado, '09:00', '13:00').

horario_semanal(cs_santa_lucia, lunes, '08:00', '14:00').
horario_semanal(cs_santa_lucia, miercoles, '08:00', '14:00').
horario_semanal(cs_santa_lucia, viernes, '08:00', '14:00').

horario_semanal(cs_zaachila, lunes, '08:30', '14:30').
horario_semanal(cs_zaachila, martes, '08:30', '14:30').
horario_semanal(cs_zaachila, jueves, '08:30', '14:30').

horario_semanal(cs_ocotlan, lunes, '08:00', '14:00').
horario_semanal(cs_ocotlan, martes, '08:00', '14:00').
horario_semanal(cs_ocotlan, jueves, '08:00', '14:00').

horario_semanal(cessa_tlacolula, lunes, '08:00', '15:30').
horario_semanal(cessa_tlacolula, martes, '08:00', '15:30').
horario_semanal(cessa_tlacolula, miercoles, '08:00', '15:30').
horario_semanal(cessa_tlacolula, jueves, '08:00', '15:30').
horario_semanal(cessa_tlacolula, viernes, '08:00', '15:30').
horario_semanal(cessa_tlacolula, sabado, '09:00', '13:00').

horario_semanal(cs_etla, lunes, '08:00', '14:00').
horario_semanal(cs_etla, miercoles, '08:00', '14:00').
horario_semanal(cs_etla, viernes, '08:00', '14:00').

horario_semanal(hosp_huajuapan, lunes, '08:00', '15:00').
horario_semanal(hosp_huajuapan, martes, '08:00', '15:00').
horario_semanal(hosp_huajuapan, miercoles, '08:00', '15:00').
horario_semanal(hosp_huajuapan, jueves, '08:00', '15:00').
horario_semanal(hosp_huajuapan, viernes, '08:00', '15:00').
horario_semanal(hosp_huajuapan, sabado, '09:00', '13:00').

horario_semanal(cessa_huajuapan, lunes, '08:00', '15:30').
horario_semanal(cessa_huajuapan, martes, '08:00', '15:30').
horario_semanal(cessa_huajuapan, miercoles, '08:00', '15:30').
horario_semanal(cessa_huajuapan, jueves, '08:00', '15:30').
horario_semanal(cessa_huajuapan, viernes, '08:00', '15:30').
horario_semanal(cessa_huajuapan, sabado, '08:30', '13:30').

horario_semanal(jurisdiccion_mixteca, lunes, '09:00', '15:00').
horario_semanal(jurisdiccion_mixteca, martes, '09:00', '15:00').
horario_semanal(jurisdiccion_mixteca, jueves, '09:00', '15:00').

horario_semanal(cessa_tlaxiaco, lunes, '08:00', '16:00').
horario_semanal(cessa_tlaxiaco, martes, '08:00', '16:00').
horario_semanal(cessa_tlaxiaco, miercoles, '08:00', '16:00').
horario_semanal(cessa_tlaxiaco, jueves, '08:00', '16:00').
horario_semanal(cessa_tlaxiaco, viernes, '08:00', '16:00').

horario_semanal(hosp_tlaxiaco, lunes, '08:30', '14:30').
horario_semanal(hosp_tlaxiaco, miercoles, '08:30', '14:30').
horario_semanal(hosp_tlaxiaco, viernes, '08:30', '14:30').

horario_semanal(hosp_nochixtlan, lunes, '08:30', '14:30').
horario_semanal(hosp_nochixtlan, martes, '08:30', '14:30').
horario_semanal(hosp_nochixtlan, jueves, '08:30', '14:30').

horario_semanal(hosp_juxtlahuaca, lunes, '08:30', '15:00').
horario_semanal(hosp_juxtlahuaca, miercoles, '08:30', '15:00').
horario_semanal(hosp_juxtlahuaca, viernes, '08:30', '15:00').

horario_semanal(capasits_salina_cruz, lunes, '08:00', '15:30').
horario_semanal(capasits_salina_cruz, martes, '08:00', '15:30').
horario_semanal(capasits_salina_cruz, miercoles, '08:00', '15:30').
horario_semanal(capasits_salina_cruz, jueves, '08:00', '15:30').
horario_semanal(capasits_salina_cruz, viernes, '08:00', '15:30').

horario_semanal(hosp_salina_cruz, lunes, '08:00', '15:00').
horario_semanal(hosp_salina_cruz, martes, '08:00', '15:00').
horario_semanal(hosp_salina_cruz, miercoles, '08:00', '15:00').
horario_semanal(hosp_salina_cruz, jueves, '08:00', '15:00').
horario_semanal(hosp_salina_cruz, viernes, '08:00', '15:00').

horario_semanal(hosp_juchitan, lunes, '08:00', '15:00').
horario_semanal(hosp_juchitan, martes, '08:00', '15:00').
horario_semanal(hosp_juchitan, miercoles, '08:00', '15:00').
horario_semanal(hosp_juchitan, jueves, '08:00', '15:00').
horario_semanal(hosp_juchitan, viernes, '08:00', '15:00').

horario_semanal(jurisdiccion_istmo, lunes, '09:00', '14:30').
horario_semanal(jurisdiccion_istmo, martes, '09:00', '14:30').
horario_semanal(jurisdiccion_istmo, jueves, '09:00', '14:30').

horario_semanal(cessa_tehuantepec, lunes, '08:00', '15:00').
horario_semanal(cessa_tehuantepec, martes, '08:00', '15:00').
horario_semanal(cessa_tehuantepec, miercoles, '08:00', '15:00').
horario_semanal(cessa_tehuantepec, jueves, '08:00', '15:00').
horario_semanal(cessa_tehuantepec, viernes, '08:00', '15:00').

horario_semanal(capasits_puerto_escondido, lunes, '08:00', '15:00').
horario_semanal(capasits_puerto_escondido, martes, '08:00', '15:00').
horario_semanal(capasits_puerto_escondido, miercoles, '08:00', '15:00').
horario_semanal(capasits_puerto_escondido, jueves, '08:00', '15:00').
horario_semanal(capasits_puerto_escondido, viernes, '08:00', '15:00').
horario_semanal(capasits_puerto_escondido, sabado, '09:00', '13:00').

horario_semanal(hosp_puerto_escondido, lunes, '08:00', '15:00').
horario_semanal(hosp_puerto_escondido, martes, '08:00', '15:00').
horario_semanal(hosp_puerto_escondido, miercoles, '08:00', '15:00').
horario_semanal(hosp_puerto_escondido, jueves, '08:00', '15:00').
horario_semanal(hosp_puerto_escondido, viernes, '08:00', '15:00').

horario_semanal(cessa_huatulco, lunes, '08:00', '15:00').
horario_semanal(cessa_huatulco, martes, '08:00', '15:00').
horario_semanal(cessa_huatulco, miercoles, '08:00', '15:00').
horario_semanal(cessa_huatulco, jueves, '08:00', '15:00').
horario_semanal(cessa_huatulco, viernes, '08:00', '15:00').

horario_semanal(hosp_pochutla, lunes, '08:30', '14:30').
horario_semanal(hosp_pochutla, martes, '08:30', '14:30').
horario_semanal(hosp_pochutla, jueves, '08:30', '14:30').

horario_semanal(hosp_pinotepa, lunes, '08:00', '14:30').
horario_semanal(hosp_pinotepa, miercoles, '08:00', '14:30').
horario_semanal(hosp_pinotepa, viernes, '08:00', '14:30').

horario_semanal(jurisdiccion_tuxtepec, lunes, '08:00', '15:00').
horario_semanal(jurisdiccion_tuxtepec, martes, '08:00', '15:00').
horario_semanal(jurisdiccion_tuxtepec, miercoles, '08:00', '15:00').
horario_semanal(jurisdiccion_tuxtepec, jueves, '08:00', '15:00').
horario_semanal(jurisdiccion_tuxtepec, viernes, '08:00', '15:00').

horario_semanal(hosp_tuxtepec, lunes, '08:00', '15:00').
horario_semanal(hosp_tuxtepec, martes, '08:00', '15:00').
horario_semanal(hosp_tuxtepec, miercoles, '08:00', '15:00').
horario_semanal(hosp_tuxtepec, jueves, '08:00', '15:00').
horario_semanal(hosp_tuxtepec, viernes, '08:00', '15:00').

horario_semanal(hosp_ixtlan, lunes, '08:30', '14:30').
horario_semanal(hosp_ixtlan, miercoles, '08:30', '14:30').
horario_semanal(hosp_ixtlan, viernes, '08:30', '14:30').

horario_semanal(hosp_miahuatlan, lunes, '08:30', '15:00').
horario_semanal(hosp_miahuatlan, martes, '08:30', '15:00').
horario_semanal(hosp_miahuatlan, jueves, '08:30', '15:00').

horario_semanal(hosp_huautla, lunes, '09:00', '14:30').
horario_semanal(hosp_huautla, miercoles, '09:00', '14:30').
horario_semanal(hosp_huautla, viernes, '09:00', '14:30').

% =========================================================================
% 6. TABLA: contacto_directo(IdSede, TelefonoOExtension) - 55 registros
% =========================================================================
contacto_directo(huajuapan, '951 502 2200 (COESIDA Huajuapan)').
contacto_directo(tlalixtac, '951 501 5000 ext. 10898 (Centro Mujer)').
contacto_directo(imedi, '951 502 2200 (COESIDA, atención IMEDI)').
contacto_directo(capasits, '951 502 2200 ext. 112 (CAPASITS Coyotepec)').
contacto_directo(cessa_reforma, '951 515 3910 (CESSA Reforma)').
contacto_directo(cs_centro_oax, '951 516 3245 (CS Urbano No. 1)').
contacto_directo(jurisdiccion_valles, '951 515 1190 (Jurisdicción Sanitaria 01)').
contacto_directo(hosp_civil_oax, '951 515 1300 ext. 214 (Medicina Preventiva / PEP)').
contacto_directo(cs_estrella_oax, '951 514 6022 (CS Col. Estrella)').
contacto_directo(clinica_universitaria_oax, '951 502 0700 ext. 118 (Módulo UABJO)').
contacto_directo(hosp_especialidades_coyotepec, '951 501 8080 ext. 1310 (HRAEO)').
contacto_directo(cs_coyotepec, '951 551 0125 (CS San Bartolo Coyotepec)').
contacto_directo(cs_tlalixtac, '951 517 8230 (CS Urbano Tlalixtac)').
contacto_directo(modulo_movil_admon, '951 501 5000 ext. 10412 (Complejo Administrativo)').
contacto_directo(cessa_xoxocotlan, '951 517 2040 (CESSA Xoxocotlán)').
contacto_directo(cs_santa_lucia, '951 513 4421 (CS Santa Lucía)').
contacto_directo(cs_san_jacinto, '951 512 8810 (CS San Jacinto)').
contacto_directo(cs_zaachila, '951 528 6120 (CESSA Zaachila)').
contacto_directo(cs_zimatlan, '951 571 5210 (CS Zimatlán)').
contacto_directo(cs_ocotlan, '951 571 0085 (CS Ocotlán)').
contacto_directo(cs_ejutla, '951 573 2104 (CS Ejutla)').
contacto_directo(cessa_tlacolula, '951 562 0230 (CESSA Tlacolula)').
contacto_directo(cs_etla, '951 521 5312 (CS Villa de Etla)').
contacto_directo(cs_mitla, '951 568 0142 (CS Villa de Mitla)').
contacto_directo(cs_san_antonio_cal, '951 511 4590 (CS San Antonio de la Cal)').
contacto_directo(cs_atzompa, '951 524 8109 (CS Santa María Atzompa)').
contacto_directo(cs_cuilapam, '951 524 2218 (CS Cuilápam)').
contacto_directo(hosp_huajuapan, '953 532 0180 (Hospital General Huajuapan - Módulo ITS)').
contacto_directo(cessa_huajuapan, '953 532 4510 (CESSA Huajuapan)').
contacto_directo(jurisdiccion_mixteca, '953 532 0045 (Jurisdicción Sanitaria 05 Mixteca)').
contacto_directo(cessa_tlaxiaco, '953 552 0415 (CESSA Tlaxiaco)').
contacto_directo(hosp_tlaxiaco, '953 552 0088 (Hospital General Tlaxiaco)').
contacto_directo(hosp_nochixtlan, '951 522 0340 (Hospital Básico Nochixtlán)').
contacto_directo(cs_tamazulapam, '953 533 0112 (CS Tamazulápam)').
contacto_directo(hosp_juxtlahuaca, '953 554 0220 (Hospital General Juxtlahuaca)').
contacto_directo(hosp_chalcatongo, '953 558 0095 (Hospital Básico Chalcatongo)').
contacto_directo(cs_silacayoapam, '953 556 0110 (CS Silacayoápam)').
contacto_directo(cs_teposcolula, '953 518 2033 (CS Teposcolula)').
contacto_directo(capasits_salina_cruz, '971 714 5510 (CAPASITS Salina Cruz)').
contacto_directo(hosp_salina_cruz, '971 714 3210 (Hospital Salina Cruz)').
contacto_directo(hosp_juchitan, '971 711 1245 (Hospital General Juchitán)').
contacto_directo(jurisdiccion_istmo, '971 711 0830 (Jurisdicción Sanitaria 02)').
contacto_directo(cessa_tehuantepec, '971 715 1120 (CESSA Tehuantepec)').
contacto_directo(hosp_ixtepec, '971 713 0190 (Hospital General Ciudad Ixtepec)').
contacto_directo(cs_matias_romero, '972 722 0314 (CS Matías Romero)').
contacto_directo(cs_union_hidalgo, '971 717 1044 (CS Unión Hidalgo)').
contacto_directo(cs_espinal, '971 712 3108 (CS El Espinal)').
contacto_directo(cs_zanatepec, '971 726 0115 (CS Zanatepec)').
contacto_directo(capasits_puerto_escondido, '954 582 2480 (CAPASITS Puerto Escondido)').
contacto_directo(hosp_puerto_escondido, '954 582 0450 (Hospital Puerto Escondido)').
contacto_directo(cessa_huatulco, '958 587 1090 (CESSA Huatulco)').
contacto_directo(hosp_pochutla, '958 584 0205 (Hospital General Pochutla)').
contacto_directo(hosp_pinotepa, '954 543 2410 (Hospital General Pinotepa)').
contacto_directo(hosp_juquila, '954 524 0175 (Hospital Básico Juquila)').
contacto_directo(cs_rio_grande, '954 583 0260 (CS Río Grande)').
contacto_directo(cs_jamiltepec, '954 588 0042 (CS Jamiltepec)').
contacto_directo(jurisdiccion_tuxtepec, '287 875 1420 (Jurisdicción 03 Tuxtepec)').
contacto_directo(hosp_tuxtepec, '287 875 0211 (Hospital General Tuxtepec)').
contacto_directo(hosp_loma_bonita, '281 872 0890 (Hospital Básico Loma Bonita)').
contacto_directo(cs_valle_nacional, '287 881 0074 (CS Valle Nacional)').
contacto_directo(hosp_ixtlan, '951 553 6080 (Hospital Básico Ixtlán)').
contacto_directo(hosp_miahuatlan, '951 572 0412 (Hospital General Miahuatlán)').
contacto_directo(hosp_huautla, '236 378 0122 (Hospital Básico Huautla)').

% =========================================================================
% 7. TABLA: fuente_oficial(IdSede, UrlDocumental) - 55 registros
% =========================================================================
fuente_oficial(huajuapan, 'https://www.oaxaca.gob.mx/comunicacion/inaugura-coesida-modulo-para-deteccion-de-infecciones-de-transmision-sexual-en-huajuapan-de-leon/').
fuente_oficial(tlalixtac, 'https://www.oaxaca.gob.mx/administracion/punto-de-deteccion-de-vih-hepatitis-c-y-sifilis/').
fuente_oficial(imedi, 'https://www.oaxaca.gob.mx/comunicacion/abre-coesida-capasits-noveno-punto-de-deteccion-permanente-en-instalaciones-de-imedi-oaxaca/').
fuente_oficial(capasits, 'https://www.oaxaca.gob.mx/comunicacion/inaugura-coesida-capasits-nuevo-punto-para-la-deteccion-de-vih-sifilis-y-hepatitis-c-en-la-mixteca/').
fuente_oficial(cessa_reforma, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cessa-reforma/').
fuente_oficial(cs_centro_oax, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/csu-01-oaxaca/').
fuente_oficial(jurisdiccion_valles, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-01-valles-centrales/').
fuente_oficial(hosp_civil_oax, 'https://www.oaxaca.gob.mx/salud/hospital-general-dr-aurelio-valdivieso/').
fuente_oficial(cs_estrella_oax, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/csu-estrella/').
fuente_oficial(clinica_universitaria_oax, 'https://www.oaxaca.gob.mx/salud/vinculacion-universitaria-prevencion-its/').
fuente_oficial(hosp_especialidades_coyotepec, 'https://www.oaxaca.gob.mx/salud/hraeo-san-bartolo-coyotepec/').
fuente_oficial(cs_coyotepec, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-san-bartolo-coyotepec/').
fuente_oficial(cs_tlalixtac, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-tlalixtac/').
fuente_oficial(modulo_movil_admon, 'https://www.oaxaca.gob.mx/administracion/jornadas-permanentes-salud-ciudad-administrativa/').
fuente_oficial(cessa_xoxocotlan, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cessa-xoxocotlan/').
fuente_oficial(cs_santa_lucia, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-santa-lucia/').
fuente_oficial(cs_san_jacinto, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-san-jacinto-amilpas/').
fuente_oficial(cs_zaachila, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cessa-zaachila/').
fuente_oficial(cs_zimatlan, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-zimatlan/').
fuente_oficial(cs_ocotlan, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-ocotlan/').
fuente_oficial(cs_ejutla, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-ejutla/').
fuente_oficial(cessa_tlacolula, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cessa-tlacolula/').
fuente_oficial(cs_etla, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-villa-de-etla/').
fuente_oficial(cs_mitla, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-mitla/').
fuente_oficial(cs_san_antonio_cal, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-san-antonio-de-la-cal/').
fuente_oficial(cs_atzompa, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-atzompa/').
fuente_oficial(cs_cuilapam, 'https://www.oaxaca.gob.mx/salud/directorio-de-unidades-medicas-valles-centrales/cs-cuilapam/').
fuente_oficial(hosp_huajuapan, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/hospital-general-huajuapan/').
fuente_oficial(cessa_huajuapan, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/cessa-huajuapan/').
fuente_oficial(jurisdiccion_mixteca, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/').
fuente_oficial(cessa_tlaxiaco, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/cessa-tlaxiaco/').
fuente_oficial(hosp_tlaxiaco, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/hg-tlaxiaco/').
fuente_oficial(hosp_nochixtlan, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/hbc-nochixtlan/').
fuente_oficial(cs_tamazulapam, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/cs-tamazulapam/').
fuente_oficial(hosp_juxtlahuaca, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/hg-juxtlahuaca/').
fuente_oficial(hosp_chalcatongo, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/hbc-chalcatongo/').
fuente_oficial(cs_silacayoapam, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/cs-silacayoapam/').
fuente_oficial(cs_teposcolula, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-05-mixteca/cs-teposcolula/').
fuente_oficial(capasits_salina_cruz, 'https://www.oaxaca.gob.mx/detalle-portal/coesida/capasits-salina-cruz/').
fuente_oficial(hosp_salina_cruz, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/hg-salina-cruz/').
fuente_oficial(hosp_juchitan, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/hg-juchitan/').
fuente_oficial(jurisdiccion_istmo, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/').
fuente_oficial(cessa_tehuantepec, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/cessa-tehuantepec/').
fuente_oficial(hosp_ixtepec, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/hg-ciudad-ixtepec/').
fuente_oficial(cs_matias_romero, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/cs-matias-romero/').
fuente_oficial(cs_union_hidalgo, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/cs-union-hidalgo/').
fuente_oficial(cs_espinal, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/cs-el-espinal/').
fuente_oficial(cs_zanatepec, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-02-istmo/cs-zanatepec/').
fuente_oficial(capasits_puerto_escondido, 'https://www.oaxaca.gob.mx/detalle-portal/coesida/modulo-puerto-escondido/').
fuente_oficial(hosp_puerto_escondido, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-04-costa/hg-puerto-escondido/').
fuente_oficial(cessa_huatulco, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-04-costa/cessa-huatulco/').
fuente_oficial(hosp_pochutla, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-04-costa/hg-pochutla/').
fuente_oficial(hosp_pinotepa, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-04-costa/hg-pinotepa-nacional/').
fuente_oficial(hosp_juquila, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-04-costa/hbc-juquila/').
fuente_oficial(cs_rio_grande, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-04-costa/cs-rio-grande/').
fuente_oficial(cs_jamiltepec, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-04-costa/cs-jamiltepec/').
fuente_oficial(jurisdiccion_tuxtepec, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-03-tuxtepec/').
fuente_oficial(hosp_tuxtepec, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-03-tuxtepec/hg-tuxtepec/').
fuente_oficial(hosp_loma_bonita, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-03-tuxtepec/hbc-loma-bonita/').
fuente_oficial(cs_valle_nacional, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-03-tuxtepec/cs-valle-nacional/').
fuente_oficial(hosp_ixtlan, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-06-sierra/hbc-ixtlan/').
fuente_oficial(hosp_miahuatlan, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-06-sierra/hg-miahuatlan/').
fuente_oficial(hosp_huautla, 'https://www.oaxaca.gob.mx/salud/jurisdiccion-sanitaria-07-canada/hbc-huautla/').

% =========================================================================
% 8. TABLA: protocolo_sede(IdSede, TipoUnidad, ModalidadAcceso, Gratuidad, Consejeria) - 55 registros
%    Atributos:
%    - TipoUnidad: modulo_coesida | capasits | cessa | hospital | centro_salud | clinica_universitaria
%    - ModalidadAcceso: sin_cita | cita_o_turno | urgencias_24h
%    - Gratuidad: gratuito_total | cuota_recuperacion_voluntaria
%    - Consejeria: integral_laica_y_confidencial | orientacion_basica
% =========================================================================
protocolo_sede(huajuapan, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(tlalixtac, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(imedi, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(capasits, capasits, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cessa_reforma, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cs_centro_oax, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(jurisdiccion_valles, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_civil_oax, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cs_estrella_oax, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(clinica_universitaria_oax, clinica_universitaria, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_especialidades_coyotepec, hospital, cita_o_turno, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cs_coyotepec, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_tlalixtac, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(modulo_movil_admon, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cessa_xoxocotlan, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cs_santa_lucia, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_san_jacinto, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_zaachila, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cs_zimatlan, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_ocotlan, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_ejutla, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cessa_tlacolula, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cs_etla, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_mitla, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_san_antonio_cal, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_atzompa, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_cuilapam, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(hosp_huajuapan, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cessa_huajuapan, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(jurisdiccion_mixteca, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cessa_tlaxiaco, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_tlaxiaco, hospital, cita_o_turno, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_nochixtlan, hospital, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_tamazulapam, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(hosp_juxtlahuaca, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_chalcatongo, hospital, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_silacayoapam, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_teposcolula, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(capasits_salina_cruz, capasits, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_salina_cruz, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_juchitan, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(jurisdiccion_istmo, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cessa_tehuantepec, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_ixtepec, hospital, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_matias_romero, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_union_hidalgo, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_espinal, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_zanatepec, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(capasits_puerto_escondido, capasits, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_puerto_escondido, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(cessa_huatulco, cessa, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_pochutla, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_pinotepa, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_juquila, hospital, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_rio_grande, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_jamiltepec, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(jurisdiccion_tuxtepec, modulo_coesida, sin_cita, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_tuxtepec, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_loma_bonita, hospital, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(cs_valle_nacional, centro_salud, cita_o_turno, gratuito_total, orientacion_basica).
protocolo_sede(hosp_ixtlan, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_miahuatlan, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).
protocolo_sede(hosp_huautla, hospital, urgencias_24h, gratuito_total, integral_laica_y_confidencial).

% =========================================================================
% 9. TABLA: guia_clinica_its(ClavePrueba, Categoria, MetodoDiagnostico, PeriodoVentanaDias, TiempoResultadoMinutos) - 50 registros
%    Estándar clínico de pruebas diagnósticas, confirmatorias y profilaxis.
% =========================================================================
guia_clinica_its(vih, prueba_rapida, 'Inmunocromatografia capilar de 4ta generacion Ag/Ac', 21, 15).
guia_clinica_its(sifilis, prueba_rapida, 'Prueba treponemica rapida en sangre capilar', 28, 15).
guia_clinica_its(hepatitis_c, prueba_rapida, 'Deteccion rapida de anticuerpos anti-VHC', 60, 20).
guia_clinica_its(hepatitis_b, prueba_rapida, 'Prueba rapida de antigeno de superficie HBsAg', 30, 20).
guia_clinica_its(vph, tamizaje, 'Citologia cervical y prueba molecular PCR ADN-VPH', 180, 2880).
guia_clinica_its(gonorrea, bacteriologia, 'Tincion de Gram y cultivo Thayer-Martin / PCR', 5, 1440).
guia_clinica_its(clamidia, biologia_molecular, 'Reaccion en Cadena de la Polimerasa PCR orina', 14, 1440).
guia_clinica_its(herpes_genital, serologia, 'Western Blot e hisopado PCR HSV-1 y HSV-2', 21, 1440).
guia_clinica_its(tricomoniasis, microscopia, 'Examen microscopico en fresco de flujo y cultivo', 7, 30).
guia_clinica_its(pep_profilaxis_post_exposicion, urgencia_medica, 'Regimen triconjugado Tenofovir/Emtricitabina/Dolutegravir', 3, 60).

guia_clinica_its(prep_profilaxis_pre_exposicion, prevencion, 'Emtricitabina con Tenofovir disoproxilo diario', 7, 60).
guia_clinica_its(vih_carga_viral, confirmatoria, 'Carga viral plasmatica de ARN por RT-PCR', 10, 2880).
guia_clinica_its(vih_western_blot, confirmatoria, 'Inmunoelectrotransferencia Western Blot', 30, 4320).
guia_clinica_its(vih_recuento_cd4, seguimiento, 'Citometria de flujo para linfocitos T CD4', 1, 1440).
guia_clinica_its(sifilis_vdrl, no_treponemica, 'Prueba de floculacion VDRL cuantitativa', 30, 240).
guia_clinica_its(sifilis_rpr, no_treponemica, 'Reagina Plasmatica Rapida RPR serica', 30, 240).
guia_clinica_its(sifilis_fta_abs, treponemica_confirmatoria, 'Inmunofluorescencia indirecta FTA-ABS', 21, 1440).
guia_clinica_its(hepatitis_c_carga_viral, confirmatoria, 'Cuantificacion de ARN viral VHC por PCR', 21, 2880).
guia_clinica_its(hepatitis_b_anti_hbc, serologia, 'Anticuerpos contra el core anti-HBc IgM e IgG', 30, 1440).
guia_clinica_its(hepatitis_b_anti_hbs, serologia, 'Anticuerpos de superficie cuantificables anti-HBs', 30, 1440).

guia_clinica_its(vph_genotipificacion, biologia_molecular, 'PCR para genotipos 16, 18, 31, 33, 45', 180, 4320).
guia_clinica_its(colposcopia_cervical, visualizacion, 'Examen colposcopico con acido acetico y lugol', 30, 30).
guia_clinica_its(biopsia_lesion_genital, histopatologia, 'Toma de tejido biopsico fijado en formol', 1, 7200).
guia_clinica_its(exudado_uretral_cultivo, cultivo, 'Cultivo en medios selectivos y antibiograma', 3, 2880).
guia_clinica_its(exudado_faringeo_its, bacteriologia, 'Hisopado faringeo para gonococo y clamidia', 5, 2880).
guia_clinica_its(exudado_rectal_its, bacteriologia, 'Hisopado anorectal para deteccion molecular', 5, 2880).
guia_clinica_its(micoplasma_genitalium, biologia_molecular, 'PCR multiplex de bacterias atipicas urogenitales', 14, 2880).
guia_clinica_its(ureaplasma_urealyticum, cultivo, 'Cultivo en caldo urea y paneles de sensibilidad', 14, 2880).
guia_clinica_its(chancro_blando_ducreyi, tincion, 'Tincion y cultivo para Haemophilus ducreyi', 7, 1440).
guia_clinica_its(linfogranuloma_venereo, biologia_molecular, 'Tipificacion serovares L1, L2, L3 de Chlamydia', 21, 2880).

guia_clinica_its(granuloma_inguinal, histologia, 'Identificacion de cuerpos de Donovan en frotis', 30, 1440).
guia_clinica_its(molusco_contagioso, clinica, 'Inspeccion visual y dermatoscopia de umbilicadas', 14, 15).
guia_clinica_its(sarna_escabiosis_genital, microscopia, 'Raspado de surco acarino y visualizacion de acaro', 14, 20).
guia_clinica_its(ladillas_ftiriasis_pubis, microscopia, 'Examen con lupa y microscopio de Phthirus pubis', 7, 15).
guia_clinica_its(candidiasis_urogenital, microscopia, 'Frotis con KOH al 10% para hifas y blastoconidios', 3, 20).
guia_clinica_its(vaginosis_bacteriana, criterios, 'Criterios de Amsel y puntaje de Nugent', 3, 30).
guia_clinica_its(prueba_dual_vih_sifilis, prueba_rapida, 'Tira combinada simultanea para VIH y Treponema', 21, 15).
guia_clinica_its(prueba_autotest_vih, prueba_rapida, 'Autoprueba de fluido oral o sangre digital', 30, 20).
guia_clinica_its(prueba_orina_pcr_its, biologia_molecular, 'Amplificacion de acidos nucleicos en primer chorro', 7, 1440).
guia_clinica_its(serologia_citomegalovirus, serologia, 'Deteccion serica de IgM e IgG anti-CMV', 21, 1440).

guia_clinica_its(prueba_antigeno_p24, laboratorio, 'Enzimoinmunoensayo EIA para antigeno libre p24', 14, 240).
guia_clinica_its(cultivo_virus_herpes, virologia, 'Aislamiento viral en monocapas celulares Vero', 7, 7200).
guia_clinica_its(antibiograma_gonococo, microbiologia, 'Concentracion Minima Inhibitoria E-test ceftriaxona', 5, 2880).
guia_clinica_its(prueba_sensibilidad_antirretroviral, genetica, 'Secuenciacion genotipica de resistencia a TAR', 30, 14400).
guia_clinica_its(tamizaje_anal_citologia, tamizaje, 'Papanicolaou anal para deteccion de displasias', 180, 2880).
guia_clinica_its(anuscopia_alta_resolucion, visualizacion, 'Examen con aumento colposcopico de canal anal', 30, 45).
guia_clinica_its(deteccion_protozoarios_heces, parasitologia, 'Coproparasitoscopico para Giardia y Entamoeba', 7, 1440).
guia_clinica_its(prueba_vih_recien_nacido, molecular, 'ADN proviral por PCR en sangre de cordon', 1, 2880).
guia_clinica_its(panel_molecular_multiplex_its, biologia_molecular, 'Panel sindromico simultaneo 7 patogenos', 7, 2880).
guia_clinica_its(consejeria_vih, orientacion, 'Consejeria pre y post-prueba confidencial y laica', 0, 30).

% =========================================================================
% 10. TABLA: sintoma_sindromico_its(ClaveSintoma, Sindrome, ITSProbable, NivelUrgencia, AccionRecomendada) - 50 registros
%     Modelo de Manejo Sindrómico oficial de la OPS/OMS y CENSIDA.
% =========================================================================
sintoma_sindromico_its(ulcera_genital_indolora, ulcera_genital, sifilis, alta, 'Realizar prueba rapida de sifilis y VDRL; sospecha de chancro primario').
sintoma_sindromico_its(ulcera_genital_dolorosa, ulcera_genital, herpes_genital, moderada, 'Manejo antiviral para herpes o chancroide; descartar coinfeccion').
sintoma_sindromico_its(vesiculas_agrupadas_genitales, ulcera_genital, herpes_genital, moderada, 'Iniciar aciclovir/valaciclovir y evitar contacto sexual hasta remision').
sintoma_sindromico_its(chancro_blando_purulento, ulcera_genital, chancro_blando_ducreyi, alta, 'Cultivo y antibiotico dirigido; tratamiento de parejas sexuales').
sintoma_sindromico_its(adenopatia_inguinal_fistulizada, bubon_inguinal, linfogranuloma_venereo, alta, 'Tratamiento prolongado con doxiciclina y drenaje si aplica').

sintoma_sindromico_its(secrecion_uretral_purulenta, descarga_uretral, gonorrea, alta, 'Tratamiento dual ceftriaxona mas azitromicina; cultivo con antibiograma').
sintoma_sindromico_its(secrecion_uretral_clara, descarga_uretral, clamidia, moderada, 'Tratamiento oral con doxiciclina 100mg por 7 dias').
sintoma_sindromico_its(ardor_al_orinar_disuria, descarga_uretral, gonorrea, moderada, 'Toma de frotis y examen de orina primer chorro').
sintoma_sindromico_its(prurito_uretral_matutino, descarga_uretral, clamidia, leve, 'Manejo empirico sindromico y prueba rapida de VIH/sifilis').
sintoma_sindromico_its(dolor_o_edema_testicular, dolor_escrotal, gonorrea, muy_alta, 'Sospecha de orquiepididimitis; valoracion urologica urgente').

sintoma_sindromico_its(flujo_vaginal_amarillento_fetido, flujo_vaginal, tricomoniasis, moderada, 'Metronidazol 2g dosis unica a la paciente y su pareja').
sintoma_sindromico_its(flujo_blanco_grumoso_prurito, flujo_vaginal, candidiasis_urogenital, leve, 'Antimicotico local o fluconazol oral 150mg').
sintoma_sindromico_its(flujo_grisaceo_olor_a_pescado, flujo_vaginal, vaginosis_bacteriana, leve, 'Tratamiento con metronidazol o clindamicina; no es siempre ITS').
sintoma_sindromico_its(dolor_durante_coito_dispareunia, dolor_pelvico, clamidia, moderada, 'Descartar enfermedad pelvica inflamatoria (EPI)').
sintoma_sindromico_its(sangrado_post_coital_cervicitis, cervicitis, gonorrea, alta, 'Especuloscopia, cultivo cervical y tamizaje de VPH').

sintoma_sindromico_its(dolor_abdominal_bajo_con_fiebre, enfermedad_pelvica_inflamatoria, gonorrea, muy_alta, 'Urgencia ginecologica por riesgo de absceso tubo-ovarico y esterilidad').
sintoma_sindromico_its(verrugas_ano_genitales_condilomas, verrugas_genitales, vph, moderada, 'Crioterapia, podofilina o acido tricloroacetico y colposcopia').
sintoma_sindromico_its(lesiones_en_cresta_de_gallo, verrugas_genitales, vph, moderada, 'Genotipificacion de VPH para descartar alto riesgo oncogenico').
sintoma_sindromico_its(lesiones_perianales_pruriginosas, verrugas_genitales, vph, moderada, 'Anuscopia y revision rectal en poblacion expuesta').
sintoma_sindromico_its(erupcion_cutanea_palmo_plantar, sifilis_secundaria, sifilis, muy_alta, 'Sifilis secundaria clasica; penicilina benzatinica urgente').

sintoma_sindromico_its(manchas_rosadas_tronco_roseola, sifilis_secundaria, sifilis, alta, 'Prueba rapida y VDRL cuantitativo; altamente contagiosa').
sintoma_sindromico_its(alopecia_en_parches_apolillada, sifilis_secundaria, sifilis, alta, 'Manifestacion sistemica de lues; tratamiento con penicilina').
sintoma_sindromico_its(placas_mucosas_blanquecinas_boca, sifilis_secundaria, sifilis, alta, 'Lesiones mucosas contagiosas de sifilis; serologia inmediata').
sintoma_sindromico_its(ganglios_linfaticos_inflamados_cuello, sindrome_retroviral_agudo, vih, muy_alta, 'Prueba de 4ta generacion o carga viral; sospecha de infeccion aguda').
sintoma_sindromico_its(fiebre_prolongada_sudores_nocturnos, sindrome_retroviral_agudo, vih, muy_alta, 'Descartar primoinfeccion por VIH y coinfeccion con tuberculosis').

sintoma_sindromico_its(perdida_de_peso_involuntaria, infeccion_cronica, vih, muy_alta, 'Carga viral, CD4 e inicio inmediato de terapia antirretroviral').
sintoma_sindromico_its(diarrea_cronica_mayor_a_un_mes, infeccion_cronica, vih, muy_alta, 'Protocolo de estadio avanzado; atencion en CAPASITS').
sintoma_sindromico_its(ictericia_ojos_y_piel_amarillos, hepatitis_aguda, hepatitis_b, muy_alta, 'Pruebas de funcion hepatica, antigeno HBsAg y reposo').
sintoma_sindromico_its(orina_muy_oscura_coluria, hepatitis_aguda, hepatitis_c, alta, 'Tamizaje serologico de hepatitis virales B y C').
sintoma_sindromico_its(heces_palidas_o_blanquecinas_acolia, hepatitis_aguda, hepatitis_b, muy_alta, 'Urgencia medica hepatologica; evaluar transmision sexual').

sintoma_sindromico_its(fatiga_extrema_y_dolor_hipocondrio, hepatitis_cronica, hepatitis_c, alta, 'Cuantificacion de carga viral ARN y tratamiento con antivirales').
sintoma_sindromico_its(dolor_ano_rectal_tenesmo_secrecion, proctitis, gonorrea, alta, 'Hisopado rectal para cultivo y tratamiento dual').
sintoma_sindromico_its(sangrado_rectal_tras_coito, proctitis, clamidia, moderada, 'Manejo sindromico anorectal y prueba rapida de VIH').
sintoma_sindromico_its(dolor_de_garganta_persistente_post_coito, faringitis_its, gonorrea, moderada, 'Cultivo de exudado faringeo en medio Thayer-Martin').
sintoma_sindromico_its(ulceras_en_labios_o_cavidad_oral, ulcera_oral, herpes_genital, moderada, 'Tratamiento antiviral; diferenciar de chancro sifilitico').

sintoma_sindromico_its(prurito_nocturno_intenso_genitales, ectoparasitosis, sarna_escabiosis_genital, leve, 'Permetrina topica al 5% o ivermectina oral').
sintoma_sindromico_its(presencia_de_parasitos_vello_pubico, ectoparasitosis, ladillas_ftiriasis_pubis, leve, 'Locion de permetrina y lavado de ropa con agua caliente').
sintoma_sindromico_its(papulas_umbilicadas_genitales, virosis_cutanea, molusco_contagioso, leve, 'Curetaje o crioterapia; descartar inmunodeficiencia').
sintoma_sindromico_its(dolor_ocular_disminucion_visual, neurosifilis, sifilis, muy_alta, 'Puncion lumbar con VDRL en LCR; penicilina sodica IV').
sintoma_sindromico_its(cefalea_intensa_rigidez_nucal, neurosifilis, sifilis, muy_alta, 'Hospitalizacion inmediata por compromiso del sistema nervioso').

sintoma_sindromico_its(dolor_articular_migratorio_con_lesiones, infeccion_diseminada, gonorrea, muy_alta, 'Manejo hospitalario para artritis gonococica diseminada').
sintoma_sindromico_its(ruptura_de_preservativo_reciente, exposicion_aguda, pep_profilaxis_post_exposicion, urgente_72h, 'Iniciar antirretrovirales PEP antes de 72 horas para prevenir VIH').
sintoma_sindromico_its(contacto_sexual_sin_proteccion_riesgo, exposicion_aguda, pep_profilaxis_post_exposicion, urgente_72h, 'Acudir a urgencias para valoracion de profilaxis PEP').
sintoma_sindromico_its(agresion_o_violencia_sexual, exposicion_aguda, pep_profilaxis_post_exposicion, urgente_72h, 'Protocolo integral NOM-046: PEP inmediata, anticoncepcion y atencion medica').
sintoma_sindromico_its(compartir_jeringas_o_agujas, transmision_sanguinea, vih, alta, 'Pruebas de VIH, VHC, VHB e ingreso a programas de reduccion de dano').

sintoma_sindromico_its(tatuaje_o_perforacion_no_esteril, transmision_sanguinea, hepatitis_c, moderada, 'Tamizaje de hepatitis C y B tras periodo de ventana').
sintoma_sindromico_its(pareja_con_diagnostico_reciente_vih, contacto_seropositivo, vih, alta, 'Prueba rapida basal, evaluacion de PrEP o PEP segun temporalidad').
sintoma_sindromico_its(pareja_con_diagnostico_reciente_sifilis, contacto_seropositivo, sifilis, alta, 'Tratamiento profilactico con penicilina benzatinica de inmediato').
sintoma_sindromico_its(deseo_de_revision_rutinaria_asintomatica, tamizaje_preventivo, vih, leve, 'Bateria basica de pruebas rapidas: VIH, Sifilis y Hepatitis C').
sintoma_sindromico_its(inicio_de_nueva_pareja_sexual, tamizaje_preventivo, vih, leve, 'Chequeo mutuo voluntario y entrega de condones y lubricantes').

% =========================================================================
% REGLAS BASE DEL MODELO LÓGICO
% =========================================================================

% Relaciona sede, municipio y prueba ofrecida
ofrece_en(IdSede, Municipio, Prueba) :-
    sede(IdSede, _, Municipio, _),
    deteccion_its(IdSede, Prueba).

% Prueba ofrecida en la sede con horario publicado para el día solicitado
opcion_con_horario(IdSede, Municipio, Prueba, Dia, Inicio, Fin) :-
    ofrece_en(IdSede, Municipio, Prueba),
    horario_semanal(IdSede, Dia, Inicio, Fin).

% Prueba documentada pero con horario pendiente de confirmar para ese día
opcion_sin_horario_confirmado(IdSede, Municipio, Prueba, Dia) :-
    dia(Dia),
    ofrece_en(IdSede, Municipio, Prueba),
    \+ horario_semanal(IdSede, Dia, _, _).

% Estado del horario de una sede en un día
estado_horario(IdSede, Dia, publicado(Inicio, Fin)) :-
    horario_semanal(IdSede, Dia, Inicio, Fin).
estado_horario(IdSede, Dia, por_confirmar) :-
    sede(IdSede, _, _, _),
    dia(Dia),
    \+ horario_semanal(IdSede, Dia, _, _).

% Sedes que pertenecen a una región geográfica específica
sede_en_region(IdSede, Region) :-
    sede(IdSede, _, Municipio, _),
    region_municipio(Municipio, Region).

% Pruebas disponibles por región
ofrece_en_region(IdSede, Region, Municipio, Prueba) :-
    sede_en_region(IdSede, Region),
    ofrece_en(IdSede, Municipio, Prueba).

% Sedes del mismo municipio con horario publicado en otro día distinto
opcion_otro_dia_municipio(IdSede, Municipio, Prueba, DiaBuscado, OtroDia, Inicio, Fin) :-
    dia(DiaBuscado),
    ofrece_en(IdSede, Municipio, Prueba),
    \+ horario_semanal(IdSede, DiaBuscado, _, _),
    horario_semanal(IdSede, OtroDia, Inicio, Fin),
    OtroDia \== DiaBuscado.

% Alternativas en municipios vecinos de la misma región con horario publicado ese día
alternativa_regional_con_horario(MunicipioBase, Prueba, Dia, IdSedeVecina, MunicipioVecino, Inicio, Fin) :-
    region_municipio(MunicipioBase, Reg),
    region_municipio(MunicipioVecino, Reg),
    MunicipioVecino \== MunicipioBase,
    opcion_con_horario(IdSedeVecina, MunicipioVecino, Prueba, Dia, Inicio, Fin).

% Sedes con horario publicado en sábado o domingo
atencion_fin_de_semana(IdSede, Municipio, Dia, Inicio, Fin) :-
    member(Dia, [sabado, domingo]),
    sede(IdSede, _, Municipio, _),
    horario_semanal(IdSede, Dia, Inicio, Fin).

% Sedes con panel básico completo (VIH + Sífilis + Hepatitis C)
sede_panel_basico_completo(IdSede, Municipio) :-
    sede(IdSede, _, Municipio, _),
    deteccion_its(IdSede, vih),
    deteccion_its(IdSede, sifilis),
    deteccion_its(IdSede, hepatitis_c).

% Resumen de pruebas disponibles en una sede
pruebas_de_sede(IdSede, Pruebas) :-
    sede(IdSede, _, _, _),
    findall(P, deteccion_its(IdSede, P), Lista),
    sort(Lista, Pruebas).

% =========================================================================
% REGLA COMPLEJA 1: MOTOR DE DIAGNÓSTICO SINDRÓMICO Y EVALUACIÓN DE RIESGO
% Aplica el algoritmo oficial de manejo sindrómico de la OPS/OMS
% =========================================================================

diagnostico_sindromico(Sintoma, Sindrome, ITSProbable, Urgencia, Accion) :-
    sintoma_sindromico_its(Sintoma, Sindrome, ITSProbable, Urgencia, Accion).

% Identifica si un síntoma requiere atención médica de emergencia inmediata
requiere_atencion_urgente(Sintoma) :-
    sintoma_sindromico_its(Sintoma, _, _, Urgencia, _),
    memberchk(Urgencia, [muy_alta, urgente_72h]).

% =========================================================================
% REGLA COMPLEJA 2: EVALUACIÓN DEL PERIODO DE VENTANA BIOLÓGICA
% Evalúa si la prueba elegida es confiable respecto a los días transcurridos
% desde el contacto sexual o exposición de riesgo.
% =========================================================================

evaluar_periodo_ventana(Prueba, DiasTranscurridos, EstadoVentana, Recomendacion) :-
    guia_clinica_its(Prueba, _, Metodo, VentanaDias, _),
    (   Prueba == pep_profilaxis_post_exposicion
    ->  Horas is DiasTranscurridos * 24,
        (   Horas =< 72.0
        ->  EstadoVentana = dentro_de_tiempo_urgencia_pep,
            Recomendacion = 'URGENCIA MÉDICA: Dentro de las 72 horas para inicio de antirretrovirales PEP.'
        ;   EstadoVentana = fuera_de_ventana_pep,
            Recomendacion = 'Ventana para PEP expirada (>72h). Acude a tamizaje serológico en 3 semanas.'
        )
    ;   DiasTranscurridos < VentanaDias
    ->  Diferencia is VentanaDias - DiasTranscurridos,
        EstadoVentana = dentro_del_periodo_de_ventana,
        format(atom(Recomendacion),
               'ALERTA DE FALSO NEGATIVO: Han pasado ~d dias y el periodo de ventana para ~w (~w) es de ~d dias. Conviene esperar ~d dias mas o realizar prueba molecular PCR.',
               [DiasTranscurridos, Prueba, Metodo, VentanaDias, Diferencia])
    ;   EstadoVentana = ventana_superada_resultado_confiable,
        format(atom(Recomendacion),
               'RESULTADO CONFIABLE: Han transcurrido ~d dias (ventana minima de ~d dias cumplida para ~w).',
               [DiasTranscurridos, VentanaDias, Prueba])
    ).

% =========================================================================
% REGLA COMPLEJA 3: RANKING MULTICRITERIO DE IDONEIDAD DE SEDES
% perfil_consulta(Municipio, Prueba, Dia, PrefAcceso, ExigeGratuidad)
% Genera un puntaje ponderado (0-100 pts) con desglose explicativo:
% - Cercanía geográfica (40 pts mismo municipio, 20 pts región)
% - Horario publicado ese día (30 pts día exacto, 15 pts otros días, 5 pts por confirmar)
% - Modalidad de acceso preferida (15 pts)
% - Gratuidad total garantizada (10 pts)
% - Consejería integral pre y post prueba (5 pts)
% =========================================================================

evaluar_sede_score(perfil_consulta(MunBuscado, Prueba, Dia, PrefAcceso, ExigeGratuidad),
                   IdSede, Puntos, Motivos) :-
    ofrece_en(IdSede, MunSede, Prueba),
    region_municipio(MunBuscado, RegBuscada),
    region_municipio(MunSede, RegBuscada),
    % 1. Proximidad territorial
    (   MunSede == MunBuscado
    ->  PGeo = 40, MGeo = ['Mismo municipio']
    ;   PGeo = 20, MGeo = ['Alternativa en municipio vecino de la región']
    ),
    % 2. Horario en el día solicitado
    (   horario_semanal(IdSede, Dia, _, _)
    ->  PHor = 30, MHor = ['Horario publicado confirmado para este dia']
    ;   horario_semanal(IdSede, _, _, _)
    ->  PHor = 15, MHor = ['Tiene horario publicado en otros dias de la semana']
    ;   PHor = 5,  MHor = ['Horario pendiente de confirmacion telefonica']
    ),
    % 3. Modalidad de acceso
    protocolo_sede(IdSede, _, AccesoSede, GratuidadSede, ConsejeriaSede),
    (   (PrefAcceso == cualquiera ; PrefAcceso == AccesoSede)
    ->  PAcc = 15, MAcc = ['Modalidad de acceso coincidente']
    ;   PAcc = 0,  MAcc = ['Modalidad de acceso distinta']
    ),
    % 4. Costo
    (   (ExigeGratuidad == si -> GratuidadSede == gratuito_total ; true)
    ->  PGrat = 10, MGrat = ['Atencion 100% gratuita']
    ;   PGrat = 2,  MGrat = ['Posible cuota voluntaria de recuperacion']
    ),
    % 5. Consejería integral
    (   ConsejeriaSede == integral_laica_y_confidencial
    ->  PCon = 5, MCon = ['Consejeria especializada pre y post-prueba']
    ;   PCon = 0, MCon = []
    ),
    Puntos is PGeo + PHor + PAcc + PGrat + PCon,
    append([MGeo, MHor, MAcc, MGrat, MCon], Motivos).

mejor_recomendacion_sede(Perfil, RankingOrdenado) :-
    findall((NegPuntos-IdSede)-datos_recomendacion(IdSede, Puntos, Motivos),
            ( evaluar_sede_score(Perfil, IdSede, Puntos, Motivos),
              NegPuntos is -Puntos
            ),
            Pares),
    keysort(Pares, ParesOrdenados),
    findall(D, member(_-D, ParesOrdenados), RankingOrdenado).

% =========================================================================
% REGLA COMPLEJA 4: CÁLCULO DE DURACIÓN DE JORNADA Y HORA EXACTA
% =========================================================================

hora_a_minutos(HoraAtom, TotalMinutos) :-
    atom_string(HoraAtom, HoraStr),
    split_string(HoraStr, ":", "", [HStr, MStr]),
    number_string(H, HStr),
    number_string(M, MStr),
    TotalMinutos is H * 60 + M.

duracion_atencion_horas(IdSede, Dia, DuracionHoras, TipoJornada) :-
    horario_semanal(IdSede, Dia, Inicio, Fin),
    hora_a_minutos(Inicio, MinIni),
    hora_a_minutos(Fin, MinFin),
    DuracionHoras is (MinFin - MinIni) / 60.0,
    (   DuracionHoras >= 7.0 -> TipoJornada = jornada_completa
    ;   DuracionHoras >= 4.5 -> TipoJornada = jornada_media
    ;   TipoJornada = turno_reducido
    ).

abierto_en_hora_exacta(IdSede, Dia, HoraConsulta, Rango) :-
    horario_semanal(IdSede, Dia, Inicio, Fin),
    hora_a_minutos(Inicio, MinIni),
    hora_a_minutos(Fin, MinFin),
    hora_a_minutos(HoraConsulta, MinCons),
    MinCons >= MinIni,
    MinCons =< MinFin,
    Rango = Inicio-Fin.

% =========================================================================
% REGLA COMPLEJA 5: RUTA DE ATENCIÓN MULTI-PRUEBA Y DERIVACIÓN REGIONAL
% =========================================================================

cubre_conjunto_pruebas(IdSede, ListaPruebas) :-
    sede(IdSede, _, _, _),
    forall(member(P, ListaPruebas), deteccion_its(IdSede, P)).

ruta_atencion_completa(Municipio, ListaPruebas, TipoRuta, Solucion) :-
    ListaPruebas \== [],
    sede(IdLocal, _, Municipio, _),
    cubre_conjunto_pruebas(IdLocal, ListaPruebas),
    TipoRuta = atencion_integral_en_sede_unica,
    Solucion = sede_completa(IdLocal, Municipio, ListaPruebas).

ruta_atencion_completa(Municipio, ListaPruebas, TipoRuta, Solucion) :-
    ListaPruebas \== [],
    \+ (sede(IdL, _, Municipio, _), cubre_conjunto_pruebas(IdL, ListaPruebas)),
    sede(IdPrimaria, _, Municipio, _),
    findall(P, (member(P, ListaPruebas), deteccion_its(IdPrimaria, P)), PruebasLocales),
    PruebasLocales \== [],
    subtract(ListaPruebas, PruebasLocales, Faltantes),
    region_municipio(Municipio, Reg),
    sede_en_region(IdReferencia, Reg),
    IdReferencia \== IdPrimaria,
    cubre_conjunto_pruebas(IdReferencia, Faltantes),
    TipoRuta = derivacion_regional_combinada,
    Solucion = enlace(primaria(IdPrimaria, Municipio, PruebasLocales),
                      derivacion(IdReferencia, Reg, Faltantes)).

% =========================================================================
% REGLA COMPLEJA 6: AUDITORÍA Y DIAGNÓSTICO EPIDEMIOLÓGICO POR REGIÓN
% =========================================================================

diagnostico_regional(Region, Estadisticas) :-
    region(Region, NombreRegion),
    findall(Id, sede_en_region(Id, Region), SedesReg),
    length(SedesReg, TotalSedes),
    findall(Id, (member(Id, SedesReg), deteccion_its(Id, vih)), SedesVIH),
    length(SedesVIH, TotalVIH),
    findall(Id, (member(Id, SedesReg), deteccion_its(Id, sifilis)), SedesSif),
    length(SedesSif, TotalSifilis),
    findall(Id, (member(Id, SedesReg), deteccion_its(Id, hepatitis_c)), SedesHepC),
    length(SedesHepC, TotalHepC),
    findall(Id, (member(Id, SedesReg), deteccion_its(Id, pep_profilaxis_post_exposicion)), SedesPEP),
    length(SedesPEP, TotalPEP),
    findall(Id, (member(Id, SedesReg), horario_semanal(Id, sabado, _, _)), SedesSabado),
    length(SedesSabado, TotalSabado),
    findall(Id, (member(Id, SedesReg), protocolo_sede(Id, _, sin_cita, _, _)), SedesSinCita),
    length(SedesSinCita, TotalSinCita),
    Estadisticas = stats(
        region(Region, NombreRegion),
        total_sedes(TotalSedes),
        deteccion_vih(TotalVIH),
        deteccion_sifilis(TotalSifilis),
        deteccion_hepatitis_c(TotalHepC),
        urgencias_pep(TotalPEP),
        apertura_sabado(TotalSabado),
        acceso_sin_cita(TotalSinCita)
    ).

% =========================================================================
% REGLA COMPLEJA 7: ANALIZADOR LÉXICO DE LENGUAJE NATURAL
% =========================================================================

alias_palabra(prueba, "vih", vih).
alias_palabra(prueba, "sida", vih).
alias_palabra(prueba, "sifilis", sifilis).
alias_palabra(prueba, "hepatitis", hepatitis_c).
alias_palabra(prueba, "vhc", hepatitis_c).
alias_palabra(prueba, "vhb", hepatitis_b).
alias_palabra(prueba, "gonorrea", gonorrea).
alias_palabra(prueba, "vph", vph).
alias_palabra(prueba, "papiloma", vph).
alias_palabra(prueba, "pep", pep_profilaxis_post_exposicion).
alias_palabra(prueba, "profilaxis", pep_profilaxis_post_exposicion).

alias_palabra(dia, "lunes", lunes).
alias_palabra(dia, "martes", martes).
alias_palabra(dia, "miercoles", miercoles).
alias_palabra(dia, "jueves", jueves).
alias_palabra(dia, "viernes", viernes).
alias_palabra(dia, "sabado", sabado).
alias_palabra(dia, "domingo", domingo).

alias_palabra(municipio, "huajuapan", huajuapan).
alias_palabra(municipio, "tlalixtac", tlalixtac).
alias_palabra(municipio, "oaxaca", oaxaca_de_juarez).
alias_palabra(municipio, "coyotepec", san_bartolo_coyotepec).
alias_palabra(municipio, "xoxocotlan", santa_cruz_xoxocotlan).
alias_palabra(municipio, "xoxo", santa_cruz_xoxocotlan).
alias_palabra(municipio, "zaachila", villa_de_zaachila).
alias_palabra(municipio, "tlacolula", tlacolula_de_matamoros).
alias_palabra(municipio, "tlaxiaco", tlaxiaco).
alias_palabra(municipio, "nochixtlan", nochixtlan).
alias_palabra(municipio, "juxtlahuaca", juxtlahuaca).
alias_palabra(municipio, "juchitan", juchitan).
alias_palabra(municipio, "salina", salina_cruz).
alias_palabra(municipio, "tehuantepec", tehuantepec).
alias_palabra(municipio, "ixtepec", ixtepec).
alias_palabra(municipio, "escondido", puerto_escondido).
alias_palabra(municipio, "huatulco", huatulco).
alias_palabra(municipio, "pochutla", pochutla).
alias_palabra(municipio, "pinotepa", pinotepa_nacional).
alias_palabra(municipio, "tuxtepec", tuxtepec).
alias_palabra(municipio, "ixtlan", ixtlan_de_juarez).
alias_palabra(municipio, "miahuatlan", miahuatlan).
alias_palabra(municipio, "huautla", huautla_de_jimenez).

char_normal(225, 97) :- !.  % á -> a
char_normal(233, 101) :- !. % é -> e
char_normal(237, 105) :- !. % í -> i
char_normal(243, 111) :- !. % ó -> o
char_normal(250, 117) :- !. % ú -> u
char_normal(241, 110) :- !. % ñ -> n
char_normal(C, 32) :-
    memberchk(C, [44, 46, 59, 58, 33, 63, 191, 161, 40, 41, 34, 39, 45, 47]), !.
char_normal(C, C).

parse_frase_tokens(Texto, Tokens) :-
    string_lower(Texto, Min),
    string_codes(Min, Codes),
    maplist(char_normal, Codes, NormCodes),
    string_codes(Limpio, NormCodes),
    split_string(Limpio, " ", " \t\r\n", Tokens).

extraer_alias(Categoria, Tokens, Defecto, Valor) :-
    findall(V, (member(T, Tokens), alias_palabra(Categoria, T, V)), Vals),
    sort(Vals, Unicos),
    (   Unicos = [Valor] -> true
    ;   Unicos = [Valor|_] -> true
    ;   Valor = Defecto
    ).

interpretar_consulta_natural(Frase, consulta(Municipio, Prueba, Dia)) :-
    parse_frase_tokens(Frase, Tokens),
    extraer_alias(municipio, Tokens, oaxaca_de_juarez, Municipio),
    extraer_alias(prueba, Tokens, vih, Prueba),
    extraer_alias(dia, Tokens, lunes, Dia).

% =========================================================================
% CONTEO Y AUDITORÍA DE LAS 10 TABLAS PRINCIPALES
% =========================================================================

total_tabla(sede, N)                   :- aggregate_all(count, sede(_, _, _, _), N).
total_tabla(municipio, N)              :- aggregate_all(count, municipio(_, _), N).
total_tabla(region_municipio, N)       :- aggregate_all(count, region_municipio(_, _), N).
total_tabla(deteccion_its, N)          :- aggregate_all(count, deteccion_its(_, _), N).
total_tabla(horario_semanal, N)        :- aggregate_all(count, horario_semanal(_, _, _, _), N).
total_tabla(contacto_directo, N)       :- aggregate_all(count, contacto_directo(_, _), N).
total_tabla(fuente_oficial, N)         :- aggregate_all(count, fuente_oficial(_, _), N).
total_tabla(protocolo_sede, N)         :- aggregate_all(count, protocolo_sede(_, _, _, _, _), N).
total_tabla(guia_clinica_its, N)       :- aggregate_all(count, guia_clinica_its(_, _, _, _, _), N).
total_tabla(sintoma_sindromico_its, N) :- aggregate_all(count, sintoma_sindromico_its(_, _, _, _, _), N).

contar_tablas :-
    writeln('================================================================='),
    writeln('   TAMAÑO DE LA BASE DE CONOCIMIENTOS (10 TABLAS PRINCIPALES)'),
    writeln('================================================================='),
    Tablas = [sede, municipio, region_municipio, deteccion_its,
              horario_semanal, contacto_directo, fuente_oficial,
              protocolo_sede, guia_clinica_its, sintoma_sindromico_its],
    findall(N,
            ( member(T, Tablas),
              total_tabla(T, N),
              format('  [✓] Tabla ~w~t: ~d hechos~n', [T, N])
            ),
            Totales),
    sum_list(Totales, GranTotal),
    writeln('-----------------------------------------------------------------'),
    format('  TOTAL CONJUNTO: ~d hechos en las 10 tablas principales.~n', [GranTotal]),
    writeln('=================================================================').

% =========================================================================
% FORMATO DE SALIDA Y CONSULTA EN CONSOLA
% =========================================================================

mostrar_ficha_sede(IdSede) :-
    sede(IdSede, Nombre, Mun, Dir),
    municipio(Mun, MunNom),
    region_municipio(Mun, Reg),
    region(Reg, RegNom),
    contacto_directo(IdSede, Tel),
    fuente_oficial(IdSede, Url),
    protocolo_sede(IdSede, TipoU, Acceso, Grat, Consej),
    pruebas_de_sede(IdSede, Pruebas),
    atomic_list_concat(Pruebas, ', ', PruebasTxt),
    format('~n-----------------------------------------------------------------~n'),
    format('~w (~w - Region ~w)~n', [Nombre, MunNom, RegNom]),
    format('  Direccion: ~w~n', [Dir]),
    format('  Protocolo: ~w | Acceso: ~w | Costo: ~w~n', [TipoU, Acceso, Grat]),
    format('  Consejeria: ~w~n', [Consej]),
    format('  Pruebas disponibles: ~w~n', [PruebasTxt]),
    format('  Contacto directo: ~w~n', [Tel]),
    format('  Fuente oficial: ~w~n', [Url]).

mostrar_horarios_sede(IdSede) :-
    mostrar_ficha_sede(IdSede),
    writeln('  Horarios por dia de la semana:'),
    forall(dia(D),
           ( nombre_dia(D, NomD),
             (   horario_semanal(IdSede, D, I, F)
             ->  duracion_atencion_horas(IdSede, D, Horas, Turno),
                 format('    - ~w: ~w a ~w (~1f hrs, ~w)~n', [NomD, I, F, Horas, Turno])
             ;   format('    - ~w: Por confirmar telefonicamente~n', [NomD])
             )
           )).

mostrar_busqueda_triple(Municipio, Prueba, todos) :- !,
    mostrar_busqueda_semanal_completa(Municipio, Prueba).
mostrar_busqueda_triple(Municipio, Prueba, Dia) :-
    findall(IdS-Ini-Fin,
            opcion_con_horario(IdS, Municipio, Prueba, Dia, Ini, Fin),
            Publicados),
    findall(IdS,
            opcion_sin_horario_confirmado(IdS, Municipio, Prueba, Dia),
            Pendientes),
    findall(IdR-MunV-InR-FiR,
            alternativa_regional_con_horario(Municipio, Prueba, Dia, IdR, MunV, InR, FiR),
            Regionales),
    format('~n=================================================================~n'),
    format('RESULTADOS: Deteccion de [~w] en [~w] para el dia [~w]~n', [Prueba, Municipio, Dia]),
    format('=================================================================~n'),
    writeln('1. SEDES EN EL MUNICIPIO CON HORARIO PUBLICADO ESE DIA:'),
    (   Publicados == []
    ->  writeln('   (No hay sedes con horario publicado exactamente ese dia en este municipio)')
    ;   forall(member(IdS-Ini-Fin, Publicados),
               ( mostrar_ficha_sede(IdS),
                 duracion_atencion_horas(IdS, Dia, H, T),
                 format('  -> HORARIO PUBLICADO: ~w a ~w (~1f hrs, ~w)~n', [Ini, Fin, H, T])
               ))
    ),
    nl,
    writeln('2. SEDES EN EL MUNICIPIO CON LA PRUEBA PERO HORARIO POR CONFIRMAR:'),
    (   Pendientes == []
    ->  writeln('   (Todas las sedes del municipio cuentan con horario publicado para este dia)')
    ;   forall(member(IdP, Pendientes),
               ( mostrar_ficha_sede(IdP),
                 writeln('  -> Estado: Disponibilidad para este dia por confirmar por telefono.'),
                 findall(D-I-F, opcion_otro_dia_municipio(IdP, Municipio, Prueba, Dia, D, I, F), OtrosD),
                 (   OtrosD \== []
                 ->  writeln('     Horarios publicados en otros dias de la semana:'),
                     forall(member(D2-I2-F2, OtrosD),
                            format('       * ~w: ~w a ~w~n', [D2, I2, F2]))
                 ;   true
                 )
               ))
    ),
    nl,
    writeln('3. ALTERNATIVAS CERCANAS EN LA MISMA REGION CON HORARIO PUBLICADO ESE DIA:'),
    (   Regionales == []
    ->  writeln('   (Sin alternativas adicionales con horario publicado en municipios vecinos)')
    ;   forall(member(IdR-MunV-InR-FiR, Regionales),
               ( sede(IdR, NomR, _, DirR),
                 municipio(MunV, NomMunV),
                 contacto_directo(IdR, TelR),
                 format('  * ~w (~w) | Horario: ~w a ~w | Tel: ~w | Dir: ~w~n',
                        [NomR, NomMunV, InR, FiR, TelR, DirR])
               ))
    ),
    format('=================================================================~n').

mostrar_busqueda_semanal_completa(Municipio, Prueba) :-
    findall(IdS, ofrece_en(IdS, Municipio, Prueba), SedesLocales),
    region_municipio(Municipio, Reg),
    findall(IdR, (sede_en_region(IdR, Reg), ofrece_en(IdR, MunVec, Prueba), MunVec \== Municipio), SedesVecinas),
    municipio(Municipio, NombreMun),
    region(Reg, NombreReg),
    format('~n=================================================================~n'),
    format('HORARIO SEMANAL COMPLETO DE DETECCIÓN: [~w]~n', [Prueba]),
    format('Municipio seleccionado: ~w (Región: ~w)~n', [NombreMun, NombreReg]),
    format('=================================================================~n'),
    writeln('1. SEDES DENTRO DEL MUNICIPIO Y SU HORARIO SEMANAL DETALLADO:'),
    (   SedesLocales == []
    ->  writeln('   (No hay sedes documentadas directamente en este municipio para esta prueba)')
    ;   forall(member(IdS, SedesLocales),
               ( mostrar_ficha_sede(IdS),
                 writeln('  -> HORARIOS PUBLICADOS EN LA SEMANA (Lunes a Domingo):'),
                 forall(dia(D),
                        ( nombre_dia(D, NomDia),
                          (   horario_semanal(IdS, D, I, F)
                          ->  duracion_atencion_horas(IdS, D, Horas, Turno),
                              format('     [✓] ~w: ~w a ~w (~1f hrs, ~w)~n', [NomDia, I, F, Horas, Turno])
                          ;   format('     [?] ~w: Por confirmar telefónicamente~n', [NomDia])
                          )
                        ))
               ))
    ),
    nl,
    writeln('2. ALTERNATIVAS CERCANAS EN LA MISMA REGIÓN CON DÍAS PUBLICADOS:'),
    (   SedesVecinas == []
    ->  writeln('   (No hay sedes adicionales en la región)')
    ;   sort(SedesVecinas, SedesVecinasUnicas),
        forall(member(IdR, SedesVecinasUnicas),
               ( sede(IdR, NomR, MunR, DirR),
                 municipio(MunR, NomMunR),
                 contacto_directo(IdR, TelR),
                 findall(DiaPub-Ini-Fin, horario_semanal(IdR, DiaPub, Ini, Fin), DiasPubs),
                 format('  * ~w (~w) | Tel: ~w | Dir: ~w~n', [NomR, NomMunR, TelR, DirR]),
                 (   DiasPubs == []
                 ->  writeln('      Horarios sujetos a confirmación telefónica.')
                 ;   format('      Días publicados: '),
                     forall(member(DP-IP-FP, DiasPubs), format('~w (~w-~w) ', [DP, IP, FP])),
                     nl
                 )
               ))
    ),
    format('=================================================================~n').

% =========================================================================
% MENÚ INTERACTIVO Y ENTRADA DE DATOS
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
    ;   writeln('Entrada no valida. Escribe un numero de las opciones mostradas.'), fail
    ).

menu :-
    repeat,
    nl,
    writeln('================================================================='),
    writeln('   SISTEMA EXPERTO DE DETECCION DE ITS Y SALUD SEXUAL EN OAXACA'),
    writeln('   Programacion Logica y Funcional - Caso de Estudio 3'),
    writeln('================================================================='),
    writeln(' 1. Buscar deteccion por Municipio, Tipo de Prueba y Dia'),
    writeln(' 2. Evaluador Sindromico de Sintomas (Modelo OPS/OMS y CENSIDA)'),
    writeln(' 3. Calculador de Periodo de Ventana y Urgencia PEP (hasta 72 hrs)'),
    writeln(' 4. Recomendador Multicriterio de Sedes con Puntaje de Idoneidad'),
    writeln(' 5. Ruta de Atencion Multi-Prueba y Derivacion Regional Coordinada'),
    writeln(' 6. Ver Sedes por Region y Diagnostico de Cobertura Sanitaria'),
    writeln(' 7. Ver Sedes con Horario Publicado en Fin de Semana (Sabado)'),
    writeln(' 8. Busqueda Inteligente mediante Frase en Lenguaje Natural'),
    writeln(' 9. Ver Ficha Tecnica Detallada, Duracion de Turnos y Requisitos'),
    writeln('10. Estadisticas de la Base de Conocimientos (las 10 Tablas)'),
    writeln('11. Ejecutar Demostracion Automatica de Todas las Reglas'),
    writeln(' 0. Salir'),
    writeln('-----------------------------------------------------------------'),
    leer_entero_valido('Selecciona una opcion (0-11):', 0, 11, Opcion),
    ejecutar_opcion(Opcion),
    Opcion =:= 0, !.

ejecutar_opcion(0) :- writeln('Sesion finalizada. La deteccion oportuna salva vidas.').
ejecutar_opcion(1) :- opcion_busqueda_triple.
ejecutar_opcion(2) :- opcion_sindromica.
ejecutar_opcion(3) :- opcion_periodo_ventana.
ejecutar_opcion(4) :- opcion_multicriterio.
ejecutar_opcion(5) :- opcion_ruta_multiprueba.
ejecutar_opcion(6) :- opcion_diagnostico_regional.
ejecutar_opcion(7) :- opcion_fin_de_semana.
ejecutar_opcion(8) :- opcion_lenguaje_natural.
ejecutar_opcion(9) :- opcion_ficha_sede.
ejecutar_opcion(10) :- contar_tablas.
ejecutar_opcion(11) :- demostracion_automatica.

% Selectores de datos
seleccionar_municipio(M) :-
    findall(Mun, municipio(Mun, _), Muns),
    length(Muns, Total),
    writeln('================================================================='),
    writeln('            LISTA COMPLETA DE MUNICIPIOS DE OAXACA               '),
    writeln('================================================================='),
    forall(nth1(I, Muns, Clave),
           ( municipio(Clave, NombreOficial),
             region_municipio(Clave, Region),
             region(Region, NombreRegion),
             format(' ~|~` t~d~3+. ~w (~w)~n', [I, NombreOficial, NombreRegion])
           )),
    writeln('-----------------------------------------------------------------'),
    format(atom(Prompt), 'Elige el numero de municipio (1-~d):', [Total]),
    leer_entero_valido(Prompt, 1, Total, Idx),
    nth1(Idx, Muns, M).

seleccionar_prueba(P) :-
    Pruebas = [vih, sifilis, hepatitis_c, hepatitis_b, gonorrea, vph, pep_profilaxis_post_exposicion],
    writeln('--- Catalogo de Deteccion de ITS ---'),
    writeln('1. VIH (Prueba rapida capilar de 4ta generacion)'),
    writeln('2. Sifilis (Prueba treponemica rapida)'),
    writeln('3. Hepatitis C (Anticuerpos anti-VHC)'),
    writeln('4. Hepatitis B (Antigeno HBsAg)'),
    writeln('5. Gonorrea (Diagnostico bacteriologico / PCR)'),
    writeln('6. VPH (Tamizaje citologico / PCR genotipificacion)'),
    writeln('7. Profilaxis Post-Exposicion PEP (Antirretrovirales dentro de 72h)'),
    leer_entero_valido('Elige prueba (1-7):', 1, 7, Idx),
    nth1(Idx, Pruebas, P).

seleccionar_dia(D) :-
    Dias = [lunes, martes, miercoles, jueves, viernes, sabado, domingo, todos],
    writeln('--- Dias de Atencion ---'),
    writeln('1. Lunes  2. Martes  3. Miercoles  4. Jueves  5. Viernes  6. Sabado  7. Domingo'),
    writeln('8. Todos los dias (Consultar horario completo de la semana)'),
    leer_entero_valido('Elige dia (1-8):', 1, 8, Idx),
    nth1(Idx, Dias, D).

opcion_busqueda_triple :-
    seleccionar_municipio(M),
    seleccionar_prueba(P),
    seleccionar_dia(D),
    mostrar_busqueda_triple(M, P, D).

opcion_sindromica :-
    writeln('================================================================='),
    writeln('   EVALUADOR SINDRÓMICO DE SÍNTOMAS DE ITS (MODELO OPS/OMS)      '),
    writeln('================================================================='),
    writeln('AVISO MÉDICO Y LEGAL IMPORTANTE:'),
    writeln('Este diagnóstico sindrómico es una orientación preliminar basada en'),
    writeln('algoritmos informativos y de salud pública (OPS/OMS y CENSIDA).'),
    writeln('NO sustituye una valoración médica presencial, diagnóstico clínico formal'),
    writeln('ni estudios de laboratorio. Es indispensable acudir a consulta médica.'),
    writeln('-----------------------------------------------------------------'),
    findall(s(Sint, Sind, Urg), sintoma_sindromico_its(Sint, Sind, _, Urg, _), ListaSintomas),
    length(ListaSintomas, TotalS),
    writeln('Catálogo completo de Síntomas y Motivos de Consulta (1 al 50):'),
    writeln('-----------------------------------------------------------------'),
    forall(nth1(I, ListaSintomas, s(Sint, Sind, Urg)),
           ( format(' ~|~` t~d~2+. ~w (~w | Urgencia: ~w)~n', [I, Sint, Sind, Urg])
           )),
    writeln('-----------------------------------------------------------------'),
    format(atom(Prompt), 'Selecciona el número de síntoma o motivo (1-~d):', [TotalS]),
    leer_entero_valido(Prompt, 1, TotalS, Idx),
    nth1(Idx, ListaSintomas, s(SintomaElegido, _, _)),
    diagnostico_sindromico(SintomaElegido, Sindrome, ITS, Urgencia, Accion),
    format('~n=================================================================~n'),
    format('RESULTADO DEL DIAGNÓSTICO SINDRÓMICO:~n'),
    format('  Síntoma evaluado:       ~w~n', [SintomaElegido]),
    format('  Síndrome clínico OPS:   ~w~n', [Sindrome]),
    format('  ITS altamente probable: ~w~n', [ITS]),
    format('  Nivel de urgencia:      ~w~n', [Urgencia]),
    format('  Protocolo recomendado:  ~w~n', [Accion]),
    (   requiere_atencion_urgente(SintomaElegido)
    ->  format('~n[ALERTA CLÍNICA] Este cuadro requiere valoración médica urgente en un servicio de urgencias o CAPASITS.~n')
    ;   true
    ),
    writeln('Recuerda: Acude a un centro de salud o CAPASITS para consulta médica presencial.'),
    format('=================================================================~n').

opcion_periodo_ventana :-
    writeln('================================================================='),
    writeln('=== EVALUADOR DE PERIODO DE VENTANA BIOLÓGICA Y URGENCIA PEP ==='),
    writeln('================================================================='),
    writeln('¿Qué es el Periodo de Ventana Biológica?'),
    writeln('Es el tiempo que tarda el organismo en producir anticuerpos o antígenos'),
    writeln('detectables tras un contacto sexual. Si te realizas el estudio antes de'),
    writeln('este tiempo, corres el riesgo de obtener un FALSO NEGATIVO (salir negativa'),
    writeln('aunque sí exista la infección).'),
    writeln('-----------------------------------------------------------------'),
    writeln('Selecciona la prueba o estudio médico que deseas consultar:'),
    seleccionar_prueba(Prueba),
    nl,
    writeln('¿Cuántos días han transcurrido desde el contacto sexual o exposición de riesgo?'),
    write('Escribe el número de días transcurridos (ej. 5, 21, 45, 90): '),
    flush_output,
    read_line_to_string(user_input, Entrada),
    (   catch(number_string(Dias, Entrada), _, fail), Dias >= 0
    ->  evaluar_periodo_ventana(Prueba, Dias, Estado, Indicacion),
        format('~n=================================================================~n'),
        format('EVALUACIÓN CLÍNICA DE LA VENTANA BIOLÓGICA:~n'),
        format('  Prueba consultada: ~w~n', [Prueba]),
        format('  Días transcurridos: ~d~n', [Dias]),
        format('  Estado biológico: ~w~n', [Estado]),
        format('  Dictamen clínico: ~w~n', [Indicacion]),
        format('=================================================================~n')
    ;   writeln('Entrada de días no válida. Debe ser un número mayor o igual a 0.')
    ).

opcion_multicriterio :-
    writeln('=== RECOMENDADOR MULTICRITERIO DE SEDES CON PUNTAJE ==='),
    seleccionar_municipio(Mun),
    seleccionar_prueba(Prueba),
    seleccionar_dia(Dia),
    writeln('¿Preferencia de modalidad de acceso? 1. Sin cita previa  2. Con cita/turno  3. Cualquiera'),
    leer_entero_valido('Opcion (1-3):', 1, 3, OpAcc),
    nth1(OpAcc, [sin_cita, cita_o_turno, cualquiera], PrefAcceso),
    writeln('¿Exiges atencion 100% gratuita? 1. Si  2. No me importa pagar cuota de recuperacion'),
    leer_entero_valido('Opcion (1-2):', 1, 2, OpGrat),
    nth1(OpGrat, [si, no], ExigeGrat),
    Perfil = perfil_consulta(Mun, Prueba, Dia, PrefAcceso, ExigeGrat),
    mejor_recomendacion_sede(Perfil, Ranking),
    format('~nRanking de sedes ordenadas por idoneidad para ~w:~n', [Mun]),
    (   Ranking == []
    ->  writeln('No hay sedes documentadas para esa prueba en la region.')
    ;   forall(member(datos_recomendacion(IdS, Pts, Motivos), Ranking),
               ( sede(IdS, Nom, MunS, _),
                 contacto_directo(IdS, Tel),
                 format('  [Score: ~d pts] ~w (~w) | Tel: ~w~n', [Pts, Nom, MunS, Tel]),
                 format('    Factores: ~w~n', [Motivos])
               ))
    ).

opcion_ruta_multiprueba :-
    writeln('=== RUTA INTEGRAL MULTI-PRUEBA Y DERIVACIÓN ==='),
    seleccionar_municipio(Mun),
    writeln('Ejemplo: tamizaje integral [vih, sifilis, hepatitis_c, gonorrea].'),
    Lista = [vih, sifilis, hepatitis_c, gonorrea],
    ruta_atencion_completa(Mun, Lista, TipoRuta, Solucion),
    format('~nTipo de ruta: ~w~n', [TipoRuta]),
    (   Solucion = sede_completa(Id, M, Pruebas)
    ->  sede(Id, Nom, _, Dir),
        contacto_directo(Id, Tel),
        format('Atencion completa en una sola sede: ~w (~w)~n  Direccion: ~w | Tel: ~w~n  Pruebas cubiertas: ~w~n',
               [Nom, M, Dir, Tel, Pruebas])
    ;   Solucion = enlace(primaria(IdP, _, PruebasP), derivacion(IdR, RegR, Faltantes))
    ->  sede(IdP, NomP, _, _), sede(IdR, NomR, MunR, _),
        format('1. Unidad local: ~w cubre ~w~n', [NomP, PruebasP]),
        format('2. Derivacion regional: ~w en ~w (Region ~w) para cubrir ~w~n',
               [NomR, MunR, RegR, Faltantes])
    ).

opcion_diagnostico_regional :-
    writeln('=== DIAGNÓSTICO DE COBERTURA SANITARIA POR REGIÓN ==='),
    forall(region(RegClave, RegNom),
           ( diagnostico_regional(RegClave, stats(_, total_sedes(TS), deteccion_vih(TVIH), deteccion_sifilis(TSif), deteccion_hepatitis_c(THepC), urgencias_pep(TPEP), apertura_sabado(TSab), acceso_sin_cita(TSinCita))),
             format('~n[Region ~w - ~w]~n', [RegClave, RegNom]),
             format('  Sedes totales: ~d | Deteccion VIH: ~d | Sifilis: ~d | Hepatitis C: ~d~n', [TS, TVIH, TSif, THepC]),
             format('  Urgencias PEP: ~d | Abren en sabado: ~d | Acceso sin cita: ~d~n', [TPEP, TSab, TSinCita])
           )).

opcion_fin_de_semana :-
    writeln('=== SEDES CON ATENCIÓN PUBLICADA EN FIN DE SEMANA ==='),
    findall(Id-Mun-Dia-Ini-Fin, atencion_fin_de_semana(Id, Mun, Dia, Ini, Fin), SedesFinSemana),
    forall(member(Id-Mun-Dia-Ini-Fin, SedesFinSemana),
           ( sede(Id, Nom, _, Dir),
             contacto_directo(Id, Tel),
             format('  * ~w (~w) | ~w: ~w a ~w | Tel: ~w | Dir: ~w~n',
                    [Nom, Mun, Dia, Ini, Fin, Tel, Dir])
           )).

opcion_lenguaje_natural :-
    writeln('=== BÚSQUEDA MEDIANTE LENGUAJE NATURAL ==='),
    writeln('Ejemplos:'),
    writeln('  - "Quiero prueba rapida de sifilis en Huajuapan el sabado"'),
    writeln('  - "Donde hacerme prueba de vih en Oaxaca los martes"'),
    writeln('  - "Necesito deteccion de hepatitis en Puerto Escondido el viernes"'),
    write('Escribe tu consulta: '),
    flush_output,
    read_line_to_string(user_input, Frase),
    (   Frase == end_of_file -> true
    ;   interpretar_consulta_natural(Frase, consulta(Mun, Prueba, Dia)),
        format('~nInterpretacion logica: Municipio = ~w | Prueba = ~w | Dia = ~w~n',
               [Mun, Prueba, Dia]),
        mostrar_busqueda_triple(Mun, Prueba, Dia)
    ).

opcion_ficha_sede :-
    writeln('=== CONSULTA DE FICHA DETALLADA DE SEDE ==='),
    findall(Id, sede(Id, _, _, _), Sedes),
    length(Sedes, Total),
    writeln('Sedes destacadas: 1. Huajuapan  2. Tlalixtac  3. IMEDI  4. CAPASITS'),
    writeln('5. CESSA Reforma  6. Hospital Civil  7. CESSA Xoxocotlan  8. Hospital Tuxtepec...'),
    format(atom(Prompt), 'Elige numero de sede (1-~d):', [Total]),
    leer_entero_valido(Prompt, 1, Total, Idx),
    nth1(Idx, Sedes, SedeElegida),
    mostrar_horarios_sede(SedeElegida).

demostracion_automatica :-
    writeln('================================================================='),
    writeln('   DEMOSTRACIÓN INTEGRAL AUTOMÁTICA DEL SISTEMA EXPERTO'),
    writeln('================================================================='),
    contar_tablas,
    nl,
    writeln('--- CASO 1: Consulta en Huajuapan para Sifilis en Sabado (3 niveles) ---'),
    mostrar_busqueda_triple(huajuapan, sifilis, sabado),
    nl,
    writeln('--- CASO 2: Evaluacion sindromica de ulcera genital indolora ---'),
    diagnostico_sindromico(ulcera_genital_indolora, Sind1, ITS1, Urg1, Acc1),
    format('Sindrome: ~w | ITS: ~w | Urgencia: ~w~nProtocolo: ~w~n', [Sind1, ITS1, Urg1, Acc1]),
    nl,
    writeln('--- CASO 3: Analisis de periodo de ventana para VIH a los 10 dias ---'),
    evaluar_periodo_ventana(vih, 10, Est1, Rec1),
    format('Estado: ~w~nDictamen: ~w~n', [Est1, Rec1]),
    nl,
    writeln('--- CASO 4: Evaluacion de urgencia PEP a las 36 horas (1.5 dias) ---'),
    evaluar_periodo_ventana(pep_profilaxis_post_exposicion, 1.5, EstPEP, RecPEP),
    format('Estado: ~w~nDictamen: ~w~n', [EstPEP, RecPEP]),
    nl,
    writeln('--- CASO 5: Ranking multicriterio de idoneidad en Oaxaca de Juarez ---'),
    mejor_recomendacion_sede(perfil_consulta(oaxaca_de_juarez, vih, martes, sin_cita, si), RankingOax),
    RankingOax = [datos_recomendacion(TopSede, Pts, _)|_],
    format('Mejor opcion recomendada: ~w con ~d puntos~n', [TopSede, Pts]),
    nl,
    writeln('--- CASO 6: Interpretacion de frase en lenguaje natural ---'),
    interpretar_consulta_natural("Necesito prueba rapida de vih en Puerto Escondido el sabado", C1),
    format('Frase interpretada como: ~w~n', [C1]),
    writeln('================================================================='),
    writeln('Demostracion automatica completada con exito.').
