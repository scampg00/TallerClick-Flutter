import '../models/workshop.dart';
import '../models/workshop_service.dart';

const _oilChange = WorkshopService(
  id: 'oil-change',
  name: 'Cambio de aceite',
  description: 'Sustituimos el aceite del motor y comprobamos su nivel.',
);
const _tyreCheck = WorkshopService(
  id: 'tyre-check',
  name: 'Revisión de neumáticos',
  description: 'Comprobamos la presión y el desgaste de las ruedas.',
);
const _brakeCheck = WorkshopService(
  id: 'brake-check',
  name: 'Revisión de frenos',
  description:
      'Revisamos las pastillas y los discos que ayudan a frenar el coche.',
);
const _batteryCheck = WorkshopService(
  id: 'battery-check',
  name: 'Revisión de batería',
  description:
      'Comprobamos si la batería tiene carga suficiente para arrancar.',
);
const _basicCheck = WorkshopService(
  id: 'basic-check',
  name: 'Revisión básica',
  description:
      'Comprobamos los niveles de líquidos, las luces y los neumáticos.',
);

const workshopServices = <WorkshopService>[
  _oilChange,
  _tyreCheck,
  _brakeCheck,
  _batteryCheck,
  _basicCheck,
];

const workshops = <Workshop>[
  Workshop(
    id: 'workshop-centre-01',
    name: 'Taller Demo Chantría',
    zone: 'La Chantría',
    address: 'Calle de Ejemplo, 10 · León',
    services: [_oilChange, _tyreCheck, _basicCheck],
  ),
  Workshop(
    id: 'workshop-centre-02',
    name: 'Taller Demo Plaza',
    zone: 'La Chantría',
    address: 'Plaza de Muestra, 4 · León',
    services: [_brakeCheck, _batteryCheck],
  ),
  Workshop(
    id: 'workshop-north-01',
    name: 'Taller Demo Eras',
    zone: 'Eras de Renueva',
    address: 'Avenida de Prueba, 22 · León',
    services: [_oilChange, _brakeCheck, _batteryCheck],
  ),
  Workshop(
    id: 'workshop-south-01',
    name: 'Taller Demo Palomera',
    zone: 'La Palomera',
    address: 'Calle del Prototipo, 8 · León',
    services: [_tyreCheck, _basicCheck],
  ),
];

const workshopZones = <String>[
  'La Chantría',
  'Eras de Renueva',
  'La Palomera',
  'El Ejido',
];

const demonstrationNotice =
    'Prototipo para León. Los barrios son reales; los talleres y las direcciones son ficticios.';
