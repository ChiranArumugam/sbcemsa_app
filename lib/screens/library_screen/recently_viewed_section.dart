// lib/screens/library_screen/recently_viewed_section.dart

import 'package:flutter/material.dart';
import '../../models/pdf_document.dart';
import '../../UI/colors.dart';

class RecentlyViewedSection extends StatelessWidget {
  final List<PdfDocClass> recentlyViewed;
  final Function(PdfDocClass) onPdfTap;

  RecentlyViewedSection({
    required this.recentlyViewed,
    required this.onPdfTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentlyViewed.isEmpty) {
      // Display placeholder message when there are no favorites
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Text(
            "No recently viewed PDFs.",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recentlyViewed.length,
      itemBuilder: (context, index) {
        final pdf = recentlyViewed[index];
        return ListTile(
          leading: Icon(Icons.picture_as_pdf, color: AppColors.primary),
          title: Text(
            pdf.pdfName,
            style: TextStyle(color: AppColors.primary),
          ),
          onTap: () => onPdfTap(pdf),
        );
      },
    );
  }
}
