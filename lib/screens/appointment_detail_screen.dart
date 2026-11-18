import 'package:flutter/material.dart';

import '../data/appointment_repository.dart';
import '../widgets/appointment_slot_picker.dart';
import '../widgets/appointment_summary.dart';

enum _View { detail, schedule, review, cancel }

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({
    super.key,
    required this.repository,
    required this.reference,
  });
  final AppointmentRepository repository;
  final String reference;

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  _View _view = _View.detail;
  Appointment? _expected;
  DateTime? _day;
  DateTime? _slot;
  String? _message;

  void _back() {
    if (_view == _View.detail) {
      Navigator.maybePop(context);
    } else {
      setState(
        () => _view = _view == _View.review ? _View.schedule : _View.detail,
      );
    }
  }

  void _apply(bool cancel) {
    final expected = _expected;
    if (expected == null ||
        (cancel ? _view != _View.cancel : _view != _View.review)) {
      return;
    }
    final success = cancel
        ? widget.repository.cancel(expected)
        : widget.repository.reschedule(expected, _slot!);
    setState(() {
      _expected = null;
      _view = _View.detail;
      _message = success ? (cancel ? 'Cita cancelada' : 'Cita modificada') : 'No se pudo aplicar la operación. La cita o la disponibilidad han cambiado. Revisa los datos y vuelve a intentarlo.';
    });
  }

  Widget _button(String label, VoidCallback? action) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      onPressed: action,
      child: Text(label),
    ),
  );

  Widget _summary(Appointment appointment, {DateTime? slot}) =>
      AppointmentSummary(
        workshop: appointment.workshop.name,
        service: appointment.service.name,
        slot: slot ?? appointment.slot,
        name: appointment.name,
        phone: appointment.phone,
      );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.repository,
    builder: (context, _) {
      final appointment = widget.repository.find(widget.reference);
      final days = widget.repository.bookingDays();
      final day = days.contains(_day) ? _day! : days.first;
      final title = switch (_view) {
        _View.detail => 'Detalle de la cita',
        _View.schedule => 'Cambiar fecha y hora',
        _View.review => 'Revisa el cambio',
        _View.cancel => '¿Cancelar esta cita?',
      };
      return PopScope(
        canPop: _view == _View.detail,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _back();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('TallerClick'),
            leading: IconButton(
              tooltip: 'Volver',
              onPressed: _back,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SafeArea(
            child: ListView(
              key: ValueKey(_view),
              padding: const EdgeInsets.all(24),
              children: [
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                if (_message != null)
                  Semantics(liveRegion: true, child: Text(_message!)),
                if (appointment == null)
                  const Text('No se encuentra esta cita.')
                else ...[
                  Text('Referencia: ${appointment.reference}'),
                  Text(appointmentStatusLabel(appointment.status)),
                  if (appointment.rescheduled)
                    const Text('Fecha y hora modificadas'),
                  const SizedBox(height: 16),
                  _summary(appointment),
                  if (_view == _View.detail &&
                      appointment.status == AppointmentStatus.confirmed) ...[
                    _button(
                      'Cambiar fecha y hora',
                      () => setState(() {
                        _expected = appointment;
                        _slot = null;
                        _day = null;
                        _message = null;
                        _view = _View.schedule;
                      }),
                    ),
                    _button(
                      'Cancelar cita',
                      () => setState(() {
                        _expected = appointment;
                        _message = null;
                        _view = _View.cancel;
                      }),
                    ),
                  ],
                  if (_view == _View.schedule) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Elige una nueva fecha y hora. La franja actual permanece reservada hasta confirmar el cambio.',
                    ),
                    AppointmentSlotPicker(
                      repository: widget.repository,
                      workshop: appointment.workshop,
                      day: day,
                      slot: _slot,
                      currentSlot: appointment.slot,
                      onDayChanged: (value) => setState(() {
                        _day = value;
                        _slot = null;
                      }),
                      onSlotChanged: (value) => setState(() => _slot = value),
                    ),
                    _button(
                      'Revisar cambio',
                      _slot == null
                          ? null
                          : () => setState(() => _view = _View.review),
                    ),
                    _button(
                      'Mantener fecha y hora actuales',
                      () => setState(() => _view = _View.detail),
                    ),
                  ],
                  if (_view == _View.review) ...[
                    const SizedBox(height: 16),
                    const Text('Nueva fecha y hora'),
                    _summary(_expected!, slot: _slot),
                    _button('Confirmar cambio', () => _apply(false)),
                    _button('Volver a elegir horario', _back),
                  ],
                  if (_view == _View.cancel) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Al confirmar se cancelará esta cita y su horario quedará disponible.',
                    ),
                    _button(
                      'No, mantener mi cita',
                      () => setState(() => _view = _View.detail),
                    ),
                    _button('Sí, cancelar cita', () => _apply(true)),
                  ],
                ],
                _button(
                  'Volver a Mis citas',
                  () => Navigator.maybePop(context),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
