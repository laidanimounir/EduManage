import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color? backgroundColor;
  final Color? eyeColor;
  final Color? dataColor;
  final EdgeInsets padding;

  const QrCodeWidget({
    super.key,
    required this.data,
    this.size = 200,
    this.backgroundColor,
    this.eyeColor,
    this.dataColor,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: Icon(Icons.qr_code, size: 48, color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: padding,
      color: backgroundColor ?? Colors.white,
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size - padding.horizontal,
        backgroundColor: backgroundColor ?? Colors.white,
        eyeStyle: QrEyeStyle(
          color: eyeColor ?? Colors.black,
        ),
        dataModuleStyle: QrDataModuleStyle(
          color: dataColor ?? Colors.black,
        ),
      ),
    );
  }
}
