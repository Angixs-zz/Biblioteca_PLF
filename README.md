# HW-Expert

Sistema experto en **Prolog** para configurar hardware y diagnosticar su rendimiento. Valida la compatibilidad entre componentes, detecta riesgos (fuente insuficiente, cuellos de botella) y recomienda un equipo completo según el perfil de uso y el presupuesto del cliente.

Todos los precios están en **pesos mexicanos (MXN)** y son aproximados (tipo de cambio de referencia: 18 MXN por USD).

## Requisitos

- [SWI-Prolog](https://www.swi-prolog.org/Download.html) 9.x o superior.

## Cómo ejecutarlo

```bash
swipl hw_expert.pl
```

El menú interactivo se abre automáticamente al cargar el archivo. En Windows también puedes abrir `hw_expert.pl` con SWI-Prolog (`swipl-win`).

Si sales del menú con la opción `0`, regresas al prompt de Prolog. Para abrirlo otra vez:

```prolog
?- menu.
```

Para cerrar Prolog:

```prolog
?- halt.
```

## Menú principal

| Opción | Qué hace |
|---|---|
| 1 | **Recomendarme un equipo completo.** Pregunta el uso (gaming, IA, renderizado, servidor web o desarrollo), el presupuesto en pesos, la marca de procesador y de gráfica, el tipo de RAM y si se quieren cambiar los mínimos. Muestra el mejor equipo que cabe en el presupuesto, con su diagnóstico. |
| 2 | **Validar compatibilidad** entre procesador, placa madre y RAM. Si no son compatibles, explica el motivo. |
| 3 | **Verificar la fuente de poder.** Muestra el consumo con 25 % de margen y sugiere una fuente si la elegida no alcanza. |
| 4 | **Revisar cuello de botella** entre procesador y tarjeta gráfica. |
| 5 | **Diagnóstico completo** de una configuración armada por el usuario. |
| 6 | **Ver el catálogo** de componentes con sus precios. |
| 7 | **Ver el tamaño de la base de conocimientos** (registros por tabla). |
| 8 | **Demostración automática** de las cuatro reglas con casos fijos. |
| 0 | Salir del menú. |

En las opciones 2 a 5 los componentes se eligen escribiendo su número (ID) del catálogo, que se muestra en pantalla.

## Base de conocimientos

Cada entidad tiene más de 50 registros:

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

## Reglas implementadas

**Regla 1: compatibilidad.** `compatibles(IdCpu, IdMb, IdRam)` se cumple si el socket del procesador es igual al de la placa y el tipo de RAM coincide con el que soporta la placa.

**Regla 2: seguridad energética.** `fuente_suficiente(IdCpu, IdMb, IdGpu, IdPsu)` suma el consumo del procesador, la placa y la gráfica, le agrega 25 % de margen y exige que la potencia de la fuente sea mayor o igual.

**Regla 3: cuellos de botella.** `cuello_botella(IdCpu, IdGpu, Mensaje)` se activa cuando la gráfica tiene 16 GB de VRAM o más y el procesador tiene menos de 8 núcleos. El mensaje es: *"El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas"*. `configuracion_equilibrada/2` cubre el caso contrario.

**Regla 4: recomendación por presupuesto.** `recomendar/7` arma un equipo de 5 componentes que cumple las reglas 1 y 2 y cuyo precio total no supera el presupuesto. `recomendar_perfil/2` además elige la mejor combinación para el perfil de uso, sin cuellos de botella.

### Perfiles de uso

Requisitos mínimos que exige el sistema para cada perfil:

| Perfil | Núcleos | RAM (GB) | VRAM (GB) |
|---|---|---|---|
| `gaming` | 6 | 16 | 8 |
| `ia` | 8 | 32 | 16 |
| `renderizado` | 8 | 32 | 12 |
| `servidor_web` | 8 | 32 | 0 |
| `desarrollo` | 6 | 16 | 0 |

La "mejor" configuración se elige con un puntaje de rendimiento ponderado según el perfil (`puntaje/5` y `perfil_peso/4`).

## Consultas desde el prompt de Prolog

Además del menú, se pueden hacer consultas directas:

```prolog
?- ayuda.                                          % lista de consultas disponibles
?- contar_registros.                               % registros por tabla
?- demo.                                           % demostración de las reglas

% Regla 1
?- compatibles(IdCpu, IdMb, IdRam).

% Regla 2
?- fuente_suficiente(IdCpu, IdMb, IdGpu, IdPsu).
?- consumo_total(IdCpu, IdMb, IdGpu, Total).
?- consumo_con_margen(IdCpu, IdMb, IdGpu, Requerido).

% Regla 3
?- cuello_botella(IdCpu, IdGpu, Mensaje).
?- configuracion_equilibrada(IdCpu, IdGpu).

% Regla 4
?- recomendar(30000, Cpu, Mb, Ram, Gpu, Psu, Total).
?- recomendar_perfil(gaming, 30000).
?- recomendar_perfil(ia, 60000).

% Diagnóstico completo de una configuración
?- diagnosticar(Cpu, Mb, Ram, Gpu, Psu, gaming).
```

Para buscar un Id por nombre:

```prolog
?- cpu_id('Ryzen 5 5600', Id).
?- gpu_id('GeForce RTX 4090', Id).
```

## Ejemplo de uso

Recomendación para gaming con $30,000 MXN, sin preferencia de marca ni de RAM:

```
Mejor equipo para gaming con presupuesto de $30,000 MXN:
  CPU    : Intel Core i5-12600K (lga1700, 10N/16H)  $4,500
  Placa  : ASUS PRIME B760M-A WIFI (lga1700, ddr5)  $3,060
  RAM    : G.Skill ddr5 32GB 7200MHz  $3,060
  GPU    : AMD Radeon RX 7900 XTX, 24GB VRAM (PCIe 4.0)  $16,200
  Fuente : Corsair CV650 650W 80+ bronze  $1,170
  TOTAL  : $27,990 MXN
```

## Notas

- La búsqueda de la mejor configuración revisa miles de combinaciones y puede tardar unos segundos con presupuestos altos.
- El menú se inicia al cargar el archivo, así que ejecutar `swipl -g demo hw_expert.pl` sin teclado conectado termina el programa. Para ver la demo usa la opción 8 del menú o escribe `?- demo.` después de salir con `0`.
- Los precios y especificaciones son aproximados y se usan con fines académicos.

## Estructura

```
hw_expert.pl   % base de conocimientos, reglas y menú
README.md      % este archivo
```