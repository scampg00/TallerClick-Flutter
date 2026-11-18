# TallerClick — Tareas de desarrollo y verificación (semana 5)

**Estado actualizado (2026-11-18):** R1 y R2 conectados; implementado R3 (consulta, cambio y cancelación). «Mis citas» de inicio usa el repositorio compartido. Evidencias y límites en [R3_VERIFICACION.md](docs/R3_VERIFICACION.md). Pendientes validación de responsables y coordinador, Android, TalkBack y Excel del Grupo E. Las casillas pendientes se conservan hasta esa validación.

**Cómo usar la tabla:** una fila está completada solo cuando su resultado y evidencia existen. Cambiar `[ ]` a `[x]`, escribir fecha `AAAA-MM-DD` y poner ruta de captura, prueba, commit o PR. Una revisión pendiente no equivale a un aprobado.

## 0. Coordinación: contratos compartidos (Hugo, antes de programar recorridos)

| Hecho | ID | Tarea concreta | Criterio para cerrar | Fecha completado | Evidencia / PR |
|:---:|---|---|---|---|---|
| [ ] | H01 | Clonar y ejecutar proyecto Flutter; registrar SDK y plataforma | Arranca sin error en entorno indicado | — | — |
| [ ] | H02 | Acordar estructura de carpetas y nombres de pantallas | R1–R3 pueden importar los módulos sin conflicto | — | — |
| [ ] | H03 | Definir `Taller`, `Servicio`/tipo de servicio y `Cita` con identificador, fecha, hora, estado y datos mínimos | Modelos compartidos compilados | — | — |
| [ ] | H04 | Implementar almacenamiento local/en memoria y contrato único para crear, listar, modificar y cancelar | API sencilla acordada con Isaac y Adrián | — | — |
| [ ] | H05 | Configurar `ThemeData` con paleta y tipografía de v4 | Misma apariencia en pantallas de prueba | — | — |
| [ ] | H06 | Configurar navegación base, volver y rutas entre R1–R3 | Se puede ir y regresar sin perder contexto | — | — |

## 1. Santiago Campos García — R1: búsqueda de taller y elección de servicio

| Hecho | ID | Tarea concreta | Criterio para cerrar | Fecha completado | Evidencia / PR |
|:---:|---|---|---|---|---|
| [x] | S01 | Crear pantalla de inicio con «Buscar taller» y «Mis citas» | Accesos visibles, legibles y navegables | 2026-11-17 | [Inicio](lib/main.dart), [pruebas](test/widget_test.dart) y [PR #2](https://github.com/scampg00/TallerClick-Flutter/pull/2). «Mis citas» conectado al repositorio en la entrega R3; pendiente validación conjunta. |
| [x] | S02 | Preparar catálogo de talleres ficticios con zona, dirección, servicios | Datos coherentes y sin API externa | 2026-11-17 | [Catálogo local](lib/data/workshop_catalog.dart): cuatro talleres y cinco servicios con descripción; [PR #2](https://github.com/scampg00/TallerClick-Flutter/pull/2). |
| [x] | S03 | Implementar selección de zona y listado de talleres | R1 permite encontrar una opción | 2026-11-17 | [Búsqueda](lib/screens/workshop_search_screen.dart), [captura](docs/evidence/r1/search-normal.png) y prueba de filtrado y recuperación en [widget_test.dart](test/widget_test.dart); [PR #2](https://github.com/scampg00/TallerClick-Flutter/pull/2). |
| [x] | S04 | Construir ficha de taller con descripción sencilla de servicios | Sin jerga técnica sin explicar | 2026-11-17 | [Ficha](lib/screens/workshop_detail_screen.dart), [descripciones](lib/data/workshop_catalog.dart) y [captura](docs/evidence/r1/service-normal.png); [PR #2](https://github.com/scampg00/TallerClick-Flutter/pull/2). |
| [ ] | S05 | Permitir seleccionar taller y servicio y transmitir selección a R2 | Isaac recibe datos correctos para reservar | — | Selección única y conexión real con R2 implementadas y cubiertas por pruebas automatizadas. Pendiente validación de responsables; [registro](docs/R1_VERIFICACION.md). |
| [x] | S06 | Añadir estados sin resultados, carga simulada si aplica y «Volver» | No hay pantallas bloqueadas ni mensajes ambiguos | 2026-11-17 | [Pruebas](test/widget_test.dart) de zona vacía, recuperación, referencia inválida y regreso conservando búsqueda/selección; [PR #2](https://github.com/scampg00/TallerClick-Flutter/pull/2). Catálogo en memoria sin espera simulada. |
| [ ] | S07 | Revisar etiquetas, orden de lectura y botones ≥48×48 en R1 | Revisión manual documentada | — | Superadas las guías automáticas de etiquetas, tamaño táctil y contraste de texto en inicio, búsqueda y ficha. Pendientes revisión manual y orden de lectura con TalkBack; [registro](docs/R1_VERIFICACION.md). |
| [ ] | S08 | Probar R1 y entregar captura + breve registro de ejecución | R1 se completa en dispositivo objetivo | — | Seis pruebas de widgets superadas, capturas normales/al 200 % y arranque en Chrome registrados. Falta ejecución manual completa en Android; [registro y capturas](docs/R1_VERIFICACION.md). |

Actualización solicitada por Santiago el 2026-11-18 tras revisar la entrega. Las fechas de las filas marcadas corresponden a la implementación, las evidencias y la integración del 2026-11-17. Las seis pruebas y `dart analyze lib test` se repitieron el 2026-11-18 con resultado satisfactorio. El coordinador mantiene la validación final; no se atribuye su aprobación ni se cierran tareas de otros integrantes o comprobaciones conjuntas.

## 2. Isaac Caño Calvo — R2: selección de fecha/hora y reserva

| Hecho | ID | Tarea concreta | Criterio para cerrar | Fecha completado | Evidencia / PR |
|:---:|---|---|---|---|---|
| [ ] | I01 | Recibir taller y servicio seleccionados desde R1 | Datos visibles y correctos | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I02 | Crear pantalla de franjas con día y horarios disponibles | Ocupada/deshabilitada en texto, no solo color | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I03 | Implementar selección por toques, sin arrastrar | Se elige una sola franja inequívoca | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I04 | Crear formulario de datos mínimos del usuario | Etiquetas visibles y campos accesibles | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I05 | Validar errores específicos y conservar lo ya introducido | Se corrige sin repetir datos válidos | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I06 | Mostrar resumen completo antes de confirmar | Taller, servicio, fecha, hora y contacto visibles | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I07 | Confirmar **una sola** reserva utilizando contrato compartido | Una pulsación/acción no duplica citas | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I08 | Crear resultado persistente con referencia y estado; salida a «Mis citas» | R2 completo y resultado consultable | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac. |
| [ ] | I09 | Probar errores, franjas ocupadas y botones ≥48×48; entregar evidencias | Casos reproducibles y documentados | — | Implementación y pruebas en [R2](docs/R2_VERIFICACION.md) y [entrega integrada](docs/R3_VERIFICACION.md). Pendiente validación de Isaac y revisión manual Android/TalkBack. |

## 3. Adrián Doncel Casado — R3: consulta, cambio y cancelación

| Hecho | ID | Tarea concreta | Criterio para cerrar | Fecha completado | Evidencia / PR |
|:---:|---|---|---|---|---|
| [ ] | A01 | Crear «Mis citas» con estado, referencia y resumen | Se identifica cada reserva sin depender del color | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |
| [ ] | A02 | Mostrar detalle de una cita y acciones explícitas | «Cambiar» y «Cancelar» claros | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |
| [ ] | A03 | Permitir cambiar fecha/hora usando las franjas compartidas | No se admiten horarios ocupados | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |
| [ ] | A04 | Mostrar resumen y pedir confirmación antes de cambiar | Usuario revisa cambio antes de aplicarlo | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |
| [ ] | A05 | Crear confirmación contextual de cancelación con «No, mantener mi cita» | No se cancela por pulsación accidental | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |
| [ ] | A06 | Actualizar estado de la cita y mostrar resultado escrito persistente | No hay citas duplicadas o estados inconsistentes | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |
| [ ] | A07 | Impedir reservas duplicadas y dobles operaciones al volver atrás | Prueba demuestra una sola cita y estado correcto | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |
| [ ] | A08 | Revisar semántica, orden de foco y objetivos táctiles de R3 | Revisión manual documentada | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente revisión manual y TalkBack. |
| [ ] | A09 | Probar modificar/cancelar, error y regreso; entregar capturas | R3 completo con evidencias | — | [Código, pruebas y capturas R3](docs/R3_VERIFICACION.md). Pendiente validación de Adrián y coordinación. |

## 4. Hugo Esteban Monje — integración, accesibilidad y coordinación

| Hecho | ID | Tarea concreta | Criterio para cerrar | Fecha completado | Evidencia / PR |
|:---:|---|---|---|---|---|
| [ ] | H07 | Integrar R1, R2 y R3 manteniendo contratos y rutas | La app compila y los tres recorridos se ejecutan | — | — |
| [ ] | H08 | Revisar componentes semánticos (`Semantics`, `MergeSemantics` si procede) | Nombres/roles/estados correctos en elementos clave | — | — |
| [ ] | H09 | Comprobar contraste de combinaciones usadas y áreas táctiles ≥48×48 | Medidas registradas y fallos anotados | — | — |
| [ ] | H10 | Coordinar prueba de texto al **200 %** con capturas normal/ampliado | R1–R3 utilizables, o incidencias registradas | — | — |
| [ ] | H11 | Coordinar prueba **TalkBack** en al menos un recorrido | Secuencia y observaciones anotadas | — | — |
| [ ] | H12 | Verificar el anuncio y la persistencia de errores/éxitos | Mensaje entendible visualmente y con lector | — | — |
| [ ] | H13 | Ejecutar `flutter analyze`, `flutter test` y documentar resultado | Registro reproducible (no basta con ejecutar) | — | — |
| [ ] | H14 | Coordinar validación de 8 incidencias del Grupo E | Cada incidencia con corregida/no corregida, evidencia y responsable | — | — |
| [ ] | H15 | Revisar PRs y publicar versión integrada en GitHub | Código fuente disponible y revisado | — | — |
| [ ] | H16 | Coordinar evidencias y actualizar **Memoria v5** | Documento refleja pruebas reales y pendientes | — | — |

## 5. Control de integración y revisión conjunta

| Hecho | ID | Responsables | Comprobación | Fecha completado | Evidencia / PR |
|:---:|---|---|---|---|---|
| [ ] | T01 | Santiago + Isaac | Paso de taller/servicio de R1 a R2 sin pérdida de datos | — | Cubierto por pruebas automatizadas en [entrega R3](docs/R3_VERIFICACION.md); pendiente validación conjunta y ejecución manual. |
| [ ] | T02 | Isaac + Adrián | Nueva reserva visible en Mis citas, mismo ID y estado | — | Cubierto por pruebas automatizadas en [entrega R3](docs/R3_VERIFICACION.md); pendiente validación conjunta y ejecución manual. |
| [ ] | T03 | Adrián + Hugo | Cancelación/cambio no duplica ni altera otra cita | — | Cubierto por pruebas automatizadas en [entrega R3](docs/R3_VERIFICACION.md); pendiente validación conjunta y ejecución manual. |
| [ ] | T04 | Todos | R1, R2 y R3 completos en Flutter | — | Cubierto por pruebas automatizadas en [entrega R3](docs/R3_VERIFICACION.md); pendiente validación conjunta y ejecución manual. |
| [ ] | T05 | Todos | Ejecutar al menos una prueba con TalkBack y dejar constancia de la secuencia | — | — |
| [ ] | T06 | Todos | Texto 200 %, errores, color y objetivos táctiles revisados | — | — |
| [ ] | T07 | Hugo + todos | Cerrar incidencias del Grupo E y comprobar de nuevo | — | — |

## 6. Registro de incidencias (sin atribuir soluciones no realizadas)

La evaluación cruzada del **Grupo E** registró 8 incidencias: 1 alta, 4 medias y 3 bajas. Se requiere revisar el Excel original y copiar aquí el detalle exacto para asignar responsables y confirmar correcciones. **No marcar como solucionadas de forma automática.**

| Hecho | Incidencia | Severidad | Responsable asignado | Solución / decisión | Fecha completado | Evidencia |
|:---:|---|---|---|---|---|---|
| [ ] | GE-01 · Pendiente de transcribir | — | — | — | — | — |
| [ ] | GE-02 · Pendiente de transcribir | — | — | — | — | — |
| [ ] | GE-03 · Pendiente de transcribir | — | — | — | — | — |
| [ ] | GE-04 · Pendiente de transcribir | — | — | — | — | — |
| [ ] | GE-05 · Pendiente de transcribir | — | — | — | — | — |
| [ ] | GE-06 · Pendiente de transcribir | — | — | — | — | — |
| [ ] | GE-07 · Pendiente de transcribir | — | — | — | — | — |
| [ ] | GE-08 · Pendiente de transcribir | — | — | — | — | — |

## 7. Definición de terminado

Una tarea NO está terminada solo porque el código exista. Debe compilar, cumplir su criterio de cierre, incluir una comprobación reproducible y una evidencia, estar integrada sin romper otras pantallas y figurar marcada con **fecha real** tras validación.
