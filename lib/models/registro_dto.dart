//Visulizaion de registro
class RegistroDTO {
  final int idRegistro;
  final String fecha;
  final String descripcion;
  final int estado;
  final String nombreCliente;
  final String marcaMoto;
  final String modeloMoto;
  final String rutaImagenMoto;

  RegistroDTO({
    required this.idRegistro,
    required this.fecha,
    required this.descripcion,
    required this.estado,
    required this.nombreCliente,
    required this.marcaMoto,
    required this.modeloMoto,
    required this.rutaImagenMoto,
  });

  factory RegistroDTO.fromJson(Map<String, dynamic> json) {
    return RegistroDTO(
      idRegistro: json['idRegistro'],
      fecha: json['fecha'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      nombreCliente: json['nombreCliente'],
      marcaMoto: json['marcaMoto'],
      modeloMoto: json['modeloMoto'],
      rutaImagenMoto: json['rutaImagenMoto'],
    );
  }
}
