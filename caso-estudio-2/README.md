# HW-Expert

Sistema experto en **Prolog** para configurar hardware y diagnosticar su rendimiento. Valida la compatibilidad entre componentes, detecta riesgos (fuente insuficiente, cuellos de botella) y recomienda un equipo completo según el perfil de uso y el presupuesto del cliente.

Todos los precios están en **pesos mexicanos (MXN)** y son aproximados (tipo de cambio de referencia: 18.5 MXN por USD). El programa es académico: el cálculo energético y el balance CPU/GPU son **heurísticos** y no sustituyen benchmarks ni la validación del fabricante.

## Requisitos

- [SWI-Prolog](https://www.swi-prolog.org/Download.html) 9.x o superior.
- No se requieren dependencias externas ni servicios de pago.

En Ubuntu/Debian, SWI-Prolog puede instalarse con el gestor del sistema; este repositorio no instala nada automáticamente:

```bash
sudo apt install swi-prolog
```

## Cómo ejecutarlo

### Menú interactivo

```bash
swipl hw_expert.pl
```

El menú se abre automáticamente **solo si hay una terminal interactiva**. Si el archivo se carga desde otro programa o desde una tubería, no se bloquea la terminal.

Al elegir la opción `0` se regresa al prompt de Prolog. Para volver a abrir el menú:

```prolog
?- menu.
```

Para cerrar Prolog:

```prolog
?- halt.
```

### Demostración automática

```bash
swipl hw_expert.pl --demo
```

Ejecuta las cuatro reglas, muestra una configuración válida, una recomendación para gaming con $27,000 MXN y otra para servidor web con $22,000 MXN, y termina.

### Carga sin menú

```bash
swipl hw_expert.pl --no-menu
```

Carga la base de conocimientos y deja el prompt de Prolog sin abrir el menú.

### Consultas automatizadas

```bash
swipl -g "consult('hw_expert.pl'), contar_registros, halt" -t halt
swipl -g "consult('hw_expert.pl'), compatibles(9,10,28), halt" -t halt
```

Al usar `consult/1`, el archivo no se considera el archivo principal y no se ejecuta `main/0`; por eso no aparece el menú.

### Pruebas automatizadas

```bash
swipl pruebas_hw_expert.pl
```

Ejecuta **50 pruebas plunit** y devuelve código de salida `0` si todas pasan o `1` si alguna falla. La suite incluye base de conocimientos, las cuatro reglas, límites numéricos, entradas inválidas, menú, recomendaciones y selección por puntaje.

## Menú principal

| Opción | Qué hace |
|---|---|
| 1 | **Recomendarme un equipo completo.** Pregunta el uso (gaming, IA, renderizado, servidor web o desarrollo), el presupuesto en pesos, la marca de procesador y de gráfica, el tipo de RAM y si se quieren cambiar los mínimos. Muestra la mejor configuración heurística que cabe en el presupuesto, con su diagnóstico. |
| 2 | **Validar compatibilidad** entre procesador, placa madre y RAM. Si no son compatibles, explica el motivo. |
| 3 | **Verificar la fuente de poder.** Muestra el consumo con 25 % de margen y sugiere una fuente si la elegida no alcanza. |
| 4 | **Revisar cuello de botella** entre procesador y tarjeta gráfica. Distingue cuello de botella, configuración equilibrada y resultado no concluyente. |
| 5 | **Diagnóstico completo** de una configuración armada por el usuario. |
| 6 | **Ver el catálogo** de componentes con sus precios. |
| 7 | **Ver el tamaño de la base de conocimientos** (registros por tabla y total). |
| 8 | **Demostración automática** de las cuatro reglas con casos fijos. |
| 0 | Salir del menú. |

En las opciones 2 a 5 los componentes se eligen escribiendo su número (ID) del catálogo, que se muestra en pantalla.

## Base de conocimientos

Cada entidad tiene al menos 50 registros y el total es **285 hechos**:

| Hecho | Registros |
|---|---|
| `procesador(Id, Marca, Modelo, Socket, Cores, Hilos, ConsumoWatts, Precio)` | 59 |
| `placa_madre(Id, Modelo, Socket, TipoRAM, SlotsRAM, ConsumoWatts, Precio)` | 64 |
| `memoria_ram(Id, Marca, Tipo, CapacidadGB, VelocidadMHz, Precio)` | 52 |
| `tarjeta_grafica(Id, Marca, Modelo, VRAM_GB, ConsumoWatts, PCIeVersion, Precio)` | 53 |
| `fuente_poder(Id, Marca, Modelo, PotenciaWatts, Certificacion, Precio)` | 57 |

Notas:

- Los sockets y tipos de RAM son átomos (`lga1700`, `am5`, `ddr4`, `ddr5`, ...).
- Cada registro de `memoria_ram` representa un kit con la capacidad total indicada.
- Los IDs son únicos y consecutivos; no se duplicaron componentes para inflar los conteos.

## Reglas implementadas

### Regla 1: compatibilidad

`compatibles(IdCpu, IdMb, IdRam)` se cumple si y solo si:

1. El socket del procesador es igual al socket de la placa.
2. El tipo de RAM de la placa es igual al tipo del kit de RAM (DDR4/DDR5).

`incompatibilidad/4` explica si el problema es de socket o de memoria.

**Alcance:** los hechos de la práctica no incluyen chipset, versión de BIOS, capacidad máxima de RAM, número de módulos, velocidad soportada, conectores de la fuente, PCIe ni dimensiones físicas. El programa muestra una advertencia explícita: la compatibilidad validada es la de la Regla 1, no una garantía física total. Por ejemplo, una placa AM4 antigua puede necesitar actualización de BIOS para un Ryzen 5000, y una placa Intel de la serie 600 puede necesitar BIOS para un CPU de 14.ª generación; esos datos no están en los hechos.

### Regla 2: seguridad energética

`consumo_total/4` suma:

```
consumo = W(CPU) + W(placa) + W(GPU)
```

`consumo_con_margen/4` aplica exactamente el 25 %:

```
requerido = consumo * 1.25
```

`fuente_suficiente(IdCpu, IdMb, IdGpu, IdPsu)` exige `Potencia >= Requerido`. El caso límite de igualdad **se acepta** (`>=`).

`psu_mas_barata/5` elige la fuente suficiente de menor precio; `psu_para_watts/3` está tabulada por potencia requerida redondeada hacia arriba, porque las potencias del catálogo son enteras.

**Alcance:** el cálculo no incluye RAM, almacenamiento, ventiladores, bomba de refrigeración ni picos transitorios. Por eso el programa agrega avisos cuando la holgura es menor al 10 % o cuando una GPU de alto consumo usa una fuente 80+ white/bronze. Esos avisos no cambian el resultado de la Regla 2.

### Regla 3: cuellos de botella y equilibrio

Criterio académico obligatorio:

```prolog
cuello_botella(IdCpu, IdGpu, Mensaje) :-
    VRAM >= 16,
    Cores < 8.
```

El mensaje es exactamente:

> El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas

Además, `configuracion_equilibrada/2` usa una heurística de proporción:

| VRAM de la GPU | Núcleos mínimos del CPU |
|---|---|
| 16 GB o más | 8 |
| 8 GB a 15 GB | 6 |
| Menos de 8 GB | 4 |

`diagnostico_balance/3` distingue tres resultados mutuamente excluyentes:

- `cuello_botella(Mensaje)`: se activó el criterio obligatorio.
- `equilibrada`: la heurística de núcleos/VRAM considera la pareja coherente.
- `no_concluyente(Mensaje)`: no se activa el umbral obligatorio, pero la heurística tampoco permite afirmar equilibrio.

El diagnóstico es heurístico y **no sustituye benchmarks reales**.

### Regla 4: recomendación por presupuesto

Una configuración de cinco componentes es válida si:

1. Cumple la Regla 1 (`compatibles/3`).
2. Cumple la Regla 2 (`fuente_suficiente/4`).
3. La suma de los cinco precios es menor o igual al presupuesto.
4. No activa el cuello de botella obligatorio y es coherente según la heurística de equilibrio.

`recomendar/7` genera configuraciones válidas; devuelve la primera que encuentra, no necesariamente la mejor.

`mejor_configuracion/3` y `mejor_configuracion/4` recorren las combinaciones y eligen la de mayor puntaje heurístico para el perfil, respetando presupuesto, filtros y reglas. La búsqueda poda por precio parcial y usa una tabla para la fuente más barata por potencia requerida.

## Perfiles de uso

Requisitos mínimos que exige el sistema:

| Perfil | Núcleos | RAM (GB) | VRAM (GB) |
|---|---|---|---|
| `gaming` | 6 | 16 | 8 |
| `ia` | 8 | 32 | 16 |
| `renderizado` | 8 | 32 | 12 |
| `servidor_web` | 8 | 32 | 0 |
| `desarrollo` | 6 | 16 | 0 |

## Puntaje heurístico

El puntaje **no es un benchmark**. Usa solo los datos disponibles en los hechos:

- **CPU:** núcleos e hilos, con rendimientos decrecientes y topes por perfil.
- **RAM:** capacidad y velocidad, con topes por perfil.
- **GPU:** VRAM aprovechable por perfil. El precio de la GPU solo desempata de forma mínima (`PrecioG / 1,000,000`); el consumo **no** se usa como si fuera rendimiento.
- **Desempate final:** entre dos equipos con el mismo puntaje, se prefiere el de menor costo total.

Esto evita que una GPU más cara o de mayor consumo gane automáticamente. La limitación es que dos GPU con la misma VRAM pueden tener rendimiento real muy distinto y el programa no tiene benchmarks para distinguirlas.

## Consultas desde el prompt de Prolog

```prolog
?- ayuda.                                          % lista de consultas disponibles
?- contar_registros.                               % registros por tabla y total
?- demo.                                           % demostración de las reglas

% Regla 1
?- compatibles(IdCpu, IdMb, IdRam).
?- incompatibilidad(IdCpu, IdMb, IdRam, Motivo).

% Regla 2
?- consumo_total(IdCpu, IdMb, IdGpu, Total).
?- consumo_con_margen(IdCpu, IdMb, IdGpu, Requerido).
?- fuente_suficiente(IdCpu, IdMb, IdGpu, IdPsu).
?- psu_mas_barata(IdCpu, IdMb, IdGpu, IdPsu, Precio).

% Regla 3
?- cuello_botella(IdCpu, IdGpu, Mensaje).
?- configuracion_equilibrada(IdCpu, IdGpu).
?- diagnostico_balance(IdCpu, IdGpu, Estado).

% Regla 4
?- recomendar(30000, Cpu, Mb, Ram, Gpu, Psu, Total).
?- recomendar_perfil(gaming, 30000).
?- mejor_configuracion(gaming, 30000, Config).
?- mejor_configuracion(gaming, 30000, filtros('AMD','NVIDIA',ddr5,8,32,16), Config).

% Diagnóstico completo
?- diagnosticar(Cpu, Mb, Ram, Gpu, Psu, gaming).
```

Para buscar un ID por nombre:

```prolog
?- cpu_id('Ryzen 5 5600', Id).
?- gpu_id('GeForce RTX 4090', Id).
```

## Ejemplo de uso

Recomendación real ejecutada para gaming con $30,000 MXN, sin preferencia de marca ni de RAM:

```text
Mejor equipo para gaming con presupuesto de $30,000 MXN:
  CPU    : Intel Core i5-14400F (lga1700, 10N/16H)  $3,780
  Placa  : MSI PRO B760M-P DDR5 (lga1700, ddr5)  $2,340
  RAM    : G.Skill ddr5 32GB 6400MHz  $2,430
  GPU    : NVIDIA GeForce RTX 4080, 16GB VRAM (PCIe 4.0)  $18,000
  Fuente : EVGA 600 W1 600W 80+ white  $810
  TOTAL  : $27,360 MXN

=== DIAGNÓSTICO (perfil: gaming) ===
[OK]   Compatibilidad: socket y tipo de RAM correctos.
[INFO] La validación cubre socket y tipo de RAM (DDR4/DDR5). No verifica versión de BIOS, chipset, capacidad máxima, número de módulos, velocidad soportada, conectores de la fuente, PCIe ni dimensiones físicas; confirma esos datos con el fabricante.
[OK]   Energía: consumo 420 W (+25% = 525.0 W) <= fuente de 600 W.
[INFO] GPU de 320 W con fuente 80+ white: revisa calidad, protecciones y conectores; el cálculo no modela picos transitorios.
[INFO] El cálculo solo suma CPU + placa + GPU; no incluye RAM, almacenamiento, ventiladores, bomba de refrigeración ni picos transitorios.
[OK]   Balance: configuración equilibrada según la heurística de núcleos/VRAM (no sustituye benchmarks reales).
[INFO] El balance CPU/GPU es heurístico y no sustituye benchmarks reales.
[OK]   Cumple los requisitos mínimos del perfil gaming.
```

La salida anterior es real. No se usan capturas de pantalla ni resultados inventados.

## Pruebas

La suite `pruebas_hw_expert.pl` contiene 50 pruebas y cubre, entre otros:

- Conteos exactos: 59, 64, 52, 53, 57 y total 285.
- IDs únicos y consecutivos.
- `compatibles(9,10,28)` verdadero y `compatibles(9,10,2)` falso.
- Consumo 675 W y margen 843.75 W para CPU 51, placa 54 y GPU 23.
- Fuente de 750 W insuficiente y de 1000 W suficiente.
- Caso límite de igualdad: 750 W requeridos con fuente de 750 W.
- Fuente más barata suficiente para 843.75 W (EVGA 850 GQ, $2,160).
- `cuello_botella(37,44,Mensaje)` y `configuracion_equilibrada(48,21)`.
- Recomendaciones para los cinco perfiles con $18,000, $22,000 y $27,000 MXN.
- Verificación de que cada recomendación es compatible, tiene fuente suficiente, respeta el presupuesto y no tiene cuello de botella.
- Selección de la configuración con mayor puntaje en un conjunto de filtros.
- Entradas válidas e inválidas de enteros y pesos.
- Menú: opciones 1 (sin solución), 2, 3, 4, 5, 7, 0 y entrada inválida.

Resultado de la última ejecución:

```text
% All 50 tests passed
```

## Rendimiento

La búsqueda de la mejor configuración revisa miles de combinaciones. Como referencia medida en este equipo:

- Medición inicial, antes de las mejoras: `recomendar_perfil(gaming, 27000)` tardó **4.69 s**.
- Medición posterior, con la misma consulta: **3.70 s**.
- Segunda medición de control en este equipo: **3.54 s** con el archivo original y **2.69 s** con el mejorado (la carga del equipo afecta la medición).
- La suite completa de 50 pruebas tarda aproximadamente **19 s**, dominada por las 15 recomendaciones de perfiles y presupuestos.

Los tiempos pueden variar según el equipo, la carga y la versión de SWI-Prolog. No se presentan como un benchmark absoluto.

## Limitaciones

- **Compatibilidad física:** solo se valida socket y tipo DDR4/DDR5. No se valida BIOS, chipset, capacidad máxima, número de módulos, velocidad real soportada, conectores de la fuente, PCIe ni dimensiones.
- **Energía:** solo se suman CPU + placa + GPU. No se incluyen RAM, discos, ventiladores, bomba, iluminación ni picos transitorios. El margen del 25 % es el exigido por la práctica, no una garantía de estabilidad.
- **Cuellos de botella:** la heurística usa VRAM y núcleos; no mide IPC, frecuencia, arquitectura, caché ni rendimiento real. No sustituye benchmarks.
- **Puntaje:** no hay datos de rendimiento por modelo. Dos GPU con la misma VRAM pueden recibir puntajes casi iguales aunque rindan distinto.
- **Precios:** son aproximados y pueden cambiar. No se consultan tiendas ni servicios externos.
- **Datos no modelados:** no hay información de stock, garantías, tamaño de gabinete, refrigeración, overclocking ni sistema operativo.
- **Alcance académico:** el programa prioriza los requisitos del Caso de Estudio 2 y no pretende ser una herramienta comercial de presupuesto.

## Estructura

```text
hw_expert.pl                 % base de conocimientos, reglas, menú y demo
pruebas_hw_expert.pl         % 50 pruebas automatizadas con plunit
README.md                    % este archivo
REPORTE_CASO_ESTUDIO_2.md    % reporte documental del caso de estudio
```
