# Comprobación en emulador Android — 2026-11-18

Copia de trabajo: `C:\Users\totti\TallerClick-Flutter`, fuera de OneDrive. Flutter 3.47.4, Dart 3.13.3; emulador `TallerClick_API35`, imagen Google Play Android 35 x86_64, pantalla 1080 × 2400 píxeles físicos y densidad 420 dpi. `flutter run -d emulator-5554` compiló, instaló y abrió la aplicación; el primer plano se comprobó mediante ADB. Datos de prueba ficticios; las citas se guardan en memoria.

Se accionaron controles mediante `adb shell input` y se inspeccionó el árbol de accesibilidad con `uiautomator`; esto no equivale a una evaluación manual por una persona ni a una prueba de lectura con TalkBack.

## Recorrido con escala predeterminada

1. Buscar taller → seleccionar Centro → Buscar talleres → Taller Demo Plaza → Revisión de batería → continuar.
2. Elegir 09:00. Al intentar revisar el formulario vacío aparecieron mensajes distintos para nombre y teléfono; después se introdujeron Ana Demo y 600123456. El resumen mostró taller, servicio, fecha, hora y datos; se confirmó la cita TC-0001.
3. Ir a Mis citas → ver TC-0001 → cambiar a 11:00 → revisar y confirmar. El resumen mostró primero 09:00 y después 11:00 manteniendo la referencia. Al cambiar, la franja de las 09:00 aparece como «Ocupada» mientras la hora actual figura en el resumen: revisar claridad con el equipo y TalkBack.
4. Cancelar → «No, mantener mi cita» → cancelar de nuevo → confirmar. Se mostró «Cita cancelada», TC-0001 y 11:00. [Captura normal](evidence/android/cancelada-normal.png).

## Escala del sistema 200 %

Se ajustó `settings put system font_scale 2.0`, se reinició el proceso de demostración y se repitieron búsqueda por Centro, ficha, selección de servicio, reserva a las 09:00, consulta, cambio a las 11:00 y cancelación, alcanzando los botones mediante desplazamiento. Se mostró TC-0001 con la hora actualizada y estado cancelado. [Captura ampliada del resultado](evidence/android/cancelada-200.png). Se revisó visualmente esta captura; los demás pasos se inspeccionaron mediante el árbol de Android, por lo que no se afirma revisión visual exhaustiva ni ausencia de recortes en todas las vistas.

## Límites y observaciones

- TalkBack está instalado, pero el emulador arrancó sin audio. No se verificaron los anuncios ni el orden de navegación del lector; siguen pendientes con audio y una persona que los escuche.
- El árbol `uiautomator` mostró el campo de nombre vacío como `EditText` sin `content-desc` ni texto y con `NAF=true`; el campo de teléfono también apareció sin esos atributos. Esto es una señal para revisar los nombres anunciados por TalkBack, no una conclusión sobre lo que anuncia el lector: Android puede exponer otra información semántica que ese volcado no refleja.
- La franja actual aparece como «Ocupada»; el resumen indica su hora. Conviene comprobar si distinguir «Tu hora actual» evita confusión (incidencia I01).
- Las acciones destructivas y datos corresponden al prototipo local. No se probó Android en un teléfono físico ni se evaluaron todos los tamaños, colores y estados.
- Para repetir: iniciar `TallerClick_API35` con Android Studio, ejecutar `flutter run -d emulator-5554` desde la copia fuera de OneDrive y seguir los pasos anteriores. Ajustar tamaño de fuente en Android y restituirlo al finalizar. Para TalkBack, activar el lector y registrar lo anunciado, el orden de foco, errores y resultados; adjuntar evidencia sin datos reales.
