// lib/screens/home_screen/contacts_card.dart

import 'package:flutter/material.dart';
import '../../UI/colors.dart';
import 'contacts_list.dart'; // Import ContactsList

class ContactsCard extends StatelessWidget {
  final VoidCallback? onTap;

  // Accept the `onTap` parameter in the constructor
  const ContactsCard({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double squareSize = MediaQuery.of(context).size.width / 2 - 24.0;

    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ContactsList()),
            );
          },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: squareSize,
        height: squareSize - 15,
        child: Card(
          color: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 40.0,
                  color: AppColors.accent,
                  semanticLabel: 'Contacts Icon',
                ),
                SizedBox(height: 8.0),
                Text(
                  'Contacts',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                  semanticsLabel: 'Contacts',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
