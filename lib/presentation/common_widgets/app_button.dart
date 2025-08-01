import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.padding,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: BorderSide(
            color: backgroundColor ?? Theme.of(context).primaryColor,
          ),
        ),
        child: _buildButtonChild(context),
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: _buildButtonChild(context),
      );
    }

    return SizedBox(width: width, child: button);
  }

  Widget _buildButtonChild(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.0),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }
}
