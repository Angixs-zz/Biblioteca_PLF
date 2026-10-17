# Revisión de calidad — rama sushi

## Qué cambia

Se conserva el modelo de seis conjuntos principales y sus cuatro catálogos. No se inventaron obras, autores, editoriales ni formatos disponibles en bibliotecas reales. Los 100 libros existentes mantienen sus vínculos a ediciones de Open Library en `fuentes_editoriales.md`; **estos vínculos documentan ediciones, pero no verifican automáticamente disponibilidad, dificultad lectora o todas las etiquetas temáticas**.

### Corrección y criterio de las relaciones

- Género: forma de la obra (novela, ensayo, manual, divulgación).
- Tema: asunto tratado en la obra (literatura, guerra, historia, amor...).
- Nivel: dificultad de lectura *orientativa*, no nivel académico formal.
- Formato: categoría didáctica de la actividad; no inventario de un ejemplar.

Los temas del menú dependen de los libros realmente asociados con el género. La regla `temas_disponibles/2` parte de `tema_de_libro/4` y `libro/7`. Por eso «novela -> matemáticas» no aparece en este catálogo, pero sí podría aparecer al registrar una novela matemática correctamente.

`relacion_tematica/3` almacena temas secundarios con una justificación legible. Por ejemplo, las novelas bélicas también pueden localizarse desde literatura; un texto sobre historia que trate guerras puede recomendarse desde guerra sin convertir toda la historia en guerra. Una novela ambientada durante una guerra **no es automáticamente una fuente histórica**.

### Dificultad de novelas

Las 13 novelas registradas tienen una justificación individual en `justificacion_dificultad/2`, que se muestra al recomendar. Las justificaciones consideran lenguaje, complejidad narrativa, contexto y referencias culturales. Son valoraciones humanas didácticas, no resultados de una prueba automática de legibilidad.

Se ajustaron dos niveles orientativos:

- Libro 30, *La sombra del viento*: de avanzado a intermedio.
- Libro 78, *Crónica de una muerte anunciada*: de básico a intermedio.

### Auditoría automática

`validar_catalogo(Errores)` examina claves duplicadas, referencias inexistentes, libros sin autor, categorías inválidas, relaciones temáticas redundantes o huérfanas, novelas sin justificación, preferencias sin libros compatibles y recomendaciones guardadas que ya no correspondan al perfil. `catalogo_valido` se cumple cuando la lista de errores está vacía.

La búsqueda por frases continúa siendo **un analizador léxico basado en reglas**, no un chatbot ni comprensión de lenguaje natural irrestricta. Se ampliaron algunos alias; una frase ambigua o sin tema sigue rechazándose.

### Menú y cancelación

En los menús, escribir `salir` permite cancelar la selección. Los formatos didácticos se distinguen explícitamente de la disponibilidad real. La consulta guiada mantiene las dependencias género -> tema -> nivel -> formato.

## Cómo ejecutar

```bash
sudo apt install swi-prolog
swipl -s biblioteca.pl -g iniciar -t halt
```

## Cómo validar el catálogo

```bash
swipl -q -s biblioteca.pl -g "validar_catalogo(Errores),writeln(Errores)" -t halt
```

El resultado esperado es `[]`.

## Cómo ejecutar las pruebas

```bash
swipl -q -s pruebas_biblioteca.pl -g run_tests -t halt
```

La suite comprueba relaciones, filtros dinámicos, niveles, interpretación básica de frases y consultas de recomendaciones.

**Límite de verificación:** la clasificación bibliográfica necesita revisión editorial humana si se utilizará fuera de una práctica académica. El programa y las pruebas requieren SWI-Prolog para confirmar la ejecución; revisar el texto del código por sí solo no prueba el comportamiento en ejecución.
