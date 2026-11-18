// Optional evidence generation: CAPTURE_EVIDENCE=1 flutter test ...
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

bool get captureEnabled => Platform.environment['CAPTURE_EVIDENCE'] == '1';

Future<void> loadEvidenceFonts() async {
  if (!captureEnabled) return;
  final root = Platform.environment['FLUTTER_ROOT']!;
  for (final entry in {
    'Roboto': 'Roboto-Regular.ttf',
    'MaterialIcons': 'MaterialIcons-Regular.otf',
  }.entries) {
    final loader = FontLoader(entry.key)
      ..addFont(
        File('$root/bin/cache/artifacts/material_fonts/${entry.value}')
            .readAsBytes()
            .then((bytes) => ByteData.sublistView(bytes)),
      );
    await loader.load();
  }
}

Future<void> captureEvidence(WidgetTester tester, String name) async {
  if (!captureEnabled) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('evidence')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('docs/evidence/r3/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
    } finally {
      image.dispose();
    }
  });
}
