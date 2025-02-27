// lib/screens/home_screen/medication_details_popup.dart

import 'package:flutter/material.dart';
import '../library_screen/pdf_viewer_screen.dart';
import '../../UI/colors.dart';
import 'medication_content.dart';
import '../../widgets/custom_toggle_switch.dart';
import '../../models/medication.dart'; // Import the Medication model

class MedicationDetailsPopup extends StatefulWidget {
  final Medication medication;

  const MedicationDetailsPopup({Key? key, required this.medication})
      : super(key: key);

  @override
  _MedicationDetailsPopupState createState() => _MedicationDetailsPopupState();
}

class _MedicationDetailsPopupState extends State<MedicationDetailsPopup> {
  bool isPediatric = false;

  void _toggleMode() {
    setState(() {
      isPediatric = !isPediatric;
    });
  }

  void _handleMoreInfo(Medication medication) {
    // Define your desired action here.
    // For demonstration, we'll navigate to a PDF viewer screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          pdf: medication.pdf,
        ),
      ),
    );

    // Alternatively, you can perform other actions:
    // - Show a SnackBar
    // - Navigate to another screen
    // - Open a URL using the url_launcher package
  }

  @override
  Widget build(BuildContext context) {
    // Determine the maximum height for the popup based on screen size
    final double maxHeight = MediaQuery.of(context).size.height * 0.6;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // Ensure the popup doesn't exceed the maxHeight
          maxHeight: maxHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Allow the column to take up minimum space and let the scrollable content handle overflow
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Toggle Switch and Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Toggle Switch on the left
                  CustomToggleSwitch(
                    isSelected: isPediatric,
                    onToggle: _toggleMode,
                  ),
                  // Close Button on the right
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              // Scrollable Medication Content with Scrollbar
              Expanded(
                child: Stack(
                  children: [
                    Scrollbar(
                      thumbVisibility: true, // Always show scrollbar thumb
                      child: SingleChildScrollView(
                        child: MedicationContent(
                          medication: widget.medication,
                          isPediatric: isPediatric,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0), // Space before the button
              // "View Policy" Button using ElevatedButton
              ElevatedButton(
                onPressed: () => _handleMoreInfo(widget.medication),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: AppColors.accent, // White text
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: Text(
                  'View Policy',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
