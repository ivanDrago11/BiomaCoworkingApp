class Reserva {

  int? id;
  String usuario;
  String oficina;
  num costo;
  String fecha;
  String hora;
  String codigoQR;
  String image;

  Reserva({ this.id, required this.usuario, required this.oficina, required this.costo, required this.fecha, required this.hora, required this.codigoQR, required this.image});

  Map<String, dynamic> toMap() {
    return {'usuario': usuario, 'oficina': oficina, 'costo': costo, 'fecha': fecha, 'codigoQR': codigoQR, 'image': image, 'hora': hora };
  }

}