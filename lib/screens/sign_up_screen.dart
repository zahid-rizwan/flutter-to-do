import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app_1_0/utils/constans.dart';
import 'package:todo_app_1_0/widget/common_button.dart';
import 'package:todo_app_1_0/widget/common_text_field.dart';
class SignUpScreen extends StatefulWidget{
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sign up",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: GestureDetector( // Wrap your body with GestureDetector
        onTap: () {
          // This will dismiss the keyboard when you tap anywhere outside the TextField
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView( // Make the screen scrollable
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 25),
                CommonTextField(
                  controller: emailController,
                  inputField: "Email",
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: passwordController,
                  inputField: "Password",
                ),SizedBox(height: 20),
                CommonTextField(
                  controller: retypePasswordController,
                  inputField: "re-type Password",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      title: "Sign Up Now",
                      backgroundColor: AppColors.primaryButtonColor,
                      foregroundColor: Colors.white,
                      iconColor: Colors.white,
                      icon: Icons.login,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "Or with",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                      width: double.infinity,
                      child: CommonButton(
                        title: "Signup with Facebook",
                        backgroundColor: AppColors.primaryButtonColor,
                        foregroundColor: Colors.white,
                        iconColor: Colors.white,
                        icon: Icons.facebook,
                      )),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      title: "Signup with Google",
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      iconColor: Colors.black,
                      icon: FontAwesomeIcons.google,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}