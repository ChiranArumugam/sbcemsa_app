import 'package:flutter/material.dart';
import 'hospitals_card.dart';
import 'hospitals_list.dart';
import 'main_slideshow.dart';
import 'contacts_card.dart';
import 'medications_card.dart';
import 'pediatric_drug_card.dart';
import 'visit_website.dart';
import 'contacts_list.dart';
import 'medications_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart'; // If using Lottie animations

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkPopupStatus();
  }

  Future<void> _checkPopupStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenPopup = prefs.getBool('hasSeenPopup') ?? false;

    if (!hasSeenPopup) {
      // Show the popup message
      _showWelcomePopup();
      // Mark the popup as shown
      await prefs.setBool('hasSeenPopup', true);
    }
  }

  void _showWelcomePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome to the App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie animation that takes up maximum available space
              Expanded(
                child: Lottie.asset(
                  'assets/icons/animation.json',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.0),
              Text('Thank you for using our app!'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomNavBarHeight = 70.0 + 24.0;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Overall padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainSlideshow(),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ContactsCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ContactsList()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: MedicationsCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MedicationsList()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: HospitalsCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HospitalsList()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: PediatricDrugCard(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              VisitWebsiteCard(
                url: 'https://www.countyofsb.org/2024/EMS-Agency/',
                text: 'Visit Website',
              ),
              SizedBox(height: bottomNavBarHeight),
            ],
          ),
        ),
      ),
    );
  }
}
