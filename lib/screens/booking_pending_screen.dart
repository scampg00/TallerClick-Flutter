import 'package:flutter/material.dart';

import '../models/workshop.dart';
import '../models/workshop_service.dart';

/// Temporary destination until the booking flow supplies its page builder.
class BookingPendingScreen extends StatelessWidget {
  const BookingPendingScreen({
    super.key,
    required this.workshop,
    required this.service,
  });

  final Workshop workshop;
  final WorkshopService service;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('TallerClick'),
      leading: IconButton(
        tooltip: 'Volver a los servicios',
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Semantics(
            header: true,
            child: Text(
              'Servicio elegido',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          Text('Taller: ${workshop.name}'),
          Text('Servicio: ${service.name}'),
          const SizedBox(height: 16),
          const Text(
            'La reserva de citas aún no está disponible en este prototipo. '
            'No se ha creado ninguna cita.',
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver a los servicios'),
          ),
        ],
      ),
    ),
  );
}
