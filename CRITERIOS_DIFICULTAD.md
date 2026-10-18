# Criterios de dificultad lectora en novelas

## ¿Se puede asignar dificultad a una novela?

Sí, siempre que se indique que es **una estimación cualitativa y orientativa**, no un dato universal, una calificación académica ni una medida producida automáticamente por Prolog.

El marco de complejidad textual de Common Core distingue la evaluación cualitativa (significados, estructura, claridad del lenguaje, conocimientos exigidos), la evaluación cuantitativa y las características del lector y su tarea.

Fuente: https://www.thecorestandards.org/ELA-Literacy/standard-10-range-quality-complexity/measuring-text-complexity-three-factors/

## Rúbrica propuesta para el proyecto (no validada científicamente)

Para clasificar una novela, documentar por separado:

1. **Lenguaje:** vocabulario cotidiano frente a léxico arcaico, abstracto o especializado.
2. **Estructura:** narración lineal frente a múltiples perspectivas, saltos temporales o secuencias experimentales.
3. **Interpretación:** sentido explícito frente a simbolismos, ironía y significados implícitos.
4. **Contexto:** conocimientos históricos o culturales necesarios para seguir la obra.

Cada indicador puede valorarse de 0 a 2:

- 0: exigencia baja;
- 1: exigencia moderada;
- 2: exigencia alta.

**Criterio provisional de síntesis**: 0–2 = básico; 3–5 = intermedio; 6–8 = avanzado. Estas bandas las propone el equipo como instrumento didáctico; **no provienen de Common Core ni se ha demostrado su validez**. No hay que afirmar que las 18 novelas del catálogo ya recibieron esta puntuación: actualmente tienen niveles y justificaciones narrativas, no una medición por indicadores.

Para convertir la clasificación en un procedimiento verificable, el equipo tendría que evaluar las 18 obras con esta rúbrica, justificar cada puntuación con pasajes concretos y revisar discrepancias entre evaluadores. Una edición o traducción diferente puede cambiar la dificultad lingüística.

## Si el docente no acepta niveles de novelas

Una alternativa válida sería mantener `nivel/2` para manuales, ensayos y divulgación, y usar `no_aplica` para novelas, ocultando el filtro en consulta guiada. **Esto no está aplicado en la rama sushi** porque cambiaría el modelo de datos y las reglas de recomendación; es una decisión de alcance académico pendiente de aprobación del equipo.

## Qué se implementó

El predicado `justificacion_dificultad/2` conserva una explicación orientativa por novela, y `validar_catalogo/1` comprueba que no falte ninguna. Son explicaciones humanas, no el resultado de ejecutar la rúbrica anterior.
