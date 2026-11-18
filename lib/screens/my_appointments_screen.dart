import 'package:flutter/material.dart';

import '../data/appointment_repository.dart';

String appointmentDay(DateTime date) {
  const weekdays = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  return '${weekdays[date.weekday - 1]}, '
      '${date.day} de ${months[date.month - 1]} de ${date.year}';
}

String appointmentTime(DateTime date) =>
    '${date.hour.toString().padLeft(2, '0')}:'
    '${date.minute.toString().padLeft(2, '0')}';

String appointmentStatusLabel(AppointmentStatus status) => switch (status) {
  AppointmentStatus.confirmed => 'Cita confirmada',
};

class AppointmentSummary extends StatelessWidget {
  const AppointmentSummary({
    super.key,
    required this.workshop,
    required this.service,
    required this.slot,
    required this.name,
    required this.phone,
  });

  final String workshop;
  final String service;
  final DateTime slot;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Taller: $workshop'),
      Text('Servicio: $service'),
      Text('Fecha: ${appointmentDay(slot)}'),
      Text('Hora: ${appointmentTime(slot)}'),
      Text('Nombre: $name'),
      Text('Teléfono: $phone'),
    ],
  );
}

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key, required this.repository});

  final AppointmentRepository repository;

  @override
  Widget build(BuildContext context) {
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
            if (appointments.isEmpty) const Text('Todavía no tienes citas.'),
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
                      Text('Referencia: ${appointment.reference}'),
                      const SizedBox(height: 8),
                      AppointmentSummary(
                        workshop: appointment.workshop.name,
                        service: appointment.service.name,
                        slot: appointment.slot,
                        name: appointment.name,
                        phone: appointment.phone,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
