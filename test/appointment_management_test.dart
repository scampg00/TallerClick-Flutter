import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/data/appointment_repository.dart';
import 'package:flutter_application_1/data/workshop_catalog.dart';

import 'evidence_capture.dart';
import 'booking_test.dart' show newRepository, enterContact;
import 'widget_test.dart' show tapVisible, openPlaza, showVisible;

Appointment seed(AppointmentRepository repository, int hour) => repository.book(
  workshop: workshops[1],
  service: workshops[1].services.first,
  slot: DateTime(2026, 11, 19, hour),
  name: 'Álex Demo',
  phone: '600123456',
)!;

void main() {
  setUpAll(loadEvidenceFonts);
  test('Cambio y cancelación preservan ID, aíslan citas y rechazan operaciones antiguas', () {
    final repository = newRepository();
    final first = seed(repository, 9);
    final other = seed(repository, 11);
    expect(repository.reschedule(first, other.slot), isFalse);
    final target = DateTime(2026, 11, 20, 12);
    expect(repository.reschedule(first, target), isTrue);
    expect(repository.reschedule(first, DateTime(2026, 11, 21, 9)), isFalse);
    expect(repository.cancel(first), isFalse);
    final changed = repository.find(first.reference)!;
    expect(changed.slot, target);
    expect(changed.rescheduled, isTrue);
    expect(repository.isAvailable(first.workshop, first.slot), isTrue);
    expect(repository.find(other.reference), same(other));
    expect(repository.cancel(changed), isTrue);
    expect(repository.cancel(changed), isFalse);
    final cancelled = repository.find(first.reference)!;
    expect(cancelled.status, AppointmentStatus.cancelled);
    expect(repository.reschedule(cancelled, first.slot), isFalse);
    expect(repository.isAvailable(first.workshop, target), isTrue);
    expect(repository.appointments, hasLength(2));
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'R1–R3: reserva, inicio, cambio, cancelación y regreso a escala $scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final semantics = tester.ensureSemantics();
        try {
          final repository = newRepository();
          await tester.pumpWidget(
            RepaintBoundary(
              key: const ValueKey('evidence'),
              child: TallerClickApp(repository: repository),
            ),
          );
          await openPlaza(tester);
          await tapVisible(tester, find.text('Revisión de batería'));
          await tapVisible(tester, find.text('Continuar con este servicio'));
          await tapVisible(tester, find.text('09:00 · Disponible'));
          await tapVisible(
            tester,
            find.text('Continuar a los datos de contacto'),
          );
          await enterContact(tester);
          await tapVisible(tester, find.text('Confirmar reserva'));
          await tapVisible(tester, find.text('Volver al inicio'));
          await tapVisible(tester, find.text('Mis citas'));
          await tapVisible(tester, find.text('Ver cita TC-0001'));
          await captureEvidence(tester, 'detalle-$scale');
          await tapVisible(tester, find.text('Cambiar fecha y hora'));
          await showVisible(tester, find.text('09:00 · Tu hora actual'));
          expect(find.text('09:00 · Tu hora actual'), findsOneWidget);
          await tapVisible(tester, find.text('09:00 · Tu hora actual'));
          await tapVisible(tester, find.text('10:00 · Ocupada'));
          await showVisible(tester, find.text('Revisar cambio'));
          expect(
            tester
                .widget<OutlinedButton>(
                  find.widgetWithText(OutlinedButton, 'Revisar cambio'),
                )
                .onPressed,
            isNull,
          );
          await tapVisible(tester, find.text('11:00 · Disponible'));
          await captureEvidence(tester, 'horario-$scale');
          await tapVisible(tester, find.text('Revisar cambio'));
          expect(repository.appointments.single.slot.hour, 9);
          await tapVisible(tester, find.text('Volver a elegir horario'));
          expect(repository.appointments.single.slot.hour, 9);
          await tapVisible(tester, find.text('Revisar cambio'));
          await showVisible(tester, find.text('Confirmar cambio'));
          await captureEvidence(tester, 'revision-$scale');
          final confirm = tester
              .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, 'Confirmar cambio'),
              )
              .onPressed!;
          confirm();
          confirm();
          await tester.pumpAndSettle();
          expect(repository.appointments.single.slot.hour, 11);
          expect(find.text('Cita modificada'), findsOneWidget);
          await tapVisible(tester, find.text('Cancelar cita'));
          await tapVisible(tester, find.text('No, mantener mi cita'));
          expect(
            repository.appointments.single.status,
            AppointmentStatus.confirmed,
          );
          await tapVisible(tester, find.text('Cancelar cita'));
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await showVisible(tester, find.text('Sí, cancelar cita'));
          await captureEvidence(tester, 'cancelar-$scale');
          final cancel = tester
              .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, 'Sí, cancelar cita'),
              )
              .onPressed!;
          cancel();
          cancel();
          await tester.pumpAndSettle();
          expect(repository.appointments, hasLength(1));
          expect(
            repository.appointments.single.status,
            AppointmentStatus.cancelled,
          );
          expect(find.text('Cancelar cita'), findsNothing);
          await tapVisible(tester, find.text('Volver a Mis citas'));
          expect(find.text('Cita cancelada'), findsOneWidget);
          await captureEvidence(tester, 'resultado-$scale');
          expect(find.text('Referencia: TC-0001'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets('Conflicto al cambiar mantiene la cita y permite reintentar', (
    tester,
  ) async {
    final repository = newRepository();
    final original = seed(repository, 9);
    await tester.pumpWidget(TallerClickApp(repository: repository));
    await tapVisible(tester, find.text('Mis citas'));
    await tapVisible(tester, find.text('Ver cita TC-0001'));
    await tapVisible(tester, find.text('Cambiar fecha y hora'));
    await tapVisible(tester, find.text('11:00 · Disponible'));
    await tapVisible(tester, find.text('Revisar cambio'));
    final other = seed(repository, 11);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Confirmar cambio'));
    expect(
      find.textContaining('No se pudo aplicar la operación'),
      findsOneWidget,
    );
    expect(repository.find(original.reference), same(original));
    expect(repository.find(other.reference), same(other));
    await tapVisible(tester, find.text('Cambiar fecha y hora'));
    expect(find.text('11:00 · Ocupada'), findsOneWidget);
  });

  testWidgets('Una cita cancelada no vuelve a ofrecer la cancelación', (
    tester,
  ) async {
    final repository = newRepository();
    seed(repository, 9);
    await tester.pumpWidget(TallerClickApp(repository: repository));
    await tapVisible(tester, find.text('Mis citas'));
    await tapVisible(tester, find.text('Ver cita TC-0001'));
    await tapVisible(tester, find.text('Cancelar cita'));
    await tapVisible(tester, find.text('Sí, cancelar cita'));
    await tapVisible(tester, find.text('Volver a Mis citas'));
    await tapVisible(tester, find.text('Ver cita TC-0001'));
    expect(find.text('Cita cancelada'), findsWidgets);
    expect(find.text('Cancelar cita'), findsNothing);
    expect(find.text('Sí, cancelar cita'), findsNothing);
    expect(repository.appointments, hasLength(1));
  });

  testWidgets(
    'Las confirmadas aparecen antes que las canceladas sin perder su detalle',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final semantics = tester.ensureSemantics();
      try {
        final repository = newRepository();
        final active = seed(repository, 9);
        final cancelled = seed(repository, 11);
        expect(repository.cancel(cancelled), isTrue);
        await tester.pumpWidget(TallerClickApp(repository: repository));
        await tapVisible(tester, find.text('Mis citas'));

        expect(find.text('Citas confirmadas'), findsOneWidget);
        expect(find.text('Citas canceladas'), findsOneWidget);
        expect(find.text('Estas citas ya no están activas.'), findsOneWidget);
        expect(find.byIcon(Icons.event_busy), findsOneWidget);
        expect(
          tester.getTopLeft(find.text('Ver cita ${active.reference}')).dy,
          lessThan(
            tester.getTopLeft(find.text('Ver cita ${cancelled.reference}')).dy,
          ),
        );
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));

        await tapVisible(tester, find.text('Ver cita ${cancelled.reference}'));
        expect(find.text('Cita cancelada'), findsOneWidget);
        expect(find.text('Cancelar cita'), findsNothing);
        expect(repository.appointments, hasLength(2));
        expect(repository.find(active.reference), same(active));
      } finally {
        semantics.dispose();
      }
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'Volver a Mis citas sale de todas las vistas con un toque a escala $scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final repository = newRepository();
        final original = seed(repository, 9);
        await tester.pumpWidget(TallerClickApp(repository: repository));
        await tapVisible(tester, find.text('Mis citas'));

        for (final view in ['detail', 'schedule', 'review', 'cancel']) {
          await tapVisible(tester, find.text('Ver cita TC-0001'));
          if (view == 'schedule' || view == 'review') {
            await tapVisible(tester, find.text('Cambiar fecha y hora'));
          }
          if (view == 'review') {
            await tapVisible(tester, find.text('11:00 · Disponible'));
            await tapVisible(tester, find.text('Revisar cambio'));
          }
          if (view == 'cancel') {
            await tapVisible(tester, find.text('Cancelar cita'));
          }

          await tapVisible(tester, find.text('Volver a Mis citas'));
          expect(find.text('Mis citas'), findsOneWidget, reason: view);
          expect(find.text('Ver cita TC-0001'), findsOneWidget, reason: view);
          expect(repository.appointments, hasLength(1));
          expect(repository.find(original.reference), same(original));
          expect(tester.takeException(), isNull);
        }
      },
    );
  }

  testWidgets('Atrás del sistema conserva el regreso entre pasos de edición', (
    tester,
  ) async {
    final repository = newRepository();
    final original = seed(repository, 9);
    await tester.pumpWidget(TallerClickApp(repository: repository));
    await tapVisible(tester, find.text('Mis citas'));
    await tapVisible(tester, find.text('Ver cita TC-0001'));
    await tapVisible(tester, find.text('Cambiar fecha y hora'));
    await tapVisible(tester, find.text('11:00 · Disponible'));
    await tapVisible(tester, find.text('Revisar cambio'));

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Cambiar fecha y hora'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Detalle de la cita'), findsOneWidget);

    await tapVisible(tester, find.text('Cancelar cita'));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Detalle de la cita'), findsOneWidget);
    expect(repository.find(original.reference), same(original));

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Mis citas'), findsOneWidget);
  });
}
