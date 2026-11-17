# AGENTS.md — TallerClick

> Instrucciones compartidas para estudiantes, asistentes de IA y herramientas de desarrollo que trabajen en este repositorio.
> Curso 2026/2027 · Accesibilidad · Grado en Ingeniería Informática · Universidad de León.
> **Coordinador:** Hugo Esteban Monje. **Equipo:** Santiago Campos García, Isaac Caño Calvo, Adrián Doncel Casado y Hugo Esteban Monje.

## 1. Objetivo y alcance

TallerClick es una aplicación móvil **Flutter** para buscar talleres mecánicos, reservar citas y consultarlas, cambiarlas o cancelarlas. Debe demostrar accesibilidad desde el diseño hasta las pruebas.

Mantener estos tres recorridos obligatorios:

- **R1:** Buscar taller por zona, consultar taller y servicio.
- **R2:** Seleccionar fecha y hora, introducir datos mínimos, revisar y confirmar una única reserva.
- **R3:** Consultar la reserva, modificar fecha/hora o cancelarla tras confirmación, viendo el nuevo estado.

Usar **datos locales o simulados**. No añadir backend, pagos, inicio de sesión, mapas, geolocalización, base de datos ni funciones que no sean necesarias para R1–R3. No presentar el prototipo como una red de talleres reales.

## 2. Regla principal: código sencillo, universal y accesible

- Escribir **Dart/Flutter estándar**, con código claro, pequeño, legible y fácil de ejecutar en cualquier instalación Flutter compatible. Preferir widgets nativos (`MaterialApp`, `Scaffold`, `ListView`, `TextFormField`, `ElevatedButton`, `Navigator`, `Semantics`) y paquetes oficiales cuando realmente hagan falta.
- Favorecer compatibilidad **Android** y, cuando sea posible, **iOS/web**, sin condicionar la lógica a un dispositivo o resolución concreta. No asumir que una plataforma ha sido probada si no hay evidencia.
- Evitar dependencias nuevas, patrones complejos, arquitectura por capas innecesaria, generación de código y librerías de estado externas. Para este alcance bastan modelos simples, un repositorio en memoria y `ChangeNotifier`/`ListenableBuilder` o `setState` según convenga.
- Evitar duplicación; funciones con responsabilidad única, nombres descriptivos en inglés para clases y métodos y **textos de interfaz en español**. No usar rutas o credenciales locales en el código.
- Mantener la estructura del repositorio existente. La organización de carpetas de `TASKS.md` es una **propuesta**: antes de crear archivos, comprobar cuáles existen y acordar los nombres y contratos compartidos.
- No reescribir trabajo ajeno ni cambiar contratos compartidos unilateralmente. Antes de tocar `main.dart`, tema, navegación o modelos, comunicarlo al coordinador.
- No inventar que una prueba pasó, que una corrección se aplicó o que un usuario confirmó algo. Marcar tareas y evidencias **solo después de ejecutarlas**.

## 3. Guía de accesibilidad de la práctica

Aplicar a todas las pantallas y recorridos:

| ID | Criterio | Cómo comprobarlo |
| --- | --- | --- |
| A01 | Contraste texto normal ≥ **4,5:1**, texto grande ≥ **3:1** y componentes pertinentes ≥ **3:1** | Medición del par de colores real |
| A02 | Texto escalado al **200 %** sin cortes ni acciones inaccesibles | Ejecutar R1–R3 con texto aumentado y capturas |
| A03 | Disponibilidad, errores, selección y estados no dependen solo del color | Revisar sin color y leer etiquetas visibles |
| A04 | Objetivos táctiles ≥ **48 × 48 píxeles lógicos** | Inspección/guías de accesibilidad Flutter |
| A05 | No se requiere arrastrar, mantener pulsado ni gestos complejos para tareas esenciales | Ejecutar R1–R3 solo con pulsaciones simples |
| A06 | Errores claros; conservar datos válidos al corregir | Forzar un campo inválido y rectificarlo |
| A07 | Nombres, roles, estados y orden accesibles con TalkBack | Recorrer pantallas con TalkBack |
| A08 | Confirmación, error, modificación y cancelación perceptibles y persistentes | Verificar mensajes escritos y anuncio cuando corresponda |
| A09 | Servicios en lenguaje cotidiano con descripción breve | Revisar todas las opciones |

**Paleta inicial acordada:** `#123A4A` principal, `#FFFFFF` fondo, `#F1F6F7` superficie y `#415B67` texto secundario. No cambiar los valores sin registrar una nueva medición de contraste.

Usar textos como «Disponible», «Ocupada», «Cita confirmada», «Cita cancelada» y «No, mantener mi cita», además del color. Para acciones destructivas mostrar resumen y confirmación. Evitar una confirmación que genere dos citas al volver atrás.

## 4. Integración y colaboración

1. **Hugo** define primero los contratos de `Taller`, `Cita` y `CitasRepository` (o el equivalente simple que ya exista) y las rutas; los publica antes de que cada persona programe su recorrido.
2. Cada integrante crea una rama: `feature/r1-santiago`, `feature/r2-isaac`, `feature/r3-adrian`, `feature/base-accesibilidad-hugo`.
3. Hacer commits pequeños y descriptivos; abrir Pull Request con descripción, pantallas afectadas, captura y pruebas realizadas.
4. Hugo integra progresivamente; **todos** prueban después de cada integración. Evitar cambios simultáneos sobre archivos compartidos.
5. Antes de fusionar, ejecutar cuando esté disponible: `flutter analyze`, `flutter test` y `flutter run` en un dispositivo/emulador o Chrome. Registrar plataforma y resultados reales.
6. Las incidencias de la revisión cruzada del Grupo E son **trabajo pendiente**, no corregido: priorizar la duplicación de reservas y la selección de horarios. Consultar el Excel original antes de afirmar el detalle de cada una de las 8 incidencias.

## 5. Reglas para el asistente de IA

- Leer este archivo y `TASKS.md` antes de modificar el repositorio.
- Primero inspeccionar archivos reales; nunca suponer que la estructura o un widget ya existe.
- Proponer el **cambio mínimo** que satisface una tarea. Explicar qué archivos se modifican y por qué.
- No introducir dependencias sin justificar y solicitar revisión del coordinador si se afecta un contrato común.
- Acompañar cada entrega con pasos de prueba reproducibles; no afirmar resultados que no se ejecutaron.
- No actualizar como completadas las casillas o fechas de `TASKS.md` sin confirmación del responsable y evidencia.
- Mantener el trabajo centrado en R1–R3 y en los requisitos A01–A09.

## 6. Seguimiento

La **tabla maestra de tareas, fechas y evidencias** está en [`TASKS.md`](TASKS.md). Cada estudiante actualiza solo sus tareas, usando una casilla `[x]` y una fecha real en formato `AAAA-MM-DD`. Si no se ha completado, mantener `[ ]` y `—`. El coordinador valida el cierre y la integración.
