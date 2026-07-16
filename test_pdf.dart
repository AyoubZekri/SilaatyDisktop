import "package:pdf/pdf.dart";
void main() {
  print(PdfPageFormat.roll80.height == double.infinity);
  print(PdfPageFormat.roll80.width);
  print(PdfPageFormat.roll57.width);
}
