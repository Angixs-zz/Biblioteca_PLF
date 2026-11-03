# Sistema Experto: Orientador Epidemiológico y Detección de ITS en Oaxaca

**Caso de Estudio 3 — Programación Lógica y Funcional (Proyecto Final)**

- **Autores:** Miguel Ángel Hernández Pérez y Yareli.
- **Materia:** Programación Lógica y Funcional.
- **Lenguaje:** SWI-Prolog 9.x.

---

## 1. Problema, Enfoque y Utilidad Social

La prevención, detección oportuna y tratamiento integral de las **Infecciones de Transmisión Sexual (ITS: VIH, Sífilis, Hepatitis C, Hepatitis B, VPH, Gonorrea, Clamidia, etc.)** constituyen un desafío prioritario de salud pública en el estado de Oaxaca. Muchas personas se enfrentan a dudas diagnósticas ante la aparición de lesiones o secreciones, desconocen los **periodos de ventana biológica** (arriesgándose a falsos negativos tempranos), ignoran la urgencia crítica de la **Profilaxis Post-Exposición (PEP dentro de las primeras 72 horas)** o no saben qué clínicas de los Servicios de Salud de Oaxaca (SSO) y COESIDA atienden de forma gratuita y sin cita previa.

Este sistema experto proporciona un orientador clínico, epidemiológico y geográfico automatizado que:
1. Implementa el **Modelo de Manejo Sindrómico de las ITS** (avalado por la OPS/OMS y CENSIDA) para orientar al usuario según sus síntomas declarados (úlceras, descargas, dolor, verrugas, etc.).
2. Evalúa los **días transcurridos** frente a la ventana inmunológica para certificar si el resultado de una prueba rápida o serológica será clínicamente concluyente o si existe riesgo de falso negativo.
3. Alerta y canaliza casos de urgencia médica en menos de 72 horas para **PEP antirretroviral**.
4. Dispone de un **ranking multicriterio de idoneidad** (0-100 puntos) que pondera cercanía municipal, horarios publicados, gratuidad total y consejería especializada.
5. Permite realizar consultas mediante un **analizador léxico de lenguaje natural**.

---

## 2. Base de Conocimientos: 10 Tablas Principales (≥ 50 registros por tabla)

Siguiendo la arquitectura completa vista en `hw_expert.pl` (Caso de Estudio 2), la base cuenta con **10 tablas principales**, cada una con al menos 50 hechos:

| No. | Tabla / Predicado | Aridad | Descripción y Campos | Registros |
|:---:|---|:---:|---|:---:|
| 1 | `sede/4` | 4 | `sede(IdSede, Nombre, Municipio, Dirección)` | **55** |
| 2 | `municipio/2` | 2 | `municipio(IdMunicipio, NombreOficial)` | **52** |
| 3 | `region_municipio/2` | 2 | `region_municipio(IdMunicipio, Región)` | **52** |
| 4 | `deteccion_its/2` | 2 | `deteccion_its(IdSede, ClavePrueba)` (VIH, Sífilis, VHC, VHB, Gonorrea, VPH, PEP) | **190** |
| 5 | `horario_semanal/4` | 4 | `horario_semanal(IdSede, Día, HoraInicio, HoraFin)` | **145** |
| 6 | `contacto_directo/2` | 2 | `contacto_directo(IdSede, TeléfonoOExtensión)` | **55** |
| 7 | `fuente_oficial/2` | 2 | `fuente_oficial(IdSede, URLDocumental)` | **55** |
| 8 | `protocolo_sede/5` | 5 | `protocolo_sede(IdSede, TipoUnidad, Acceso, Gratuidad, Consejería)` | **55** |
| 9 | `guia_clinica_its/5` | 5 | `guia_clinica_its(ClavePrueba, Categoría, Método, PeriodoVentanaDías, TiempoMinutos)` | **50** |
| 10 | `sintoma_sindromico_its/5` | 5 | `sintoma_sindromico_its(Síntoma, Síndrome, ITSProbable, Urgencia, AcciónRecomendada)` | **50** |
| **TOTAL** | | | **Hechos totales en las 10 tablas principales** | **709** |

*Catálogos de clasificación:* `dia/1`, `nombre_dia/2`, `region/2`, `alias_palabra/3`.

---

## 3. Reglas Complejas e Inferencias Clínicas

1. **Búsqueda Geográfico-Temporal en 3 Niveles (`mostrar_busqueda_triple/3`):**
   - Nivel 1: Sedes en el municipio con horario publicado confirmado para ese día.
   - Nivel 2: Sedes en el municipio que tienen la prueba pero con horario por confirmar (muestra los otros días publicados).
   - Nivel 3: Alternativas en municipios vecinos de la misma región con horario publicado ese día.
2. **Motor de Diagnóstico Sindrómico (`diagnostico_sindromico/5` y `requiere_atencion_urgente/1`):**
   Clasifica el motivo de consulta según los 7 síndromes canónicos de la OMS (úlcera genital, descarga uretral, flujo vaginal, dolor pélvico, verrugas anogenitales, manifestaciones secundarias, exposición aguda) e indica la ITS más probable y su nivel de urgencia.
3. **Evaluación de Periodo de Ventana y Urgencia PEP (`evaluar_periodo_ventana/4`):**
   Compara los días transcurridos desde el coito de riesgo contra el tiempo biológico de seroconversión de la prueba. Si han pasado < 72h emite alerta de PEP; si está en ventana alerta sobre falso negativo; si superó la ventana valida el resultado como concluyente.
4. **Ranking Multicriterio de Idoneidad (`mejor_recomendacion_sede/2`):**
   Calcula un puntaje ponderado (0 a 100 puntos) con lista de motivos: proximidad territorial (40/20 pts), horario publicado ese día (30 pts), acceso sin cita previa (15 pts), gratuidad total (10 pts) y consejería integral (5 pts).
5. **Cálculo de Jornadas y Disponibilidad en Hora Exacta (`duracion_atencion_horas/4` y `abierto_en_hora_exacta/4`):**
   Calcula la duración en horas del servicio y verifica si la unidad está abierta a una hora específica (`HH:MM`).
6. **Ruta Multi-Prueba y Derivación Regional (`ruta_atencion_completa/4`):**
   Para baterías completas (ej. `[vih, sifilis, hepatitis_c, gonorrea]`); si la unidad local no dispone de todas, genera la coordinación con la sede de referencia regional.
7. **Diagnóstico Epidemiológico Regional (`diagnostico_regional/2`):**
   Genera métricas de cobertura por región (sedes totales, pruebas de VIH, sífilis, hepatitis C, PEP, atención en sábado y acceso sin cita).
8. **Analizador Léxico en Lenguaje Natural (`interpretar_consulta_natural/2`):**
   Interpreta consultas libres como *"Quiero prueba rapida de sifilis en Huajuapan el sabado"* mediante tokenización y normalización de acentos.

---

## 4. Ejecución del Programa

Requiere **SWI-Prolog** (9.x o superior):

```bash
cd caso-estudio-3
swipl -s orientador_its.pl -g menu -t halt
```

### Menú Interactivo (Opciones 0 a 11)

```text
=================================================================
   SISTEMA EXPERTO DE DETECCIÓN DE ITS Y SALUD SEXUAL EN OAXACA
   Programación Lógica y Funcional - Caso de Estudio 3
=================================================================
 1. Buscar detección por Municipio, Tipo de Prueba y Día
 2. Evaluador Sindrómico de Síntomas (Modelo OPS/OMS y CENSIDA)
 3. Calculador de Periodo de Ventana y Urgencia PEP (hasta 72 hrs)
 4. Recomendador Multicriterio de Sedes con Puntaje de Idoneidad
 5. Ruta de Atención Multi-Prueba y Derivación Regional Coordinada
 6. Ver Sedes por Región y Diagnóstico de Cobertura Sanitaria
 7. Ver Sedes con Horario Publicado en Fin de Semana (Sábado)
 8. Búsqueda Inteligente mediante Frase en Lenguaje Natural
 9. Ver Ficha Técnica Detallada, Duración de Turnos y Requisitos
10. Estadísticas de la Base de Conocimientos (las 10 Tablas)
11. Ejecutar Demostración Automática de Todas las Reglas
 0. Salir
-----------------------------------------------------------------
```

---

## 5. Pruebas Automatizadas (plunit)

Para verificar la integridad de las 10 tablas y las reglas del sistema:

```bash
swipl -q -s pruebas_orientador_its.pl -g run_tests -t halt
```

La suite cubre:
- Conteo de **≥ 50 registros** en cada una de las 10 tablas.
- Integridad referencial entre sedes, municipios, pruebas, síntomas y guías clínicas.
- Casos históricos de compatibilidad (Huajuapan en sábado, IMEDI por confirmar, Tlalixtac).
- Evaluación sindrómica, cálculo de periodos de ventana y alerta de urgencia PEP.
- Duración de jornada, ranking multicriterio y analizador léxico.

---

## 6. Fuentes Oficiales, Normativas y Referencias Clínicas

El diseño de la base de conocimientos, la clasificación de los 50 síntomas, los periodos de ventana y los protocolos de derivación se fundamentan en las siguientes directrices oficiales y normativas de salud pública:

1. **Organización Panamericana de la Salud (OPS) y Organización Mundial de la Salud (OMS):**
   - *Directrices para el Tratamiento y Manejo Sindrómico de las Infecciones de Transmisión Sexual (ITS):* Clasificación clínica en síndromes clave (úlcera genital, descarga uretral, flujo vaginal, dolor abdominal bajo, etc.) para tratamiento inmediato sin esperar pruebas invasivas de laboratorio en atención primaria.
   - [OPS - Infecciones de Transmisión Sexual](https://www.paho.org/es/temas/infecciones-transmision-sexual)
   - [OMS - Directrices clínicas para el manejo sindrómico de ITS](https://iris.who.int/handle/10665/341991)
   - [OMS - Datos y cifras de ITS](https://www.who.int/es/news-room/fact-sheets/detail/sexually-transmitted-infections-(stis))

2. **Secretaría de Salud de México — Centro Nacional para la Prevención y el Control del VIH y el sida (CENSIDA):**
   - *Norma Oficial Mexicana NOM-039-SSA2-2014, Para la prevención y control de las infecciones de transmisión sexual:* Marco legal que rige el diagnóstico, tamizaje y tratamiento de ITS en todo México.
     - [Diario Oficial de la Federación (DOF) - NOM-039-SSA2-2014](https://www.dof.gob.mx/nota_detalle.php?codigo=5391307&fecha=06/05/2015)
   - *Guía Nacional para la Profilaxis Previa a la Exposición (PrEP) y Post-Exposición (PEP) al VIH en México:* Establece el protocolo estricto de las **primeras 72 horas** posteriores a una relación de riesgo no protegida o rotura de condón.
     - [CENSIDA - Protocolo de Profilaxis Post-Exposición (PEP)](https://www.gob.mx/salud/censida/acciones-y-programas/profilaxis-pre-y-post-exposicion)

3. **Consejo Estatal para la Prevención y Control del Sida (COESIDA) y Servicios de Salud de Oaxaca (SSO):**
   - Red estatal de unidades médicas y CAPASITS (San Bartolo Coyotepec, Salina Cruz, Pinotepa Nacional, CESSAs y centros de salud de las 8 regiones de Oaxaca).
   - [Portal Oficial de COESIDA Oaxaca](https://coesida.oaxaca.gob.mx/)
   - [Directorio de Unidades Médicas - Servicios de Salud de Oaxaca](https://www.oaxaca.gob.mx/salud/)

4. **CDC (Centers for Disease Control and Prevention) — STI Treatment Guidelines:**
   - Referencia médica internacional para periodos de ventana inmunológica, seroconversión de pruebas de 4ta generación y diferenciación etiológica.
   - [CDC STI Treatment Guidelines](https://www.cdc.gov/std/treatment-guidelines/default.htm)
