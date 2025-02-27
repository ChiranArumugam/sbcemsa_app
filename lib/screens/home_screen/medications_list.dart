// lib/screens/home_screen/medications_list.dart

import 'package:flutter/material.dart';
import '../../models/pdf_document.dart';
import '../../UI/colors.dart';
import 'medication_details_popup.dart';
import '../../models/medication.dart'; // Import the Medication model

class MedicationsList extends StatelessWidget {
  // Define a list of Medication objects
  final List<Medication> medications = [
    Medication(
      name: 'Fentanyl',
      iconPath: 'assets/icons/pill.png',
      adultInfo:
'''SBP ≥ 100mmHg with unimpaired respirations, GCS normal for baseline & no known anaphylaxis: \n
• IV/IO – 1mcg/kg over 1 min (Max single dose 100mcg, may repeat every 5 mins for persistent pain, not to exceed 200mcg total dose) \n
• IM/IN – 1mcg/kg (Max single dose 100mcg, may repeat after 15 mins for persistent pain, not to exceed 200mcg total dose)''',
      pediatricInfo:
'''SBP is Age-Appropriate with unimpaired respirations, GCS normal for baseline & no  known anaphylaxis\n
• IV/IO – 1mcg/kg over 1 min (May repeat every 5 mins for persistent pain, not to exceed 4 doses or 200mcg total dose)\n
• IM/IN – 1mcg/kg  (Max single dose 100mcg, may repeat after 15 mins for persistent pain, not to exceed 4 doses or 200mcg total dose)''',    
      pdf: PdfDocClass(filePath: 'assets/documents/533-03_Pain_Control.pdf', pdfName: '533-03 Pain Control', category: 'Protocols', subcategory: 'General')),
    Medication(
      name: 'Ketamine',
      iconPath: 'assets/icons/pill.png',
      adultInfo:
'''Only when Fentanyl is contraindicated:\n
• IV/IO – 0.3mg/kg in 100mL Normal Saline IVPB over 5 mins (Max single dose 30mg, may repeat x1 in 10 mins)\n
• Contraindications:\n  – GCS <14\n  – Suspected or confirmed pregnancy\n  – Suspected acute coronary syndrome\n  – Known or suspected alcohol or drug intoxication\n  – Known allergy or anaphylaxis''',
      pediatricInfo:
'''Only when Fentanyl is contraindicated:\n
• IV/IO – 0.3mg/kg in 100mL Normal Saline IVPB over 5 mins (Max single dose 10mg, may repeat x1 in 10 mins)\n
• Contraindications:\n  – GCS <14\n  – Suspected or confirmed pregnancy\n  – Suspected acute coronary syndrome\n  – Known or suspected alcohol or drug intoxication\n  – Known allergy or anaphylaxis''',    
      pdf: PdfDocClass(filePath: 'assets/documents/533-03_Pain_Control.pdf', pdfName: '533-03 Pain Control', category: 'Protocols', subcategory: 'General')),
    // Medication(
    //   name: 'Vitamin C',
    //   iconPath: 'assets/icons/pill.png',
    //   adultInfo:
    //       'Adult dose and usage information for Vitamin C. Essential for immune function and skin health.',
    //   pediatricInfo:
    //       'Pediatric dose and usage information for Vitamin C. Important for growth and development in children.',
    // ),
    // Medication(
    //   name: 'Antibiotic',
    //   iconPath: 'assets/icons/pill.png',
    //   adultInfo:
    //       'Adult dose and usage information for Antibiotic. Used to treat bacterial infections.',
    //   pediatricInfo:
    //       'Pediatric dose and usage information for Antibiotic. Effective in treating infections in children.',
    // ),
    // Medication(
    //   name: 'Allergy Relief',
    //   iconPath: 'assets/icons/pill.png',
    //   adultInfo:
    //       'Adult dose and usage information for Allergy Relief. Helps alleviate allergy symptoms.',
    //   pediatricInfo:
    //       'Pediatric dose and usage information for Allergy Relief. Suitable for managing allergies in children.',
    // ),
    // Medication(
    //   name: 'Cough Syrup',
    //   iconPath: 'assets/icons/pill.png',
    //   adultInfo:
    //       'Adult dose and usage information for Cough Syrup. Relieves cough and throat irritation.',
    //   pediatricInfo:
    //       'Pediatric dose and usage information for Cough Syrup. Safe for children when administered correctly.',
    // ),
    // Add more medications as needed
  ];

  // Function to open the medication details
  void _openMedicationDetails(BuildContext context, Medication medication) {
    showDialog(
      context: context,
      builder: (_) => MedicationDetailsPopup(medication: medication),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: medications.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75, // Adjusts the height-to-width ratio
          ),
          itemBuilder: (context, index) {
            final medication = medications[index];
            return Material(
              elevation: 1.0,
              borderRadius: BorderRadius.circular(16.0),
              child: InkWell(
                onTap: () => _openMedicationDetails(context, medication),
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        medication.iconPath,
                        width: 40.0,
                        height: 40.0,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        medication.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.0),
                      Icon(
                        Icons.info_outline,
                        color: AppColors.accent,
                        size: 24.0,
                      ),
                    ],
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
