// lib/screens/home_screen/main_slideshow.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../UI/colors.dart'; // Ensure this imports your custom color definitions

class MainSlideshow extends StatefulWidget {
  @override
  _MainSlideshowState createState() => _MainSlideshowState();
}

class _MainSlideshowState extends State<MainSlideshow> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _autoSlideTimer;
  Timer? _captionTimer;
  bool _showCaption = false;

  // List of slides: Each slide contains an image path and a caption
  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/slide1.png',
      'caption': 'Emergency Response Vehicle and Helicopter',
    },
    {
      'image': 'assets/images/slide2.png',
      'caption': 'Fire Truck in Front of a Fire',
    },
    {
      'image': 'assets/images/slide3.png',
      'caption': 'Emergency Responders Responding to an Emergency',
    },
    // Add more slides as needed
  ];

  @override
  void initState() {
    super.initState();
    // Start the timer for auto-sliding
    _startAutoSlide();
  }

  /// Starts the auto-slide timer to change slides every 5 seconds.
  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      int nextPage = _currentPage + 1;
      if (nextPage >= _slides.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Displays the caption and hides it after 3 seconds.
  void _showAndHideCaption() {
    setState(() {
      _showCaption = true;
    });

    // Cancel any existing caption timer
    _captionTimer?.cancel();

    // Hide the caption after 3 seconds of inactivity
    _captionTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showCaption = false;
      });
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _captionTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Builds the indicator dots overlaying the image at the top.
  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _slides.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _pageController.animateToPage(
            entry.key,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
          child: Container(
            width: 12.0,
            height: 12.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (_currentPage == entry.key)
                  ? AppColors.background
                  : AppColors.background.withOpacity(0.5),
              border: Border.all(
                color: AppColors.primary,
                width: 1.0,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define a taller aspect ratio for the slideshow (e.g., 2:1)
    const double aspectRatio = 2 / 1;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        color: Colors.grey[200], // Light grey background for visibility
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0, // Added elevation for better visibility
        child: Stack(
          children: [
            // GestureDetector to detect taps and swipes on the slideshow
            GestureDetector(
              onTap: () {
                _showAndHideCaption();
              },
              onPanDown: (_) {
                // User started interacting with the slideshow
                _showAndHideCaption();
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                  // Do not show caption on auto-slide
                  // Caption only shows on user interaction via GestureDetector
                },
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      _slides[index]['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      semanticLabel: _slides[index]['caption']!, // Added for accessibility
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.red,
                              size: 50.0,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            // Caption positioned at the top of the image
            if (_showCaption)
              Positioned(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                child: AnimatedOpacity(
                  opacity: _showCaption ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _slides[_currentPage]['caption']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            // Indicator dots overlaying the image at the top
            Positioned(
              bottom: 4, // Adjust position below the caption if needed
              left: 0,
              right: 0,
              child: _buildIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
