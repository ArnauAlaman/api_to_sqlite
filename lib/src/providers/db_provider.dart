import 'dart:io';
import 'package:api_to_sqlite/src/models/student_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // If database exists, return database
    //if (_database != null) return _database;
    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'student_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE Student (id INTEGER PRIMARY KEY,email TEXT, firstName TEXT,lastName TEXT)');
    });
  }

  // Insert employee on database
  createStudent(Students newEmployee) async {
    //await deleteStudents();
    final db = await database;
    final res = await db?.insert('Student', newEmployee.toJson());

    return res;
  }

  // Delete all employees
  Future<int?> deleteAllStudents() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM Student');

    return res;
  }

  Future<List<Students?>> getAllStudents() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM Student");

    List<Students> list = res!.isNotEmpty ? res.map((c) => Students.fromJson(c)).toList() : [];

    return list;
  }
}
