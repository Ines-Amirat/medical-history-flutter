import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medhistory_app_flutter/databases/DBimage.dart';
import 'package:medhistory_app_flutter/databases/DBrecord.dart';
import 'package:medhistory_app_flutter/view/image_screen.dart';

class RecordDetailScreen extends StatefulWidget {
  final Map record;

  const RecordDetailScreen({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  late Future<List<String>> imagePaths;

  @override
  void initState() {
    super.initState();
    // Fetch images for the current record
    imagePaths = DBImage.getImagePathsForRecord(widget.record['id']);
  }

  void showCustomDisabledFeatureMessage(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(12),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Record successfully deleted",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAssociatedImages(int recordId) async {
    try {
      //fetch the paths of all images associated with the record
      List<String> imagePaths = await DBImage.getImagePathsForRecord(recordId);

      //loop through each path and delete the file
      for (String imagePath in imagePaths) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print("Error deleting images: $e");
    }
  }

  void _deleteRecord() async {
    //first delete the associated image files
    await _deleteAssociatedImages(widget.record['id']);

    //then delete the database entries for these images
    await DBImage.deleteImagesForRecord(widget.record['id']);
    bool success = await DBRecord.deleteRecord(widget.record['id']);
    if (success) {
      showCustomDisabledFeatureMessage(context);

      // Pop back to the previous screen
      Navigator.of(context)
          .pop(true); // Passing 'true' to indicate a successful deletion
    } else {
      // Handle failure (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete the record'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        // Zone bleue avec le mot "Record"
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(100),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                title: Text('Record  Informations ',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white)),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
        Container(
          color: Theme.of(context).primaryColor,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 1,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Doctor:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Lyna'),
                        SizedBox(
                            height: 8.0), // Provides space between the rows
                        Text(
                          'Record type:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('consultation'),
                        SizedBox(height: 8.0),
                        Text(
                          'Title:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Lyna consultation'),
                        SizedBox(height: 8.0),
                        Text(
                          'Date:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('23 february 2024'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30)
                ],
              )),
        ),

        const SizedBox(height: 20),
      ]),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(title.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      );
}
