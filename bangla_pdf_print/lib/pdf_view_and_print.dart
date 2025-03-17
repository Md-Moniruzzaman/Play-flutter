import 'dart:typed_data';

import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfViewAndPrint extends StatefulWidget {
  const PdfViewAndPrint({super.key});

  @override
  State<PdfViewAndPrint> createState() => _PdfViewAndPrintState();
}

class _PdfViewAndPrintState extends State<PdfViewAndPrint> {
  @override
  Widget build(BuildContext context) {
    print(unicodeToBijoy("কিছু গ্লিফ প্রিভিউ জন্মদিন সিঁড়ি"));
    return Scaffold(
      appBar: AppBar(title: const Text('PDF View and Print')),
      body: PdfPreview(build: (format) => _generatePdf(format, unicodeToBijoy("কিছু গ্লিফ প্রিভিউ জন্মদিন সিঁড়ি"))),
      // Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       // Add code here
      //     },
      //     child: const Text('Open PDF'),
      //   ),
      // ),
    );
  }

  String getUnicodeString(String unicodeValue) => unicodeToBijoy(unicodeValue);

  Future<pw.Font> loadBanglaFont() async {
    // final fontData = await rootBundle.load("assets/fonts/TiroBangla-Regular.ttf");
    final fontData = await rootBundle.load("assets/fonts/NotoSansBengali-Regular.ttf");
    // final fontData = await rootBundle.load("assets/fonts/Akkhor-Regular.ttf");
    // final fontData = await rootBundle.load("assets/fonts/AtraiMJ.ttf");
    // final fontData = await rootBundle.load("assets/fonts/kalpurush.ttf");
    // final fontData = await rootBundle.load("assets/fonts/SiyamRupaliANSI.ttf");
    return pw.Font.ttf(fontData);
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await loadBanglaFont();
    // final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(child: pw.Text(bijoyToUnicode(title), style: pw.TextStyle(font: font))),
              ),
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(
                    // unicodeToBijoy("যেহেতু জাতিসমূহের \nসমস্ত যেহেতু মানুষ যাতে"),
                    'c«¯—yZKvix: ',
                    style: pw.TextStyle(font: font),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo()),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
