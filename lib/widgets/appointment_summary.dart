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
  AppointmentStatus.cancelled => 'Cita cancelada',
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
