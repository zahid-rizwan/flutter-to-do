import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller; // Text controller
  final String inputField; // Field label text
  final bool isPassword; // Indicates if the field is for a password
  final String? errorText; // Error message to display
  final Function(String)? onChanged; // Callback for input changes
  final IconData? prefixIcon; // Optional prefix icon
  final IconData? suffixIcon; // Optional suffix icon
  final VoidCallback? onSuffixTap; // Action for suffix icon tap
  final bool obscureText; // Toggle for showing/hiding password

  CommonTextField({
    Key? key,
    required this.controller,
    required this.inputField,
    this.isPassword = false,
    this.errorText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false, // Default to not obscure text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword && obscureText, // Obscure text if password
          onChanged: onChanged, // Notify parent of input changes
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFD4D4D4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            labelText: inputField,
            filled: true,
            fillColor: const Color(0xfff6f6f6),
            errorText: errorText, // Display error if provided
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey)
                : null, // Add prefix icon if available
            suffixIcon: suffixIcon != null
                ? GestureDetector(
              onTap: onSuffixTap,
              child: Icon(suffixIcon, color: Colors.grey),
            )
                : null, // Add suffix icon if available
          ),
        ),
        if (errorText != null) // Display error message if provided
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
