import 'package:flutter/material.dart';

import '../data/appointment_repository.dart';
import 'appointment_detail_screen.dart';
import '../widgets/appointment_summary.dart';
export '../widgets/appointment_summary.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key, required this.repository});

  final AppointmentRepository repository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (context, _) {
        final appointments = repository.appointments;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis citas'),
            leading: IconButton(
              tooltip: 'Volver',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (appointments.isEmpty)
                  const Text('Todavía no tienes citas.'),
                for (final appointment in appointments)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              appointmentStatusLabel(appointment.status),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          if (appointment.rescheduled)
                            const Text('Cita modificada'),
                          Text('Referencia: ${appointment.reference}'),
                          const SizedBox(height: 8),
                          AppointmentSummary(
                            workshop: appointment.workshop.name,
                            service: appointment.service.name,
                            slot: appointment.slot,
                            name: appointment.name,
                            phone: appointment.phone,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                            onPressed: () => Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppointmentDetailScreen(
                                  repository: repository,
                                  reference: appointment.reference,
                                ),
                              ),
                            ),
                            child: Text('Ver cita ${appointment.reference}'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
