import 'package:sqflite/sqflite.dart';
import 'package:medhistory_app_flutter/databases/dbhelper.dart';

class DBRecord {
  static const tableName = 'record';

  static const sql_code = '''
         CREATE TABLE IF NOT EXISTS record (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             title TEXT,
             date TEXT,
             description TEXT,
             doctor_id INTEGER,
             record_type_id INTEGER
           );''';

  static Future<int> insertRecord(int doctorId, int recordTypeId, String title,
      String date, String des) async {
    final database = await DBHelper.getDatabase();
    final Map<String, dynamic> data = {
      'doctor_id': doctorId,
      'record_type_id': recordTypeId,
      'title': title,
      'date': date,
      'description': des,
    };
    int id = await database.insert(
      'record',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // Method to fetch all records but only returning type_record_id, doctor_id, and date
  static Future<List<Map<String, dynamic>>> fetchAllRecords() async {
    final database = await DBHelper.getDatabase();
    // Prepare the SQL query to select only doctor_id, record_type_id, and date columns from all records
    final String sqlQuery = '''
      SELECT id,title,description,doctor_id, record_type_id, date FROM $tableName
      ORDER BY date DESC; 
    '''; // Assuming you want to order the records by date in descending order
    // Execute the query
    final List<Map<String, dynamic>> records =
        await database.rawQuery(sqlQuery);
    return records;
  }

  static Future<bool> deleteRecord(int recordId) async {
    final database = await DBHelper.getDatabase();
    int result = await database.delete(
      tableName,
      where: "id = ?",
      whereArgs: [recordId],
    );
    return result > 0;
  }
}
