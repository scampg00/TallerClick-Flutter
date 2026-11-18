import 'package:flutter/material.dart';

import '../data/appointment_repository.dart';
import '../models/workshop.dart';
import '../models/workshop_service.dart';
import 'my_appointments_screen.dart';
import '../widgets/appointment_slot_picker.dart';

enum _Step { schedule, contact, review, confirmed }

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
    required this.workshop,
    required this.service,
    required this.repository,
  });

  final Workshop workshop;
  final WorkshopService service;
  final AppointmentRepository repository;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();

  _Step _step = _Step.schedule;
  DateTime? _day;
  DateTime? _slot;
  Appointment? _appointment;
  bool _slotChanged = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _showStep(_Step step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
  }

  void _review() {
    if (_formKey.currentState?.validate() ?? false) {
      _showStep(_Step.review);
    } else if (_name.text.trim().isEmpty) {
      _nameFocus.requestFocus();
    } else {
      _phoneFocus.requestFocus();
    }
  }

  void _confirm() {
    final slot = _slot;
    if (_step != _Step.review || _appointment != null || slot == null) return;

    final appointment = widget.repository.book(
      workshop: widget.workshop,
      service: widget.service,
      slot: slot,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
    );

    if (appointment == null) {
      setState(() {
        _slot = null;
        _day = null;
        _slotChanged = true;
        _step = _Step.schedule;
      });
      return;
    }
    setState(() {
      _appointment = appointment;
      _step = _Step.confirmed;
    });
  }

  void _back() {
    switch (_step) {
      case _Step.contact:
        _showStep(_Step.schedule);
      case _Step.review:
        _showStep(_Step.contact);
      case _Step.schedule:
      case _Step.confirmed:
        Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = _appointment == null
        ? null
        : widget.repository.find(_appointment!.reference);
    final title = switch (_step) {
      _Step.schedule => 'Elige fecha y hora',
      _Step.contact => 'Datos de contacto',
      _Step.review => 'Revisa tu reserva',
      _Step.confirmed => appointmentStatusLabel(appointment!.status),
    };

    return PopScope(
      canPop: _step == _Step.schedule || _step == _Step.confirmed,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && (_step == _Step.contact || _step == _Step.review)) {
          _back();
        }
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
            key: ValueKey(_step),
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
              if (_step == _Step.schedule) ..._schedule(context),
              if (_step == _Step.contact) _contact(),
              if (_step == _Step.review) ..._reviewDetails(),
              if (appointment != null) ..._confirmed(appointment),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _schedule(BuildContext context) {
    final days = widget.repository.bookingDays();
    final day = days.contains(_day) ? _day! : days.first;
    final hours = widget.repository.slotsFor(day);
    final selected =
        hours.contains(_slot) &&
            widget.repository.isAvailable(widget.workshop, _slot!)
        ? _slot
        : null;

    return [
      Text('Taller: ${widget.workshop.name}'),
      Text('Servicio: ${widget.service.name}'),
      const SizedBox(height: 16),
      if (_slotChanged)
        Semantics(
          liveRegion: true,
          child: const Text(
            'La hora elegida ya no está disponible. Elige otra franja.',
          ),
        ),
      AppointmentSlotPicker(
        repository: widget.repository,
        workshop: widget.workshop,
        day: day,
        slot: selected,
        onDayChanged: (option) => setState(() {
          _day = option;
          _slot = null;
        }),
        onSlotChanged: (option) => setState(() {
          _slot = option;
          _slotChanged = false;
        }),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: selected == null ? null : () => _showStep(_Step.contact),
        child: const Text('Continuar a los datos de contacto'),
      ),
      const SizedBox(height: 12),
      _secondary('Volver a los servicios', _back),
    ];
  }

  Widget _contact() => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Usa datos ficticios en esta demostración.'),
        const SizedBox(height: 16),
        TextFormField(
          controller: _name,
          focusNode: _nameFocus,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (value) =>
              (value ?? '').trim().isEmpty ? 'Escribe tu nombre.' : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _phone,
          focusNode: _phoneFocus,
          decoration: const InputDecoration(
            labelText: 'Teléfono',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
            helperText: 'De 9 a 15 dígitos; puedes incluir el prefijo.',
            helperMaxLines: 3,
            errorMaxLines: 3,
          ),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          validator: (value) {
            final phone = (value ?? '').trim();
            if (phone.isEmpty) return 'Escribe tu número de teléfono.';
            final compact = phone.replaceAll(RegExp(r'[\s().-]'), '');
            if (!RegExp(r'^\+?[0-9]{9,15}$').hasMatch(compact)) {
              return 'Introduce un teléfono de 9 a 15 dígitos.';
            }
            return null;
          },
          onFieldSubmitted: (_) => _review(),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _review,
          child: const Text('Revisar reserva'),
        ),
        const SizedBox(height: 12),
        _secondary('Volver a los horarios', _back),
      ],
    ),
  );

  List<Widget> _reviewDetails() => [
    AppointmentSummary(
      workshop: widget.workshop.name,
      service: widget.service.name,
      slot: _slot!,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
    ),
    const SizedBox(height: 20),
    ElevatedButton(onPressed: _confirm, child: const Text('Confirmar reserva')),
    const SizedBox(height: 12),
    _secondary('Editar datos de contacto', _back),
  ];

  List<Widget> _confirmed(Appointment appointment) => [
    Text('Referencia: ${appointment.reference}'),
    const SizedBox(height: 8),
    AppointmentSummary(
      workshop: appointment.workshop.name,
      service: appointment.service.name,
      slot: appointment.slot,
      name: appointment.name,
      phone: appointment.phone,
    ),
    const SizedBox(height: 16),
    const Text(
      'La cita de demostración se guarda mientras la app esté abierta.',
    ),
    const SizedBox(height: 20),
    ElevatedButton(
      onPressed: () async {
        await Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (_) => MyAppointmentsScreen(repository: widget.repository),
          ),
        );
        if (mounted) setState(() {});
      },
      child: const Text('Ir a Mis citas'),
    ),
    const SizedBox(height: 12),
    _secondary(
      'Volver al inicio',
      () => Navigator.popUntil(context, (route) => route.isFirst),
    ),
  ];

  Widget _secondary(String label, VoidCallback onPressed) => OutlinedButton(
    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
    onPressed: onPressed,
    child: Text(label),
  );
}
