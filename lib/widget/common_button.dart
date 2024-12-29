import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? iconColor;
  final VoidCallback callback;

  const CommonButton({
    super.key,
    this.title,
    this.icon,
    this.backgroundColor,
    required this.foregroundColor,
    required this.iconColor,
    required this.callback

  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: TextStyle(fontSize: 16),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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
