import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

import 'booking_test.dart' show enterContact, newRepository;
import 'widget_test.dart' show openPlaza, tapVisible;

void main() {
  testWidgets('Accesibilidad automatizada durante reserva y gestión', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final semantics = tester.ensureSemantics();

    Future<void> checkVisibleScreen() async {
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    }

    try {
      await tester.pumpWidget(TallerClickApp(repository: newRepository()));
      await openPlaza(tester);
      await tapVisible(tester, find.text('Revisión de batería'));
      await tapVisible(tester, find.text('Continuar con este servicio'));
      await checkVisibleScreen();
      await tapVisible(tester, find.byType(DropdownButton<DateTime>));
      await checkVisibleScreen();
      await tapVisible(
        tester,
        find.text('viernes, 20 de noviembre de 2026').last,
      );
      await tapVisible(tester, find.text('09:00 · Disponible'));
      await tapVisible(tester, find.text('Continuar a los datos de contacto'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Revisar reserva'));
      await checkVisibleScreen();
      await enterContact(tester);
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Confirmar reserva'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Ir a Mis citas'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Ver cita TC-0001'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Cambiar fecha y hora'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('11:00 · Disponible'));
      await tapVisible(tester, find.text('Revisar cambio'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Confirmar cambio'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Cancelar cita'));
      await checkVisibleScreen();
      await tapVisible(tester, find.text('Sí, cancelar cita'));
      await checkVisibleScreen();
      expect(find.text('Cita cancelada'), findsWidgets);
    } finally {
      semantics.dispose();
    }
  });
}
