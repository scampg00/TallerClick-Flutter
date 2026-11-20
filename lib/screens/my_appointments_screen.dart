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
        final confirmed = appointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.confirmed,
            )
            .toList();
        final cancelled = appointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.cancelled,
            )
            .toList();
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
                if (appointments.isNotEmpty) ...[
                  _heading(context, 'Citas confirmadas'),
                  if (confirmed.isEmpty)
                    const Text('No tienes citas confirmadas.'),
                  for (final appointment in confirmed)
                    _appointmentCard(context, appointment),
                  if (cancelled.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _heading(context, 'Citas canceladas'),
                    const Text('Estas citas ya no están activas.'),
                    for (final appointment in cancelled)
                      _appointmentCard(context, appointment),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _heading(BuildContext context, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Semantics(
      header: true,
      child: Text(label, style: Theme.of(context).textTheme.headlineSmall),
    ),
  );

  Widget _appointmentCard(BuildContext context, Appointment appointment) {
    final isCancelled = appointment.status == AppointmentStatus.cancelled;
    final theme = Theme.of(context);
    final statusColor =
        theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    return Card(
      color: isCancelled ? theme.scaffoldBackgroundColor : null,
      shape: isCancelled
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: statusColor, width: 2),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isCancelled) ...[
                  ExcludeSemantics(
                    child: Icon(Icons.event_busy, color: statusColor),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      appointmentStatusLabel(appointment.status),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: isCancelled ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (appointment.rescheduled && !isCancelled)
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
    );
  }
}
