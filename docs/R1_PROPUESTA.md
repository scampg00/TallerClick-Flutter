# R1 — Catálogo ficticio y propuesta de recorrido

Responsable: Santiago Campos García. Preparado el 2026-11-17.

Estado: decisiones técnicas de R1 fijadas por el asistente por delegación de Santiago; pendientes de comunicación y revisión con Hugo e Isaac. Todavía sin implementar ni probar en Flutter. Este documento prepara S02–S06 de `TASKS.md` y la comprobación conjunta T01. No acredita su cierre.

## 1. Punto de partida y alcance

`lib/main.dart` contiene `HomeScreen`, `BasePage`, el tema y pantallas provisionales `DemoPage`. Se aprovechará lo que existe cuando se acuerde la integración. Aún no hay modelos de taller/servicio ni catálogo en el código.

R1 permite buscar por zona, consultar un taller y seleccionar un servicio. R2 se encarga de fecha, hora, datos personales y confirmación. «Mis citas» pertenece a R3; R1 solo conserva su acceso desde el inicio.

Los nombres y direcciones siguientes se han inventado para el prototipo. Las zonas son etiquetas de demostración, sin relación con la ubicación del dispositivo. No se necesitan mapas, permisos de ubicación, conexión ni API externa.

Texto visible propuesto en el inicio y la búsqueda: **«Prototipo de demostración. Los talleres y las direcciones son ficticios.»**

## 2. Catálogo propuesto para S02

Se adoptan los identificadores de las tablas como cadenas de texto estables para distinguir talleres y servicios, aunque sus textos cambien. Su representación prevista se concreta en la sección 4 para comunicarla a Hugo.

### Servicios

| Referencia | Nombre visible | Descripción breve |
| --- | --- | --- |
| oil-change | Cambio de aceite | Sustituimos el aceite del motor y comprobamos su nivel. |
| tyre-check | Revisión de neumáticos | Comprobamos la presión y el desgaste de las ruedas. |
| brake-check | Revisión de frenos | Revisamos las pastillas y los discos que ayudan a frenar el coche. |
| battery-check | Revisión de batería | Comprobamos si la batería tiene carga suficiente para arrancar. |
| basic-check | Revisión básica | Comprobamos los niveles de líquidos, las luces y los neumáticos. |

### Talleres

| Referencia | Nombre visible | Zona | Dirección ficticia | Servicios ofrecidos |
| --- | --- | --- | --- | --- |
| workshop-centre-01 | Taller Demo Centro | Centro | Calle de Ejemplo, 10 | oil-change, tyre-check, basic-check |
| workshop-centre-02 | Taller Demo Plaza | Centro | Plaza de Muestra, 4 | brake-check, battery-check |
| workshop-north-01 | Taller Demo Norte | Norte | Avenida de Prueba, 22 | oil-change, brake-check, battery-check |
| workshop-south-01 | Taller Demo Sur | Sur | Calle del Prototipo, 8 | tyre-check, basic-check |

### Zonas y resultados esperados

| Opción visible | Talleres esperados | Uso |
| --- | --- | --- |
| Todas las zonas | Los cuatro talleres | Opción inicial; permite explorar sin conocer una zona. |
| Centro | Taller Demo Centro y Taller Demo Plaza | Comprobar varios resultados. |
| Norte | Taller Demo Norte | Comprobar un resultado. |
| Sur | Taller Demo Sur | Comprobar un resultado distinto. |
| Oeste | Ninguno | Zona de demostración para comprobar el estado vacío. |

No se añaden precios, valoraciones ni disponibilidad de horarios a este catálogo. R2 mostrará las franjas a partir del contrato compartido.

## 3. Pantallas y comportamiento propuestos

Los títulos siguientes son textos de interfaz. Los nombres técnicos y la navegación elegida se concretan en la sección 4.

| Paso | Contenido y acciones | Resultado |
| --- | --- | --- |
| Inicio | Mantener «Buscar taller» y «Mis citas»; mostrar el aviso de demostración. | Buscar abre R1; Mis citas se conectará con R3 mediante la navegación acordada. |
| Buscar taller | Selector con etiqueta visible «Zona», inicialmente «Todas las zonas», y botón «Buscar talleres». | Pulsar el botón actualiza el listado en esta misma pantalla. |
| Resultados | Mensaje con el número de talleres, nombre, zona y dirección de cada uno; acción «Ver taller» asociada a su nombre. | Abre la ficha del taller elegido. |
| Ficha de taller | Nombre, zona, dirección ficticia, aviso de demostración y servicios con descripción breve. Cada servicio tiene una opción de selección única. | Permite seleccionar exactamente un servicio ofrecido por ese taller. |
| Continuación | Mostrar «Servicio seleccionado: …» y el botón «Continuar con este servicio». | Entrega taller y servicio a R2; todavía no crea una cita. |

El botón de continuación estará deshabilitado mientras no haya servicio seleccionado. Un texto visible explicará: «Selecciona un servicio para continuar». La selección se indicará con el control nativo y el resumen escrito, además del color.

### Búsqueda, vuelta atrás y recuperación

- Al entrar en la búsqueda se muestran los cuatro talleres. Se distingue la zona elegida en el selector de la zona de la última búsqueda aplicada: cambiar el selector requiere pulsar «Buscar talleres» para actualizar los resultados.
- El encabezado de resultados identifica la zona aplicada; por ejemplo: «2 talleres en Centro». Para un único resultado: «1 taller en Norte».
- Para Oeste: «No hay talleres en la zona Oeste. Elige otra zona y pulsa Buscar talleres». Mantener visibles el selector y el botón para recuperarse.
- Si el selector cambia sin aplicar la búsqueda, los resultados siguen identificados por su zona anterior; no deben parecer resultados de la nueva zona.
- Volver desde la ficha conserva la zona del selector, la última búsqueda y el listado. Ofrecer «Volver a los talleres», además del mecanismo habitual para volver.
- Volver desde R2 conserva el taller y servicio de la ficha abierta. Abrir otra ficha empieza sin servicio seleccionado, para evitar arrastrar una elección de otro taller.
- No simular esperas: el catálogo está en memoria y no requiere una pantalla de carga.
- Si una integración entrega una referencia inexistente o un servicio ajeno al taller, mostrar «No se puede usar esta selección. Vuelve a elegir el taller y el servicio», con acción de regreso; no avanzar a R2.

## 4. Decisiones técnicas para desarrollar R1

Santiago ha delegado la elección técnica en el asistente. Se eligen los siguientes contratos y archivos como base concreta de trabajo. Esta decisión local no acredita aprobación de Hugo ni de Isaac: según `AGENTS.md`, se les comunicará antes de modificar modelos o navegación compartidos. En esta entrega se concreta el diseño en documentación.

### Modelos simples e inmutables

| Clase | Archivo previsto | Campos, todos obligatorios |
| --- | --- | --- |
| `WorkshopService` | `lib/models/workshop_service.dart` | `String id`, `String name`, `String description` |
| `Workshop` | `lib/models/workshop.dart` | `String id`, `String name`, `String zone`, `String address`, `List<WorkshopService> services` |

Ambas clases tendrán constructor `const` y campos `final`. El catálogo usará listas constantes, incluida la lista de servicios de cada taller. Las clases y los campos estarán en inglés; todos los textos visibles seguirán en español.

Cada identificador de taller será único y cada servicio aparecerá una sola vez dentro de un taller. El mismo servicio podrá ofrecerse en varios talleres. La selección se validará por `id`: el taller debe pertenecer al catálogo y el servicio a ese taller. Se transmitirá el servicio del catálogo, sin reconstruirlo a partir de su nombre.

La zona será un texto sencillo: Centro, Norte, Sur u Oeste. «Todas las zonas» se representará internamente con `null` en el filtro y no será una zona de ningún taller. Para cuatro zonas no se necesita otro modelo.

### Archivos y responsabilidades

| Archivo previsto | Responsabilidad |
| --- | --- |
| `lib/data/workshop_catalog.dart` | Definir `workshopServices`, `workshops` y `workshopZones` como datos constantes a partir de las tablas de este documento. Incluir Oeste para el caso vacío. |
| `lib/screens/workshop_search_screen.dart` | `WorkshopSearchScreen`: selector, búsqueda aplicada, listado y estado vacío en una misma pantalla. Recibir el catálogo y la función de construcción de R2 por constructor. |
| `lib/screens/workshop_detail_screen.dart` | `WorkshopDetailScreen`: mostrar taller, seleccionar un servicio y abrir R2. Recibir el taller y la misma función de construcción de R2 por constructor. |
| `lib/main.dart` (existente) | Conservar `TallerClickApp`, tema, `HomeScreen` y `BasePage`; sustituir únicamente el destino provisional de Buscar taller al integrar R1. |

Las pantallas nuevas usarán widgets nativos y su propio `Scaffold` con `SafeArea` y contenido desplazable. No importarán `main.dart` para reutilizar `BasePage`, lo que evita una dependencia circular. Tampoco se extraerá o reescribirá ese componente compartido en esta fase.

### Navegación y conexión con Isaac

Se usará `Navigator.push` con `MaterialPageRoute`, como en el código actual. No hace falta añadir un gestor de rutas ni rutas con argumentos sin tipo.

El punto de conexión será un parámetro obligatorio llamado `bookingPageBuilder`, de tipo `Widget Function(Workshop workshop, WorkshopService service)`, recibido por la búsqueda y transmitido a la ficha. Al continuar, la ficha validará la selección y usará esa función para construir la pantalla R2 dentro de un `MaterialPageRoute`.

Isaac implementará su pantalla recibiendo `Workshop workshop` y `WorkshopService service`. El punto de integración proporcionará una función que construya esa pantalla con ambos datos. Su nombre de clase y archivo quedan dentro de R2; R1 no necesita importarlos.

La búsqueda mantiene su filtro con `setState` y la ficha mantiene el servicio seleccionado con `setState`. Las pantallas permanecen en la pila al abrir la siguiente, por lo que volver conserva el contexto durante ese recorrido. No se requiere guardar esa selección entre reinicios de la aplicación.

Antes de que exista R2, las pruebas de R1 podrán proporcionar un constructor de pantalla de prueba que muestre la selección recibida. Eso permite verificar la entrega sin implementar reservas; no acredita T01 integrado. La conexión final con R2 se comprueba con Isaac.

Ejemplo concreto de T01: buscar Centro, abrir Taller Demo Plaza y seleccionar Revisión de batería. R2 debe recibir el taller con `id == 'workshop-centre-02'` y el servicio con `id == 'battery-check'`, y mostrar sus nombres. Entrar y volver desde R1 no crea ni confirma reservas.

### Alcance de estas decisiones y comunicación

Para R1 se conservan el catálogo, el flujo y los textos de este documento. No se añaden dependencias. El modelo de cita y el repositorio de reservas siguen correspondiendo a la coordinación de R2–R3; R1 no necesita implementarlos para desarrollar búsqueda y ficha.

Resumen preparado para comunicar a Hugo e Isaac: «R1 usará Workshop y WorkshopService con identificadores estables, catálogo constante, dos pantallas y Navigator. La entrada a R2 recibirá taller y servicio mediante bookingPageBuilder. Conservaremos el tema y el inicio existentes; el cambio de main.dart se limitará a conectar Buscar taller y el constructor de R2».

No se ha enviado ningún mensaje al equipo ni se ha registrado su aprobación. Si ya han publicado contratos fuera de este repositorio, se revisarán antes de implementar para evitar modelos incompatibles.

## 5. Accesibilidad prevista

| Criterio | Decisión para R1 | Verificación pendiente |
| --- | --- | --- |
| A01 | Mantener la paleta acordada; usar estilos del tema compartido. | Medir los pares de colores realmente renderizados, incluidos controles y foco. |
| A02 | Contenido desplazable, texto que admita varias líneas y sin alturas fijas para tarjetas o descripciones. | Recorrido completo con texto al 200 %; capturas y ausencia de desbordamientos. |
| A03 | Zona en el encabezado, número de resultados y selección con control y texto. | Identificar zona, resultado vacío y servicio seleccionado sin depender del color. |
| A04 | Controles y áreas pulsables de al menos 48 × 48 píxeles lógicos. | Medir selector, botones, opciones de servicio y acciones para volver. |
| A05 | Todas las acciones esenciales mediante pulsaciones y desplazamiento convencional. | Buscar y elegir sin arrastrar controles ni mantener pulsado. |
| A06 | Mensajes que expliquen cómo recuperarse; conservar la búsqueda al regresar. | Ejecutar caso sin resultados y caso de referencia inválida. |
| A07 | Controles nativos con etiqueta, rol y estado; asociar «Ver taller» con el nombre correcto. | TalkBack: título, zona, buscar, resultados, ficha, servicios, selección y continuar; evitar anuncios duplicados. |
| A08 | Resultado de búsqueda y selección visibles mientras corresponda; anunciar los cambios de resultados cuando proceda. | Comprobar percepción visual y con TalkBack; R1 no anuncia una cita confirmada. |
| A09 | Nombres cotidianos y descripción breve para todos los servicios. | Revisar los cinco servicios en las fichas, también con texto ampliado. |

## 6. Comprobaciones reproducibles para la implementación

Estado de todos los casos: **pendientes de ejecución**. No son pruebas superadas del código actual.

| Caso | Pasos | Resultado esperado |
| --- | --- | --- |
| R1-01 | Inicio → Buscar taller. | Aviso de demostración, Todas las zonas y cuatro talleres. |
| R1-02 | Elegir Centro → Buscar talleres. | Solo Taller Demo Centro y Taller Demo Plaza; «2 talleres en Centro». |
| R1-03 | Con Centro aplicado, cambiar el selector a Norte sin buscar; después pulsar Buscar talleres. | Primero siguen los resultados identificados como Centro; después aparece solo Taller Demo Norte con «1 taller en Norte». |
| R1-04 | Elegir Oeste → Buscar talleres; después elegir Sur → Buscar talleres. | Mensaje vacío con instrucciones; recuperación a Taller Demo Sur sin reiniciar el recorrido. |
| R1-05 | Buscar Centro → abrir Taller Demo Plaza. | Dirección correcta y solo Revisión de frenos y Revisión de batería, con descripciones. Continuación deshabilitada y explicación hasta seleccionar. |
| R1-06 | Seleccionar frenos y después batería. | Una única selección: batería; resumen escrito actualizado y continuación habilitada. |
| R1-07 | Desde la ficha, volver a los talleres; abrir otra ficha. | Centro y sus resultados conservados; la nueva ficha no hereda la selección anterior. |
| R1-08 / T01 | Plaza → batería → continuar a R2 → volver a la ficha. | R2 recibe los datos del ejemplo de integración; al volver se conserva la selección y no se ha creado ninguna cita por navegar. Requiere R2 integrado. |
| R1-09 | En una prueba de widget, proporcionar una referencia de taller inexistente o un servicio no ofrecido por él. | Mensaje de recuperación, regreso disponible y ninguna entrega a R2. |
| R1-10 | Repetir búsqueda, estado vacío y selección con texto al 200 %. | Sin texto cortado ni acciones inaccesibles; guardar capturas normales y ampliadas. |
| R1-11 | Repetir R1-02, R1-04 y R1-06 en Android con TalkBack. | Orden comprensible, resultados perceptibles, taller identificado en cada acción y servicio con estado seleccionado. |

Al implementar: ejecutar `flutter analyze`, `flutter test` y `flutter run -d <id-del-dispositivo>` (obtener el identificador con `flutter devices`). Registrar SDK, dispositivo/plataforma, comandos, resultados reales, casos ejecutados y rutas de capturas. TalkBack requiere comprobación en Android; una ejecución en otra plataforma no acredita esa prueba.

Antes de utilizar la suite, actualizar `test/widget_test.dart`: actualmente prueba un contador y referencia `MyApp`, pero la aplicación define `TallerClickApp`.

## 7. Orden de trabajo y revisión

1. Comunicar a Hugo e Isaac las decisiones concretas de la sección 4 y comprobar si hay contratos compartidos ya publicados.
2. Implementar los dos modelos y el catálogo definidos en la sección 4, tras esa comunicación (S02).
3. Implementar búsqueda/listado y recuperación sin resultados (S03 y parte de S06).
4. Implementar ficha, selección única y vuelta atrás (S04 y resto de S06).
5. Conectar con R2 y comprobar T01 junto a Isaac (S05).
6. Revisar el inicio existente (S01), accesibilidad (S07) y ejecución con evidencias (S08).

Esta entrega actualiza únicamente `docs/R1_PROPUESTA.md`. Las rutas mencionadas en este documento se refieren a la raíz del repositorio. No cambia modelos, tema, navegación, código de la aplicación ni casillas o fechas de `TASKS.md`. Las decisiones técnicas están concretadas; quedan pendientes la comunicación al equipo, su implementación y las comprobaciones descritas.
