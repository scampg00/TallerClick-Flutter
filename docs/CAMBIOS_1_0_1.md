# TallerClick 1.0.1

Cambios solicitados por Santiago el 2026-11-20 para la siguiente APK de pruebas. Versión 1.0.1, compilación 2; datos de demostración en memoria.

## Citas confirmadas y canceladas

Mis citas muestra primero Citas confirmadas y después Citas canceladas. Una cancelada conserva su referencia y detalle, pero se presenta con icono de calendario cancelado, estado en negrita, fondo blanco y borde oscuro. El texto «Estas citas ya no están activas» explica el significado de la segunda sección. Si solo quedan canceladas, se indica «No tienes citas confirmadas».

Esta presentación permite comprobar la cancelación sin confundirla con una reserva activa. El estado no depende únicamente del color. Se conserva la paleta: `#123A4A` sobre `#FFFFFF` mide 12,14:1; se reutiliza ese par para el borde y el icono de las tarjetas canceladas. Las confirmadas mantienen la superficie del tema.

## Catálogo de León

Los barrios se utilizan como zonas de búsqueda. Los identificadores de talleres y servicios permanecen estables para conservar el contrato con reserva y gestión.

| Taller ficticio | Barrio | Dirección ficticia |
| --- | --- | --- |
| Taller Demo Chantría | La Chantría | Calle de Ejemplo, 10 · León |
| Taller Demo Plaza | La Chantría | Plaza de Muestra, 4 · León |
| Taller Demo Eras | Eras de Renueva | Avenida de Prueba, 22 · León |
| Taller Demo Palomera | La Palomera | Calle del Prototipo, 8 · León |

El Ejido permite comprobar la búsqueda sin resultados. Estos nombres de barrios aparecen en la documentación municipal de León; no se utilizan límites geográficos ni ubicaciones reales de talleres. [Fuente municipal, página 38](https://www.aytoleon.es/es/tu-ayuntamiento/corporaci%C3%B3n/secretaria/Actas%20de%20Pleno/Pleno%20ORDINARIO%20de%2028%20de%20MAYO%20de%202021.pdf#page=38).

El aviso visible explica: «Prototipo para León. Los barrios son reales; los talleres y las direcciones son ficticios». Los cinco servicios conservan sus descripciones.

## Nombre e icono

Android muestra TallerClick en lugar de `flutter_application_1`. El icono combina un coche y una marca de confirmación en blanco y azul oscuro, exportado para las densidades Android y como icono adaptable. Se han preparado también el nombre y los iconos de iOS; no se acredita ejecución en esa plataforma.

El origen es un dibujo vectorial reproducible con `tool/generate_app_icons.py` (Python y Pillow para desarrollo). La app mantiene su identificador Android, lo que permite actualizar una instalación anterior firmada con la misma clave. El cambio de versión aumenta el número de compilación a 2.

## Comprobaciones ejecutadas

- `flutter test`: 20 pruebas superadas en Windows, Flutter 3.47.4 y Dart 3.13.3.
- `dart analyze lib test`: sin incidencias.
- Nueva prueba de listado: una cancelada más reciente aparece después de las confirmadas, conserva su detalle y no puede volver a cancelarse; superadas las guías automáticas de tamaño táctil, etiquetas y contraste en ese estado.
- El recorrido integrado se mantiene a escala normal y al 200 %. Se han adaptado los casos de filtrado al catálogo de León.
- Se revisaron visualmente el icono y seis capturas de widgets a 390 × 844 píxeles lógicos con fuente normal y al 200 %. Las vistas largas requieren desplazamiento.

| Vista | Normal | Texto al 200 % |
| --- | --- | --- |
| Búsqueda por barrio | [Captura](evidence/v1.0.1/leon-normal.png) | [Captura](evidence/v1.0.1/leon-200.png) |
| Inicio del listado | [Captura](evidence/v1.0.1/mis-citas-normal.png) | [Captura](evidence/v1.0.1/mis-citas-200.png) |
| Sección de canceladas | [Captura](evidence/v1.0.1/canceladas-normal.png) | [Captura](evidence/v1.0.1/canceladas-200.png) |

Las capturas son renderizados de Flutter, no del OPPO. La [guía del OPPO A98 5G](PRUEBAS_OPPO_A98.md) explica instalación, tamaño de fuente, comprobación exacta del 200 %, activación y desactivación de TalkBack, gestos y recorrido. El 2026-11-20 Santiago confirmó que había probado la nueva versión, incluido texto al 200 % y TalkBack con audio, con resultado correcto; [registro de su confirmación y límites](PRUEBAS_OPPO_A98.md#resultado-comunicado-por-santiago). Se actualizaron sus tareas S05, S07 y S08. La validación final del coordinador y de los demás responsables sigue pendiente.
