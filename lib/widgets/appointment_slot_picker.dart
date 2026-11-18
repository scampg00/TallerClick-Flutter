import 'package:flutter/material.dart';

import '../data/appointment_repository.dart';
import '../models/workshop.dart';
import 'appointment_summary.dart';

class AppointmentSlotPicker extends StatelessWidget {
  const AppointmentSlotPicker({
    super.key,
    required this.repository,
    required this.workshop,
    required this.day,
    required this.slot,
    required this.onDayChanged,
    required this.onSlotChanged,
  });
  final AppointmentRepository repository;
  final Workshop workshop;
  final DateTime day;
  final DateTime? slot;
  final ValueChanged<DateTime?> onDayChanged;
  final ValueChanged<DateTime?> onSlotChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text('Día'),
      Semantics(
        label: 'Día de la cita',
        child: DropdownButton<DateTime>(
          value: day,
          isExpanded: true,
          itemHeight: null,
          items: [
            for (final option in repository.bookingDays())
              DropdownMenuItem(
                value: option,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(appointmentDay(option)),
                ),
              ),
          ],
          onChanged: onDayChanged,
        ),
      ),
      const SizedBox(height: 16),
      const Text('Horarios'),
      RadioGroup<DateTime>(
        groupValue: slot,
        onChanged: onSlotChanged,
        child: Column(
          children: [
            for (final option in repository.slotsFor(day))
              if (repository.isAvailable(workshop, option))
                RadioListTile<DateTime>(
                  value: option,
                  title: Text('${appointmentTime(option)} · Disponible'),
                  selected: slot == option,
                )
              else
                ListTile(
                  leading: const Icon(Icons.event_busy_outlined),
                  title: Text('${appointmentTime(option)} · Ocupada'),
                ),
          ],
        ),
      ),
      Semantics(
        liveRegion: true,
        child: Text(
          slot == null
              ? 'Elige una hora disponible para continuar.'
              : 'Hora seleccionada: ${appointmentTime(slot!)}',
        ),
      ),
    ],
  );
}
