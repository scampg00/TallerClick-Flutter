import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/data/appointment_repository.dart';
import 'package:flutter_application_1/data/workshop_catalog.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screens/booking_screen.dart';

import 'widget_test.dart' show openPlaza, tapVisible;

const name = 'Álex Demo';
const phone = '+34 600 123 456';

AppointmentRepository newRepository() =>
    AppointmentRepository(now: () => DateTime(2026, 11, 18));

Future<void> openBooking(
  WidgetTester tester,
  AppointmentRepository repository,
) async {
  await tester.pumpWidget(
    TallerClickApp(
      bookingPageBuilder: (workshop, service) => BookingScreen(
        workshop: workshop,
        service: service,
        repository: repository,
      ),
    ),
  );
  await openPlaza(tester);
  await tapVisible(tester, find.text('Revisión de batería'));
  await tapVisible(tester, find.text('Continuar con este servicio'));
}

Future<void> enterContact(WidgetTester tester) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Nombre'), name);
  await tester.enterText(find.widgetWithText(TextFormField, 'Teléfono'), phone);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

void main() {
  test('El taller comparte la franja entre servicios y comprueba el día', () {
    final repository = newRepository();
    final workshop = workshops[1];
    final day = repository.bookingDays().first;
    final slots = repository.slotsFor(day);
    expect(day, DateTime(2026, 11, 19));
    expect(repository.isAvailable(workshop, slots[1]), isFalse);
    expect(
      repository.isAvailable(workshop, DateTime(2026, 11, 18, 9)),
      isFalse,
    );

    final appointment = repository.book(
      workshop: workshop,
      service: workshop.services.first,
      slot: slots.first,
      name: name,
      phone: phone,
    );
    expect(appointment?.reference, 'TC-0001');
    expect(
      repository.book(
        workshop: workshop,
        service: workshop.services.last,
        slot: slots.first,
        name: name,
        phone: phone,
      ),
      isNull,
    );
    expect(repository.appointments, [appointment]);
    expect(repository.isAvailable(workshops.first, slots.first), isTrue);
  });

  testWidgets(
    'R2 corrige errores, revisa y confirma una única cita consultable',
    (tester) async {
      final repository = newRepository();
      await openBooking(tester, repository);
      expect(find.text('Taller: Taller Demo Plaza'), findsOneWidget);
      expect(find.text('Servicio: Revisión de batería'), findsOneWidget);

      final occupied = find.text('10:00 · Ocupada');
      final continueButton = find.widgetWithText(
        ElevatedButton,
        'Continuar a los datos de contacto',
      );
      await tapVisible(tester, occupied);
      expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNull);
      await tapVisible(tester, find.text('09:00 · Disponible'));
      await tapVisible(tester, find.text('11:00 · Disponible'));
      expect(find.text('Hora seleccionada: 11:00'), findsOneWidget);

      await tapVisible(tester, find.byType(DropdownButton<DateTime>));
      await tapVisible(
        tester,
        find.text('viernes, 20 de noviembre de 2026').last,
      );
      expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNull);
      await tapVisible(tester, find.text('11:00 · Disponible'));
      await tapVisible(tester, continueButton);
      expect(
        find.text('De 9 a 15 dígitos; puedes incluir el prefijo.'),
        findsOneWidget,
      );

      await tapVisible(tester, find.text('Revisar reserva'));
      expect(find.text('Escribe tu nombre.'), findsOneWidget);
      expect(find.text('Escribe tu número de teléfono.'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre'),
        name,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Teléfono'),
        'x',
      );
      await tapVisible(tester, find.text('Revisar reserva'));
      expect(
        find.text('Introduce un teléfono de 9 a 15 dígitos.'),
        findsOneWidget,
      );
      expect(find.text(name), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Teléfono'),
        phone,
      );
      await tapVisible(tester, find.text('Revisar reserva'));

      expect(find.text('Revisa tu reserva'), findsOneWidget);
      expect(find.text('Taller: Taller Demo Plaza'), findsOneWidget);
      expect(find.text('Servicio: Revisión de batería'), findsOneWidget);
      expect(
        find.text('Fecha: viernes, 20 de noviembre de 2026'),
        findsOneWidget,
      );
      expect(find.text('Hora: 11:00'), findsOneWidget);
      expect(find.text('Nombre: $name'), findsOneWidget);
      expect(find.text('Teléfono: $phone'), findsOneWidget);
      expect(repository.appointments, isEmpty);

      await tapVisible(tester, find.text('Editar datos de contacto'));
      expect(find.text(name), findsOneWidget);
      expect(find.text(phone), findsOneWidget);
      await tapVisible(tester, find.text('Revisar reserva'));
      final confirm = tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Confirmar reserva'),
          )
          .onPressed!;
      confirm();
      confirm();
      await tester.pumpAndSettle();
      expect(find.text('Cita confirmada'), findsOneWidget);
      expect(find.text('Referencia: TC-0001'), findsOneWidget);
      expect(repository.appointments, hasLength(1));

      await tapVisible(tester, find.text('Ir a Mis citas'));
      expect(find.text('Mis citas'), findsOneWidget);
      expect(find.text('Cita confirmada'), findsOneWidget);
      expect(find.text('Referencia: TC-0001'), findsOneWidget);
      expect(find.text('Hora: 11:00'), findsOneWidget);
      await tapVisible(tester, find.byTooltip('Volver'));
      expect(find.text('Confirmar reserva'), findsNothing);
      expect(find.text('Referencia: TC-0001'), findsOneWidget);

      await tapVisible(tester, find.byTooltip('Volver'));
      await tapVisible(tester, find.text('Continuar con este servicio'));
      await tapVisible(tester, find.byType(DropdownButton<DateTime>));
      await tapVisible(
        tester,
        find.text('viernes, 20 de noviembre de 2026').last,
      );
      expect(find.text('11:00 · Ocupada'), findsOneWidget);
      expect(repository.appointments, hasLength(1));
    },
  );

  testWidgets('Recupera una franja ocupada durante la revisión', (
    tester,
  ) async {
    final repository = newRepository();
    await openBooking(tester, repository);
    await tapVisible(tester, find.text('09:00 · Disponible'));
    await tapVisible(tester, find.text('Continuar a los datos de contacto'));
    await enterContact(tester);
    expect(find.text('Revisa tu reserva'), findsOneWidget);

    repository.book(
      workshop: workshops[1],
      service: workshops[1].services.first,
      slot: repository.slotsFor(repository.bookingDays().first).first,
      name: 'Otra persona',
      phone: phone,
    );
    await tapVisible(tester, find.text('Confirmar reserva'));
    expect(
      find.textContaining('La hora elegida ya no está disponible'),
      findsOneWidget,
    );
    expect(find.text('09:00 · Ocupada'), findsOneWidget);
    await tapVisible(tester, find.text('11:00 · Disponible'));
    await tapVisible(tester, find.text('Continuar a los datos de contacto'));
    expect(find.text(name), findsOneWidget);
    expect(find.text(phone), findsOneWidget);
    expect(repository.appointments, hasLength(1));
  });

  testWidgets('R2 al 200 % mantiene acciones accesibles a 390 × 844', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final semantics = tester.ensureSemantics();
    try {
      Future<void> checkTargets() async {
        expect(tester.takeException(), isNull);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      }

      await openBooking(tester, newRepository());
      await checkTargets();
      await tapVisible(tester, find.byType(DropdownButton<DateTime>));
      await tapVisible(
        tester,
        find.text('viernes, 20 de noviembre de 2026').last,
      );
      await tapVisible(tester, find.text('12:00 · Disponible'));
      await tapVisible(tester, find.text('Continuar a los datos de contacto'));
      await checkTargets();
      await enterContact(tester);
      await checkTargets();
      await tapVisible(tester, find.text('Confirmar reserva'));
      await checkTargets();
      await tapVisible(tester, find.text('Ir a Mis citas'));
      expect(find.text('Referencia: TC-0001'), findsOneWidget);
      await checkTargets();
    } finally {
      semantics.dispose();
    }
  });
}
