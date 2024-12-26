import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget{
  TextEditingController controller= TextEditingController();
  String inputField;
  CommonTextField({super.key, required  this.controller,required this.inputField});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Color(0xFFD4D4D4)
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: Color(0xFFD4D4D4)
            )
        ),
        label: Text(inputField),
        filled: true,
        // Enables the background color
        fillColor: Color(0xfff6f6f6),
      ),


    );
  }

}