// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medhistory_app_flutter/databases/DBimage.dart';
import 'package:medhistory_app_flutter/utils/global_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medhistory_app_flutter/databases/DBrecord.dart';
import 'package:medhistory_app_flutter/view/doctor_screen.dart';
import 'package:medhistory_app_flutter/view/image_screen.dart';

class AddRecordScreen extends StatefulWidget {
  static final pageRoute = '/addrecord';
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  String? dropdownValue = null;
  String typeRecordDropdownValue = '';
  List<Map<String, dynamic>> options = [];
  String generatedTitle = '';
  String dateString = '02-16-2024';
  int? selectedDoctorId;
  int? selectedTypeRecordId;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  // detect when it is tapped (focused) and then set its value
  FocusNode titleFocusNode = FocusNode();
  // Controllers for the text fields
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController _tx_doctorNameController = TextEditingController();
  TextEditingController _tx_description_Controller = TextEditingController();

  //function to open the file system and pick the file
  void openFiles() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      PlatformFile file = resultFile.files.first;
      print(file.name);
      print(file.bytes);
      print(file.extension);
      print(file.path);
    } else {
      print('File picking canceled');
    }
  }

  @override
  void initState() {
    super.initState();
    // Set initial values for date text fields
    DateTime currentDate = DateTime.now();
    dayController.text = currentDate.day.toString().padLeft(2, '0');
    monthController.text = currentDate.month.toString().padLeft(2, '0');
    yearController.text = currentDate.year.toString();
    //print(dayController.text + monthController.text + yearController.text);

    //Load type records
    fetchData();

    // Listen to the focus change
    titleFocusNode.addListener(() {
      if (titleFocusNode.hasFocus) {
        generateTitle();
      }
    });
  }

  // method to generate title based on selected doctor and type of record
  void generateTitle() {
    setState(() {
      generatedTitle = '$dropdownValue ${_tx_doctorNameController.text}';
    });
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
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

  void selectImages() async {
    // returns a list of XFile objects,
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imageFileList.addAll(selectedImages);
      });
    }
  }

  //handle the selection of an image from either the camera or the gallery, based on the ImageSource passed to it
  void _pickImage(ImageSource source) async {
    // If the source is the camera, continue allowing only single image selection
    if (source == ImageSource.camera) {
      final XFile? selectedImage = await imagePicker.pickImage(source: source);
      if (selectedImage != null) {
        setState(() {
          imageFileList.add(selectedImage);
        });
      }
    } else {
      // For the gallery, allow multiple image selections
      selectImages();
    }
  }

  //shows a modal bottom sheet "screen to5rej mn ta7et" with the 2 options to choose a photo from the gallery or camera
  void _showImageSourceActionSheet(BuildContext context) {
    //adding a new route (the bottom sheet) on top of the current screen
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context)
                        .pop(); //remove this route (close the bottom sheet)
                  }),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addNewRecord() async {
    if (dayController.text.isNotEmpty &&
        monthController.text.isNotEmpty &&
        yearController.text.isNotEmpty &&
        selectedDoctorId != null &&
        selectedTypeRecordId != null &&
        generatedTitle.isNotEmpty) {
      // Combine the date strings into a date string in the format "YYYY-MM-DD"
      dateString =
          "${yearController.text}-${monthController.text}-${dayController.text}";
      // Call the method to insert the new record into the database
      int newRecordId = await DBRecord.insertRecord(
          selectedDoctorId!,
          selectedTypeRecordId!,
          generatedTitle,
          dateString,
          _tx_description_Controller.text);
      //storing image paths in the SQLite database
      // Now insert image paths associated with this record
      for (XFile imageFile in imageFileList) {
        String imagePath = imageFile.path; // Directly use the path
        await DBImage.insertImagePath(newRecordId, imagePath);
      }
      //Close the dialog
      //pop the screen with a result that indicates success
      Navigator.of(context).pop(true);
    } else {
      // Show a SnackBar instead of showDialog for a less intrusive notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          //behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(255, 255, 223, 220),
          content: Row(
            children: <Widget>[
              Icon(
                Icons.error,
                color: const Color.fromARGB(255, 129, 15, 7),
              ),
              SizedBox(width: 8),
              Text(
                "Please fill all the fields",
                style: TextStyle(
                  color: const Color.fromARGB(255, 129, 15, 7),
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        title: Text(
          'Add Record',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(25.0),
          children: [
            GestureDetector(
              onTap: () async {
                Map data = await Navigator.of(context).pushNamed(
                  DoctorScreen.pageRoute,
                ) as Map;
                print("Returned data ${data.toString()}");
                _tx_doctorNameController.text = data['name'];
                selectedDoctorId = data['doctor_id'];
                print(data['name']);
                print(data['doctor_id']);
              },
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tx_doctorNameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Doctor",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                      width: 40,
                      child: SizedBox(
                          width: 40, child: Icon(Icons.arrow_right_alt_sharp)))
                ],
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: dropdownValue,
              decoration: InputDecoration(
                labelText: "Type of Record",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
              ),
              dropdownColor: const Color.fromARGB(255, 255, 255, 255),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  // hold the selected specialty ID && "firstWhere" find the first element that matches a given newValue and return id.
                  selectedTypeRecordId = options
                      .firstWhere((option) => option['name'] == newValue)['id'];
                  print(selectedTypeRecordId);
                });
              },
              items: options
                  .map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                return DropdownMenuItem<String>(
                  value: value['name'],
                  child: Text(value['name']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                labelText: 'Title',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              focusNode: titleFocusNode,
              controller: TextEditingController(text: generatedTitle),
              readOnly: true,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: monthController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      hintText: 'mm',
                      labelText: 'Month',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: dayController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      hintText: 'dd',
                      labelText: 'Day',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: yearController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      hintText: 'yyyy',
                      labelText: 'Year',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _tx_description_Controller,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showImageSourceActionSheet(context),
              //selectImages();
              child: Text('Add Photo'),
            ),
            SizedBox(
              height: 200, //fixe height for container of image
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //number of columns as i want
                  crossAxisSpacing: 7.0,
                  mainAxisSpacing: 7.0,
                  childAspectRatio: 1,
                ),
                itemCount: imageFileList.length,
                itemBuilder: (BuildContext context, int index) {
                  //"GestureDetector" detect taps on the image,
                  return GestureDetector(
                    onTap: () {
                      // This block executed when an image is tapped
                      //takes an image file path as a parameter and displays the image in full screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FullScreenImageScreen(
                          imagePath: imageFileList[index].path,
                          imageIndex: index,
                          onDelete: (index) {
                            setState(() {
                              imageFileList.removeAt(index);
                            });
                          },
                        ),
                      ));
                    },
                    // The image is displayed here
                    child: Image.file(File(imageFileList[index].path),
                        fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _addNewRecord();
        },
        child: Icon(
          Icons.check,
          size: 35,
        ),
        backgroundColor: GlobalColors.mainColor, // Background color
        foregroundColor: Colors.white, // Text color
        elevation: 5, // Shadow depth
      ),
    );
  }
}
