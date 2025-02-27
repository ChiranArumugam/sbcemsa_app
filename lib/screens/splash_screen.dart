// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart'; // Import the MainScreen
import '../view_models/library_view_model.dart';
import 'dart:async'; // Import for Future.delayed

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isNavigated = false;
  late LibraryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Schedule a post-frame callback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<LibraryViewModel>(context, listen: false);
      _viewModel.addListener(_listener);
    });
  }

  // Make the listener asynchronous to accommodate the delay
  void _listener() async {
    if (!_isNavigated && _viewModel.initializationProgress >= 1.0) {
      _isNavigated = true;
      // Introduce a delay before navigation
      await Future.delayed(Duration(milliseconds: 200));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize as needed
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<LibraryViewModel>(
            builder: (context, viewModel, child) {
              double progress = viewModel.initializationProgress;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox for initial spacing
                  SizedBox(height: 20),

                  // **Added:** kern.png icon centered horizontally
                  Center(
                    child: Image.asset(
                      'assets/icons/sb.png', // Ensure this path is correct
                      width: MediaQuery.of(context).size.width *70/ 100, // Adjust width as needed
                      height: MediaQuery.of(context).size.width *70 / 100, // Adjust height as needed
                    ),
                  ),

                  // SizedBox to add spacing between sb.png and the loading bar
                  SizedBox(height: MediaQuery.of(context).size.height/7),

                  // **Adjusted:** TweenAnimationBuilder for the loading bar and ambulance
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: progress),
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      double width = MediaQuery.of(context).size.width - 40; // Considering padding
                      double ambulanceWidth = 50.0; // Width of the ambulance icon
                      double maxPosition = (width - ambulanceWidth).clamp(0.0, double.infinity); // Ensure it's not negative
                      double position = (value * (width - ambulanceWidth)).clamp(0.0, maxPosition);

                      return Stack(
                        children: [
                          // Define the height of the Stack to accommodate the ambulance above the progress bar
                          Container(
                            height: 80, // Increased height to move the loading bar down
                            width: double.infinity,
                          ),
                          // Grey progress bar background at bottom
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          // Red progress bar foreground
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: width * value,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          // **Adjusted:** Ambulance icon positioned above the progress bar and centered
                          Positioned(
                            left: position, // Center horizontally
                            bottom: 15, // Positioned slightly above the progress bar
                            child: Image.asset(
                              'assets/icons/ambulance.png', // Ensure this path is correct
                              width: ambulanceWidth,
                              height: 50, // Adjust height as needed
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // **Adjusted:** Increased spacing to move the loading bar down
                  SizedBox(height: 30),

                  // Optional: Add other widgets or leave empty
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
