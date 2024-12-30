import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_1_0/data/local/db_helper.dart';
import 'package:todo_app_1_0/screens/homeScreen.dart';
import 'package:todo_app_1_0/screens/sign_up_screen.dart';
import 'package:todo_app_1_0/screens/splash_screen.dart';

import '../utils/constans.dart';
import '../widget/common_button.dart';
import '../widget/common_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  static  Map<String, dynamic>? user;
  String? _emailError;
  DBHelper? dbRef;


  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sign in",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextField(
                          controller: emailController,
                          inputField: "Email",
                          onChanged: (value) {
                            setState(() {
                              _emailError = _validateEmail(value)
                                  ? null
                                  : "Enter a valid email address";
                            });
                          },
                        ),
                        if (_emailError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _emailError!,
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CommonTextField(
                      controller: passwordController,
                      inputField: "Password",
                      isPassword: true,
                      suffixIcon: _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                      onSuffixTap: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      obscureText: _isPasswordHidden,

                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          title: "Login",
                          backgroundColor: AppColors.primaryButtonColor,
                          foregroundColor: Colors.white,
                          iconColor: Colors.white,
                          icon: Icons.login,
                          callback: () async {
                            user = await dbRef!.getUserByEmailAndPassword(
                                emailController.text, passwordController.text);
                            if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                              if (user != null) {
                                var sharedPref = await SharedPreferences.getInstance();
                                sharedPref.setBool(SplashScreenState.KYELOGIN, true);
                                String userJson = jsonEncode(user);
                                await sharedPref.setString('user', userJson);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                      user: user,
                                    ),
                                  ),
                                );
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Email or password is wrong",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "please fill all the required field",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Or with",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          title: "Login with Facebook",
                          backgroundColor: AppColors.primaryButtonColor,
                          foregroundColor: Colors.white,
                          iconColor: Colors.white,
                          icon: Icons.facebook,
                          callback: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          title: "Login with Google",
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          icon: FontAwesomeIcons.google,
                          iconColor: Colors.black,
                          callback: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 190,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New user? ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Click here",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
