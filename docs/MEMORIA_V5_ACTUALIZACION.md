# Memoria v5 — propuesta de actualización de la semana 5

Texto editable para integrar en las páginas 21–23 de `Grupo_T-Memoria_v5_provisional.pdf`. Conserva las semanas 1–4 como antecedentes históricos. Es una propuesta para revisión del equipo, no una modificación ni una versión final del PDF original.

## Implementación y alcance

TallerClick dispone de una implementación Flutter integrada para los tres recorridos: búsqueda de taller y servicio (R1), selección de fecha/hora y reserva con resumen (R2), y consulta, cambio y cancelación (R3). El catálogo es ficticio y las citas se mantienen en memoria mientras la aplicación está abierta; no existe conexión con talleres reales, backend ni persistencia entre reinicios. El repositorio compartido comprueba la disponibilidad y las operaciones de cambio y cancelación conservan la referencia.

La interfaz utiliza controles Material, etiquetas en español, confirmación antes de cancelar y estados expresados mediante texto. La reserva valida nombre y teléfono y conserva los datos al corregir. Los resultados incluyen referencia y estado. El código y las decisiones de integración están descritos en [R3](R3_VERIFICACION.md) y en el [registro de Hugo](HUGO_INTEGRACION_ACCESIBILIDAD.md).

## Evidencias y verificación

El [registro de integración del 18/11/2026](HUGO_INTEGRACION_ACCESIBILIDAD.md) recoge una ejecución en Windows, con Flutter 3.47.4 y Dart 3.13.3, en la que `flutter analyze --no-pub` terminó sin incidencias y `flutter test --no-pub` superó 16 pruebas. Cubren la entrega R1→R2, selección de hora, validación y recuperación de errores, confirmación única, consulta, cambio, cancelación y rechazo de operaciones antiguas. El recorrido integrado de widgets se ejecuta a escala normal y al 200 % en 390 × 844 píxeles lógicos; las capturas de widgets están enlazadas en [R1](R1_VERIFICACION.md), [R2](R2_VERIFICACION.md) y [R3](R3_VERIFICACION.md).

La [corrección del 19/11/2026](R3_VERIFICACION.md#corrección-de-regreso-al-listado-2026-11-19) permite volver directamente a Mis citas desde cualquier paso de gestión sin aplicar cambios pendientes. La suite ampliada superó 19 pruebas y el análisis directo con Dart no encontró incidencias. En este entorno, `flutter analyze` falla al inicializar con la ruta que contiene caracteres no ASCII; se distingue ese fallo de herramienta del resultado del análisis directo.

Las guías automáticas de Flutter han comprobado etiquetas y objetivos táctiles en las vistas ensayadas, y contraste de texto en R1 y en las partes renderizadas durante reserva y gestión. Entre los pares de la paleta, `#123A4A` sobre blanco mide 12,14:1 y sobre `#F1F6F7` 11,14:1. Estas pruebas no demuestran todos los colores efectivos, bordes y estados; tampoco sustituyen una evaluación manual o con lector de pantalla.

La aplicación arrancó en Chrome para depuración, con un aviso de que el proyecto no tiene configuración web; no se completó una revisión manual de los recorridos allí. Tras un primer intento de compilación Android sin resultado, el 18/11/2026 se compiló, instaló y ejecutó la app en el emulador `TallerClick_API35`, Android 35 x86_64, desde una copia de trabajo fuera de OneDrive. Se recorrieron R1–R3 con texto normal y al 200 % mediante ADB y se guardaron capturas del resultado cancelado. El [registro Android](ANDROID_VERIFICACION.md) distingue los pasos comprobados por el árbol de accesibilidad de la revisión visual de las capturas; no acredita una evaluación manual exhaustiva ni una ejecución en teléfono físico.

TalkBack se enlazó temporalmente en el emulador, pero sin audio no se verificaron las frases anunciadas ni el orden de lectura. La [revisión de accesibilidad](REVISION_ACCESIBILIDAD.md) mantiene pendiente la prueba audible, especialmente las etiquetas de los campos, el selector de día y los avisos. No se ha realizado una prueba con usuarios en esta fase. El APK utilizado en el recorrido Android es anterior a la etiqueta «Tu hora actual» y a la corrección del regreso directo a Mis citas: estas modificaciones requieren una nueva comprobación en Android.

## Revisión cruzada

El Excel original del Grupo E recoge ocho incidencias del prototipo HTML: una alta, cuatro medias y tres bajas. La [comparación con Flutter](GRUPO_E_REVISION_FLUTTER.md) relaciona cada incidencia con código y pruebas, y mantiene pendientes la verificación con TalkBack, la gestión del foco, la evaluación visual y la validación de los responsables. No se afirma que la revisión del prototipo anterior se haya repetido ni que las ocho incidencias estén cerradas.

## Pendientes antes de la entrega definitiva

- Recompilar la versión actual y repetir R1–R3 en Android, con texto normal y al 200 %, completando la revisión visual de todas las pantallas y estados. Conservar como antecedente el recorrido automatizado y las capturas del 18/11/2026.
- Realizar una prueba con TalkBack y registrar orden de lectura, roles, selección y anuncios de error y resultado.
- Medir las combinaciones efectivas y componentes aún no comprobados, y revisar la presentación de avisos sin color.
- Validar con el equipo las ocho incidencias, los contratos y los recorridos; actualizar `TASKS.md` solo con evidencia y validación.
- Integrar este texto en una versión editable de la memoria, comprobar las capturas y exportar el PDF final cuando corresponda.
