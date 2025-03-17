import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfViewAndPrintAsImage extends StatefulWidget {
  const PdfViewAndPrintAsImage({super.key});

  @override
  State<PdfViewAndPrintAsImage> createState() => _PdfViewAndPrintAsImageState();
}

class _PdfViewAndPrintAsImageState extends State<PdfViewAndPrintAsImage> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF View and Print')),
      body: Column(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Column(
              children: [
                Text(
                  "আশা করি তুমি ভালো আছো।",
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "NotoSansBengali", // Ensure the font supports Bangla
                  ),
                ),
                Text(
                  "কোম্পানিটির সাংগঠনিক কাঠামো জটিল।",
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "NotoSansBengali", // Ensure the font supports Bangla
                  ),
                ),
                Text(
                  "আশা করি তুমি ভালো আছো।",
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "NotoSansBengali", // Ensure the font supports Bangla
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(child: PdfPreview(build: (format) => _generatePdf(format))),
        ],
      ),
    
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final imageBytes = await _capturePng();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pw.MemoryImage(imageBytes), width: 300));
        },
      ),
    );

    return pdf.save();
  }

  // Future<Uint8List> _capturePng() async {
  //   RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData!.buffer.asUint8List();
  // }
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    // Convert the image to byte data
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Convert image to correct orientation
    final ui.Codec codec = await ui.instantiateImageCodec(pngBytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image flippedImage = await _flipImage(frame.image);

    // Convert flipped image to Uint8List
    ByteData? flippedByteData = await flippedImage.toByteData(format: ui.ImageByteFormat.png);
    return flippedByteData!.buffer.asUint8List();
  }

  Future<ui.Image> _flipImage(ui.Image srcImage) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint();
    final size = Size(srcImage.width.toDouble(), srcImage.height.toDouble());

    // Flip the image vertically to fix upside-down issue
    canvas.translate(size.width, size.height);
    canvas.rotate(3.1416); // Rotate 180 degrees (π radians)
    canvas.scale(1, 1);
    canvas.drawImage(srcImage, Offset.zero, paint);

    final picture = recorder.endRecording();
    return picture.toImage(srcImage.width, srcImage.height);
  }
}
