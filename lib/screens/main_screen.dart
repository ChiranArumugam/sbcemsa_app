import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/library_view_model.dart';
import 'library_screen/library_page.dart';
import 'home_screen/home_screen.dart';
import 'notes_screen/notes_screen.dart';
import 'settings_screen.dart';
import '../UI/colors.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/notification_popup.dart';
import 'package:badges/badges.dart' as badges;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late List<Widget> _screens;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      LibraryPage(),
      NotesScreen(),
      SettingsScreen(),
    ];

    // Initialize the animation controller and height animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 0.0, // Start with 0 height
      end: 50.0,  // Height of the notification bar
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void showNotification() {
    _animationController.forward();
  }

  void hideNotification() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_currentIndex)),
        actions: [
          Consumer<LibraryViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                onPressed: () {
                  if (viewModel.updatedPdfs.isNotEmpty) {
                    showUpdatedPdfsDialog(context, viewModel.updatedPdfs);
                  } else {
                    showNoUpdatesDialog(context);
                  }
                  viewModel.markNotificationsAsRead();
                },
                icon: badges.Badge(
                  showBadge: viewModel.hasUnreadNotifications,
                  badgeContent: Container(
                    width: 2,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  position: badges.BadgePosition.topEnd(top: 0, end: 3),
                  child: const Icon(Icons.notifications),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Animated height for notification bar
          Consumer<LibraryViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.showNotification) {
                showNotification();
              } else {
                hideNotification();
              }
              return AnimatedBuilder(
                animation: _heightAnimation,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _heightAnimation.value / 50, // Normalize height
                      child: NotificationPopup(
                        message: viewModel.notificationMessage,
                        progress: viewModel.updateProgress,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Main content
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String _getTitle(int index) {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Library';
      case 2:
        return 'Notes';
      case 3:
        return 'Settings';
      default:
        return 'PDF Browser';
    }
  }

  void showUpdatedPdfsDialog(BuildContext context, List<Map<String, String>> updatedPdfs) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Updated PDFs"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: updatedPdfs.length,
              itemBuilder: (context, index) {
                final pdf = updatedPdfs[index];
                return ListTile(
                  title: Text(pdf['pdfName'] ?? 'Unknown'),
                  subtitle: Text("Version: ${pdf['version']}"),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void showNoUpdatesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("No Updates"),
          content: const Text("All PDFs are up to date!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
