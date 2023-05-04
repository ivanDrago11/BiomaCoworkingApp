// To parse this JSON data, do
//
//     final reservaModel = reservaModelFromJson(jsonString);

import 'dart:convert';

ReservaModel reservaModelFromJson(String str) => ReservaModel.fromJson(json.decode(str));

String reservaModelToJson(ReservaModel data) => json.encode(data.toJson());

class ReservaModel {
    bool ok;
    List<Reserva> reservas;

    ReservaModel({
        required this.ok,
        required this.reservas,
    });

    factory ReservaModel.fromJson(Map<String, dynamic> json) => ReservaModel(
        ok: json["ok"],
        reservas: List<Reserva>.from(json["reservas"].map((x) => Reserva.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "reservas": List<dynamic>.from(reservas.map((x) => x.toJson())),
    };
}

class Reserva {
    String area;
    String usuario;
    int price;
    DateTime start;
    DateTime end;
    String id;
    String? codigoQr;

    Reserva({
        required this.area,
        required this.usuario,
        required this.price,
        required this.start,
        required this.end,
        required this.id,
        this.codigoQr,
    });

    factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
        area: json["area"],
        usuario: json["usuario"],
        price: json["price"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        id: json["id"],
        codigoQr: json["codigoQR"],
    );

    Map<String, dynamic> toJson() => {
        "area": area,
        "usuario": usuario,
        "price": price,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "id": id,
        "codigoQR": codigoQr,
    };
}
