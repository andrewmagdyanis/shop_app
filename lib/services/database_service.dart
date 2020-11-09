import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../reduxElements/models/models.dart';

final tableName = "Users";

class DatabaseService {
  //factory constructor
  factory DatabaseService() {
    return _instance;
  }

  static final DatabaseService _instance = DatabaseService._internal();

  Future<Database> database;

  //private (named) constructor
  DatabaseService._internal() {
    initDatabase();
  }

  initDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'comicerDatabase.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            userName TEXT,
            profilePictureUrl TEXT,
            phoneNumber TEXT,
            email TEXT,
            authProvider TEXT,
            creationTime DATETIME,
            lastSignInTime DATETIME,
            loggedIn INTEGER)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<int> insertObject(dynamic object) async {
    Database db = await database;
    int id = await db.insert(tableName, object.toMap(),conflictAlgorithm: ConflictAlgorithm
        .replace);
    print('id of the object inserted: '+id.toString());
    return id;
  }

  Future<dynamic> getObject(int id) async {
    Database db = await database;
    List<Map> datas = await db.query(tableName,
        where: 'id = ?',
        whereArgs: [id]);
    if (datas.length > 0) {
      return datas.first;
    }
    return null;
  }

  void createTable(tableName, Map<String, String> columnNamesAndTypes) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'comicerDatabase.db'),
      // When the database is first created, create a table to store data.
      onOpen: (db) {
        String creationStatement = 'id INTEGER PRIMARY KEY AUTOINCREMENT,\n';
        for (dynamic columnName in columnNamesAndTypes.keys) {
          creationStatement =
              creationStatement + columnName + ' ' + columnNamesAndTypes[columnName] + ',\n';
        }
        db.execute(
          '''CREATE TABLE $tableName( $creationStatement)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  void createTableWithCreationStatement(String creationStatement) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'comicerDatabase.db'),
      // When the database is first created, create a table to store data.
      onOpen: (db) {
        db.execute(
          '''$creationStatement
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> updateField(String tableName, dynamic newObject, int id) async {
    Database db = await database;
    await db.update(
      tableName,
      newObject.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<int>lastId(String tableName)async{
    Database db = await database;
    List<Map> data = await db.query(tableName, orderBy: 'id desc LIMIT 2');
    print(data[0]["id"]);
    return data[0]["id"];
  }

  Future<dynamic> retrieveObject(int id, String tableName, dynamic objectType) async {
    Database db = await database;
    List<Map> data = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (data.length > 0) {
      return objectType.fromMap(data.first);
      //return data.first;//state.fromMap(data.first);
    }
    return null;
  }

  Future<dynamic> retrieveLastRecord( String tableName, String objectType, int lastIndex) async {
    Database db = await database;
    List<Map> data = await db.query(tableName, orderBy: 'id desc LIMIT 2');
    if (data.length > 0) {
      if (objectType == 'UserState') {
        return UserState.fromMap(data[lastIndex]);
        //return data.first;//state.fromMap(data.first);

      }
    }
    return null;
  }



}






/*
class DatabaseService {
  String tableName = '';

  //factory constructor
  factory DatabaseService({String tableName}) {
    tableName = tableName;
    return _instance;
  }

  static final DatabaseService _instance = DatabaseService._internal();
  Future<Database> database;

  //private (named) constructor
  DatabaseService._internal() {
    initDatabase();
  }

  initDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'comicerDatabase.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE $tableRandomNumber (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            value INTEGER,
            createdTime DATETIME,
            userId TEXT,
            userName TEXT,
            profilePictureUrl TEXT,
            phoneNumber TEXT,
            email TEXT,
            authProvider TEXT,
            creationTime DATETIME,
            lastSignInTime DATETIME,
            loggedIn INTEGER)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  void createTable(tableName, Map<String, String> columnNamesAndTypes) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'comicerDatabase.db'),
      // When the database is first created, create a table to store data.
      onOpen: (db) {
        String creationStatement = 'id INTEGER PRIMARY KEY AUTOINCREMENT,\n';
        for (dynamic columnName in columnNamesAndTypes.keys) {
          creationStatement =
              creationStatement + columnName + ' ' + columnNamesAndTypes[columnName] + ',\n';
        }
        db.execute(
          '''CREATE TABLE $tableName( $creationStatement)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  void createTableWithCreationStatement(String creationStatement) async {
    database = openDatabase(
      join(await getDatabasesPath(), 'comicerDatabase.db'),
      // When the database is first created, create a table to store data.
      onOpen: (db) {
        db.execute(
          '''$creationStatement
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> updateField(String tableName, dynamic newObject) async {
    Database db = await database;
    await db.update(
      tableName,
      newObject.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [newObject.id],
    );
  }


  Future<int> insertObject(dynamic object) async {
    Database db = await database;
    print('Object: '+ object.toMap().toString());
    int id = await db.insert(tableRandomNumber, object.toMap());
    return id;
  }
  Future<int> insertNumber(dynamic number) async {
    Database db = await database;
    int id = await db.insert(tableName, number.toMap());
    return id;
  }

  Future<dynamic> retrieveObject(int id, String tableName, dynamic objectType) async {
    Database db = await database;
    List<Map> data = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (data.length > 0) {
      return objectType.fromMap(data.first);
      //return data.first;//state.fromMap(data.first);
    }
    return null;
  }

  Future<dynamic> retrieveLastRecord( String tableName, dynamic objectType) async {
    Database db = await database;
    List<Map> data = await db.query(tableName, orderBy: 'id desc LIMIT 1');
    if (data.length > 0) {
      return objectType.fromMap(data.first);
      //return data.first;//state.fromMap(data.first);
    }
    return null;
  }

}
*/
