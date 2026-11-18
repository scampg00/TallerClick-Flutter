import '../models/workshop.dart';
import '../models/workshop_service.dart';

enum AppointmentStatus { confirmed }

class Appointment {
  const Appointment({
    required this.reference,
    required this.workshop,
    required this.service,
    required this.slot,
    required this.name,
    required this.phone,
    required this.status,
  });

  final String reference;
  final Workshop workshop;
  final WorkshopService service;
  final DateTime slot;
  final String name;
  final String phone;
  final AppointmentStatus status;
}

/// Shared by booking and consultation for the lifetime of this demo process.
final demoAppointments = AppointmentRepository();

class AppointmentRepository {
  AppointmentRepository({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments =>
      List.unmodifiable(_appointments.reversed);

  List<DateTime> bookingDays() {
    final today = _now();
    return List.generate(
      7,
      (index) => DateTime(today.year, today.month, today.day + index + 1),
    );
  }

  List<DateTime> slotsFor(DateTime day) => [
    for (final hour in [9, 10, 11, 12])
      DateTime(day.year, day.month, day.day, hour),
  ];

  bool isAvailable(Workshop workshop, DateTime slot) {
    final day = DateTime(slot.year, slot.month, slot.day);
    return bookingDays().contains(day) &&
        slotsFor(day).contains(slot) &&
        slot.hour != 10 &&
        !_appointments.any(
          (appointment) =>
              appointment.workshop.id == workshop.id &&
              appointment.slot == slot,
        );
  }

  /// Checks availability and inserts synchronously. All services at the same
  /// workshop share the same capacity.
  Appointment? book({
    required Workshop workshop,
    required WorkshopService service,
    required DateTime slot,
    required String name,
    required String phone,
  }) {
    if (!workshop.services.any((available) => available.id == service.id) ||
        !isAvailable(workshop, slot)) {
      return null;
    }
    final sequence = (_appointments.length + 1).toString().padLeft(4, '0');
    final appointment = Appointment(
      reference: 'TC-$sequence',
      workshop: workshop,
      service: service,
      slot: slot,
      name: name,
      phone: phone,
      status: AppointmentStatus.confirmed,
    );
    _appointments.add(appointment);
    return appointment;
  }
}
