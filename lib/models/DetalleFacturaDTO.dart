class DetalleFacturaDTO {
  final int? idDetalleFactura;
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final int? idProducto;

  DetalleFacturaDTO({
    this.idDetalleFactura,
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.idProducto,
  });

  // Constructor desde JSON (para recibir del backend)
  factory DetalleFacturaDTO.fromJson(Map<String, dynamic> json) {
    return DetalleFacturaDTO(
      idDetalleFactura: _parseIntOrList(json['idDetalleFactura']),
      descripcion: _parseStringOrList(json['descripcion']) ?? '',
      cantidad: _parseIntOrList(json['cantidad']) ?? 0,
      precioUnitario: _parseDoubleOrList(json['precioUnitario']) ?? 0.0,
      subtotal: _parseDoubleOrList(json['subtotal']) ?? 0.0,
      idProducto: _parseIntOrList(json['idProducto']),
    );
  }

  // Convertir a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'idDetalleFactura': idDetalleFactura,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
      'idProducto': idProducto,
    };
  }

  // ========== FUNCIONES AUXILIARES ==========

  // Función auxiliar para manejar campos que pueden ser String o List<dynamic>
  static String? _parseStringOrList(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value.isNotEmpty ? value : null;
    } else if (value is List) {
      // Si es una lista vacía, retorna null
      if (value.isEmpty) return null;
      // Si la lista tiene elementos, intenta convertir el primero a string
      return value.first.toString();
    } else {
      // Para cualquier otro tipo, convertir a string
      return value.toString();
    }
  }

  // Función auxiliar para manejar campos numéricos (int)
  static int? _parseIntOrList(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      if (value.isNotEmpty) {
        return int.tryParse(value);
      }
      return null;
    } else if (value is List) {
      if (value.isEmpty) return null;

      final firstValue = value.first;
      if (firstValue is int) {
        return firstValue;
      } else if (firstValue is double) {
        return firstValue.toInt();
      } else if (firstValue is String) {
        return int.tryParse(firstValue);
      }
      return null;
    }
    return null;
  }

  // Función auxiliar para manejar campos double
  static double? _parseDoubleOrList(dynamic value) {
    if (value == null) return null;

    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      if (value.isNotEmpty) {
        return double.tryParse(value);
      }
      return null;
    } else if (value is List) {
      if (value.isEmpty) return null;

      final firstValue = value.first;
      if (firstValue is double) {
        return firstValue;
      } else if (firstValue is int) {
        return firstValue.toDouble();
      } else if (firstValue is String) {
        return double.tryParse(firstValue);
      }
      return null;
    }
    return null;
  }
}