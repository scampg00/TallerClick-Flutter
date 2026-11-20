# TallerClick

Prototipo Flutter de talleres ficticios de León con datos en memoria: buscar taller y servicio por barrio (R1), reservar una cita (R2), consultarla, cambiarla y cancelarla (R3). Las reservas se conservan mientras la aplicación está abierta. En Mis citas, las confirmadas aparecen antes que las canceladas, que conservan su estado y detalle en una sección propia.

[Descargar APK de pruebas en GitHub Releases](https://github.com/scampg00/TallerClick-Flutter/releases) · [Guía para probar en un OPPO A98 5G](docs/PRUEBAS_OPPO_A98.md)

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
- [Cambios y comprobaciones de la versión 1.0.1](docs/CAMBIOS_1_0_1.md)

Las pruebas automáticas no sustituyen la revisión manual con Android y TalkBack. Las casillas se cierran con evidencia y validación del responsable y del coordinador.

El nombre visible de la aplicación es TallerClick. El icono original y editable está en `assets/branding/tallerclick.svg`. Para regenerar opcionalmente los recursos Android/iOS: `python tool/generate_app_icons.py` con Pillow instalado; esta herramienta de desarrollo no añade dependencias a Flutter. Los recursos de iOS están preparados, pero esa plataforma no se ha ejecutado.
