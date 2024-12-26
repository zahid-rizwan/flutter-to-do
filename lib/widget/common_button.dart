import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? iconColor;

  const CommonButton({
    super.key,
    this.title,
    this.icon,
    this.backgroundColor,
    required this.foregroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: TextStyle(fontSize: 16),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            if (icon != null)
              SizedBox(width: 8), // Optional: Adds space between icon and text
            Text(
              title ?? 'Button',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
