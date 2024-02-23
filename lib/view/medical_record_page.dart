import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medhistory_app_flutter/databases/DBdoctor.dart';

import 'package:medhistory_app_flutter/databases/DBrecord.dart';
import 'package:medhistory_app_flutter/utils/global_colors.dart';
import 'package:medhistory_app_flutter/view/add_record_screen.dart';
import 'package:medhistory_app_flutter/view/record_detail_screen.dart';

class MedicalRecordsPage extends StatefulWidget {
  static final pageRoute = '/medicalrecord';

  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  List<Map<String, dynamic>> options = [];
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    //Load type records
    fetchTypeRecord();
    fetchDoctors();
  }

  Future<void> fetchTypeRecord() async {
    try {
      final response = await http
          .get(Uri.parse('https://flask-app-medical.vercel.app/records.type'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          options = jsonData
              .map((option) => {"id": option['id'], "name": option['name']})
              .toList();
        });
        print(options);
      } else {
        print('Failed to load options. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading options: $e');
    }
  }

  Future<void> fetchDoctors() async {
    doctors = await DBDoctor.getAllDoctors();
  }

  //update the state with the new list of records
  Future<void> updatFetchRecords() async {
    try {
      // Fetch the latest records
      final List<Map<String, dynamic>> updatedRecords =
          await DBRecord.fetchAllRecords();
      setState(() {
        // Update your state with the new records
        this.records = updatedRecords;
      });
    } catch (e) {
      print('Error fetching records: $e');
    }
  }

  String _getTypeRecordById(int id) {
    var typeRecord = options.firstWhere((option) => option['id'] == id,
        orElse: () => {"id": -1, "name": 'loading....'});
    return typeRecord['name'];
  }

  String _getDoctorNameById(int doctorId) {
    final doctor = doctors.firstWhere(
      (doc) => doc['doctor_id'] == doctorId,
      orElse: () => {'name': 'loading....'},
    );
    return doctor['name'];
  }

  Future<void> _navigateAndRefreshList() async {
    // Navigate and wait for the result
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddRecordScreen()),
    );
    //waits for a result to come back,
    // Check if the record list needs to be refreshed
    if (result == true) {
      await updatFetchRecords();
      setState(() {
        //trigger a rebuild of the widget with the updated records
      });
    }
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        title: const Text('List of Medical Records ',
            style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add Record"),
        icon: Icon(Icons.add),
        onPressed: _navigateAndRefreshList,
        backgroundColor: GlobalColors.mainColor, // Background color
        foregroundColor: Colors.white, // Text color
        elevation: 5,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: GlobalColors.mainColor,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (int index) {
          setState(() {
            selectedIndex = index; // Update the vrb
          });
          // Handle navigation
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/page1');
              break;
            case 1:
              Navigator.pushNamed(context, '/page2');
              break;
          }
        },
      ),
      // Using FutureBuilder to asynchronously load data
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBRecord.fetchAllRecords(), //fetchRecords(),
        builder: (context, snapshot) => _build_list_records(context, snapshot),
      ),
    );
  }

  Widget _build_list_records(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      List<Map> items = snapshot.data!;
      if (options.isEmpty) {
        //data is still loading, show a placeholder or loading indicator
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 10,
            margin: EdgeInsets.all(8.0), //spacing around the card
            child: ListTile(
              title: Text(_getTypeRecordById(items[index]['record_type_id'])),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, //start from the left
                children: [
                  Text("Dr." + _getDoctorNameById(items[index]['doctor_id'])),
                  Text(items[index]['date']),
                ],
              ),
              // Add trailing to show the delete icon
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () async {
                  // Find the doctor's name using the doctor_id
                  String doctorName =
                      _getDoctorNameById(items[index]['doctor_id']);
                  // Find the record type name using the record_type_id
                  String recordTypeName =
                      _getTypeRecordById(items[index]['record_type_id']);
                  // Add the doctor's name and record type name to the record map
                  Map<String, dynamic> recordWithDetails =
                      Map.from(items[index]);
                  recordWithDetails['doctorName'] = doctorName;
                  recordWithDetails['recordTypeName'] = recordTypeName;
                  print(items[index]);
                  // Navigate to the detail screen with the selected record
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecordDetailScreen(record: recordWithDetails),
                    ),
                  );
                  if (res == true) {
                    await updatFetchRecords();
                    setState(() {
                      //trigger a rebuild of the widget with the updated records
                    });
                  }
                },
              ),
            ),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Text("${snapshot.error}");
    }
    return CircularProgressIndicator();
  }
}
