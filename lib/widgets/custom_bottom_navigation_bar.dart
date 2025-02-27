// lib/widgets/custom_bottom_navigation_bar.dart

import 'package:flutter/material.dart';
import '../UI/colors.dart'; // Adjust the import path if necessary

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  // Define the list of navigation items
  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.library_books, label: 'Library'),
    _NavItem(icon: Icons.note, label: 'Notes'),
    _NavItem(icon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0, // Height of the navigation bar
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 24.0), // Adjusted margin to move up
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.95), // Slightly opaque background
        borderRadius: BorderRadius.circular(20.0), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 10.0, // Shadow blur
            offset: Offset(0, 5), // Shadow position
          ),
        ],
      ),
      child: Row(
        children: _navItems.asMap().entries.map((entry) {
          int idx = entry.key;
          _NavItem navItem = entry.value;
          bool isSelected = idx == currentIndex;

          return Expanded(
            child: Material(
              color: Colors.transparent, // Make Material transparent
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0), // Match the container's border radius
                onTap: () {
                  onTap(idx);
                },
                splashColor: AppColors.accent.withOpacity(0.2), // Ripple color
                highlightColor: AppColors.accent.withOpacity(0.1), // Highlight color
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      navItem.icon,
                      color: isSelected ? AppColors.accent : Colors.grey,
                      size: isSelected ? 28.0 : 24.0,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      navItem.label,
                      style: TextStyle(
                        color: isSelected ? AppColors.accent : Colors.grey,
                        fontSize: 12.0,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Helper class to define navigation items
class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
