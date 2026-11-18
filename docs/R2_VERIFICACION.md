# R2 — Reserva y verificación

**Actualización 2026-11-18:** «Mis citas» de inicio ya conecta con el mismo repositorio y R3 permite cambiar y cancelar. Selector y resumen compartidos; contrato ampliado preparado para revisión de Hugo. Ver [entrega R3](R3_VERIFICACION.md). El resto conserva el registro de la entrega inicial de Isaac.

Responsable del recorrido R2: Isaac Caño Calvo.

## Recorrido

1. En «Buscar taller», elige la zona Centro, abre Taller Demo Plaza y selecciona «Revisión de batería».
2. Continúa a la reserva. Elige uno de los siete días ofrecidos, a partir de mañana. Las horas de demostración son 09:00, 10:00, 11:00 y 12:00. La de las 10:00 aparece como «Ocupada» y no admite selección. Cambiar de día borra la selección anterior.
3. Introduce un nombre ficticio y un teléfono. Prueba primero con `123` y corrige a `+34 600 123 456`. El nombre se conserva. El formulario admite de 9 a 15 dígitos y separadores habituales.
4. Revisa taller, servicio, fecha, hora, nombre y teléfono. Al confirmar aparece el estado «Cita confirmada» y la referencia.
5. Abre «Ir a Mis citas» y comprueba que coinciden la referencia y el estado. Vuelve a la ficha e intenta reservar la misma hora en el mismo taller. La hora aparece como ocupada.

La disponibilidad se comprueba otra vez al confirmar. Si la franja se ha ocupado, el usuario puede elegir otra con sus datos ya introducidos. Una doble pulsación sobre la misma confirmación deja una sola cita. Servicios distintos de un mismo taller comparten capacidad por franja.

## Archivos e integración

| Archivo | Función |
| --- | --- |
| [booking_screen.dart](../lib/screens/booking_screen.dart) | Selección, formulario, resumen y confirmación. |
| [appointment_repository.dart](../lib/data/appointment_repository.dart) | Modelo y repositorio de demostración en memoria. |
| [my_appointments_screen.dart](../lib/screens/my_appointments_screen.dart) | Consulta desde la confirmación con la misma instancia del repositorio. |
| [booking_pending_screen.dart](../lib/screens/booking_pending_screen.dart) | Adapta el punto de entrada original de R1 al recorrido de reserva. |
| [booking_test.dart](../test/booking_test.dart) y [widget_test.dart](../test/widget_test.dart) | Pruebas reproducibles del flujo y de su conexión con R1. |

El repositorio conserva las citas al navegar y mientras dura el proceso de la app. Al reiniciar se reinician los datos de demostración. La capacidad del prototipo y la validación de teléfono se decidieron para R2. Hugo aún no ha publicado el contrato de citas para R2–R3. El repositorio en memoria ofrece un punto de conexión provisional para coordinar la entrada «Mis citas» de inicio y la futura gestión con Adrián.

## Comprobaciones

Ejecutadas el **2026-11-18** en Ubuntu 22.04 (WSL), con Flutter **3.47.4** y Dart **3.13.3**.

| Comprobación | Resultado |
| --- | --- |
| `flutter analyze --no-pub` | Sin incidencias. |
| `flutter test --no-pub test/widget_test.dart test/booking_test.dart` | 10 pruebas superadas. Seis de R1 y cuatro de R2. |
| Entrega de R1 a R2 | Se muestran el taller y el servicio elegidos. Al volver, la ficha conserva la selección. |
| Horarios | Ocupación visible por texto. Selección única y reinicio al cambiar de día. El repositorio rechaza una segunda reserva para la misma franja y taller aunque el servicio sea distinto. |
| Formulario | Errores de campos vacíos y de teléfono inválido. Corrección sin perder el nombre. |
| Revisión y confirmación | Resumen completo. Dos llamadas al botón de confirmar producen una sola cita. Consulta con la misma referencia y estado. La hora se muestra ocupada al volver a reservar. |
| Conflicto durante la revisión | Un horario que se ocupa antes de confirmar devuelve a la selección de hora y conserva los datos de contacto. |
| Accesibilidad automatizada | Flujo completo al 200 % en 390 × 844 píxeles lógicos. Guías de Flutter para controles etiquetados y objetivos táctiles de al menos 48 × 48. |
| Android y TalkBack | Pendientes. ADB se inició y no detectó ningún dispositivo conectado. |

Ejecuta `flutter pub get`, `flutter analyze` y `flutter test` desde la raíz. Para la comprobación manual en Android, usa `flutter devices`, abre la app con `flutter run -d <dispositivo>` y sigue los cinco pasos anteriores con TalkBack y con texto ampliado.

## Capturas

Renderizadas con Flutter a 390 × 844 píxeles lógicos, con Roboto y Material Icons. Las pantallas largas permiten desplazamiento.

| Vista | Texto normal | Texto al 200 % |
| --- | --- | --- |
| Horarios | [Normal](evidence/r2/horarios-normal.png) | [Ampliado](evidence/r2/horarios-200.png) |
| Error de contacto | [Normal](evidence/r2/error-normal.png) | [Ampliado](evidence/r2/error-200.png) |
| Revisión | [Normal](evidence/r2/revision-normal.png) | [Ampliado](evidence/r2/revision-200.png) |
| Confirmación | [Normal](evidence/r2/confirmacion-normal.png) | [Ampliado](evidence/r2/confirmacion-200.png) |
| Consulta | [Normal](evidence/r2/consulta-normal.png) | [Ampliado](evidence/r2/consulta-200.png) |

El cierre de las casillas de `TASKS.md` requiere la validación del responsable. La coordinación con Hugo y Adrián sigue pendiente para el contrato definitivo y las operaciones de R3.
