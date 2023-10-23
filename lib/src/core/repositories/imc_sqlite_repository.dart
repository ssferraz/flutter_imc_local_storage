import 'package:flutter_imc_local_storage/src/core/models/imc_sqlite_model.dart';
import 'package:flutter_imc_local_storage/src/core/repositories/sqlite_database.dart';

class IMCSQLiteRepository {
  Future<List<IMCSQLiteModel>> getIMCs() async {
    List<IMCSQLiteModel> imcs = [];
    var db = await SQLiteDataBase().getDatabase();
    var result = await db.rawQuery("SELECT id, peso, altura FROM imc");
    for (var item in result) {
      imcs.add(
        IMCSQLiteModel(
          id: int.parse(item["id"].toString()),
          peso: double.parse(item["peso"].toString()),
          altura: double.parse(item["altura"].toString()),
        ),
      );
    }
    return imcs;
  }

  Future<void> save(IMCSQLiteModel imcSqLiteModel) async {
    var db = await SQLiteDataBase().getDatabase();
    db.rawInsert(
      "INSERT INTO imc (peso, altura) VALUES (?,?)",
      [imcSqLiteModel.peso, imcSqLiteModel.altura],
    );
  }

  Future<void> update(IMCSQLiteModel imcSqLiteModel) async {
    var db = await SQLiteDataBase().getDatabase();
    db.rawInsert(
      "UPDATE imc SET peso = ?,  altura = ? WHERE id = ?",
      [
        imcSqLiteModel.peso,
        imcSqLiteModel.altura,
        imcSqLiteModel.id,
      ],
    );
  }

  Future<void> delete(int id) async {
    var db = await SQLiteDataBase().getDatabase();
    db.rawInsert(
      "DELETE FROM imc WHERE id = ?",
      [
        id,
      ],
    );
  }
}
