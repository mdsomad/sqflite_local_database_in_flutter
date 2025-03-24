import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  ///singleton
  DBHelper._();

  static DBHelper getInstance = DBHelper._();

  /// Tables notes
  static final String TABLE_NOTE = "notes";
  static final String COLUME_NOTE_SON = "s_no";
  static final String COLUME_NOTE_TITLE = "title";
  static final String COLUME_NOTE_DESC = "desc";

  Database? myDB;

  /// db Open (path -> if exists then open else create db)

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;

    // if (myDB == null) {
    //   return myDB!;
    // } else {
    //   myDB = await openDB();
    //   return myDB!;
    // }
  }

  Future<Database> openDB() async {
    Directory appDocPathDir = await getApplicationDocumentsDirectory();
    String dbPath = path.join(appDocPathDir.path, "noteDB.db");
    // open db
    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      //👇 create all your tables here (Table Name Unique)
      db.execute(
          "create table $TABLE_NOTE($COLUME_NOTE_SON integer primary key autoincrement, $COLUME_NOTE_TITLE text, $COLUME_NOTE_DESC text)");
      //
      //
      //
    });
  }

  /// all queries
  /// insertion
  Future<bool> addNote({
    required String mTitle,
    required String mDesc,
  }) async {
    Database db = await getDB();
    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUME_NOTE_TITLE: mTitle,
      COLUME_NOTE_DESC: mDesc,
    });

    return rowsEffected > 0;
  }

  /// reading all data
  Future<List<Map<String, dynamic>>> getAllNote() async {
    Database db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(
      TABLE_NOTE,
    );
    return mData;
  }

  /// Update data
  Future<bool> updateNote(
      {required String mTitle, required String mDesc, required int son}) async {
    Database db = await getDB();
    int rowsEffected = await db.update(
        TABLE_NOTE,
        {
          COLUME_NOTE_TITLE: mTitle,
          COLUME_NOTE_DESC: mDesc,
        },
        where: "$COLUME_NOTE_SON = $son");
    return rowsEffected > 0;
  }

  /// Delete data
  Future<bool> deleteNote(int son) async {
    Database db = await getDB();
    int rowsEffected = await db.delete(TABLE_NOTE, where: "$COLUME_NOTE_SON = ?", whereArgs: ['$son']);
    return rowsEffected > 0;
  }
}
