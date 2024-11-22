class Tarea {
  int id;
  String nombre;
  String descripcion;
  bool completada;
  DateTime fechaCreacion;
  bool eliminada;
  DateTime? fechaLimite;
  String? prioridad;
  String? categoria;
  String? responsable;
  String? comentarios;

  Tarea({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.completada = false,
    required this.fechaCreacion,
    this.eliminada = false,
    this.fechaLimite,
    this.prioridad,
    this.categoria,
    this.responsable,
    this.comentarios,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      completada: json['completada'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      eliminada: json['eliminada'],
      fechaLimite: json['fechaLimite'] != null ? DateTime.parse(json['fechaLimite']) : null,
      prioridad: json['prioridad'],
      categoria: json['categoria'],
      responsable: json['responsable'],
      comentarios: json['comentarios'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'completada': completada,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'eliminada': eliminada,
      'fechaLimite': fechaLimite?.toIso8601String(),
      'prioridad': prioridad,
      'categoria': categoria,
      'responsable': responsable,
      'comentarios': comentarios,
    };
  }
}
