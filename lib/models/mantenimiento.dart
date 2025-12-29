//Almacenamiento de Registro
//Creacio y Actualiacion(Aun no implementada)
class Mantenimiento {
  final int? idMantenimiento;
  final int? idCliente;
  final int? idEncargado;
  final int? idMoto;
  final int? idTipo;
  final int? estado;
  final String? observaciones;
  final String? fechaRegistro;
  final String? fechaModificacion;

  Mantenimiento({
    this.idMantenimiento,
    this.idCliente,
    this.idEncargado,
    this.idMoto,
    this.idTipo,
    this.estado,
    this.observaciones,
    this.fechaRegistro,
    this.fechaModificacion,
  });

  // Para recibir datos del backend (con todos los campos)
  factory Mantenimiento.fromJson(Map<String, dynamic> json) {
    return Mantenimiento(
      idMantenimiento: json['idMantenimiento'],
      idCliente: json['idCliente'],
      idEncargado: json['idEncargado'],
      idMoto: json['idMoto'],
      idTipo: json['idTipo'],
      estado: json['estado'],
      observaciones: json['observaciones'],
      fechaRegistro: json['fechaRegistro'],
      fechaModificacion: json['fechaModificacion'],
    );
  }

  // Para enviar datos completos (actualización)
  Map<String, dynamic> toJson() {
    return {
      'idMantenimiento': idMantenimiento,
      'idCliente': idCliente,
      'idEncargado': idEncargado,
      'idMoto': idMoto,
      'idTipo': idTipo,
      'estado': estado,
      'observaciones': observaciones,
      'fechaRegistro': fechaRegistro,
      'fechaModificacion': fechaModificacion,
    };
  }

  // ⬅️ NUEVO: Para crear (sin campos autogenerados)
  Map<String, dynamic> toJsonCreate({required List<Map<String, dynamic>> detalles}) {
    return {
      'idCliente': idCliente,
      'idEncargado': idEncargado,
      'idMoto': idMoto,
      'idTipo': idTipo,
      'estado': estado,
      'observaciones': observaciones,
      'detalles': detalles,
    };
  }
}