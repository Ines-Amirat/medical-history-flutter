import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medhistory_app_flutter/utils/global_colors.dart';
import 'package:medhistory_app_flutter/view/welcome2.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a timer to navigate to LoginPage after 2 seconds
    Timer(const Duration(seconds: 3), () {
      Get.to(Welcome2Screen());
    });
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Center(
        child: Text(
          'MedHistory',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              letterSpacing: .5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
