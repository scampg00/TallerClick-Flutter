import 'package:flutter/material.dart';

import '../data/workshop_catalog.dart';
import '../models/workshop.dart';
import '../models/workshop_service.dart';

class WorkshopDetailScreen extends StatefulWidget {
  const WorkshopDetailScreen({
    super.key,
    required this.workshop,
    required this.workshops,
    required this.bookingPageBuilder,
  });

  final Workshop workshop;
  final List<Workshop> workshops;
  final Widget Function(Workshop workshop, WorkshopService service)
  bookingPageBuilder;

  @override
  State<WorkshopDetailScreen> createState() => _WorkshopDetailScreenState();
}

class _WorkshopDetailScreenState extends State<WorkshopDetailScreen> {
  String? _selectedServiceId;
  bool _openingBooking = false;

  Workshop? get _workshop {
    for (final workshop in widget.workshops) {
      if (workshop.id == widget.workshop.id) return workshop;
    }
    return null;
  }

  WorkshopService? _selectedService(Workshop workshop) {
    for (final service in workshop.services) {
      if (service.id == _selectedServiceId) return service;
    }
    return null;
  }

  Future<void> _continueToBooking() async {
    final workshop = _workshop;
    final service = workshop == null ? null : _selectedService(workshop);
    if (workshop == null || service == null || _openingBooking) return;

    setState(() => _openingBooking = true);
    try {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => widget.bookingPageBuilder(workshop, service),
        ),
      );
    } finally {
      if (mounted) setState(() => _openingBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workshop = _workshop;
    final service = workshop == null ? null : _selectedService(workshop);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TallerClick'),
        leading: IconButton(
          tooltip: 'Volver a los talleres',
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
                workshop?.name ?? 'Taller no disponible',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            if (workshop == null)
              const Text(
                'No se puede usar esta selección. '
                'Vuelve a elegir el taller y el servicio.',
              )
            else ...[
              Text('Zona: ${workshop.zone}'),
              Text('Dirección ficticia: ${workshop.address}'),
              const SizedBox(height: 16),
              const Text(demonstrationNotice),
              const SizedBox(height: 24),
              Semantics(
                header: true,
                child: Text(
                  'Elige un servicio',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: service?.id,
                onChanged: (value) =>
                    setState(() => _selectedServiceId = value),
                child: Column(
                  children: [
                    for (final option in workshop.services)
                      RadioListTile<String>(
                        value: option.id,
                        title: Text(option.name),
                        subtitle: Text(option.description),
                        contentPadding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        visualDensity: VisualDensity.standard,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: Text(
                  service == null
                      ? 'Selecciona un servicio para continuar.'
                      : 'Servicio seleccionado: ${service.name}',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: service == null || _openingBooking
                    ? null
                    : _continueToBooking,
                child: const Text('Continuar con este servicio'),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver a los talleres'),
            ),
          ],
        ),
      ),
    );
  }
}
