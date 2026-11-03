# Vocación-Expert: Sistema Experto de Orientación Vocacional y Admisión Universitaria en Oaxaca

**Caso de Estudio 3 — Programación Lógica y Funcional (Proyecto Final)**

- **Autores:** Miguel Ángel Hernández Pérez y Yareli.
- **Materia:** Programación Lógica y Funcional.
- **Entorno:** SWI-Prolog 9.x (Windows).
- **Archivos principales:**
  - [`vocacion_expert.pl`](file:///c:/Users/pache/OneDrive/Escritorio/ActividadSpring/Biblioteca_PLF/caso-estudio-3/vocacion_expert.pl): Base de conocimientos, motor de inferencia, analizador léxico y menú interactivo.
  - [`pruebas_vocacion_expert.pl`](file:///c:/Users/pache/OneDrive/Escritorio/ActividadSpring/Biblioteca_PLF/caso-estudio-3/pruebas_vocacion_expert.pl): Suite de 25 pruebas unitarias con `plunit`.

---

## 1. Problema, Enfoque y Utilidad Social

La elección de una carrera universitaria y de la institución adecuada es una de las decisiones socioeconómicas y personales más trascendentales para los jóvenes estudiantes en el estado de Oaxaca y en México. Con frecuencia, los aspirantes enfrentan:
1. **Desorientación vocacional y deserción temprana:** desconocimiento de sus verdaderas aptitudes frente a los perfiles profesionales requeridos.
2. **Incertidumbre en la admisión:** falta de información sobre los puntajes históricos de corte del examen EXANI-II (CENEVAL) y promedios mínimos requeridos por facultad.
3. **Barreras financieras y foraneidad:** gastos no previstos de renta, alimentación y transporte según el municipio sede (Valles Centrales, Istmo, Costa, Mixteca, Papaloapan, Sierra).
4. **Desconocimiento de becas:** programas de apoyo federales, estatales o institucionales a los que tienen derecho por promedio o situación socioeconómica.

**Vocación-Expert** es un sistema experto desarrollado en Prolog que modela el proceso de orientación vocacional y toma de decisiones mediante reglas lógicas declarativas, algoritmos psicométricos reconocidos y análisis multicriterio explicable.

---

## 2. Base de Conocimientos: 10 Tablas Principales ($\ge 50$ Hechos por Tabla)

Siguiendo la arquitectura completa y rigurosa vista en `hw_expert.pl` (Caso de Estudio 2), el sistema cuenta con **10 tablas fundamentales**, todas superando el umbral de 50 registros:

| No. | Tabla / Predicado | Aridad | Descripción y Atributos | Registros |
|:---:|---|:---:|---|:---:|
| 1 | `carrera/5` | 5 | `carrera(IdCarrera, Nombre, AreaConocimiento, Semestres, Exigencia)` | **55** |
| 2 | `institucion/5` | 5 | `institucion(IdInstitucion, Nombre, Municipio, TipoRegimen, Prestigio)` (47 Públicas + 20 Privadas) | **67** |
| 3 | `municipio_sede/4` | 4 | `municipio_sede(IdMunicipio, NombreOficial, Region, CostoVidaMesMXN)` | **52** |
| 4 | `oferta_academica/4` | 4 | `oferta_academica(IdInstitucion, IdCarrera, Modalidad, Turno)` | **178** |
| 5 | `perfil_holland/7` | 7 | `perfil_holland(IdCarrera, Realista, Investigador, Artistico, Social, Emprendedor, Convencional)` | **55** |
| 6 | `mercado_laboral/5` | 5 | `mercado_laboral(IdCarrera, SueldoPromedioMXN, EmpleabilidadPct, Demanda, Sector)` | **55** |
| 7 | `requisito_admision/5` | 5 | `requisito_admision(IdInstitucion, IdCarrera, PromedioMinimo, TipoExamen, CorteExani)` | **178** |
| 8 | `programa_beca/5` | 5 | `programa_beca(IdBeca, NombreBeca, TipoBeca, PromedioMinimo, MontoMensualMXN)` | **50** |
| 9 | `costo_carrera/5` | 5 | `costo_carrera(IdInstitucion, IdCarrera, CuotaSemestral, CostoMaterialesMes, TipoCuota)` | **178** |
| 10 | `materia_critica/5` | 5 | `materia_critica(IdMateria, IdCarrera, NombreMateria, Semestre, AreaDificultad)` | **55** |
| **TOTAL** | | | **Gran total de hechos en las 10 tablas principales** | **923 hechos** |

---

## 3. Reglas Complejas e Inferencias Lógicas

1. **Motor de Afinidad Vocacional Psicométrica (Modelo Holland RIASEC) con Diagnóstico Pedagógico:**
   - Evalúa el vector de aptitudes del estudiante $[R, I, A, S, E, C]$ (escala 1 a 10) contra el perfil calibrado de cada una de las 55 profesiones.
   - Aplica distancia euclidiana multidimensional normalizada para calcular un porcentaje de compatibilidad vocacional exacto (0% a 100%).
   - **Diagnóstico Profundo de Personalidad:** Identifica automáticamente el **Área Dominante Principal** (máximo puntaje) y el **Área Secundaria de Apoyo**, explicando en lenguaje natural su significado psicológico y su combinación sintetizada (Código Holland, ej. `[I-C]`, `[S-I]`, `[E-C]`).
   - **Justificación Vocacional Individualizada:** Para cada una de las carreras del Top 5 de afinidad, explica claramente **por qué se le recomienda**, vinculando las destrezas de las áreas dominantes del aspirante con las exigencias cognitivas, técnicas y humanas de esa profesión.
2. **Simulador Probabilístico de Admisión Universitaria Multimodelo:**
   - Reconoce la diversidad real de pruebas de admisión aplicadas en Oaxaca según el subsistema:
     - **TecNM (Institutos Tecnológicos - ITO, Tuxtepec, Salina Cruz, etc.):** Evalúa mediante la plataforma oficial **EVALUATEC** (escala de 0 a 100 puntos / porcentaje de aciertos).
     - **SUNEO (UTM, UMAR, UNPA, UNSIS, UNISTMO, etc.):** Aplica su propio **Examen Institucional de Selección SUNEO** (escala 0 a 100 puntos), cuyo puntaje define el pase a Curso Propedéutico Corto (4 semanas) o Largo (8 semanas) obligatorio.
     - **UABJO y Escuelas Normales (CRENO, UPN):** Aplican el **Examen General de Admisión bajo reactivos CENEVAL EXANI-II** (escala nacional estandarizada de 700 a 1300 puntos, con 1000 como media nacional).
     - **Universidades Privadas (Anáhuac, La Salle, URSE):** Aplican la **Prueba de Aptitud Académica (PAA)** o **Examen Diagnóstico Interno y Entrevista Vocacional** (escala 0 a 100 puntos), donde el resultado condiciona el porcentaje de beca académica (30% al 80%).
   - Cruza el promedio de bachillerato y el puntaje obtenido/simulado con los cortes históricos oficiales y emite dictámenes categóricos contextualizados: `alta_probabilidad_de_admision`, `en_rango_competitivo`, `admision_en_riesgo`, `admision_confirmada_con_opcion_a_beca` o `no_cumple_requisito_academico`.
3. **Analizador de Proximidad Territorial (Sedes Cercanas vs. Foráneas):**
   - Cruza el municipio de residencia del estudiante (ej. *Santa Cruz Xoxocotlán*, *Oaxaca de Juárez*, *Tuxtepec*, etc.) con la oferta académica en todo el estado.
   - Clasifica las sedes automáticamente en 3 niveles de proximidad:
     - **Locales / Zona Conurbada:** Traslado diario en transporte urbano, vive en su hogar sin pagar renta (ej. desde Xoxo: UABJO, ITO, URSE, Anáhuac en San Raymundo Jalpan, La Salle).
     - **Regionales Cercanas:** En la misma región geográfica; traslado intermunicipal accesible.
     - **Foráneas en otras regiones:** Requieren forzosamente mudanza y cambio de residencia (ej. UTM en la Mixteca, UMAR en la Costa, UNPA en Papaloapan, ITSC en el Istmo); cuantifica el impacto económico de renta y manutención mensual en ese municipio foráneo.
4. **Observatorio Financiero Universitario y Comparador de Costos:**
   - Proporciona un análisis financiero macro y microeducativo enfocado y claro en 2 dimensiones:
     - **Panorama de Colegiaturas por Régimen:** Comparativa transparente entre Privadas Élite ($35k-$65k/semestre), Privadas Intermedias ($12k-$22k), Públicas Estatales SUNEO ($1.2k-$2.2k), Tecnológicos TecNM ($1.8k-$2.8k) y UABJO ($1k-$3.5k).
     - **Ranking de Carreras por Insumos y Materiales:** Identifica las carreras con mayor costo de instrumental mensual (Odontología ~$3,200/mes, Medicina ~$2,800/mes, Gastronomía ~$2,500/mes, Arquitectura ~$2,200/mes) frente a las de gasto mínimo en materiales (Derecho, Filosofía, Matemáticas, Administración ~$300-$500/mes).
5. **Verificador de Elegibilidad de Becas:**
   - Cruza el promedio del alumno y el tipo de régimen (universidad pública vs. privada) para filtrar los programas de becas y montos aplicables de entre los 50 disponibles.
6. **Diagnóstico de Materias Críticas y Filtro Académico:**
   - Identifica las asignaturas con mayor tasa de reprobación y complejidad conceptual (ej. Cálculo Multivariable, Anatomía Humana, Derecho Procesal Penal, Termodinámica).
7. **Analizador Léxico en Lenguaje Natural:**
   - Procesa oraciones libres en español (ej. *"quisiera estudiar ingenieria en sistemas en Huajuapan"*), realizando normalización fonética (eliminación de tildes y mayúsculas) y extracción de entidades léxicas mediante alias.
8. **Red de Afinidad Disciplinar y Carreras Relacionadas (Opción 1):**
   - Agrupa las 55 profesiones en 12 clusters temáticos de especialización.
   - En la consulta de oferta académica, no se limita a la carrera exacta:
     - **Fase A:** Sedes universitarias que imparten directamente la carrera seleccionada.
     - **Fase B:** Recomendación de carreras afines/hermanas dentro del mismo cluster o área de conocimiento, junto con las universidades públicas y privadas que las ofertan y sus costos semestrales.
   - Permite tanto selección por catálogo numerado (1 a 55) como búsqueda inteligente por palabra clave (ej. *"software"*, *"salud"*, *"medicina"*, *"derecho"*, *"química"*).

---

## 4. Menú Interactivo (Opciones 0 al 9)

```text
=================================================================
   SISTEMA EXPERTO VOCACIONAL Y DE ADMISIÓN UNIVERSITARIA        
   Caso de Estudio 3 — Programación Lógica y Funcional           
=================================================================
 1. Explorar Oferta Académica (Filtro por Públicas, Privadas o Todas)
 2. Test Vocacional Automatizado (Modelo Psicométrico Holland RIASEC)
 3. Simulador de Admisión Universitaria (EVALUATEC, SUNEO, EXANI-II, PAA)
 4. Analizador de Proximidad Territorial: Escuelas Cercanas vs Foráneas (Mudanza)
 5. Observatorio Financiero Universitario: Costos y Comparativa por Régimen
 6. Buscador Inteligente de Becas y Apoyos Estudiantiles Elegibles
 7. Análisis de Materias Críticas y Filtro de Retención Académica
 8. Búsqueda Inteligente mediante Frase en Lenguaje Natural
 9. Ficha Técnica Profesional, Salarios de Egresados y Empleabilidad
 0. Salir del Sistema
-----------------------------------------------------------------
```

> **Nota:** Las predicados de auditoría interna (`contar_tablas_vocacion/0` y `demostracion_vocacion/0`) continúan existiendo en el código fuente para verificación y pruebas técnicas en consola Prolog (`?- contar_tablas_vocacion.`), pero fueron removidos del menú del estudiante para que la experiencia sea más limpia y enfocada al aspirante.

---

## 5. Ejecución y Pruebas Unitarias

### Cargar el Menú en SWI-Prolog:
```prolog
?- consult(['c:/Users/pache/OneDrive/Escritorio/ActividadSpring/Biblioteca_PLF/caso-estudio-3/vocacion_expert.pl']).
?- menu.
```

### Ejecutar las 33 Pruebas Unitarias Automatizadas:
```prolog
?- consult(['c:/Users/pache/OneDrive/Escritorio/ActividadSpring/Biblioteca_PLF/caso-estudio-3/pruebas_vocacion_expert.pl']).
?- run_tests.
```
*(Resultado: 33 pruebas exitosas al 100%, 0 errores, 0 advertencias).*

---

## 6. Fuentes y Referencias Académicas Oficiales

1. **John L. Holland — Teoría de Elección Vocacional y Tipología de Personalidades (RIASEC):**
   - Fundamento psicométrico que categoriza los intereses profesionales en seis dimensiones canónicas: Realista, Investigador, Artístico, Social, Emprendedor y Convencional.
   - [American Psychological Association (APA) - Holland's Theory](https://www.apa.org/)
2. **CENEVAL (Centro Nacional de Evaluación para la Educación Superior):**
   - Estándares del **Examen Nacional de Ingreso a la Educación Superior (EXANI-II)**: escala estándar de 700 a 1300 puntos y módulos de diagnóstico de áreas de conocimiento.
   - [CENEVAL - Guía EXANI-II](https://ceneval.edu.mx/)
3. **Instituto Mexicano para la Competitividad (IMCO) / Observatorio Laboral de México:**
   - Estadísticas salariales de egresados, tasas de colocación profesional formal y demanda proyectada por sector productivo.
   - [IMCO - Compara Carreras](https://imco.org.mx/comparacarreras/)
4. **Coordinación General de Educación Media Superior y Superior de Oaxaca (CGEMSySCyT):**
   - Catálogo oficial de Universidades Tecnológicas, Institutos Tecnológicos del TecNM, Universidades del Sistema SUNEO (UTM, UMAR, UNISTMO, UNPA, UNSIJ, UNSIS, UNCOS) y la Universidad Autónoma "Benito Juárez" de Oaxaca (UABJO).
   - [Gobierno del Estado de Oaxaca - Educación Superior](https://www.oaxaca.gob.mx/)

