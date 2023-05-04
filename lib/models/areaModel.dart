// To parse this JSON data, do
//
//     final areaModel = areaModelFromJson(jsonString);

import 'dart:convert';

AreaModel areaModelFromJson(String str) => AreaModel.fromJson(json.decode(str));

String areaModelToJson(AreaModel data) => json.encode(data.toJson());

class AreaModel {
    bool ok;
    List<Area> areas;

    AreaModel({
        required this.ok,
        required this.areas,
    });

    factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        ok: json["ok"],
        areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
    };
}

class Area {
    List<String> amenities;
    String name;
    String description;
    int pricePerHour;
    String capacity;
    String image;
    String id;

    Area({
        required this.amenities,
        required this.name,
        required this.description,
        required this.pricePerHour,
        required this.capacity,
        required this.image,
        required this.id,
    });

    factory Area.fromJson(Map<String, dynamic> json) => Area(
        amenities: List<String>.from(json["amenities"].map((x) => x)),
        name: json["name"],
        description: json["description"],
        pricePerHour: json["pricePerHour"],
        capacity: json["capacity"],
        image: json["image"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "amenities": List<dynamic>.from(amenities.map((x) => x)),
        "name": name,
        "description": description,
        "pricePerHour": pricePerHour,
        "capacity": capacity,
        "image": image,
        "id": id,
    };
}
