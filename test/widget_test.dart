import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/data/workshop_catalog.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/workshop.dart';
import 'package:flutter_application_1/models/workshop_service.dart';
import 'package:flutter_application_1/screens/workshop_detail_screen.dart';

Future<void> showVisible(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).last,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await showVisible(tester, finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> chooseZone(WidgetTester tester, String zone) async {
  tester
      .state<ScrollableState>(find.byType(Scrollable).last)
      .position
      .jumpTo(0);
  await tester.pumpAndSettle();
  await tapVisible(tester, find.byType(DropdownButtonFormField<String>));
  await tapVisible(tester, find.text(zone).last);
}

Future<void> openPlaza(WidgetTester tester) async {
  await tapVisible(tester, find.text('Buscar taller'));
  await chooseZone(tester, 'Centro');
  await tapVisible(tester, find.text('Buscar talleres'));
  await tapVisible(tester, find.text('Ver taller: Taller Demo Plaza'));
}

void main() {
  testWidgets('Filtra solo al buscar y permite recuperarse de una zona vacía', (
    tester,
  ) async {
    await tester.pumpWidget(const TallerClickApp());
    expect(find.text('Mis citas'), findsOneWidget);
    expect(find.text(demonstrationNotice), findsOneWidget);
    await tapVisible(tester, find.text('Buscar taller'));
    expect(find.text('4 talleres en todas las zonas'), findsOneWidget);

    await chooseZone(tester, 'Centro');
    expect(find.text('4 talleres en todas las zonas'), findsOneWidget);
    await tapVisible(tester, find.text('Buscar talleres'));
    expect(find.text('2 talleres en Centro'), findsOneWidget);
    expect(find.text('Taller Demo Norte'), findsNothing);

    await chooseZone(tester, 'Oeste');
    expect(find.text('2 talleres en Centro'), findsOneWidget);
    await tapVisible(tester, find.text('Buscar talleres'));
    expect(
      find.textContaining('No hay talleres en la zona Oeste.'),
      findsOneWidget,
    );

    await chooseZone(tester, 'Sur');
    await tapVisible(tester, find.text('Buscar talleres'));
    expect(find.text('1 taller en Sur'), findsOneWidget);
    expect(find.text('Taller Demo Sur'), findsOneWidget);

    await chooseZone(tester, 'Todas las zonas');
    await tapVisible(tester, find.text('Buscar talleres'));
    expect(find.text('4 talleres en todas las zonas'), findsOneWidget);
  });

  testWidgets('Entrega una única selección y la conserva al volver de R2', (
    tester,
  ) async {
    Workshop? receivedWorkshop;
    WorkshopService? receivedService;
    await tester.pumpWidget(
      TallerClickApp(
        bookingPageBuilder: (workshop, service) {
          receivedWorkshop = workshop;
          receivedService = service;
          return Scaffold(
            appBar: AppBar(title: const Text('Entrada de prueba a R2')),
            body: Text('${workshop.name}: ${service.name}'),
          );
        },
      ),
    );
    await openPlaza(tester);
    expect(find.text('Revisión de frenos'), findsOneWidget);
    expect(find.text('Revisión de batería'), findsOneWidget);
    expect(find.text('Cambio de aceite'), findsNothing);
    final continueButton = find.widgetWithText(
      FilledButton,
      'Continuar con este servicio',
    );
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tapVisible(tester, find.text('Revisión de frenos'));
    await tapVisible(tester, find.text('Revisión de batería'));
    expect(
      tester
          .widget<RadioGroup<String>>(find.byType(RadioGroup<String>))
          .groupValue,
      'battery-check',
    );
    expect(
      find.text('Servicio seleccionado: Revisión de batería'),
      findsOneWidget,
    );
    await tapVisible(tester, continueButton);
    expect(receivedWorkshop, same(workshops[1]));
    expect(receivedService?.id, 'battery-check');
    expect(receivedService, same(workshops[1].services[1]));

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      find.text('Servicio seleccionado: Revisión de batería'),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Volver a los talleres'));
    expect(find.text('2 talleres en Centro'), findsOneWidget);
    await tapVisible(tester, find.text('Ver taller: Taller Demo Centro'));
    expect(find.text('Selecciona un servicio para continuar.'), findsOneWidget);
    await showVisible(tester, continueButton);
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);
  });

  testWidgets('La continuación provisional explica que no hay ninguna cita', (
    tester,
  ) async {
    await tester.pumpWidget(const TallerClickApp());
    await openPlaza(tester);
    await tapVisible(tester, find.text('Revisión de batería'));
    await tapVisible(tester, find.text('Continuar con este servicio'));
    expect(find.text('Taller: Taller Demo Plaza'), findsOneWidget);
    expect(find.text('Servicio: Revisión de batería'), findsOneWidget);
    expect(
      find.textContaining('No se ha creado ninguna cita.'),
      findsOneWidget,
    );
    await tapVisible(tester, find.text('Volver a los servicios'));
    expect(
      find.text('Servicio seleccionado: Revisión de batería'),
      findsOneWidget,
    );
  });

  testWidgets('Un taller inexistente no permite continuar y ofrece regreso', (
    tester,
  ) async {
    var bookingOpened = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkshopDetailScreen(
                    workshop: const Workshop(
                      id: 'missing',
                      name: 'Referencia inexistente',
                      zone: 'Centro',
                      address: '',
                      services: [],
                    ),
                    workshops: workshops,
                    bookingPageBuilder: (_, _) {
                      bookingOpened = true;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              child: const Text('Abrir referencia inválida'),
            ),
          ),
        ),
      ),
    );
    await tapVisible(tester, find.text('Abrir referencia inválida'));
    expect(
      find.textContaining('No se puede usar esta selección.'),
      findsOneWidget,
    );
    expect(find.text('Continuar con este servicio'), findsNothing);
    expect(bookingOpened, isFalse);
    await tapVisible(tester, find.text('Volver a los talleres'));
    expect(find.text('Abrir referencia inválida'), findsOneWidget);
  });

  testWidgets('R1 se puede completar en 390 × 844 con texto al 200 %', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const TallerClickApp());
    await openPlaza(tester);
    expect(tester.takeException(), isNull);
    await tapVisible(tester, find.text('Revisión de batería'));
    await tapVisible(tester, find.text('Continuar con este servicio'));
    expect(tester.takeException(), isNull);
    expect(find.text('Servicio elegido'), findsOneWidget);
    await tapVisible(tester, find.text('Volver a los servicios'));
    await tapVisible(tester, find.text('Volver a los talleres'));
    tester
        .state<ScrollableState>(find.byType(Scrollable).last)
        .position
        .jumpTo(0);
    await tester.pumpAndSettle();
    await showVisible(tester, find.text('2 talleres en Centro'));
    expect(find.text('2 talleres en Centro'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Controles con etiqueta, tamaño táctil y contraste de texto', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const TallerClickApp());
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await tapVisible(tester, find.text('Buscar taller'));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await chooseZone(tester, 'Centro');
      await tapVisible(tester, find.text('Buscar talleres'));
      await tapVisible(tester, find.text('Ver taller: Taller Demo Plaza'));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      semantics.dispose();
    }
  });
}
