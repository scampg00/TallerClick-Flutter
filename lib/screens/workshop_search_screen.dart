import 'package:flutter/material.dart';

import '../data/workshop_catalog.dart';
import '../models/workshop.dart';
import '../models/workshop_service.dart';
import 'workshop_detail_screen.dart';

class WorkshopSearchScreen extends StatefulWidget {
  const WorkshopSearchScreen({
    super.key,
    required this.workshops,
    required this.bookingPageBuilder,
  });

  final List<Workshop> workshops;
  final Widget Function(Workshop workshop, WorkshopService service)
  bookingPageBuilder;

  @override
  State<WorkshopSearchScreen> createState() => _WorkshopSearchScreenState();
}

class _WorkshopSearchScreenState extends State<WorkshopSearchScreen> {
  String? _selectedZone;
  String? _appliedZone;

  @override
  Widget build(BuildContext context) {
    final results = widget.workshops
        .where(
          (workshop) => _appliedZone == null || workshop.zone == _appliedZone,
        )
        .toList();
    final location = _appliedZone == null
        ? 'en todas las zonas'
        : 'en $_appliedZone';
    final resultLabel = results.length == 1
        ? '1 taller $location'
        : '${results.length} talleres $location';

    return Scaffold(
      appBar: AppBar(
        title: const Text('TallerClick'),
        leading: IconButton(
          tooltip: 'Volver al inicio',
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
                'Buscar taller en León',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            const Text(demonstrationNotice),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Zona',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Todas las zonas'),
              isExpanded: true,
              isDense: false,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Todas las zonas'),
                ),
                for (final zone in workshopZones)
                  DropdownMenuItem(value: zone, child: Text(zone)),
              ],
              onChanged: (zone) => setState(() => _selectedZone = zone),
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () => setState(() => _appliedZone = _selectedZone),
              child: const Text('Buscar talleres'),
            ),
            const SizedBox(height: 24),
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                resultLabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (results.isEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _appliedZone == null
                    ? 'No hay talleres en el catálogo de demostración.'
                    : 'No hay talleres en la zona $_appliedZone. '
                          'Elige otra zona y pulsa Buscar talleres.',
              ),
            ],
            for (final workshop in results)
              Card(
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          workshop.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Zona: ${workshop.zone}'),
                      Text('Dirección ficticia: ${workshop.address}'),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () => Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkshopDetailScreen(
                              workshop: workshop,
                              workshops: widget.workshops,
                              bookingPageBuilder: widget.bookingPageBuilder,
                            ),
                          ),
                        ),
                        child: Text('Ver taller: ${workshop.name}'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
