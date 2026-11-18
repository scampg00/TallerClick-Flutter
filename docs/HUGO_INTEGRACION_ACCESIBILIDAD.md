# Integración y revisión de accesibilidad — Hugo

Revisión del código y de las evidencias existentes, 2026-11-18. Este registro no constituye la validación del coordinador ni sustituye una ejecución en dispositivo.

## Integración y contratos (H02–H07)

La aplicación utiliza `Workshop` y `WorkshopService` en `lib/models`, y `Appointment` y `AppointmentRepository` en `lib/data/appointment_repository.dart`. El repositorio conserva las citas en memoria durante la ejecución: `book` comprueba disponibilidad y crea una referencia; `appointments` y `find` permiten consultar; `reschedule` y `cancel` rechazan instantáneas antiguas y operaciones sobre citas canceladas. Todos los servicios de un mismo taller comparten capacidad por franja.

Por inspección, `TallerClickApp` proporciona la misma instancia a la entrada de reserva y a «Mis citas». La selección de taller y servicio pasa de la ficha a `BookingPendingScreen`, que abre `BookingScreen`. El detalle usa el mismo repositorio para modificar y cancelar. El tema define el color principal `#123A4A`, fondo blanco y tarjetas `#F1F6F7`; la navegación utiliza `Navigator` y botones de regreso. Esto describe el contrato implementado, no demuestra que haya sido acordado con los responsables ni que todas las rutas se hayan ejecutado manualmente.

La [verificación integrada anterior](R3_VERIFICACION.md) registra 14 pruebas superadas, incluido el recorrido completo y operaciones repetidas. Las 14 pruebas se han repetido satisfactoriamente en esta sesión; queda pendiente validar los recorridos manualmente con el equipo.

## Semántica y mensajes (H08, H12)

- Por inspección, búsqueda, ficha, reserva y detalle identifican encabezados con `Semantics`; los resultados de búsqueda, selección, pasos de reserva y mensajes del detalle incluyen regiones activas. Los servicios y horarios disponibles usan controles de selección nativos, y los ocupados muestran «Ocupada» en texto.
- El formulario conserva los controladores al corregir errores y dirige el foco al primer campo inválido. Los mensajes de validación aparecen en los campos. Hay que comprobar con TalkBack que se anuncien y se entiendan al recibir el foco.
- La confirmación muestra referencia y estado. El detalle conserva un mensaje escrito tras modificar o cancelar, y el listado refleja el estado de la cita. Los datos se pierden al reiniciar la aplicación, como indica la interfaz.
- Pendiente comprobar en Android los nombres, roles, estados, orden de foco y anuncios reales; la presencia de `liveRegion` no garantiza por sí sola un anuncio audible. Revisar especialmente el selector de día, errores de formulario y transiciones de confirmación, modificación y cancelación.

## Contraste, áreas táctiles y texto ampliado (H09–H10)

Medición calculada en esta revisión con luminancia relativa sRGB y `(L claro + 0,05) / (L oscuro + 0,05)`:

| Primer plano | Fondo | Relación | Texto normal ≥ 4,5:1 |
| --- | --- | ---: | --- |
| `#123A4A` | `#FFFFFF` | 12,14:1 | Sí |
| `#123A4A` | `#F1F6F7` | 11,14:1 | Sí |
| `#415B67` | `#FFFFFF` | 7,20:1 | Sí |
| `#415B67` | `#F1F6F7` | 6,60:1 | Sí |

Los dos primeros pares están definidos en el tema. Los dos últimos corresponden a la paleta acordada; no se ha demostrado que se utilicen como colores efectivos de texto. Estos cálculos no cubren colores derivados de Material, bordes, iconos, foco o estados de los componentes. La [medición previa de R1](R1_VERIFICACION.md) incluye además el botón relleno efectivo de aquella ejecución. Falta medir las combinaciones efectivamente renderizadas en R2 y R3 y los componentes pertinentes al umbral de 3:1.

Por inspección, los botones principales tienen alturas mínimas explícitas de 48 o 52 píxeles lógicos y las opciones emplean controles Material. Las guías automáticas anteriores cubren pantallas concretas, no todas las áreas táctiles ni los menús desplegados. Ver alcance en [R1](R1_VERIFICACION.md), [R2](R2_VERIFICACION.md) y [R3](R3_VERIFICACION.md).

La prueba adicional [accessibility_integration_test.dart](../test/accessibility_integration_test.dart) supera las guías de Flutter para objetivos táctiles Android, etiquetas y contraste de texto en las porciones renderizadas durante horario, menú de días abierto, contacto y errores, revisión, confirmación, listado, detalle, cambio y cancelación. Se ejecutó a 390 × 844 píxeles lógicos y escala normal. Las guías no miden todos los bordes o iconos, ni garantizan la lectura o el orden con TalkBack; tampoco acreditan el contenido fuera del área inspeccionada.

Las pruebas de widgets anteriores recorrieron R1–R3 con escala 1 y 2 a 390 × 844, y hay capturas normales y ampliadas enlazadas en esos tres registros. Son capturas de widgets, no una revisión manual de Android. El recorrido al 200 % se prob? despu?s en un emulador mediante ADB; queda pendiente una revisi?n visual exhaustiva en todas las pantallas. Ver [registro Android](ANDROID_VERIFICACION.md).

## Comprobación en esta sesión (H01, H11, H13–H16)

- Windows, Flutter 3.47.4 stable y Dart 3.13.3. El SDK está fuera del PATH y necesitó acceso de escritura a su caché. `flutter analyze --no-pub` terminó sin incidencias y `flutter test --no-pub` superó 16 pruebas tras ampliar las regresiones. `flutter devices` detectó Windows, Chrome y Edge; ADB no detectó dispositivos y `flutter emulators` no encontró emuladores.
- `flutter run -d chrome --no-pub --web-port=58671` arrancó la aplicación y el servicio de depuración. Flutter avisó de que el proyecto no tiene configuración web. El arranque no equivale a una revisión manual del recorrido en el navegador.
- Después se instaló Android 35 y se creó el emulador `TallerClick_API35`. La compilación en OneDrive falló por bloqueo de archivos temporales; en un clon fuera de OneDrive la aplicación compiló, se instaló y se recorrió al tamaño predeterminado y con escala 200 %. Detalles y límites en [Android](ANDROID_VERIFICACION.md).
- No se ha probado TalkBack. Posteriormente el usuario facilitó el Excel original: se han transcrito las ocho incidencias y comparado con Flutter en [este registro](GRUPO_E_REVISION_FLUTTER.md), sin atribuir responsables ni validación.
- El usuario también facilitó la memoria v5 provisional en PDF. Se ha preparado una [actualización editable](MEMORIA_V5_ACTUALIZACION.md); el PDF original se conserva. No consta una revisión o publicación nueva de PR, ni se han marcado casillas o atribuido validaciones al equipo.

## Pasos reproducibles pendientes

1. En un entorno Flutter operativo, ejecutar `flutter --version`, `flutter pub get`, `flutter analyze`, `flutter test`, `flutter devices` y `flutter run -d <dispositivo>`. Registrar versión, plataforma, salida y cualquier fallo.
2. En Android, completar el recorrido descrito en [R3](R3_VERIFICACION.md), con texto normal y al 200 %. Capturar vistas y anotar cualquier acción inaccesible o texto cortado.
3. Con TalkBack activado, recorrer búsqueda → selección de servicio → reserva → consulta → modificación → cancelación. Registrar el orden de foco y las frases anunciadas para controles, errores y resultados. Comprobar «No, mantener mi cita» antes de confirmar la cancelación.
4. Medir colores efectivos de texto y componentes, incluidos estados y bordes, y comprobar áreas táctiles de controles y menús. Registrar pantalla, par de colores, relación y tamaño medido.
5. Validar con el equipo las ocho incidencias transcritas del Excel en `TASKS.md`, asignar responsables y completar las comprobaciones pendientes. Integrar la propuesta de actualización en la Memoria v5 editable a partir de los resultados reales.
