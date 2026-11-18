# Revisión de accesibilidad e incidencias — 18/11/2026

## TalkBack

En el emulador Android 35 se activó temporalmente `com.google.android.marvin.talkback/.TalkBackService`; `dumpsys accessibility` confirmó el servicio enlazado con salida hablada. El emulador se ejecuta sin audio y los registros consultados no revelaron las frases pronunciadas. Por tanto no se ha comprobado el orden de lectura, las etiquetas escuchadas ni los anuncios de errores o resultados. Tras la comprobación se restituyó la configuración anterior del emulador. La revisión audible con TalkBack sigue pendiente.

El volcado de Android señaló el campo de nombre vacío como `NAF=true` y no mostró `content-desc` ni texto en los campos de contacto. No basta para afirmar que TalkBack carezca de etiqueta: comprobar directamente el nombre anunciado, rol, error y foco al validar. El selector de día agrupaba varios textos en el árbol de Android; revisar también su lectura real.

## Revisión de capturas

Se inspeccionaron las capturas normales y ampliadas disponibles de búsqueda, ficha y servicio, horarios, error, revisión, confirmación, consulta, cambio, cancelación y resultado. Los textos y controles visibles en las áreas inspeccionadas se distinguen; al 200 % algunos textos pasan a varias líneas y las vistas largas requieren desplazamiento. Las capturas recortadas en el borde muestran una posición del desplazamiento; no demuestran por sí solas que el resto sea accesible o que no haya cortes en todas las posiciones. Las capturas de widgets R1–R3 son anteriores a la nueva etiqueta de hora actual y al texto de ayuda del teléfono. Las dos [capturas del emulador](ANDROID_VERIFICACION.md) muestran el resultado cancelado normal y al 200 %.

Las guías automáticas existentes comprueban contraste de texto, etiquetas y objetivos táctiles en los estados renderizados. Los pares de colores medidos se registran en [integración](HUGO_INTEGRACION_ACCESIBILIDAD.md); siguen sin cubrir todos los bordes, iconos, estados, combinaciones y simulaciones de visión cromática de la app Flutter.

## Incidencias del Grupo E

La comparación completa está en [Grupo E](GRUPO_E_REVISION_FLUTTER.md). Para I01 se ha cambiado el selector compartido: al modificar una cita, su franja figura como «Tu hora actual» y no como «Ocupada», sin hacerla seleccionable. La prueba comprueba esta etiqueta y que no habilita la revisión, tanto al 100 % como al 200 %. La batería completa pasó: 16 pruebas, `flutter test --no-pub`; `flutter analyze --no-pub` sin incidencias. No se ha repetido el recorrido en el APK después de este cambio; el APK instalado y las capturas de horarios previas muestran el comportamiento anterior.

I02 e I03 disponen de comprobaciones automatizadas y del recorrido del emulador; I04 e I05 disponen de errores específicos y prueba de contacto inválido; I07 tiene acciones y opciones equivalentes revisadas por código y capturas. I06 sigue pendiente de una prueba real de foco y anuncios; I08 requiere verificar el reconocimiento de errores y resultados sin color en la versión Flutter. Para todas, la comprobación con TalkBack y la validación de responsables siguen pendientes cuando correspondan. No se han cerrado casillas ni atribuido aprobaciones.
