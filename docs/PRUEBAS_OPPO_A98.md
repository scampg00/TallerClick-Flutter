# Pruebas de TallerClick en el OPPO A98 5G

Esta guía sirve para probar TallerClick 1.0.1 en tu móvil con texto aumentado y TalkBack. Usa datos ficticios y anota la versión de Android y ColorOS en Ajustes → Acerca del dispositivo. Los nombres de los menús pueden variar con las actualizaciones.

## Instalar la actualización

Descarga el APK de la nueva release desde una sesión de GitHub con acceso al repositorio privado y ábrelo para actualizar TallerClick. La app debe aparecer como **TallerClick**, con un coche blanco y una marca de confirmación sobre fondo azul oscuro. La versión del paquete es 1.0.1, compilación 2.

Las citas de demostración duran mientras la app está abierta. Prepara una nueva cita si el proceso se reinicia durante las pruebas.

## Aumentar el texto desde Ajustes

1. Abre Ajustes y busca **Tamaño de fuente** o **Fuente**.
2. En ColorOS 13–15, OPPO sitúa normalmente Fuente en **Pantalla y brillo**; también puede aparecer en **Fondos de pantalla y estilo**. Usa el buscador si tu versión muestra otra ruta.
3. Guarda o anota el tamaño actual. Sube el tamaño de la fuente y pulsa Aplicar si aparece.
4. Si el control indica **200 %**, elígelo. Si solo indica tamaños como «Muy grande», anota el ajuste exacto: el máximo de ese control no demuestra por sí solo un 200 %.
5. Abre TallerClick y repite el recorrido de abajo. Al terminar, restaura el tamaño original.

Modifica el tamaño de **fuente**. El tamaño de visualización y la ampliación con lupa son ajustes distintos. [Instrucciones de OPPO](https://support.oppo.com/eg-en/answer/?aid=neu7664) y [ayuda de Android sobre tamaño de texto](https://support.google.com/accessibility/android/answer/11183305?hl=es).

### Fijar un 200 % exacto desde el ordenador

Si ColorOS no muestra porcentajes y ya tienes el móvil conectado mediante ADB con la depuración USB autorizada, comprueba primero el valor original:

```sh
adb devices
adb shell settings get system font_scale
```

Anota el valor devuelto; después aplica y comprueba el factor 2:

```sh
adb shell settings put system font_scale 2.0
adb shell settings get system font_scale
```

El segundo comando debe devolver `2.0`. Reabre TallerClick y realiza la prueba. Al terminar, sustituye `VALOR_ORIGINAL` por el valor que anotaste:

```sh
adb shell settings put system font_scale VALOR_ORIGINAL
```

Este método utiliza el mismo ajuste de escala documentado en la [prueba del emulador](ANDROID_VERIFICACION.md). Si todavía no tienes ADB preparado, puedes hacer primero la comprobación con el máximo del móvil y registrarla como «tamaño máximo de ColorOS», dejando pendiente el 200 % exacto.

## Activar y utilizar TalkBack

Antes de empezar, deja el volumen multimedia audible y localiza cómo desactivar el lector. En Ajustes, busca **TalkBack**; suele encontrarse bajo Accesibilidad, en el apartado Visión. Entra y activa Usar TalkBack. Si no está disponible, consulta la ayuda de Android para instalar o actualizar Android Accessibility Suite.

Con TalkBack activado:

- Un toque enfoca y lee el elemento; un doble toque lo activa.
- Deslizar un dedo a la derecha avanza al siguiente elemento; a la izquierda vuelve al anterior.
- Deslizar con dos dedos desplaza las listas y pantallas largas.

Para desactivarlo, vuelve a su ajuste con esos gestos y desactiva Usar TalkBack. Si has configurado el acceso directo de las teclas de volumen, puedes mantener ambas pulsadas según las indicaciones del teléfono. El acceso directo puede requerir activación previa. [Activación y desactivación](https://support.google.com/accessibility/android/answer/6007100?hl=es) y [gestos oficiales](https://support.google.com/accessibility/android/answer/6151827?hl=es).

## Recorrido que debes comprobar

Haz primero el recorrido con texto aumentado y después con TalkBack audible. Puedes combinar ambos ajustes cuando te resulte cómodo.

1. **Buscar:** Buscar taller → La Chantría → Buscar talleres → Taller Demo Plaza. Comprueba que se leen el barrio, el taller y el aviso de demostración. Prueba también El Ejido: debe indicar que no hay resultados y permitir elegir otro barrio.
2. **Seleccionar servicio:** elige Revisión de batería. Comprueba el nombre, la descripción y el estado seleccionado; después continúa.
3. **Reservar:** elige una hora disponible. Una franja ocupada debe identificarse como «Ocupada» y no permitir continuar por ella. Deja los campos vacíos para provocar errores; introduce después un nombre ficticio y `x` como teléfono. Debe explicar el error y conservar el nombre. Corrige con `600123456`, revisa el resumen y confirma una sola cita.
4. **Consultar:** abre Mis citas. La cita debe estar en Citas confirmadas, con referencia y datos correctos.
5. **Modificar:** abre el detalle, elige otra hora y revisa el cambio. Prueba Volver a Mis citas antes de confirmar: debe llevar al listado sin modificar la cita. Repite y confirma; debe conservar la referencia y mostrar la nueva hora.
6. **Cancelar:** prueba primero No, mantener mi cita. Después vuelve a cancelar y confirma. En Mis citas debe aparecer bajo Citas canceladas, con icono, borde y estado escrito; no debe confundirse con una cita activa. Su detalle ya no debe ofrecer modificar o cancelar.

Con texto ampliado, comprueba especialmente menús, errores y botones al final de cada vista: ningún texto debe quedar oculto de forma permanente y todas las acciones deben alcanzarse desplazando. Con TalkBack, anota las frases que anuncia para los campos, la selección, los errores y los resultados, y cualquier salto de foco que te desoriente.

## Registrar el resultado

Anota fecha, OPPO A98 5G, versiones de Android/ColorOS/TalkBack, versión de TallerClick, ajuste de fuente y pasos ejecutados. Guarda capturas normal/ampliada y describe cualquier fallo con sus pasos. Para TalkBack, añade lo que escuchaste o una grabación con datos ficticios. Separa los casos probados de los pendientes antes de actualizar `TASKS.md`.

## Resultado comunicado por Santiago

El 2026-11-20, Santiago confirmó en la conversación que la nueva versión funcionaba correctamente en su OPPO A98 5G. Al preguntarle expresamente por el texto al 200 % y TalkBack con audio, respondió: «Lo he probado todo, el 200% y el Tallback tambien». La versión de referencia de esta entrega es [TallerClick 1.0.1, compilación 2](https://github.com/scampg00/TallerClick-Flutter/releases/tag/test-1.0.1-2026-11-20), del commit `7b97bc6`.

Se registra como prueba manual comunicada por el responsable: funcionamiento general, texto al 200 % y uso audible de TalkBack, sin incidencias comunicadas. Complementa las 20 pruebas automatizadas y las capturas de widgets de [la entrega](CAMBIOS_1_0_1.md); no se presenta como una ejecución del asistente en el teléfono.

No se han facilitado nuevas capturas del OPPO, grabaciones, versiones de Android/ColorOS/TalkBack ni transcripciones de los anuncios. El 200 % se registra según la confirmación de Santiago, sin atribuir una medición ADB. La validación final del coordinador y de los demás responsables sigue pendiente.
