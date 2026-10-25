# Reporte — Caso de Estudio 2: HW-Expert

- **Proyecto:** Biblioteca_PLF
- **Rama de trabajo:** `miguel/mejoras-hw-expert`
- **Commit base:** `b24384c`
- **Fecha de verificación:** 25 de octubre de 2026
- **Entorno:** SWI-Prolog 9.0.4 para x86_64-linux
- **Repositorio original de referencia:** `https://github.com/yareliyazmin16/Biblioteca_PLF.git`
- **Repositorio de publicación:** `https://github.com/Angixs-zz/Biblioteca_PLF`
- **Commit de mejoras publicado:** `255a88f` (`miguel/mejoras-hw-expert`)
- **Organización:** incorporado a `caso-estudio-2/` en la rama `miguel/organizar-casos-prolog`, sin fusionar con `main`.
- **Nota sobre pruebas:** los resultados se registraron antes de mover los archivos; no se han repetido después de la reorganización.

---

## 1. Resumen ejecutivo

Se mejoró el sistema experto **HW-Expert** sin sustituir su base de conocimientos, sus predicados principales, su menú ni sus funciones ya operativas. La base conserva exactamente **285 hechos**: 59 procesadores, 64 placas madre, 52 kits de RAM, 53 tarjetas gráficas y 57 fuentes de poder.

Las mejoras se concentraron en cinco áreas:

1. **Pruebas automatizadas:** se agregó una suite de **50 pruebas plunit**.
2. **Advertencias honestas:** el sistema ahora distingue entre la compatibilidad que realmente valida (socket y tipo de RAM) y la compatibilidad física completa que no puede garantizar.
3. **Seguridad energética:** se conserva el cálculo obligatorio con 25 % de margen y se agregan avisos cuando la holgura es menor al 10 % o cuando una GPU de alto consumo usa una fuente 80+ white/bronze.
4. **Diagnóstico de balance:** se añadió `diagnostico_balance/3` con tres estados: cuello de botella, equilibrada y no concluyente.
5. **Recomendación y rendimiento:** se corrigió el puntaje para no premiar el consumo ni el precio como si fueran rendimiento, y se redujo el tiempo de búsqueda.

Resultado real de la suite:

```text
% All 50 tests passed
```

Durante la fase de verificación no se hizo `commit`, `push`, `merge` ni se abrió un pull request. **Posteriormente** se publicaron las mejoras en el fork propio mediante el commit `255a88f`; la reorganización se hizo en una rama independiente, sin fusionar con `main`.

---

## 2. Objetivo y alcance

El objetivo fue mejorar un sistema experto académico en Prolog para configuración de hardware, manteniendo los requisitos del Caso de Estudio 2:

- Validar compatibilidad CPU + placa madre + RAM.
- Calcular el consumo eléctrico y verificar la fuente de poder con 25 % de margen.
- Detectar cuellos de botella entre CPU y GPU.
- Recomendar una configuración completa de cinco componentes dentro de un presupuesto.

El trabajo se realizó únicamente sobre la rama `miguel/mejoras-hw-expert`. No se trabajó sobre `main` ni sobre la rama original de otro integrante.

---

## 3. Restricciones respetadas

| Restricción | Estado |
|---|---|
| No reemplazar la base de conocimientos | Respetada: los 285 hechos no se modificaron |
| No duplicar componentes para inflar conteos | Respetada: se verificaron IDs únicos y consecutivos |
| Conservar `procesador/8` | Respetada |
| Conservar `placa_madre/7` | Respetada |
| Conservar `memoria_ram/6` | Respetada |
| Conservar `tarjeta_grafica/7` | Respetada |
| Conservar `fuente_poder/6` | Respetada |
| Conservar el menú en español con 8 opciones | Respetada; la opción 0 sigue siendo salir |
| Conservar la Regla 1 obligatoria | Respetada |
| Conservar la Regla 2 con 25 % exacto | Respetada |
| Conservar la Regla 3 obligatoria (VRAM ≥ 16 y núcleos < 8) | Respetada, incluido el mensaje exacto |
| Conservar la Regla 4 de cinco componentes | Respetada |
| No inventar componentes, datos ni capturas | Respetado |
| No instalar dependencias globales ni usar servicios de pago | Respetado |
| No publicar sin autorización durante la implementación y las pruebas | Respetado en esa etapa; después se publicó la rama de mejoras |

**Nota sobre `candidato/10`:** el enunciado hace referencia a `candidato/11`, pero la implementación original y la conservada usan **`candidato/10`**. No se cambió su aridad; se documentó la diferencia para evitar confusiones.

---

## 4. Base de conocimientos

La base no se modificó. La verificación ejecutada fue:

```bash
swipl -q -g "consult('hw_expert.pl'), contar_registros, halt" -t halt
```

Salida real:

```text
procesador: 59 | placa_madre: 64 | memoria_ram: 52 | tarjeta_grafica: 53 | fuente_poder: 57
TOTAL: 285 hechos
```

| Hecho | Aridad | Registros |
|---|---|---:|
| `procesador` | 8 | 59 |
| `placa_madre` | 7 | 64 |
| `memoria_ram` | 6 | 52 |
| `tarjeta_grafica` | 7 | 53 |
| `fuente_poder` | 6 | 57 |
| **Total** | | **285** |

Las pruebas también verifican que los IDs de cada tabla sean únicos y contiguos.

---

## 5. Reglas implementadas

### Regla 1 — Compatibilidad

`compatibles(IdCpu, IdMb, IdRam)` exige:

1. `Socket(CPU) == Socket(Placa)`
2. `TipoRAM(Placa) == Tipo(RAM)`

`incompatibilidad/4` explica si el problema es de socket o de memoria.

**Mejora:** se agregó `advertencia_compatibilidad_fisica/1`. El sistema ya no afirma que un equipo sea físicamente compatible en todos los sentidos; aclara que no verifica BIOS, chipset, capacidad máxima, número de módulos, velocidad soportada, conectores de la fuente, PCIe ni dimensiones.

Casos ejecutados:

```text
compatibles(9,10,28): true
compatibles(9,10,2): false
incompatibilidad(9,10,2): Memoria incompatible: la placa soporta ddr5 y la RAM es ddr4
```

### Regla 2 — Seguridad energética

```prolog
consumo_total = W(CPU) + W(Placa) + W(GPU)
consumo_con_margen = consumo_total * 1.25
fuente_suficiente :- PotenciaFuente >= consumo_con_margen
```

El caso límite de igualdad se acepta porque la comparación es `>=`.

Resultados ejecutados:

```text
consumo_total(51,54,23) = 675 W
consumo_con_margen(51,54,23) = 843.8 W
fuente_suficiente(51,54,23,8): false
fuente_suficiente(51,54,23,10): true
psu_mas_barata(51,54,23): EVGA 850 GQ 850W $2160
```

Caso frontera ejecutado:

```text
CPU 8 + placa 1 + GPU 23 = 600 W
Requerido = 750.0 W
PSU 6 (750 W): true
PSU 5 (650 W): false
```

**Mejora:** `advertencias_energeticas/5` agrega tres avisos que **no cambian** el resultado de la regla:

- Holgura menor al 10 %.
- GPU de 250 W o más con fuente 80+ white/bronze.
- El cálculo solo suma CPU + placa + GPU; no incluye RAM, discos, ventiladores, bomba ni picos transitorios.

### Regla 3 — Cuello de botella y balance

Se conservó el criterio académico obligatorio:

```prolog
cuello_botella(IdCpu, IdGpu, Mensaje) :-
    VRAM >= 16,
    Cores < 8.
```

Mensaje exacto conservado:

> El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas

Resultado ejecutado:

```text
cuello_botella(37,44): El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas
configuracion_equilibrada(48,21): true
```

**Mejora:** `configuracion_equilibrada/2` dejó de ser una condición demasiado amplia y ahora usa una heurística de proporción:

| VRAM de la GPU | Núcleos mínimos del CPU |
|---|---:|
| 16 GB o más | 8 |
| 8 GB a 15 GB | 6 |
| Menos de 8 GB | 4 |

También se agregó `diagnostico_balance/3`, con tres resultados mutuamente excluyentes:

```text
diagnostico_balance(37,44): cuello_botella(El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas)
diagnostico_balance(48,21): equilibrada
diagnostico_balance(1,1):  no_concluyente(resultado no concluyente: GPU de 2 GB de VRAM con CPU de 2 núcleos; ...)
```

### Regla 4 — Recomendación por presupuesto

Una configuración de cinco componentes es válida si:

1. Cumple la Regla 1.
2. Cumple la Regla 2.
3. La suma de los cinco precios es menor o igual al presupuesto.
4. No activa el cuello de botella obligatorio y es coherente según la heurística de equilibrio.

Se conservaron `recomendar/7`, `recomendar_perfil/2`, `mejor_configuracion/3` y `mejor_configuracion/4`.

**Mejoras:**

- `candidato/10` unifica directamente socket y tipo de RAM, calcula los watts requeridos en línea y usa `psu_para_watts/3` con tabulación.
- El puntaje ya no usa los watts de la GPU ni un peso grande del precio.
- En `servidor_web`, el peso de la GPU es `0`.
- El costo total solo funciona como desempate final muy pequeño.

---

## 6. Cambios implementados

| Área | Antes | Ahora |
|---|---|---|
| Arranque | `initialization(menu)` abría el menú incluso al cargar desde pruebas | `initialization(main, main)`; el menú solo se abre si el archivo es el principal y hay TTY |
| Modo demo | No había bandera de demostración | `swipl hw_expert.pl --demo` ejecuta la demo y termina |
| Modo sin menú | No existía | `swipl hw_expert.pl --no-menu` carga sin abrir el menú |
| Compatibilidad | Solo se validaba socket y RAM, sin aclarar el alcance | Se agregó advertencia explícita de límites físicos |
| Energía | Solo se comparaba la potencia | Se agregaron avisos de holgura y de calidad de fuente |
| Equilibrio | `configuracion_equilibrada/2` era demasiado permisiva | Heurística por niveles de VRAM y núcleos |
| Diagnóstico | Solo había cuello de botella o equilibrio | `diagnostico_balance/3` con estado no concluyente |
| Puntaje | La GPU podía ganar por consumo o precio | VRAM útil por perfil + desempate mínimo de precio |
| Servidor web | La GPU podía influir en la recomendación | Peso de GPU = 0 |
| Búsqueda | Consultas repetidas a los hechos | Poda por precio y tabla `psu_para_watts/3` |
| Entrada de menú | `read/1` dificultaba las pruebas | `read_line_to_string/2` y parseo validado |
| Registros | Solo se listaban tablas | Se muestra también el total de 285 |
| Documentación | README breve | README ampliado y este reporte |

---

## 7. Pruebas ejecutadas

### 7.1 Versión del entorno

```bash
swipl --version
```

```text
SWI-Prolog version 9.0.4 for x86_64-linux
```

### 7.2 Suite automatizada

```bash
swipl pruebas_hw_expert.pl
```

Salida real:

```text
% PL-Unit: hw_expert_base ... passed 0.004 sec
% PL-Unit: hw_expert_regla1 ........ passed 0.001 sec
% PL-Unit: hw_expert_regla2 ........ passed 0.001 sec
% PL-Unit: hw_expert_regla3 ........ passed 0.001 sec
% PL-Unit: hw_expert_regla4 ........... passed 18.424 sec
% PL-Unit: hw_expert_interfaz ............ passed 0.006 sec
% All 50 tests passed
```

Tiempo total medido: **18.744 s**.

La suite cubre:

- Conteos exactos y IDs únicos/contiguos.
- Las cuatro reglas y sus casos límite.
- Advertencias físicas y energéticas.
- Los tres estados de `diagnostico_balance/3`.
- Las 15 combinaciones de 5 perfiles × 3 presupuestos.
- Selección por puntaje y respeto al presupuesto.
- Entradas válidas e inválidas.
- Opciones del menú 1, 2, 3, 4, 5, 7 y 0.

### 7.3 Demostración automática

```bash
swipl hw_expert.pl --demo
```

Salida real (extracto completo de las reglas):

```text
##### 0. Tamaño de la base de conocimientos #####
procesador: 59 | placa_madre: 64 | memoria_ram: 52 | tarjeta_grafica: 53 | fuente_poder: 57
TOTAL: 285 hechos

##### REGLA 1: compatibilidad #####
i5-13400F + B760M-A (DDR5) + RAM DDR4: NO compatible
i5-13400F + B760M-A (DDR5) + RAM DDR5: compatible

##### REGLA 2: seguridad energética #####
Ryzen 9 7950X + X670E + RTX 4090: 675 W, con margen 843.8 W
Corsair RM750e : INSUFICIENTE
Corsair RM1000e: suficiente

##### REGLA 3: cuellos de botella #####
Ryzen 5 5600 + RX 7900 XTX -> El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas
Ryzen 7 7800X3D + RTX 4080 -> configuración equilibrada
```

Recomendación real para gaming con $27,000 MXN:

```text
  CPU    : Intel Core i5-14400F (lga1700, 10N/16H)  $3,780
  Placa  : MSI PRO B760M-P DDR5 (lga1700, ddr5)  $2,340
  RAM    : G.Skill ddr5 32GB 6400MHz  $2,430
  GPU    : NVIDIA GeForce RTX 3090, 24GB VRAM (PCIe 4.0)  $16,200
  Fuente : EVGA 600 W1 600W 80+ white  $810
  TOTAL  : $25,560 MXN
```

La demo termina con código de salida `0` y sin abrir el menú.

### 7.4 Los 15 escenarios de recomendación

Comando ejecutado sobre un script de verificación que consulta `mejor_configuracion/3` y comprueba compatibilidad, fuente suficiente, presupuesto, ausencia de cuello de botella y equilibrio:

```text
gaming 18000: total=17370 estado=OK
gaming 22000: total=21960 estado=OK
gaming 27000: total=25560 estado=OK
ia 18000: total=18000 estado=OK
ia 22000: total=21780 estado=OK
ia 27000: total=27000 estado=OK
renderizado 18000: total=17910 estado=OK
renderizado 22000: total=21780 estado=OK
renderizado 27000: total=26820 estado=OK
servidor_web 18000: total=17820 estado=OK
servidor_web 22000: total=20520 estado=OK
servidor_web 27000: total=20520 estado=OK
desarrollo 18000: total=17730 estado=OK
desarrollo 22000: total=17730 estado=OK
desarrollo 27000: total=17730 estado=OK
```

Los 15 casos devolvieron `estado=OK`. No se inventaron configuraciones: todos los totales provienen de la ejecución real.

### 7.5 Menú interactivo

Entrada simulada: opción `7` (registros) y luego `0` (salir).

```bash
printf '7\n0\n' | swipl -q -g "consult('hw_expert.pl'), menu" -t halt
```

Salida real (extracto):

```text
 7) Cantidad de registros de cada componente
 8) Ver demostración y recomendaciones automáticas
 0) Salir
Elige una opción: procesador: 59 | placa_madre: 64 | memoria_ram: 52 | tarjeta_grafica: 53 | fuente_poder: 57
TOTAL: 285 hechos
...
Elige una opción: ¡Hasta luego!
```

### 7.6 Modos de arranque

```bash
swipl hw_expert.pl --no-menu </dev/null
```

```text
HW-Expert cargado en modo no interactivo. Usa menu. o demo.
```

```bash
swipl hw_expert.pl </dev/null
```

```text
HW-Expert cargado. No hay terminal interactiva; usa menu. o demo.
```

Ambos terminaron con código `0`.

---

## 8. Errores encontrados y correcciones

| Problema | Causa | Corrección |
|---|---|---|
| La carga del archivo abría el menú y bloqueaba las pruebas | `initialization(menu)` se ejecutaba también con `ensure_loaded/1` | Se cambió a `initialization(main, main)` y se agregaron `--demo` y `--no-menu` |
| Dos pruebas fallaban al inicio | El archivo de pruebas redefinía `main/0` y se usaba `sub_string/3` sobre una variable no ligada dentro de `assertion` | Se eliminó el `main/0` de prueba y se corrigió la aserción |
| Una prueba del menú se desalineaba y terminaba en EOF | La secuencia de entradas no coincidía con las preguntas | Se ajustó la entrada a `"1\n1\n1\n3\n4\n3\n1\n0\n"` |
| `configuracion_equilibrada/2` aceptaba parejas claramente desbalanceadas | Solo comparaba de forma amplia VRAM y núcleos | Se implementó la heurística por niveles y el estado no concluyente |
| El puntaje podía premiar consumo o precio | La fórmula usaba watts y un peso económico alto | Se eliminó el consumo del puntaje y el precio quedó como desempate mínimo |
| La búsqueda tardaba varios segundos | Se recorrían los hechos repetidamente | Se podó por precio y se tabuló `psu_para_watts/3` |
| El README tenía una medición de rendimiento desactualizada | Los tiempos variaron entre ejecuciones | Se documentaron ambas mediciones y se aclaró que dependen de la carga del equipo |

---

## 9. Resultados esperados vs. resultados reales

| Aspecto | Esperado | Real ejecutado |
|---|---|---|
| Base de conocimientos | 285 hechos sin cambios | 59 + 64 + 52 + 53 + 57 = 285 |
| Regla 1, caso compatible | `compatibles(9,10,28)` verdadero | Verdadero |
| Regla 1, caso incompatible | `compatibles(9,10,2)` falso | Falso, por DDR4 vs DDR5 |
| Regla 2 | 675 W y 843.75 W de margen | 675 W y 843.8 W mostrados |
| Fuente de 750 W | Insuficiente para 843.75 W | `fuente_suficiente(51,54,23,8)` falso |
| Fuente de 1000 W | Suficiente | `fuente_suficiente(51,54,23,10)` verdadero |
| Igualdad 750 W / 750 W | Aceptada | Verdadera |
| Regla 3 | Mensaje exacto con CPU de menos de 8 núcleos y GPU de 16 GB o más | Mensaje exacto verificado |
| Equilibrio | `configuracion_equilibrada(48,21)` verdadero | Verdadero |
| Recomendaciones | 15 combinaciones válidas | 15 con `estado=OK` |
| Suite | Todas las pruebas pasan | `% All 50 tests passed` |
| Arranque con `--demo` | Ejecuta y termina | Código `0` |
| Arranque con `--no-menu` | Carga sin menú | Código `0` |
| Commit/push durante la verificación inicial | No realizar sin autorización | No se realizó en esa etapa; posteriormente se publicó el commit `255a88f` |

**Diferencia documentada:** la recomendación de gaming con $27,000 MXN cambió de `AMD Radeon RX 7900 XTX` de 24 GB (total $26,370) a `NVIDIA GeForce RTX 3090` de 24 GB (total $25,560) tras corregir el puntaje y el desempate por costo. Esto es consecuencia de la nueva heurística, no de un hecho nuevo ni de datos inventados: ambas GPU ya existían en la base.

---

## 10. Rendimiento

Mediciones realizadas en este equipo con `recomendar_perfil(gaming, 27000)`:

| Versión | Tiempo |
|---|---:|
| Original (medición inicial) | 4.69 s |
| Mejorada (medición inicial) | 3.70 s |
| Original (medición de control) | 3.54 s |
| Mejorada (medición de control) | 2.69 s |

La mejora proviene de:

- Evitar consultas repetidas a los hechos dentro de `candidato/10`.
- Calcular los watts requeridos en línea.
- Reutilizar la fuente más barata mediante `psu_para_watts/3` con tabulación.
- Podar combinaciones por precio parcial.

Los tiempos no son un benchmark absoluto: dependen de la carga del equipo, la memoria caché y la versión de SWI-Prolog.

---

## 11. Limitaciones

- **Compatibilidad física:** solo se valida socket y tipo DDR4/DDR5. No se valida BIOS, chipset, capacidad máxima, número de módulos, velocidad real soportada, conectores de la fuente, PCIe ni dimensiones.
- **Energía:** solo se suman CPU + placa + GPU. No se incluyen RAM, almacenamiento, ventiladores, bomba de refrigeración, iluminación ni picos transitorios. El margen del 25 % es el exigido por la práctica, no una garantía de estabilidad.
- **Cuellos de botella:** la heurística usa VRAM y núcleos; no mide IPC, frecuencia, arquitectura, caché ni rendimiento real. No sustituye benchmarks.
- **Puntaje:** no hay datos de rendimiento por modelo. Dos GPU con la misma VRAM pueden recibir puntajes parecidos aunque rindan distinto.
- **Precios:** son aproximados y pueden cambiar. No se consultan tiendas ni servicios externos.
- **Datos no modelados:** no hay stock, garantías, tamaño de gabinete, refrigeración, overclocking ni sistema operativo.
- **Alcance académico:** el sistema prioriza los requisitos del Caso de Estudio 2 y no pretende ser una herramienta comercial.

---

## 12. Archivos y estado de Git

### Archivos inspeccionados

- `hw_expert.pl` (sistema completo original y modificado).
- `README.md` (documentación original y modificada).
- `pruebas_hw_expert.pl` (suite nueva).
- Estado de Git, ramas y remoto.

### Archivos modificados o creados

| Archivo | Estado |
|---|---|
| `hw_expert.pl` | Modificado |
| `README.md` | Modificado |
| `pruebas_hw_expert.pl` | Nuevo |
| `REPORTE_CASO_ESTUDIO_2.md` | Nuevo (este reporte) |

### Estado local de Git durante las pruebas (histórico)

```text
## miguel/mejoras-hw-expert
 M README.md
 M hw_expert.pl
?? pruebas_hw_expert.pl
```

### Verificación de espacios y conflictos

```bash
git diff --check
```

Resultado: sin salida, código de salida `0`.

### Estadísticas del diff

```text
 README.md    | 245 ++++++++++++++++++++++++++++++++++++++++++++++---------
 hw_expert.pl | 260 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 414 insertions(+), 91 deletions(-)
```

`pruebas_hw_expert.pl` y este reporte aparecen como archivos nuevos, por lo que no se incluyen en `git diff --stat` hasta que se agreguen al índice.

---

## 13. Publicación posterior a las pruebas

Este reporte se redactó inicialmente cuando los cambios eran **locales y no estaban publicados**. El estado posterior es:

- Las mejoras se guardaron en el commit `255a88f` y se subieron a la rama `miguel/mejoras-hw-expert` del repositorio `Angixs-zz/Biblioteca_PLF`.
- Los archivos del Caso 2 se organizaron en la carpeta `caso-estudio-2/` de la rama `miguel/organizar-casos-prolog`, junto al Caso 1 en su propia carpeta.
- **No se ha realizado merge a `main` ni se ha abierto un pull request para esta reorganización.**
- Las 50 pruebas descritas arriba pertenecen a la ejecución anterior a esta reorganización de carpetas; conviene repetirlas desde `caso-estudio-2/` antes de integrar los cambios.

---

## 14. Conclusión

El sistema conserva su base de 285 hechos, sus predicados principales, su menú de 8 opciones y las cuatro reglas obligatorias. Las mejoras añaden pruebas automatizadas, advertencias más honestas, un diagnóstico de balance con estado no concluyente, un puntaje más defendible y una búsqueda más rápida.

La verificación real confirma:

- **50 pruebas aprobadas.**
- **15 recomendaciones válidas** para 5 perfiles y 3 presupuestos.
- **Reglas 1, 2 y 3** con sus casos límite correctos.
- **Arranque controlado** con `--demo` y `--no-menu`.
- **Documentación** en `README.md` y este reporte.

El resultado es una mejora incremental y verificable, sin sustituir el trabajo original ni presentar resultados no ejecutados.
