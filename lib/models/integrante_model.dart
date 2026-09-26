class IntegranteModel {
  final String nombre;
  final String inicial;
  final String rol;
  final String area;
  final String aporte;
  final String tecnologias;
  final String frase;

  IntegranteModel({
    required this.nombre,
    required this.inicial,
    required this.rol,
    required this.area,
    required this.aporte,
    required this.tecnologias,
    required this.frase,
  });
}

final List<IntegranteModel> equipoVitaCode = [
  IntegranteModel(
    nombre: 'Alondra Espino Perez',
    inicial: 'A',
    rol: 'Lider y Manager del Proyecto',
    area:
        'Frontend, backend, base de datos, documentacion y maquetado del pastillero.',
    aporte:
        'Lidero el desarrollo completo de la aplicacion y coordino al equipo para integrar todas las areas del proyecto.',
    tecnologias: 'Dart, Flutter, Laravel, MySQL, Arduino',
    frase:
        'Una vision clara y un equipo unido pueden convertir una idea en realidad.',
  ),
  IntegranteModel(
    nombre: 'Monserrath Gutierrez Gonzalez',
    inicial: 'M',
    rol: 'Scrum Master',
    area: 'Documentacion y gestion agil del proyecto.',
    aporte:
        'Estructuro la documentacion tecnica y mantuvo la organizacion del equipo durante todo el desarrollo.',
    tecnologias: 'Scrum, Markdown, Google Docs',
    frase:
        'La documentacion no es un requisito, es la memoria del equipo.',
  ),
  IntegranteModel(
    nombre: 'Carol Aranza Mora Bautista',
    inicial: 'C',
    rol: 'Desarrollador Database',
    area: 'Diseno e implementacion de la base de datos.',
    aporte:
        'Creo la base de datos completa desde Laragon, definiendo las tablas y relaciones del sistema.',
    tecnologias: 'Laragon, MySQL, phpMyAdmin',
    frase:
        'Una base solida de datos es el cimiento de cualquier gran sistema.',
  ),
  IntegranteModel(
    nombre: 'Virginia Lizeth Quiroz Marquez',
    inicial: 'V',
    rol: 'Desarrollador Backend',
    area: 'Creacion de la API REST.',
    aporte:
        'Concibio la idea del proyecto y desarrollo la API REST completa que conecta la app con la base de datos.',
    tecnologias: 'Laravel, PHP, MySQL, Postman',
    frase:
        'Detras de cada boton hay una API que hace posible lo imposible.',
  ),
  IntegranteModel(
    nombre: 'Alexis Rojas Dario',
    inicial: 'A',
    rol: 'Desarrollador Hardware y Firmware',
    area: 'Maquetado fisico, codigo en C y Arduino.',
    aporte:
        'Diseno y construyo el pastillero fisico, programando los sensores y el firmware en Arduino.',
    tecnologias: 'Arduino, C, Electronica, Sensores',
    frase:
        'El hardware da vida a las ideas: cada sensor es una promesa cumplida.',
  ),
];