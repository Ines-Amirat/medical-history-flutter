// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:medhistory_app_flutter/utils/global_colors.dart';
import 'package:medhistory_app_flutter/view/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static final pageRoute = '/home';
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variable to track the selected index
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
              color: GlobalColors.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 3, bottom: 5),
                      child: Text(
                        "Good Morning!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 2,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.white,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here.... ",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(Icons.search, size: 25),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 190,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildButton('Medical Records', 'records1',
                    GlobalColors.mainColor, '/medicalRecords'),
                _buildButton('Icon 2', "records", Colors.green, '/page2'),
                _buildButton('Icon 3', "records", Colors.orange, '/page3'),
                _buildButton('Icon 4', "records", Colors.purple, '/page4'),
                _buildButton('Icon 5', "records", Colors.red, '/page5'),
              ],
            ),
          ),
        ],
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
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (int index) {
          setState(() {
            selectedIndex = index; // Update the vrb
          });
          // Handle navigation
          switch (index) {
            case 0:
              Navigator.pushNamed(
                  context, '/home'); //naviguer vers la page nommee "/page1"
              break;
            case 1:
              Navigator.pushNamed(context, '/wishlist');
              break;
            case 2:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildButton(
      String title, String imagePath, Color color, String route) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, route);
            },
            minWidth: 200,
            height: 150,
            color: color,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/$imagePath.png', // Adjust the path as per your project structure
                  width: 60,
                  height: 60,
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
