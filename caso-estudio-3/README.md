# Proyecto final en parejas — Puntos de detección de ITS en Oaxaca

**Proyecto principal del equipo.** Rama: `trabajo-final-parejas-its`.

**Autores:** Miguel Ángel Hernández Pérez y Yareli. **Materia:** Programación Lógica y Funcional.

## Problema y utilidad social

Una persona quiere saber dónde se ha documentado la detección de VIH, sífilis o hepatitis C en un municipio de Oaxaca, y si existe un horario publicado para el día en que piensa acudir. El programa presenta dirección, contacto y fuente. Puede usarse sin crear cuenta ni compartir síntomas, resultados o datos personales. Una consulta útil sería: «¿Dónde se ha publicado una prueba de sífilis en Huajuapan un sábado?».

Es un **prototipo académico de consulta**, independiente de PuntOax. Su base pequeña se extrajo del trabajo de auditoría del proyecto y se contrastó con las páginas oficiales enlazadas en cada ficha. No se conecta a la base de PuntOax. El corte de revisión es el **29 de octubre de 2026**. Los horarios publicados pueden cambiar: hay que llamar antes de desplazarse. La ausencia de un horario es información **por confirmar**, nunca una afirmación de que el lugar esté cerrado. El prototipo no da diagnósticos ni evalúa síntomas; tampoco incluye jornadas móviles ni servicios de ILE.

## Ejecutar

Requiere SWI-Prolog:

```bash
cd caso-estudio-3
swipl -s orientador_its.pl -g menu -t halt
```

Menú: `1` busca por municipio, prueba y día; `2` muestra sedes por prueba; `3` lista sedes por municipio; `4` explica alcance y consultas; `0` sale. Acepta números completos en cada paso y repite una entrada inválida.

También se pueden hacer consultas lógicas:

```prolog
?- [orientador_its].
?- ofrece_en(Id, huajuapan, sifilis).
?- opcion_con_horario(Id, huajuapan, sifilis, sabado, Inicio, Fin).
?- estado_horario(imedi, martes, Estado).
```

Pruebas:

```bash
swipl -q -s pruebas_orientador_its.pl -g run_tests -t halt
```

## Modelo lógico

| Hecho o regla | Significado |
| --- | --- |
| `sede/4` | Identificador, nombre, municipio y dirección. |
| `deteccion/2` | Prueba documentada por sede. |
| `horario_publicado/4` | Día y franja difundida por una fuente, sin afirmar disponibilidad actual. |
| `contacto/2`, `fuente/2` | Canal para confirmar y enlace de procedencia. |
| `ofrece_en/3` | Une municipio y prueba por identificador de sede. |
| `opcion_con_horario/6` | Une sede, prueba y horario publicado para el día elegido. |
| `opcion_sin_horario_confirmado/4` | Distingue un dato pendiente del horario publicado. |
| `estado_horario/3` | Devuelve `publicado(Inicio, Fin)` o `por_confirmar`. |

El ejercicio usa cuatro sedes y tres pruebas. Se privilegian pocos registros trazables sobre datos inventados para llenar el catálogo. Puede ampliarse con nuevas fichas verificadas sin modificar las reglas. Para el trabajo en pareja, Miguel Ángel puede mantener hechos y referencias; Yareli puede revisar reglas, menú y casos de prueba; ambos deben validar juntos los cambios y explicar la demostración.

## Fuentes y decisiones sobre datos

- Huajuapan: [boletín COESIDA del 30/10/2025](https://www.oaxaca.gob.mx/comunicacion/inaugura-coesida-modulo-para-deteccion-de-infecciones-de-transmision-sexual-en-huajuapan-de-leon/) publica dirección, pruebas y horario, incluido sábado.
- Tlalixtac: [ficha institucional](https://www.oaxaca.gob.mx/administracion/punto-de-deteccion-de-vih-hepatitis-c-y-sifilis/) indica martes y jueves de 10:00 a 14:00. Un [boletín anterior](https://www.oaxaca.gob.mx/administracion/brindan-secretaria-de-administracion-y-coesida-taller-sobre-educacion-sexual-y-prevencion-del-vih/) mostró otro cierre; se usa la ficha del servicio y se recomienda confirmar documentos y horario.
- IMEDI: [apertura del punto permanente](https://www.oaxaca.gob.mx/comunicacion/abre-coesida-capasits-noveno-punto-de-deteccion-permanente-en-instalaciones-de-imedi-oaxaca/) y [relación de puntos](https://www.oaxaca.gob.mx/comunicacion/inaugura-coesida-capasits-nuevo-punto-para-la-deteccion-de-vih-sifilis-y-hepatitis-c-en-la-mixteca/) respaldan pruebas y domicilio. No se afirma horario preciso.
- COESIDA-CAPASITS: [relación de puntos](https://www.oaxaca.gob.mx/comunicacion/inaugura-coesida-capasits-nuevo-punto-para-la-deteccion-de-vih-sifilis-y-hepatitis-c-en-la-mixteca/) y [directorio oficial](https://www.oaxaca.gob.mx/detalle-portal/coesida/) respaldan sede y teléfono. No se equipara el horario administrativo con el de detección.

**Ejemplo para clase:** elegir `1 → 1 (Huajuapan) → 2 (sífilis) → 6 (sábado)` muestra el módulo, la dirección, el contacto y el horario publicado 09:00–14:00 con fuente. Elegir IMEDI para martes muestra *horario por confirmar*, sin presentarlo como cerrado ni abierto.
