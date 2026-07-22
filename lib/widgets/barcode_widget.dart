import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';

class BarcodeWidget extends StatelessWidget {
  final String data;
  final double height;
  final double? width;
  final BarcodeType barcodeType;

  const BarcodeWidget({
    super.key,
    required this.data,
    this.height = 80,
    this.width,
    this.barcodeType = BarcodeType.code128,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        width: width ?? 200,
        child: const Center(child: Text('No data')),
      );
    }

    final barcode = _getBarcode();
    final svg = barcode.toSvg(
      data,
      width: width ?? 200,
      height: height,
      fontHeight: 12,
    );

    final widthValue = _extractSvgWidth(svg) ?? (width ?? 200);
    final heightValue = _extractSvgHeight(svg) ?? height;

    return CustomPaint(
      size: Size(widthValue, heightValue),
      painter: _BarcodePainter(barcode: barcode, data: data),
    );
  }

  Barcode _getBarcode() {
    switch (barcodeType) {
      case BarcodeType.code128:
        return Barcode.code128();
      case BarcodeType.code39:
        return Barcode.code39();
      case BarcodeType.ean13:
        return Barcode.ean13();
      case BarcodeType.qr:
        return Barcode.qrCode();
    }
  }

  double? _extractSvgWidth(String svg) {
    final match = RegExp(r'width="([\d.]+)"').firstMatch(svg);
    if (match != null) return double.tryParse(match.group(1)!);
    return null;
  }

  double? _extractSvgHeight(String svg) {
    final match = RegExp(r'height="([\d.]+)"').firstMatch(svg);
    if (match != null) return double.tryParse(match.group(1)!);
    return null;
  }
}

enum BarcodeType { code128, code39, ean13, qr }

class _BarcodePainter extends CustomPainter {
  final Barcode barcode;
  final String data;

  _BarcodePainter({required this.barcode, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final svg = barcode.toSvg(data, width: size.width, height: size.height);
    final bars = _parseSvgBars(svg, size.width, size.height);

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (final bar in bars) {
      canvas.drawRect(
        Rect.fromLTWH(bar.x, bar.y, bar.width, bar.height),
        paint,
      );
    }
  }

  List<_Bar> _parseSvgBars(String svg, double totalWidth, double totalHeight) {
    final bars = <_Bar>[];
    final rectPattern = RegExp(r'<rect[^>]*x="([\d.]+)"[^>]*y="([\d.]+)"[^>]*width="([\d.]+)"[^>]*height="([\d.]+)"');
    final matches = rectPattern.allMatches(svg);

    final svgWidthMatch = RegExp(r'width="([\d.]+)"').firstMatch(svg);
    final svgHeightMatch = RegExp(r'height="([\d.]+)"').firstMatch(svg);

    final svgW = svgWidthMatch != null ? double.tryParse(svgWidthMatch.group(1)!) ?? totalWidth : totalWidth;
    final svgH = svgHeightMatch != null ? double.tryParse(svgHeightMatch.group(1)!) ?? totalHeight : totalHeight;

    final scaleX = totalWidth / svgW;
    final scaleY = totalHeight / svgH;

    for (final match in matches) {
      final x = double.tryParse(match.group(1)!) ?? 0;
      final y = double.tryParse(match.group(2)!) ?? 0;
      final w = double.tryParse(match.group(3)!) ?? 0;
      final h = double.tryParse(match.group(4)!) ?? 0;

      bars.add(_Bar(
        x: x * scaleX,
        y: y * scaleY,
        width: w * scaleX,
        height: h * scaleY,
      ));
    }

    if (bars.isEmpty) {
      final textPattern = RegExp(r'<text[^>]*x="([\d.]+)"[^>]*y="([\d.]+)"[^>]*>');
      final textMatches = textPattern.allMatches(svg);
      for (final match in textMatches) {
        final y = double.tryParse(match.group(2)!) ?? 0;
        bars.add(_Bar(
          x: 0,
          y: y * scaleY - 10,
          width: totalWidth,
          height: 14,
        ));
      }
    }

    return bars;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Bar {
  final double x;
  final double y;
  final double width;
  final double height;

  _Bar({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}
