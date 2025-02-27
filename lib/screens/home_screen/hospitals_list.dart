// lib/screens/hospitals_screen/hospitals_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For LatLng
import 'hospital_details.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HospitalsList extends StatefulWidget {
  @override
  _HospitalsListState createState() => _HospitalsListState();
}

class _HospitalsListState extends State<HospitalsList> {
  final PanelController _panelController = PanelController();

  // State variable to keep track of the selected hospital's name
  String? _selectedHospitalName = "Santa Barbara Cottage Hospital"; // Initialized with a default selection

  final List<Map<String, dynamic>> baseHospitals = [
    {
      "name": "Santa Barbara Cottage Hospital",
      "basePhone": "123-456-7890",
      "edPhone": "805-682-8000",
      "address": "400 W Pueblo St, Santa Barbara, CA",
      "specialties": ["Level 1 Trauma", "Cardiac Center"],
      "latitude": 34.4261,
      "longitude": -119.7116,
    },
    {
      "name": "Goleta Valley Cottage Hospital",
      "basePhone": "805-967-3411",
      "edPhone": "805-965-3361",
      "address": "351 S Patterson Ave, Goleta, CA",
      "specialties": ["General Medicine"],
      "latitude": 34.4358,
      "longitude": -119.8276,
    },
  ];

  final List<Map<String, dynamic>> outOfCountyHospitals = [
    {
      "name": "Marian Regional Medical Center",
      "basePhone": "805-739-3000",
      "edPhone": "805-739-3145",
      "address": "1400 E Church St, Santa Maria, CA",
      "specialties": ["Stroke Center", "Cardiac Center"],
      "latitude": 34.9455,
      "longitude": -120.4216,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hospitals")),
      body: Stack(
        children: [
          // The map as the background
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(34.260, -119.786),
              initialZoom: 10.2,
              // Enable interaction to deselect marker when tapping on the map
              onTap: (_, __) {
                setState(() {
                  _selectedHospitalName = null;
                  print("Map tapped. Deselected any selected marker.");
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: _buildMarkers(baseHospitals + outOfCountyHospitals),
              ),
              
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                //('https://www.openstreetmap.org/copyright');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '© OpenStreetMap contributors',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue, // Indicates it's clickable
                    decoration: TextDecoration.underline, // Underlines the text
                  ),
                ),
              ),
            ),
          ),
          // Sliding Up Panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            minHeight: MediaQuery.of(context).size.height * 0.4,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            panelSnapping: true,
            parallaxEnabled: true,
            parallaxOffset: 0.1,
            // Remove the header. We'll include the handle inside the panel content.
            panelBuilder: (sc) => Column(
              children: [
                // Handle at the top inside the panel content
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: sc,
                    children: [
                      _buildHospitalSection(context, "Base Hospitals", baseHospitals),
                      _buildHospitalSection(context, "Out-of-County Hospitals", outOfCountyHospitals),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers(List<Map<String, dynamic>> hospitals) {
  return hospitals.map((hospital) {
    bool isSelected = hospital["name"] == _selectedHospitalName;
    print("Marker tapped: ${hospital["name"]}");
    print("Is Selected: $isSelected");
    print("Selected Hospital Name: $_selectedHospitalName");

    return Marker(
      point: LatLng(hospital["latitude"], hospital["longitude"]),
      width: 160.0, // Adjusted width to accommodate the label
      height: 160.0, // Adjusted height to accommodate the label
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reserve space for the label using Visibility with maintainSize
          Visibility(
            visible: isSelected,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 150, // Maximum width of the label
              ),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Increased padding
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95), // Increased opacity
                borderRadius: BorderRadius.circular(16), // More rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                hospital["name"],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                softWrap: true, // Allow text to wrap
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ),
          // Add some spacing between the label and the icon
          SizedBox(height: 4),
          // GestureDetector only wraps the Icon to prevent label taps from toggling selection
          GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedHospitalName == hospital["name"]) {
                  // If the tapped marker is already selected, deselect it
                  _selectedHospitalName = null;
                  print("Deselecting marker: ${hospital["name"]}");
                } else {
                  // Select the new marker
                  _selectedHospitalName = hospital["name"];
                  print("Selecting marker: ${hospital["name"]}");
                }
              });
            },
            child: Icon(
              Icons.location_on,
              size: 40,
              color: isSelected ? Colors.green : Colors.red, // Green when selected
            ),
          ),
        ],
      ),
    );
  }).toList();
}





  /// Builds a section of hospitals with a given title
  Widget _buildHospitalSection(BuildContext context, String title, List<Map<String, dynamic>> hospitals) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ...hospitals.map((hospital) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showHospitalDetails(context, hospital);
                  },
                  child: ListTile(
                    title: Text(hospital["name"]),
                    subtitle: Text(hospital["address"]),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  /// Displays the hospital details in a dialog
  void _showHospitalDetails(BuildContext context, Map<String, dynamic> hospital) {
    showDialog(
      context: context,
      builder: (_) => HospitalDetails(
        name: hospital["name"],
        basePhone: hospital["basePhone"],
        edPhone: hospital["edPhone"],
        address: hospital["address"],
        specialties: hospital["specialties"],
      ),
    );
  }
}
