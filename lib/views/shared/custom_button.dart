import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor; // Option to override color if needed

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Loading Indicator (White or Black depending on theme)
    final loader = SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: isOutlined ? Colors.black : Theme.of(context).canvasColor,
      ),
    );

    // 2. Outlined Button (Transparent BG, Border)
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: 55, // Fixed height for consistency
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).dividerColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? loader
              : Text(text, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        ),
      );
    }

    // 3. Filled Button (Black/White based on Theme)
    return SizedBox(
      width: double.infinity,
      height: 55, // Fixed height matches TextFields
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Uses Theme default if null
          elevation: 0,
        ),
        child: isLoading
            ? loader
            : Text(text),
      ),
    );
  }
}