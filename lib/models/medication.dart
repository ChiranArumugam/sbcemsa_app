// lib/models/medication.dart
import 'pdf_document.dart';

class Medication {
  final String name;
  final String iconPath;
  final String adultInfo;
  final String pediatricInfo;
  final PdfDocClass pdf;

  Medication({
    required this.name,
    required this.iconPath,
    required this.adultInfo,
    required this.pediatricInfo,
    required this.pdf,
  });
}
