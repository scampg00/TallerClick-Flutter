# R1 — Implementación y verificación

**Actualización 2026-11-18:** la entrada real a R2 ya está conectada y cubierta por `widget_test.dart` y por el recorrido integrado de `appointment_management_test.dart`. «Mis citas» de inicio conecta con R3. El texto que sigue conserva el registro histórico de R1; sus referencias a destinos provisionales corresponden a esa entrega. Resultados actuales y pendientes en [R3_VERIFICACION.md](R3_VERIFICACION.md).

Fecha de ejecución: 2026-11-17. Responsable del recorrido: Santiago Campos García.

## Resultado y alcance

Se puede abrir Buscar taller, filtrar por zona, consultar un taller y elegir un único servicio. El listado conserva la búsqueda al volver desde una ficha, y la ficha conserva el servicio al regresar desde la siguiente pantalla. Al abrir otra ficha no se hereda la selección anterior.

La entrada de R2 está preparada mediante `bookingPageBuilder`. Se verifica con una pantalla de prueba que recibe los objetos correctos del catálogo. En la app, mientras no se suministre el constructor de R2, `BookingPendingScreen` muestra la selección y explica que la reserva todavía no está disponible y que no se ha creado ninguna cita. Esto no acredita la integración T01 con Isaac ni implementa R2 o R3.

La base de esta implementación es la [PR #1](https://github.com/scampg00/TallerClick-Flutter/pull/1), que publicó las decisiones y fue fusionada. Santiago delegó la decisión técnica y posteriormente indicó continuar. No se atribuye una revisión o aprobación a Hugo o Isaac.

## Archivos

| Archivo | Cambio |
| --- | --- |
| `lib/models/workshop.dart` | Modelo sencillo de taller. |
| `lib/models/workshop_service.dart` | Modelo sencillo de servicio. |
| `lib/data/workshop_catalog.dart` | Cuatro talleres ficticios, cinco servicios y cuatro zonas, incluida Oeste sin resultados. |
| `lib/screens/workshop_search_screen.dart` | Selector de zona, búsqueda explícita, listado, resultado vacío y regreso. |
| `lib/screens/workshop_detail_screen.dart` | Ficha resuelta desde el catálogo, selección única, resumen visible y continuación con protección frente a aperturas simultáneas. |
| `lib/screens/booking_pending_screen.dart` | Destino provisional hasta integrar R2; no crea reservas. |
| `lib/main.dart` | Conecta Buscar taller, permite inyectar la entrada de R2 y muestra el aviso de demostración. Conserva los valores del tema y el acceso provisional a Mis citas. Formato normalizado con Dart. |
| `test/widget_test.dart` | Sustituye la prueba del contador por seis pruebas de R1. |

Sin dependencias nuevas ni cambios en las casillas o fechas de `TASKS.md`.

## Entorno y comandos ejecutados

Windows x64. Flutter **3.47.4 stable**, Dart **3.13.3**. `flutter devices` detectó Windows, Chrome y Edge; no detectó ningún dispositivo Android conectado.

| Comprobación | Resultado real |
| --- | --- |
| `dart format lib test` | Archivos formateados; la última ejecución no requirió cambios. |
| `dart analyze lib test` | **No issues found!** |
| `flutter test` | **6 pruebas superadas** en la última ejecución completa. |
| `git diff --check` | Sin errores de espacios en el diff versionado. |
| `flutter analyze` | No completado: el servidor de análisis falla al inicializar con `FormatException: Unexpected end of input`. |
| `flutter analyze --no-pub` desde el alias corto de Windows | Mismo fallo de inicialización. No se registra como aprobado. |
| `flutter run -d chrome --web-port=58671` | Compiló y arrancó la sesión de depuración de Chrome. Flutter mostró el aviso de que el proyecto no tiene configuración web. No se añadieron archivos de plataforma. |

El cliente de análisis de este SDK calcula `Content-Length` usando el número de caracteres del mensaje, mientras el servidor espera bytes. La ruta del proyecto incluye caracteres no ASCII. Se observó el error de inicialización y se revisó ese código del SDK; no se modificó el SDK ni se movió el proyecto. El análisis directo con Dart permitió comprobar `lib` y `test` sin ese fallo.

El control del navegador/ordenador no estuvo disponible en esta sesión. El arranque de Chrome no equivale a una revisión manual de la app en Chrome. Las capturas de abajo proceden de WidgetTester en Windows, con Roboto y Material Icons cargados desde el SDK.

## Cobertura de las seis pruebas

| Prueba | Qué comprueba |
| --- | --- |
| Búsqueda y recuperación | Todas las zonas al entrar; cambiar el selector no aplica la búsqueda hasta pulsar; Centro devuelve dos talleres; Oeste muestra el mensaje vacío; Sur recupera un resultado; Todas las zonas restablece el catálogo. |
| Selección y regreso | Plaza ofrece solo sus servicios; continuar está deshabilitado sin selección; elegir frenos y después batería deja batería seleccionada; la pantalla inyectada recibe los objetos correctos; al volver se conserva la selección y la zona; otra ficha empieza sin selección. |
| Continuación provisional | Muestra taller y servicio y el aviso de que no se ha creado ninguna cita; permite volver a la selección. |
| Referencia inválida | Un identificador de taller inexistente muestra recuperación, no abre R2 y permite regresar. |
| Texto al 200 % | Recorrido de búsqueda, ficha, selección, continuación y regreso a 390 × 844 píxeles lógicos sin excepciones de diseño y con acciones alcanzables mediante desplazamiento. |
| Guías de accesibilidad Flutter | Inicio, búsqueda y ficha: `androidTapTargetGuideline`, `labeledTapTargetGuideline` y `textContrastGuideline`. Es una comprobación automática de los elementos renderizados, no una prueba con TalkBack. |

La referencia de taller inexistente se prueba. La interfaz no permite seleccionar servicios ajenos al taller, pero no se ha realizado una prueba independiente que fuerce una referencia de servicio inválida ni una prueba específica de doble pulsación.

## Contraste y capturas

Medición con `Color.computeLuminance` y la fórmula `(L_mayor + 0,05) / (L_menor + 0,05)`. Son pares concretos del tema existente, que no se ha cambiado:

| Par | Contraste |
| --- | --- |
| Texto `#123A4A` / fondo `#FFFFFF` | 12,14:1 |
| Texto `#123A4A` / superficie `#F1F6F7` | 11,14:1 |
| Texto `#FFFFFF` / fondo efectivo del FilledButton `#146683` | 6,45:1 |

El color efectivo del FilledButton procede de `ColorScheme.fromSeed` del tema original. Estas mediciones y la guía automática de texto no acreditan la revisión manual de todos los bordes, estados, focos o combinaciones de R1–R3.

Capturas a 390 × 844 píxeles lógicos, escala de texto 1 y 2. Se revisaron visualmente. Las vistas ampliadas muestran una parte del contenido después de desplazarlo; el corte en el borde del viewport corresponde al desplazamiento y no a una tarjeta de altura fija.

| Vista | Texto normal | Texto al 200 % |
| --- | --- | --- |
| Búsqueda en Centro | [Captura normal](evidence/r1/search-normal.png) | [Captura ampliada](evidence/r1/search-200.png) |
| Servicio seleccionado en Plaza | [Captura normal](evidence/r1/service-normal.png) | [Captura ampliada](evidence/r1/service-200.png) |

## Reproducción y trabajo pendiente

Ejecutar en la raíz del proyecto:

```sh
flutter --version
dart analyze lib test
flutter test
flutter devices
flutter run -d <identificador-del-dispositivo>
```

Comprobación manual propuesta: Buscar taller → Centro → Buscar talleres → Ver taller: Taller Demo Plaza → Revisión de batería → Continuar con este servicio → Volver a los servicios → Volver a los talleres. Repetir con Oeste para comprobar el mensaje sin resultados y con texto al 200 % para comprobar desplazamiento y lectura.

Pendientes: revisión de contratos con Hugo e Isaac; conexión real con R2 y prueba T01; ejecución manual en Android; TalkBack; verificación manual completa de contraste y controles; revisión del Excel original del Grupo E. No se afirma que sus incidencias estén corregidas.

No se han cerrado tareas de `TASKS.md`: faltan integración y validación del responsable y del coordinador según sus criterios.
