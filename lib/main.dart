// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medhistory_app_flutter/utils/global_colors.dart';
import 'package:medhistory_app_flutter/view/Appointment_list.dart';

import 'package:medhistory_app_flutter/view/Appointment_page.dart';
import 'package:medhistory_app_flutter/view/profile_screen.dart';
import 'package:medhistory_app_flutter/view/add_record_screen.dart';
import 'package:medhistory_app_flutter/view/doctor_screen.dart';
import 'package:medhistory_app_flutter/view/home_screen.dart';
import 'package:medhistory_app_flutter/view/login_screen.dart';
import 'package:medhistory_app_flutter/view/medical_record_page.dart';
import 'package:medhistory_app_flutter/view/sign_in_screen.dart';
import 'package:medhistory_app_flutter/view/splash_screen.dart';
import 'package:medhistory_app_flutter/view/welcome2.dart';
import 'package:medhistory_app_flutter/view/welcome_screen.dart';
import 'package:medhistory_app_flutter/view/success_booked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();
  static Color primaryColor = GlobalColors.mainColor;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedHistory',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: GlobalColors.mainColor),
          brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      routes: {
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomeScreen(),
        '/medicalRecords': (context) => MedicalRecordsPage(),
        '/appointment': (context) => Appointment(),
        Appointment.pageRoute: (context) => Appointment(),
        '/success_booked': (context) => AppointmentBooked(),
        MedicalRecordsPage.pageRoute: (context) => MedicalRecordsPage(),
        '/appointmentlist': (context) => AppointmentPage(),
        AppointmentPage.pageRoute: (context) => AppointmentPage(),
        MedicalRecordsPage.pageRoute: (context) => MedicalRecordsPage(),
        DoctorScreen.pageRoute: (context) => DoctorScreen(),
        AppointmentBooked.pageRoute: (context) => AppointmentBooked(),
        HomeScreen.pageRoute: (context) => HomeScreen(),
      },
      home: HomeScreen(),
    );
  }
}
