import 'package:enie/models/sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'enieappwin.db';
  final int versionDatabase = 1;
  final String tableDatabase = 'orderTable';
  final String columnId = 'id';
  final String columnNameProduct = 'nameProduct';
  final String columnPrice = 'price';

  SQLiteHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableDatabase (id INTEGER PRIMARY KEY, $columnNameProduct TEXT, $columnPrice TEXT)'),
      version: versionDatabase,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<void> insetrDatabase({required SqliteModel sqliteModel}) async {
    Database database = await connectedDatabase();
    database.insert(
      tableDatabase,
      sqliteModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SqliteModel>> readAllDatabase() async {
    var sqliteModels = <SqliteModel>[];

    Database database = await connectedDatabase();
    var maps = await database.query(tableDatabase);
    for (var element in maps) {
      SqliteModel sqliteModel = SqliteModel.fromMap(element);
      sqliteModels.add(sqliteModel);
    }

    return sqliteModels;
  }

  Future<void> deleteDatabseWhereId({required int idDelete}) async {
    Database database = await connectedDatabase();
    await database.delete(tableDatabase, where: '$columnId = $idDelete');
  }

  Future<void> deletaAllDatabase() async {
    Database database = await connectedDatabase();
    await database.delete(tableDatabase);
  }
} // End Class