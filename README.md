# Biblioteca_PLF — Casos de estudio en Prolog

Repositorio de prácticas de Programación Lógica y Funcional organizadas por caso de estudio. Cada caso tiene su propia documentación y archivos; no es necesario mezclar el código de uno con el otro.

## Índice

| Carpeta | Proyecto | Contenido |
| --- | --- | --- |
| [caso-estudio-1/](caso-estudio-1/) | Sistema experto de recomendación de libros | `biblioteca.pl`, README, fuentes editoriales y PDF de la práctica |
| [caso-estudio-2/](caso-estudio-2/) | HW-Expert: configuración y diagnóstico de hardware | `hw_expert.pl`, 50 pruebas documentadas, README y reporte |

## Requisitos

Se recomienda usar **SWI-Prolog**. En Ubuntu, si no está instalado:

```bash
sudo apt update
sudo apt install swi-prolog
```

## Caso 1 — Biblioteca

```bash
cd caso-estudio-1
swipl -s biblioteca.pl -g iniciar -t halt
```

Consulta [la documentación del caso 1](caso-estudio-1/README.md) para ver sus hechos, reglas y otras consultas.

## Caso 2 — HW-Expert

```bash
cd caso-estudio-2
swipl hw_expert.pl
```

Demostración sin menú:

```bash
swipl hw_expert.pl --demo
```

Pruebas automatizadas:

```bash
swipl pruebas_hw_expert.pl
```

Consulta [la documentación del caso 2](caso-estudio-2/README.md) y [su reporte](caso-estudio-2/REPORTE_CASO_ESTUDIO_2.md). Los resultados de pruebas descritos allí son los que registró el entorno de desarrollo; si cambias código, ejecútalas de nuevo.

## Organización y conservación

Esta estructura se preparó para conservar simultáneamente los dos casos de estudio. Los archivos del Caso 1 provienen de la rama `main` y los del Caso 2 de `miguel/mejoras-hw-expert`. El código original de cada caso se trasladó sin modificar su contenido. Las ramas de origen se conservan como respaldo y no se integran ni eliminan automáticamente.
