
import 'package:flutter_bioma_application/models/reserva.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
 
  static Future<Database> _openDB() async {

    return openDatabase(join(await getDatabasesPath(),'reservas.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE reservas (id INTEGER PRIMARY KEY AUTOINCREMENT, usuario TEXT, oficina TEXT, costo TEXT,fecha DATE,hora String,codigoQR TEXT, image TEXT)",
        );
      }, version: 1);
  }

    static Future<Future<int>> insert(Reserva reserva) async {
    Database database = await _openDB();

    return database.insert("reservas", reserva.toMap());
  }

  static Future<Future<int>> delete(Reserva reserva) async {
    Database database = await _openDB();

    return database.delete("reservas", where: "id = ?", whereArgs: [reserva.id]);
  }

  static Future<Future<int>> update(Reserva reserva) async {
    Database database = await _openDB();

    return database.update("reservas", reserva.toMap(), where: "id = ?", whereArgs: [reserva.id]);
  }
  
  static Future<List<Reserva>> reservas() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> reservasMap = await database.query("reservas");

    return List.generate(reservasMap.length,
            (i) => Reserva(
              id: reservasMap[i]['id'],
              usuario: reservasMap[i]['usuario'],
              oficina: reservasMap[i]['oficina'], 
              fecha: reservasMap[i]['fecha'], 
              hora: reservasMap[i]['hora'], 
              costo: num.parse(reservasMap[i]['costo']), 
              codigoQR: reservasMap[i]['codigoQR'],
              image: reservasMap[i]['image']
            ));
  }
}