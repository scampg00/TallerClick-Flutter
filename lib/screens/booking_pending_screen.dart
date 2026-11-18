import 'package:flutter/material.dart';

import '../data/appointment_repository.dart';
import '../models/workshop.dart';
import '../models/workshop_service.dart';
import 'booking_screen.dart';

/// Entry point used by the current app shell.
class BookingPendingScreen extends StatelessWidget {
  const BookingPendingScreen({
    super.key,
    required this.workshop,
    required this.service,
  });

  final Workshop workshop;
  final WorkshopService service;

  @override
  Widget build(BuildContext context) => BookingScreen(
    workshop: workshop,
    service: service,
    repository: demoAppointments,
  );
}
