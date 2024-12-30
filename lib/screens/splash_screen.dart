import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'homeScreen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> {
  static const String KYELOGIN = 'login';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whereTogo();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff4a4ed9),
        child: Center(
          child: Image.asset('assets/images/profile.jpg'),


        ),
      ),
    );
  }
  void whereTogo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(KYELOGIN);
    String? userJson = sharedPref.getString('user');
    if(isLoggedIn!=null){
      if(isLoggedIn && userJson!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(user: jsonDecode(userJson))));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      }

    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }


  }
}