# TallerClick

Prototipo Flutter de talleres ficticios con datos en memoria: buscar taller y servicio (R1), reservar una cita (R2), consultarla, cambiarla y cancelarla (R3). Las reservas se conservan mientras la aplicación está abierta.

```sh
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d <identificador-del-dispositivo>
```

El SDK requerido figura en `pubspec.yaml`. Para Android debe haber un emulador o dispositivo conectado.

- [Reglas del proyecto](AGENTS.md)
- [Seguimiento y validaciones pendientes](TASKS.md)
- [Verificación R1](docs/R1_VERIFICACION.md)
- [Verificación R2](docs/R2_VERIFICACION.md)
- [Verificación R3, contratos y capturas](docs/R3_VERIFICACION.md)
- [Integración y revisión de accesibilidad](docs/HUGO_INTEGRACION_ACCESIBILIDAD.md)
- [Incidencias del Grupo E y contraste con Flutter](docs/GRUPO_E_REVISION_FLUTTER.md)
- [Propuesta de actualización de la Memoria v5](docs/MEMORIA_V5_ACTUALIZACION.md)

Las pruebas automáticas no sustituyen la revisión manual con Android y TalkBack. Las casillas se cierran con evidencia y validación del responsable y del coordinador.
