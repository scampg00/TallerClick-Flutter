import 'package:flutter/material.dart';

import 'data/workshop_catalog.dart';
import 'data/appointment_repository.dart';
import 'screens/my_appointments_screen.dart';
import 'models/workshop.dart';
import 'models/workshop_service.dart';
import 'screens/booking_pending_screen.dart';
import 'screens/workshop_search_screen.dart';

void main() => runApp(const TallerClickApp());

class TallerClickApp extends StatelessWidget {
  const TallerClickApp({super.key, this.bookingPageBuilder, this.repository});

  final Widget Function(Workshop workshop, WorkshopService service)?
  bookingPageBuilder;
  final AppointmentRepository? repository;
  static const navy = Color(0xFF123A4A);
  static const soft = Color(0xFFF1F6F7);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TallerClick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: navy),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: navy,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: soft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: HomeScreen(
        repository: repository ?? demoAppointments,
        bookingPageBuilder:
            bookingPageBuilder ??
            (workshop, service) => BookingPendingScreen(
              workshop: workshop,
              service: service,
              repository: repository ?? demoAppointments,
            ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final AppointmentRepository repository;
  const HomeScreen({
    super.key,
    required this.bookingPageBuilder,
    required this.repository,
  });

  final Widget Function(Workshop workshop, WorkshopService service)
  bookingPageBuilder;
  @override
  Widget build(BuildContext context) => BasePage(
    title: '¿Qué necesitas hacer?',
    children: [
      const Text('Busca talleres, reserva una cita y gestiónala sin llamadas.'),
      const SizedBox(height: 12),
      const Text(demonstrationNotice),
      const SizedBox(height: 20),
      FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        onPressed: () => Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (_) => WorkshopSearchScreen(
              workshops: workshops,
              bookingPageBuilder: bookingPageBuilder,
            ),
          ),
        ),
        child: const Text('Buscar taller'),
      ),
      const SizedBox(height: 12),
      OutlinedButton(
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyAppointmentsScreen(repository: repository),
          ),
        ),
        child: const Text('Mis citas'),
      ),
    ],
  );
}

class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('TallerClick')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    ),
  );
}
