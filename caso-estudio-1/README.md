# Sistema experto de recomendación de libros

Implementación del caso práctico en SWI-Prolog. El modelo tiene **seis tablas principales** y **cuatro catálogos de clasificación**. Los seis conjuntos principales tienen al menos 50 registros cada uno; los catálogos solo tienen las categorías existentes, según la aclaración del profesor.

| Tabla / predicado | Clave y campos | Registros |
| --- | --- | ---: |
| Estudiante `estudiante/2` | ID, nombre | 50 |
| Preferencia `preferencia/6` | ID de preferencia, ID de estudiante, tema, género, nivel, formato | 50 |
| Libro `libro/7` | ID, título, género, nivel, tema, formato, editorial | 100 |
| Autor `autor/2` | ID, nombre | 106 |
| LibroAutor `libro_autor/2` | ID de libro, ID de autor (clave compuesta) | 110 |
| Recomendación `recomendacion_guardada/3` | ID, ID de preferencia, ID de libro | 50 |
| Nivel `nivel/2` | Clave, nombre | 3 |
| Género `genero/2` | Clave, nombre | 4 |
| Tema `tema/2` | Clave, nombre | 12 |
| Formato `formato/2` | Clave, nombre | 2 |

```text
Estudiante 1 ─── N Preferencia 1 ─── N Recomendación N ─── 1 Libro
                                                         Libro 1 ─── N LibroAutor N ─── 1 Autor
Preferencia N ─── 1 Nivel/Género/Tema/Formato 1 ─── N Libro
```

Cada recomendación guardada refiere a una preferencia y un libro. `recomendar/4` calcula la coincidencia entre ellos; `detalle_recomendacion/5` recupera el estudiante y los motivos según las reglas actuales. Las 50 recomendaciones son una **muestra ilustrativa de historial**: son compatibles con género y tema, pero la primera opción del ranking actual puede ser distinta. Las consultas interactivas **no se guardan automáticamente**. Los estudiantes, sus preferencias y el historial son datos de ejemplo; el formato del libro no representa existencias reales de la biblioteca.

La tabla Estudiante es útil para conservar perfiles y consultar el historial de cada persona. **No hace falta ser estudiante registrado para pedir una recomendación**: la consulta rápida toma las respuestas del menú como variables y calcula el resultado sin guardarlas. **Los 100 libros tienen editorial y enlace a una edición concreta** en [`fuentes_editoriales.md`](fuentes_editoriales.md). Cuando no se encontró una edición española verificable se conservó el título original de la edición citada; por eso hay títulos en inglés y en español. Se corrigió la atribución de `El arte de mirar` a Susan Woodford. El formato y el nivel asignados son clasificaciones didácticas, no atributos comprobados de un ejemplar real.

Nivel (`basico`, `intermedio`, `avanzado`), género, tema y formato tienen su propio catálogo. Libro y Preferencia guardan la **clave** de cada categoría; por ejemplo, el valor `basico` referencia el hecho `nivel(basico, 'Básico')`. Las reglas validan las categorías al recomendar. No se crean niveles artificiales para completar 50 filas.

## Ejecutar

Desde esta carpeta:

```sh
swipl -s biblioteca.pl -g iniciar -t halt
```

El menú ofrece **1)** consulta guiada sin registro, **2)** recomendaciones para un estudiante registrado, **3)** historial guardado, **4)** búsqueda mediante una frase y **0)** salir. La consulta guiada pregunta primero el **género**, después **solo temas con libros de ese género**, luego los **niveles disponibles** en esa combinación y finalmente los **formatos presentes** para el nivel elegido. Género, nivel y formato pueden omitirse con Enter; si solo hay una opción de nivel o formato, no se hace una pregunta innecesaria. Puedes responder `matematicas` o una frase que contenga esa palabra al preguntar por tema.

El nivel significa **dificultad de lectura**, también para novelas: `basico` puede ser una lectura introductoria, `intermedio` una que requiere más contexto y `avanzado` una más exigente. Las clasificaciones son orientativas para este ejercicio, no una afirmación de que todas las novelas sean sencillas. Por ejemplo, después de escoger `novela`, los temas ofrecidos son `amor`, `filosofia`, `guerra` y `literatura`; `matematicas` no aparece porque no hay novelas matemáticas clasificadas como tales en el catálogo actual. No se prohíbe que existan en general: al incorporar una, la opción aparecería automáticamente.

La opción 4 usa un **analizador léxico sencillo**: normaliza mayúsculas, tildes y puntuación, separa la oración en palabras y busca términos conocidos. Por eso acepta distintas estructuras, por ejemplo:

```text
Quiero libros de guerra
Necesito libros que hablen sobre la guerra
Busco un manual avanzado de tecnología
Prefiero un ebook divulgativo de física
Necesito libros básicos digitales sobre conflictos bélicos
Busco novelas románticas de nivel intermedio
```

Puede extraer un tema obligatorio y, si aparecen, un género, nivel y formato. Reconoce las claves de los catálogos, plurales comunes y algunos sinónimos definidos en `alias_catalogo/3`: `principiante`, `medio`, `experto`, `ebook`, `electrónico`, `impreso`, `conflictos` y `bélicos`. Las palabras restantes se ignoran como conectores.

No es inteligencia artificial ni comprende el significado general de cualquier texto. La frase debe incluir **exactamente un tema conocido** y no debe contener valores contradictorios de una misma categoría. Por ejemplo, `quiero historia y guerra` se rechaza por tener dos temas. El vocabulario aceptado puede ampliarse de forma explícita agregando hechos a `alias_catalogo/3`.

Guerra tiene cuatro libros con ese tema principal y dos libros de historia marcados explícitamente como relacionados. El tema `amor` se registra como secundario en dos novelas y un ensayo sobre relaciones. No se recomienda automáticamente todo el catálogo de historia para una búsqueda de guerra. Hay diez libros con tema principal matemáticas.

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

El tema es obligatorio: debe ser el tema principal del libro o uno secundario documentado en `tema_de_libro/4`. **Tema y género elegido son requisitos estrictos**; si no existen libros con esa combinación, la búsqueda por frase lo explica y la consulta guiada no la ofrece. Nivel y formato son preferencias: los resultados se dividen en **Coincidencias exactas** (cumplen todos los filtros solicitados, sin mostrar puntuación) y **Posibles recomendaciones** (libros del mismo tema y género que no cumplen nivel o formato; muestran cercanía y en qué difieren). El principal aporta 2 puntos y el secundario 1. Género o formato coincidente aporta 1 punto; nivel exactamente igual, 2. La regla `adecuacion_nivel/5` considera un libro **intermedio de divulgación** como alternativa para alguien que pidió **básico**: aporta 1 punto y explica la inferencia, pero no cuenta como coincidencia exacta.
