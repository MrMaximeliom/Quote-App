import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:beautiful/ui/common/quote.dart';

class DatabaseHelper {
  static final _databaseName = "Database.db";
  static final _databaseVersion = 1;

  static final table = 'liked_quotes';

  static final id = '_id';
  static final quoteText = 'quote_text';
  static final quoteAuthor = 'quote_author';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $id INTEGER PRIMARY KEY,
            $quoteText TEXT NOT NULL,
            $quoteAuthor INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRow(int id) async {
    Database db = await instance.database;
    // get a reference to the database
    // get single row
    List<String> columnsToSelect = [
      DatabaseHelper.quoteText,
      DatabaseHelper.quoteAuthor,
    ];
    String whereString = '${DatabaseHelper.id} = ?';
    int rowId = id;
    List<dynamic> whereArguments = [rowId];
    List<Map<String, dynamic>> result = await db.query(DatabaseHelper.table,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    return result;
  }

  Future<List<Quote>> fetchSavedQuotes() async {
    Database db = await instance.database;
    List<Map> maps =
        await db.query(table, columns: [id, quoteText, quoteAuthor]);
    List<Quote> quotes = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        quotes.add(Quote.fromMap(maps[i]));
      }
    }
    return quotes;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int idHere = row[id];
    return await db.update(table, row, where: '$id = ?', whereArgs: [idHere]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    // rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
    return await db.delete(table, where: '_id = ?', whereArgs: [id]);
  }
}
