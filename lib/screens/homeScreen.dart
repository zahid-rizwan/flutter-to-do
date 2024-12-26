import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_1_0/utils/constans.dart';
import 'package:todo_app_1_0/widget/common_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text(
      //       "Sign in",
      //       style: TextStyle(
      //           fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: CircleAvatar(
              child: Image.asset('assets/images/logo.png'),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello",style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                    ),),
                    
                    Text("Zahid",style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.menu),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
                controller: null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Color(0xFFD4D4D4))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Color(0xFFD4D4D4))),

                  hintText: "Find your task here",
                  filled: true,
                  // Enables the background color
                  fillColor: Color(0xfff6f6f6),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Task",style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold

                    ),),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CommonButton(title:"In Progress",foregroundColor: Colors.white, iconColor: null,backgroundColor: AppColors.primaryButtonColor,icon: null,)
                  ],

                ),
                SizedBox(width: 8,),
                Column(
                  children: [
                    CommonButton(title:"To Do",foregroundColor: Colors.black, iconColor: null,backgroundColor: AppColors.secondaryButtonColor,icon: null,)

                  ],
                ),
                SizedBox(width: 8,),
                Column(
                  children: [
                    CommonButton(title:"Completed",foregroundColor: Colors.black, iconColor: null,backgroundColor: AppColors.secondaryButtonColor,icon: null,)

                  ],
                )

              ],
            ),
          ),

        ],
      ),
    );
  }
}
