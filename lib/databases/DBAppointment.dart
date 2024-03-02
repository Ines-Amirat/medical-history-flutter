import 'package:sqflite/sqflite.dart';
import 'package:medhistory_app_flutter/databases/dbhelper.dart';

class DBAppointment {
  static const tableName = 'Appointment';

  static const sql_code = '''
         CREATE TABLE IF NOT EXISTS Appointment (
             Appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
             Date TEXT,
             Time TEXT
           
           );''';

  static Future<int> insertAppointment(String date, String time) async {
    final database = await DBHelper.getDatabase();
    final Map<String, dynamic> data = {
      'Date': date,
      'Time': time,
    };
    int id = await database.insert(
      'Appointment',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }
}
