import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'flutterjunction.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        book_id TEXT,
        book_name TEXT,
        book_image TEXT,
        book_file TEXT,
        date_start TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        date_end TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<int> createItem(String? book_id, String? book_name) async {
    final db = await DatabaseHelper.db();

    final data = {
      'book_id': book_id,
      'book_name': book_name,
      'book_image': '',
      'book_file': ''
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getIDWithBookId(
      String bookID) async {
    final db = await DatabaseHelper.db();
    return db.query('items',
        where: "book_id = ?", whereArgs: [bookID], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String book_id, String? book_name) async {
    final db = await DatabaseHelper.db();

    final data = {
      'book_id': book_id,
      'book_name': book_name,
      'date_start': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateImageFilePath(
      {required int id,
      required String book_image,
      required String book_file}) async {
    final db = await DatabaseHelper.db();

    final data = {
      'book_image': book_image,
      'book_file': book_file,
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
