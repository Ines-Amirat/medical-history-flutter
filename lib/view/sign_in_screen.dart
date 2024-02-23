import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medhistory_app_flutter/utils/global_colors.dart';
import 'package:medhistory_app_flutter/view/login_screen.dart';

class SignInScreen extends StatefulWidget {
  static final pageRoute = '/sign';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            //removes the top route from the stack
            //remove the current screen and go back to the previous screen
            Navigator.pop(context);
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
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Register new account",
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
                  inputFile(label: "Email"),
                  const SizedBox(
                    height: 10,
                  ),
                  inputFile(label: "Password", obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  inputFile(label: "Confirm Password", obscureText: true)
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
                    onPressed: () {},
                    color: GlobalColors.mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("SIGN UP",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    //navigate to login
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//create widget for text field
Widget inputFile({label, obscureText = false}) {
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
