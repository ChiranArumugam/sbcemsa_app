import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../UI/colors.dart';

class HospitalDetails extends StatelessWidget {
  final String name;
  final String basePhone;
  final String edPhone;
  final String address;
  final List<String> specialties;

  const HospitalDetails({
    required this.name,
    required this.basePhone,
    required this.edPhone,
    required this.address,
    required this.specialties,
  });

  void _openContact(String phoneNumber) async {
    final Uri contactUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(contactUri)) {
      await launchUrl(contactUri);
    } else {
      print('Could not open contact for $phoneNumber');
    }
  }

  void _openMaps(String address) {
    MapsLauncher.launchQuery(address);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Card-like style
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Container(
        child: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoTile(
              context,
              title: "Base Phone",
              subtitle: basePhone,
              icon: Icons.phone,
              onTap: () => _openContact(basePhone),
            ),
            _buildInfoTile(
              context,
              title: "ED Phone",
              subtitle: edPhone,
              icon: Icons.phone,
              onTap: () => _openContact(edPhone),
            ),
            _buildInfoTile(
              context,
              title: "Address",
              subtitle: address,
              icon: Icons.map,
              onTap: () => _openMaps(address),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Specialties:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
            for (var specialty in specialties)
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        specialty,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Close"),
        ),
      ],
    );
  }

  Widget _buildInfoTile(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(color: AppColors.primary)),
      subtitle: Text(subtitle),
      trailing: Icon(icon, color: AppColors.accent),
      onTap: onTap,
    );
  }
}
