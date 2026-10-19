# Sistema experto de recomendación de libros

Implementación del caso práctico en SWI-Prolog. El modelo tiene **seis tablas principales** y **cuatro catálogos de clasificación**. Los seis conjuntos principales tienen al menos 50 registros cada uno; los catálogos solo tienen las categorías existentes, según la aclaración del profesor.

| Tabla / predicado | Clave y campos | Registros |
| --- | --- | ---: |
| Estudiante `estudiante/2` | ID, nombre | 50 |
| Preferencia `preferencia/6` | ID de preferencia, ID de estudiante, tema, género, nivel, formato | 50 |
| Libro `libro/7` | ID, título, género, nivel, tema, formato, editorial | 132 |
| Autor `autor/2` | ID, nombre | 127 |
| LibroAutor `libro_autor/2` | ID de libro, ID de autor (clave compuesta) | 143 |
| Recomendación `recomendacion_guardada/3` | ID, ID de preferencia, ID de libro | 50 |
| Nivel `nivel/2` | Clave, nombre | 3 |
| Género `genero/2` | Clave, nombre | 7 |
| Tema `tema/2` | Clave, nombre | 18 |
| Formato `formato/2` | Clave, nombre | 2 |

```text
Estudiante 1 ─── N Preferencia 1 ─── N Recomendación N ─── 1 Libro
                                                         Libro 1 ─── N LibroAutor N ─── 1 Autor
Preferencia N ─── 1 Nivel/Género/Tema/Formato 1 ─── N Libro
```

Cada recomendación guardada refiere a una preferencia y un libro. `recomendar/4` calcula la coincidencia entre ellos; `detalle_recomendacion/5` recupera el estudiante y los motivos según las reglas actuales. Las 50 recomendaciones son una **muestra ilustrativa de historial**: son compatibles con género y tema, pero la primera opción del ranking actual puede ser distinta. Las consultas interactivas **no se guardan automáticamente**. Los estudiantes, sus preferencias y el historial son datos de ejemplo; el formato del libro no representa existencias reales de la biblioteca.

La tabla Estudiante es útil para conservar perfiles y consultar el historial de cada persona. **No hace falta ser estudiante registrado para pedir una recomendación**: la consulta rápida toma las respuestas del menú como variables y calcula el resultado sin guardarlas. **Los 132 libros tienen editorial y referencia a una edición en español** en [`fuentes_editoriales.md`](fuentes_editoriales.md). Por ejemplo, *Caperucita Roja* corresponde a una edición de la versión de Charles Perrault. Nombres como *Python*, *UML* o *Freakonomics* forman parte de títulos de ediciones españolas. El formato y el nivel asignados son clasificaciones didácticas, no atributos comprobados de un ejemplar real.

Nivel (`basico`, `intermedio`, `avanzado`), género, tema y formato tienen su propio catálogo. Libro y Preferencia guardan la **clave** de cada categoría; por ejemplo, el valor `basico` referencia el hecho `nivel(basico, 'Básico')`. Las reglas validan las categorías al recomendar. No se crean niveles artificiales para completar 50 filas.

## Ejecutar

Desde esta carpeta:

```sh
swipl -s biblioteca.pl -g iniciar -t halt
```

El mismo comando aparece en un comentario al principio de `biblioteca.pl`.

El menú ofrece **1)** consulta guiada sin registro, **2)** recomendaciones para un estudiante registrado, **3)** historial guardado, **4)** búsqueda mediante una frase y **0)** salir. Está dividido con separadores; la consulta guiada presenta los pasos **GÉNERO → TEMA → NIVEL → FORMATO** y las opciones en filas de tres para que se lean mejor. Muestra solo temas que tienen libros del género seleccionado y niveles y formatos disponibles para la combinación. Género, nivel y formato pueden omitirse con Enter; si solo hay una opción de nivel o formato, no se hace una pregunta innecesaria.

El nivel significa **dificultad de lectura**, también para novelas: `basico` puede ser una lectura introductoria, `intermedio` una que requiere más contexto y `avanzado` una más exigente. Las clasificaciones son orientativas para este ejercicio. Después de escoger `novela` se ofrecen solo sus temas disponibles, entre ellos `amor`, `historia`, `guerra`, `aventura`, `fantasia`, `misterio` y `ciencia_ficcion`; `matematicas` no aparece porque no hay novelas matemáticas clasificadas como tales en el catálogo actual. Al incorporar una, esa opción aparecería automáticamente.

### Resultados por etapas

Primero se muestran únicamente las **coincidencias exactas**, sin puntuación. Si hay alternativas, el programa pregunta:

```text
1. Mostrar coincidencias posibles
0. Salir de esta busqueda y volver al menu
```

Solo `1` muestra el segundo bloque, con la cercanía y los filtros que no se cumplen. `0`, `salir` o el fin de entrada lo omiten. Si no hay resultados exactos, se informa de ello y se ofrece la misma elección. Si todos los resultados son exactos, se vuelve al menú sin preguntar por alternativas inexistentes. Para terminar el programa, elige `0` en el menú principal. Esta presentación también se usa al consultar un estudiante registrado.

### Nuevas lecturas

Los géneros `cuento`, `poesia` y `teatro` incluyen obras sobre `naturaleza`, `aventura`, `fantasia`, `misterio`, `ciencia_ficcion` y `sociedad`. Se sumaron veinte títulos, entre ellos *Caperucita Roja*, *La Cenicienta*, *Hansel y Gretel*, *El patito feo*, *Alicia en el país de las maravillas*, *El Aleph*, *Bestiario*, *Las aventuras de Pinocho*, *Bodas de sangre* y *Antígona*. La búsqueda `cuento` + `fantasia` pasó de **1 a 10 libros** (7 básicos y 3 avanzados); `cuento` + `naturaleza` tiene **3** y `novela` + `fantasia`, **6** (3 básicos y 3 intermedios). Se pueden combinar con niveles opcionales: si alguno no coincide aparece, con explicación, solo al pedir las recomendaciones posibles.

La opción 4 usa un **analizador léxico sencillo**: normaliza mayúsculas, tildes y puntuación, separa la oración en palabras y busca términos conocidos. Por eso acepta distintas estructuras, por ejemplo:

```text
Quiero libros de guerra
Necesito libros que hablen sobre la guerra
Busco un manual avanzado de tecnología
Prefiero un ebook divulgativo de física
Necesito libros básicos digitales sobre conflictos bélicos
Busco novelas románticas de nivel intermedio
Quiero cuentos de fantasía
Busco poemas de amor
Quiero novelas de ciencia ficción
```

Puede extraer un tema obligatorio y, si aparecen, un género, nivel y formato. Reconoce las claves de los catálogos, plurales comunes y algunos sinónimos definidos en `alias_catalogo/3`: `principiante`, `medio`, `experto`, `ebook`, `electrónico`, `impreso`, `conflictos` y `bélicos`. Las palabras restantes se ignoran como conectores.

No es inteligencia artificial ni comprende el significado general de cualquier texto. La frase debe incluir **exactamente un tema conocido** y no debe contener valores contradictorios de una misma categoría. Por ejemplo, `quiero historia y guerra` se rechaza por tener dos temas. El vocabulario aceptado puede ampliarse de forma explícita agregando hechos a `alias_catalogo/3`.

Guerra tiene cuatro libros con ese tema principal y dos libros de historia marcados explícitamente como relacionados. El tema `amor` aparece en novelas, poesía y teatro, y también como secundario en un ensayo de psicología. No se recomienda automáticamente todo el catálogo de historia para una búsqueda de guerra. Hay diez libros con tema principal matemáticas.

## Consultas directas

```prolog
?- [biblioteca].
?- libro(IdLibro, Titulo, _, basico, matematicas, _, Editorial).
?- autores_libro(7, Autores).
?- libro_autor(IdLibro, IdAutor), autor(IdAutor, 'Stephen Hawking').
?- perfil_preferencia(1, Perfil).
?- recomendar(pref(matematicas, cualquiera, basico, cualquiera), IdLibro, Puntos, Motivos).
?- coincidencia_total(pref(matematicas, divulgacion, basico, cualquiera), IdLibro).
?- recomendaciones(pref(tecnologia, manual, intermedio, cualquiera), Resultados).
?- recomendaciones(pref(guerra, cualquiera, basico, cualquiera), Resultados).
?- analizar_frase("Necesito un manual avanzado de tecnología", Perfil).
?- temas_disponibles(novela, Temas).
?- niveles_disponibles(novela, guerra, Niveles).
?- formatos_disponibles(novela, guerra, basico, Formatos).
?- tema_de_libro(IdLibro, guerra, PuntosTema, MotivosTema).
?- recomendaciones_estudiante(1, Resultados).
?- detalle_recomendacion(1, IdEstudiante, IdLibro, Puntos, Motivos).
?- nivel(Clave, Nombre).
?- genero(Clave, Nombre).
?- tema(Clave, Nombre).
?- formato(Clave, Nombre).
?- aggregate_all(count, libro(_, _, _, _, _, _, _), Total).
?- aggregate_all(count, autor(_, _), Total).
?- aggregate_all(count, libro_autor(_, _), Total).
?- aggregate_all(count, estudiante(_, _), Total).
?- aggregate_all(count, preferencia(_, _, _, _, _, _), Total).
?- aggregate_all(count, recomendacion_guardada(_, _, _), Total).
```

El tema es obligatorio: debe ser el tema principal del libro o uno secundario documentado en `tema_de_libro/4`. **Tema y género elegido son requisitos estrictos**; si no existen libros con esa combinación, la búsqueda por frase lo explica y la consulta guiada no la ofrece. Nivel y formato son preferencias: los resultados se dividen en **Coincidencias exactas** (cumplen todos los filtros solicitados, sin mostrar puntuación) y **Posibles recomendaciones** (se muestran solo al aceptar; libros del mismo tema y género que no cumplen nivel o formato). El principal aporta 2 puntos y el secundario 1. Género o formato coincidente aporta 1 punto; nivel exactamente igual, 2. La regla `adecuacion_nivel/5` considera un libro **intermedio de divulgación** como alternativa para alguien que pidió **básico**: aporta 1 punto y explica la inferencia, pero no cuenta como coincidencia exacta.

## Verificación

```sh
swipl -q -s pruebas_biblioteca.pl -g run_tests -t halt
```

Las pruebas comprueban integridad del catálogo, referencias bibliográficas de todos los IDs, filtros contextuales, frases, coincidencias exactas y el diálogo de aceptación/rechazo de alternativas (incluido fin de entrada).
