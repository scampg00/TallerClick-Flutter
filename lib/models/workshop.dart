import 'workshop_service.dart';

class Workshop {
  const Workshop({
    required this.id,
    required this.name,
    required this.zone,
    required this.address,
    required this.services,
  });

  final String id;
  final String name;
  final String zone;
  final String address;
  final List<WorkshopService> services;
}
