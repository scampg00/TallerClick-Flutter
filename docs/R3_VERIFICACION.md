# R3 — Consulta, cambio y cancelación

Implementación para Adrián Doncel Casado, 2026-11-18. Pendiente de validación del responsable y de Hugo; no se atribuye su aprobación.

## Comportamiento y archivos

- `lib/main.dart` conecta «Mis citas» de inicio al mismo repositorio de R2 y permite inyectarlo para las pruebas.
- `lib/screens/my_appointments_screen.dart` muestra referencia, estado escrito, resumen y acceso al detalle. Se actualiza al cambiar el repositorio.
- `lib/screens/appointment_detail_screen.dart` permite elegir nueva fecha/hora, revisar los datos actuales y propuestos y confirmar. Cancelar exige resumen y «Sí, cancelar cita», con salida «No, mantener mi cita». Volver antes de confirmar no cambia la reserva.
- `lib/widgets/appointment_slot_picker.dart` comparte días y horarios entre R2 y R3; muestra «Disponible» y «Ocupada», con selección única por pulsación. Cambiar de día borra la selección.
- `lib/widgets/appointment_summary.dart` comparte las etiquetas de estado, fechas y resumen.
- `lib/data/appointment_repository.dart` mantiene citas en memoria, notifica cambios y permite `find(reference)`, `reschedule(expected, slot)` y `cancel(expected)`. Los nuevos métodos devuelven `bool`: falso si la cita cambió desde la revisión, ya está cancelada o la nueva franja no está disponible. Cada operación es síncrona y reemplaza la instantánea inmutable conservando referencia y datos de contacto. Una instantánea antigua no puede modificarse ni cancelarse de nuevo.
- La cancelación conserva la cita visible con estado «Cita cancelada» y libera su franja. La modificación conserva la referencia y muestra un aviso escrito persistente. Los errores y resultados del detalle usan `Semantics(liveRegion: true)`.
- Al regresar desde «Mis citas», la confirmación de R2 recupera los datos actuales, para evitar mostrar la fecha o el estado anteriores.

El contrato ampliado queda preparado para revisión de Hugo. No se añaden dependencias, backend ni almacenamiento persistente entre reinicios; no se cambia la paleta.

## Verificación reproducible

Entorno de esta sesión: Ubuntu 20.04.6 LTS en WSL2. Ejecución con Flutter en el SDK disponible; consultar versión con `flutter --version`.

```sh
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
flutter devices
```

Las pruebas de `test/appointment_management_test.dart` verifican:

1. Cambio manteniendo referencia y número de citas; liberación de la franja anterior; aislamiento de otra reserva; rechazo de operaciones con una instantánea antigua y de cambios en citas canceladas.
2. R1 → reserva → volver al inicio → Mis citas → detalle → cambiar → revisar → confirmar → cancelar → mantener → cancelar y confirmar → volver al listado. Se ejecuta a 390 × 844 con texto al 100 % y al 200 %.
3. Una franja ocupada no se selecciona; volver desde la revisión no aplica el cambio; dos llamadas a confirmar o cancelar producen una sola operación.
4. Si otra cita ocupa la nueva franja durante la revisión, el error persiste, la reserva original no cambia y se puede volver a elegir.
5. Guías automáticas de objetivos táctiles y etiquetas en cancelación/listado; las pruebas anteriores conservan las comprobaciones de R1 y R2. Esto no sustituye TalkBack ni demuestra todos los contrastes y focos de todas las pantallas.

Resultados finales de comandos y capturas: ver el apartado de resultados al final de este documento.

## Prueba manual pendiente

Con datos ficticios: Buscar taller → Centro → Taller Demo Plaza → Revisión de batería → continuar → elegir franja → datos de contacto → revisar → confirmar → volver al inicio → Mis citas → ver referencia → cambiar fecha y hora → revisar cambio → confirmar cambio. Comprobar misma referencia y nueva fecha. Cancelar → «No, mantener mi cita» conserva estado; repetir y confirmar cancela. Reabrir el listado y comprobar el estado. Repetir con texto al 200 % y TalkBack, anotando secuencia de foco y anuncios.

`flutter devices` solo detecta Linux; no hay Android conectado en esta sesión. El proyecto no incluye plataforma Linux. No se acredita ejecución manual en Android, TalkBack ni `flutter run`. La revisión del Excel original del Grupo E, la validación conjunta y la integración por Hugo siguen pendientes.

## Capturas de widgets

Capturas generadas por Flutter, no fotografías de un dispositivo. Las vistas largas muestran el área visible después de desplazarse para alcanzar las acciones.

| Vista | Normal | Texto 200 % |
| --- | --- | --- |
| Detalle | [Normal](evidence/r3/detalle-1.0.png) | [200 %](evidence/r3/detalle-2.0.png) |
| Horario | [Normal](evidence/r3/horario-1.0.png) | [200 %](evidence/r3/horario-2.0.png) |
| Revisión | [Normal](evidence/r3/revision-1.0.png) | [200 %](evidence/r3/revision-2.0.png) |
| Confirmación de cancelación | [Normal](evidence/r3/cancelar-1.0.png) | [200 %](evidence/r3/cancelar-2.0.png) |
| Resultado en listado | [Normal](evidence/r3/resultado-1.0.png) | [200 %](evidence/r3/resultado-2.0.png) |

Para regenerar con fuentes del SDK:

```sh
CAPTURE_EVIDENCE=1 FLUTTER_ROOT="<ruta al SDK Flutter>" flutter test --no-pub test/appointment_management_test.dart
```

## Resultados de esta entrega (2026-11-18)

- Flutter 3.47.4 stable, Dart 3.13.3.
- `flutter analyze --no-pub`: sin incidencias.
- `CAPTURE_EVIDENCE=1 FLUTTER_ROOT="<SDK>" flutter test --no-pub`: 14 pruebas superadas y diez capturas generadas (normal/200 %). Revisadas visualmente la revisión ampliada y el resultado normal.
- `git diff --check`: sin errores de espacios.
- `flutter devices`: solo Linux; Android y TalkBack pendientes.
- No se ejecutó `flutter run` ni se fusionó o publicó una PR.
- Casillas de `TASKS.md` conservadas: implementación y evidencias disponibles para revisión, sin atribuir confirmaciones a los responsables.

## Corrección de regreso al listado (2026-11-19)

«Volver a Mis citas» cerraba primero el paso interno de edición o cancelación porque usaba `Navigator.maybePop` y quedaba interceptado por `PopScope`. Ahora la acción explícita usa `Navigator.pop` para regresar al listado con una pulsación desde detalle, horarios, revisión del cambio y confirmación de cancelación. Atrás del sistema y la flecha de la barra conservan el regreso entre pasos; salir al listado descarta las propuestas sin confirmar y conserva la cita original.

Se añadieron dos pruebas de regreso directo, con escala 1 y 2 a 390 × 844 píxeles lógicos, y una prueba de Atrás del sistema. Las primeras comprueban las cuatro vistas y que la cita mantiene su referencia, datos y estado sin operaciones adicionales. La última comprueba revisión → horarios → detalle y confirmación de cancelación → detalle antes de salir al listado.

Verificación en Windows, Flutter 3.47.4 y Dart 3.13.3: `flutter test test/appointment_management_test.dart` superó ocho pruebas; `flutter test` superó las 19 pruebas de la suite; `dart analyze lib test` no encontró incidencias y `git diff --check` no encontró errores de espacios. En la revisión previa de este entorno, `flutter analyze --no-pub` falló al inicializar por el problema de longitud del mensaje con la ruta no ASCII; no se registra como aprobado aquí.

Para reproducir manualmente: Mis citas → Ver cita → Cancelar cita → Volver a Mis citas. Debe aparecer el listado con una sola pulsación y la cita debe seguir confirmada. Repetir desde Cambiar fecha y hora y desde Revisa el cambio, y comprobar que la fecha y hora originales se mantienen. Las pruebas automatizadas incluyen también texto al 200 %; esta corrección no se ha vuelto a ejecutar en Android ni con TalkBack.
