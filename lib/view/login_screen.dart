import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medhistory_app_flutter/utils/global_colors.dart';
import 'package:medhistory_app_flutter/view/home_screen.dart';
import 'package:medhistory_app_flutter/view/sign_in_screen.dart';

class LoginScreen extends StatefulWidget {
  static final pageRoute = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //bool varaible to show and hide password
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
                context); //ferme l'écran actuel & retourne à l'écran précédent
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: GlobalColors.mainColor,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [
            const Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Login to your account",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 97, 97, 97),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  inputFile(
                    label: "Email",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 189, 189, 189),
                            ),
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 189, 189, 189))),
                          suffixIcon: IconButton(
                            onPressed: () {
                              // Toggle visibility of the password
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Column(
                children: [
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    color: GlobalColors.mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot password ?"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    //navigate to login
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  },
                  child: Text("Sign Up"),
                ),
              ],
            ),
            Container(
              height: 210, //hauteur de container fixe 210 px
              //decoration est pour inclure image
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/login.png"),
                      fit: BoxFit.fitHeight)),
            )
          ],
        ),
      ),
    );
  }
}

//create widget for text field
Widget inputFile({
  label,
  obscureText = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 189, 189, 189)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 189, 189, 189)),
          ),
        ),
      ),
    ],
  );
}
