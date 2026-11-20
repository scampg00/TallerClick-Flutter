# Memoria v5 — actualización de la semana 5

**Estado: versión preparada para revisión del equipo, 20/11/2026.** Esta sección actualiza el borrador de la semana 5 de la memoria provisional. Las semanas 1–4 se conservan como antecedentes: sus resultados describen las versiones y prototipos examinados entonces.

Las imágenes y simulaciones de las páginas 16–17 corresponden al prototipo HTML de la semana 4, anterior a la aplicación Flutter. Sus textos, colores y botones muestran ese diseño histórico; las capturas de la página 23 representan la versión Flutter 1.0.1.

## 1. Implementación y alcance

TallerClick dispone de una implementación Flutter integrada para buscar un taller y elegir un servicio (R1), seleccionar fecha y hora, introducir contacto, revisar y confirmar una reserva (R2), y consultar, modificar o cancelar una cita (R3). El catálogo usa barrios de León; los talleres, direcciones y datos de prueba son ficticios. Las reservas se mantienen en memoria mientras la aplicación está abierta y se reinician al cerrar el proceso. No hay backend, cuentas, pagos ni conexión con talleres reales.

La versión 1.0.1, compilación 2, organiza las citas confirmadas y canceladas en apartados distintos. La cita cancelada conserva referencia y detalle, muestra estado escrito, icono y borde, y deja de ofrecer acciones de cambio y cancelación. La selección de una hora se expresa mediante texto y control de selección; al cambiar una cita, la franja original se identifica como «Tu hora actual». Las operaciones conservan la referencia y comprueban la disponibilidad antes de aplicarse. La cancelación exige una confirmación con una opción para mantener la cita.

## 2. Accesibilidad y validación técnica

La interfaz utiliza controles Material, textos en español, servicios con descripción breve, mensajes por campo y un resumen antes de confirmar. Las fechas y horas disponibles y ocupadas, la selección, los errores y los estados se expresan con texto además de sus estilos visuales. El formulario conserva datos válidos al corregir un error y el teléfono informa del formato esperado.

La documentación de la versión 1.0.1 registra en Windows, con Flutter 3.47.4 y Dart 3.13.3, **20 pruebas automatizadas superadas** mediante `flutter test` y `dart analyze lib test` sin incidencias. Incluyen búsqueda, selección, validación, reserva única, consulta, cambio, cancelación, navegación y aislamiento de citas. La suite integrada incluye pruebas con texto normal y al 200 % a 390 × 844 píxeles lógicos y guías automáticas de Flutter para etiquetas, áreas táctiles y contraste de texto en los estados comprobados. El `flutter analyze` del 19/11/2026 falló al inicializar en una ruta con caracteres no ASCII; ese resultado no se presenta como aprobado.

En la paleta, el texto `#123A4A` sobre blanco mide 12,14:1 y sobre `#F1F6F7` 11,14:1; el par `#415B67` sobre blanco mide 7,20:1. Estas mediciones y las guías automáticas no acreditan todos los bordes, iconos, focos o combinaciones efectivamente renderizadas. Las vistas largas requieren desplazamiento. Las capturas del repositorio son renderizados de widgets o capturas del emulador, no fotografías del OPPO.

## 3. Pruebas en Android y TalkBack

El 18/11/2026 se compiló, instaló y recorrió una versión anterior en un emulador Android 35 x86_64, con texto normal y al 200 %, mediante pulsaciones enviadas por ADB e inspección del árbol de accesibilidad. Se recorrieron búsqueda, reserva, cambio y cancelación, y se guardaron capturas del resultado. Esta prueba no acredita revisión visual exhaustiva ni escucha de TalkBack: el emulador se ejecutó sin audio.

El 20/11/2026 Santiago comunicó que había probado la versión 1.0.1 en un OPPO A98 5G y que funcionaba correctamente, incluido el texto al 200 % y TalkBack con audio. Hugo trasladó después que Santiago completó un recorrido de reserva con TalkBack y no encontró incidencias. No se comunicaron correcciones derivadas de esa prueba. Se registra como confirmación del responsable, no como ejecución del asistente en ese teléfono. No se facilitaron capturas nuevas del OPPO, grabaciones, transcripciones de los anuncios ni versiones de Android, ColorOS o TalkBack; el 200 % se recoge según su confirmación, sin atribuir una medición ADB.

## 4. Revisión cruzada y pendientes

El Excel original del Grupo E documenta ocho incidencias del prototipo HTML de la semana 4: una alta, cuatro medias y tres bajas. En Flutter se incorporaron comprobaciones para evitar confirmaciones repetidas, distinguir la hora actual, rechazar contacto inválido y mantener el estado tras cancelar. Se comparó cada caso con el código y las pruebas disponibles. La revisión del prototipo anterior no equivale a repetirla en Flutter y las ocho incidencias no se declaran cerradas sin validación conjunta.

Siguen pendientes la validación final del coordinador y de los demás responsables; la asignación y cierre formal de las incidencias del Grupo E; la comprobación detallada de foco, etiquetas y anuncios con TalkBack cuando corresponda; y la revisión completa de contrastes y estados sin depender del color. No se declara conformidad global de accesibilidad ni se atribuyen capturas o mediciones no realizadas. El equipo conserva el seguimiento por tarea.

## 5. Evidencias para la entrega

- **Pruebas automatizadas:** 20 pruebas superadas en Flutter 1.0.1; incluyen creación única, cambio, cancelación y regreso a Mis citas.
- **Texto aumentado:** recorrido de widgets al 200 % y capturas comparativas de búsqueda, horarios y cancelación. Las vistas largas permiten desplazamiento.
- **Emulador Android:** búsqueda, reserva, cambio y cancelación comprobados mediante ADB, con escala normal y al 200 % en una versión anterior.
- **TalkBack:** Santiago confirmó un recorrido completo de reserva en OPPO A98 5G, sin incidencias comunicadas. No se registraron frases anunciadas ni correcciones derivadas de esa prueba.
- **Revisión cruzada:** ocho incidencias del prototipo HTML comparadas con Flutter; su cierre formal y la revisión detallada del foco siguen pendientes.

Para reproducir las pruebas técnicas desde la raíz del repositorio: `flutter pub get`, `flutter test` y `dart analyze lib test`. Registrar sistema, versión del SDK, dispositivo y salida real; en Android seguir la guía de pruebas con datos ficticios.

Repositorio del proyecto: https://github.com/scampg00/TallerClick-Flutter
