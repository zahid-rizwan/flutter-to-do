import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app_1_0/data/local/db_helper.dart';
import 'package:todo_app_1_0/screens/login_screen.dart';
import 'package:todo_app_1_0/utils/constans.dart';
import 'package:todo_app_1_0/widget/common_button.dart';
import 'package:todo_app_1_0/widget/common_text_field.dart';
import 'homeScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  DBHelper? dbRef;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  List<Map<String, dynamic>> allTodo = [];
  var result;

  String? _passwordError; // For displaying password mismatch error
  String? _emailError; // For displaying invalid email error

  bool _isPasswordHidden = true; // To toggle password visibility
  bool _isRetypePasswordHidden = true;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;

    getTodo();
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _validateFields() {
    setState(() {
      _emailError = _validateEmail(emailController.text)
          ? null
          : "Enter a valid email address";
      _passwordError = passwordController.text == retypePasswordController.text
          ? null
          : "Passwords don't match";
    });
    return _emailError == null && _passwordError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sign up",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 25),
                CommonTextField(
                  controller: nameController,
                  inputField: "Name",
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextField(
                      controller: retypePasswordController,
                      inputField: "Re-type Password",
                      isPassword: true,
                      suffixIcon:
                      _isRetypePasswordHidden ? Icons.visibility : Icons.visibility_off,
                      onSuffixTap: () {
                        setState(() {
                          _isRetypePasswordHidden = !_isRetypePasswordHidden;
                        });
                      },
                      obscureText: _isRetypePasswordHidden,
                      onChanged: (value) {
                        setState(() {
                          if (passwordController.text != value) {
                            _passwordError = "Passwords don't match";
                          } else {
                            _passwordError = null;
                          }
                          if (retypePasswordController.text.isEmpty) {
                            _passwordError = null;
                          }
                        });
                      },
                    ),
                    if (_passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _passwordError!,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                  ],
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
                      callback: () {
                        var email = emailController.text;
                        var password = passwordController.text;
                        var rePassword = retypePasswordController.text;
                        var name = nameController.text;

                        if (email.isNotEmpty &&
                            password.isNotEmpty &&
                            rePassword.isNotEmpty &&
                            name.isNotEmpty) {
                          if (_validateFields()) {
                            dbRef!.addUser(
                              username: name,
                              password: password,
                              email: email,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Sign up successful!",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),

                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );


                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => HomeScreen(),
                            //   ),
                            // );
                            if(allTodo.isNotEmpty) print("success");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _passwordError ?? _emailError!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please fill all the required fields",
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
                      callback: () {},
                    ),
                  ),
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
                      callback: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("all ready register? ",style: TextStyle(
                        fontSize: 15,
                        fontWeight:FontWeight.bold
                    ),),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text("click here",style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue

                      ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getTodo() async{
    allTodo = await dbRef!.getAllUser();
    print(allTodo);
    setState(() {

    });
  }

  // void logD() async{
  //   await dbRef?.logDatabaseSchema();
  // }
}
