import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class ImagePdf extends StatefulWidget {
  const ImagePdf({super.key});

  @override
  State<ImagePdf> createState() => _ImagePdfState();
}

class _ImagePdfState extends State<ImagePdf> {
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
                  "বিসমিল্লাহির রাহমানির রাহিম।",
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

          ElevatedButton(
            onPressed: () async {
              final pdfBytes = await _generatePdf(PdfPageFormat.a4);
              // Show PDF Preview
              await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
            },
            child: const Text('Generate PDF'),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final imageBytes = await _capturePng();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pw.MemoryImage(imageBytes), width: 300));
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    // Convert the image to byte data
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Correct the orientation by flipping the image
    final flippedBytes = await _flipImage(pngBytes);
    return flippedBytes;
  }

  Future<Uint8List> _flipImage(Uint8List imageBytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image srcImage = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint();
    final size = Size(srcImage.width.toDouble(), srcImage.height.toDouble());

    // Flip the image vertically to fix upside-down issue
    // canvas.translate(size.width, size.height);
    // canvas.rotate(3.1416); // Rotate 180 degrees (π radians)
    // canvas.scale(-1, -1);
    canvas.drawImage(srcImage, Offset.zero, paint);

    final picture = recorder.endRecording();
    final ui.Image flippedImage = await picture.toImage(srcImage.width, srcImage.height);

    // Convert flipped image to Uint8List
    ByteData? flippedByteData = await flippedImage.toByteData(format: ui.ImageByteFormat.png);
    return flippedByteData!.buffer.asUint8List();
  }

}
