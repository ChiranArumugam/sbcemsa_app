// lib/screens/library_screen/pdf_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pdf_document.dart';
import 'pdf_viewer_screen.dart';
import '../../UI/colors.dart'; // Ensure this path is correct
import '../../view_models/library_view_model.dart';

class PdfListScreen extends StatelessWidget {
  final String category;
  final String subcategory;
  final List<PdfDocClass> pdfs;

  PdfListScreen({
    required this.category,
    required this.subcategory,
    required this.pdfs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category/$subcategory'),
        backgroundColor: AppColors.background, // Set AppBar color
      ),
      body: Container(
        color: AppColors.background, // Set overall background color
        child: ListView.builder(
          itemCount: pdfs.length,
          itemBuilder: (context, index) {
            final pdf = pdfs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Material(
                elevation: 1.0, // Set elevation for shadow
                borderRadius: BorderRadius.circular(15.0),
                color: AppColors.background, // Card background color
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () {
                    // Access LibraryViewModel without listening for changes
                    final libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
                    print('LibraryViewModel accessed: $libraryViewModel');

                    // Add to recently viewed
                    libraryViewModel.addRecentlyViewed(pdf);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewerScreen(
                          pdf: pdf,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/pdf_icon.png', // Adjust the path as per your asset structure
                          width: 40.0,
                          height: 40.0,
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            pdf.pdfName,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppColors.primary, // Set text color
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Text(
                        //   '${pdf.numPages} pages',
                        //   style: TextStyle(
                        //     fontSize: 14.0,
                        //     color: AppColors.primary, // Set text color
                        //   ),
                        // ),
                        SizedBox(width: 8.0),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primary,
                          size: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
