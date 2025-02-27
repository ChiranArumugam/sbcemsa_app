import 'package:flutter/material.dart';
import '../../UI/colors.dart';

// Data model classes
class Drug {
  final String name;
  final List<DrugRoute> routes;
  
  Drug({required this.name, required this.routes});
}

class DrugRoute {
  final String name;             // e.g. "IV/IO", "IM/IN"
  final double dosePerKgMg;      // dose in mg/kg
  final double concentration;    // mg/mL for volume calculation
  final String note;

  DrugRoute({
    required this.name,
    required this.dosePerKgMg,
    required this.concentration,
    required this.note,
  });
}

// Example data: fentanyl and ketamine
final List<Drug> drugs = [
  Drug(
    name: "Fentanyl",
    routes: [
      // Fentanyl IV/IO: 1 mcg/kg = 0.001 mg/kg
      // Assuming concentration = 50 mcg/mL = 0.05 mg/mL
      DrugRoute(
        name: "IV/IO",
        dosePerKgMg: 0.001,
        concentration: 0.05,
        note: "Over 1 min (may repeat every 5 mins for persistent pain, not to exceed 4 doses or 200 mcg total dose).",
      ),
      // Fentanyl IM/IN: also 1 mcg/kg = 0.001 mg/kg
      // Same concentration assumption
      DrugRoute(
        name: "IM/IN",
        dosePerKgMg: 0.001,
        concentration: 0.05,
        note: "Max single dose 100 mcg, may repeat after 15 mins for persistent pain, not to exceed 200 mcg total dose.",
      ),
    ],
  ),
  Drug(
    name: "Ketamine",
    routes: [
      // Ketamine IV/IO: 0.3 mg/kg
      // Assuming concentration = 10 mg/mL
      DrugRoute(
        name: "IV/IO",
        dosePerKgMg: 0.3,
        concentration: 10.0,
        note: "In 100 mL NS IVPB over 5 mins (Max single dose 10 mg, may repeat x1 in 10 mins). Only when fentanyl is contraindicated.",
      ),
    ],
  ),
];

// Pediatric Dosage Calculator Page
class PediatricDoseCalculatorPage extends StatefulWidget {
  @override
  _PediatricDoseCalculatorPageState createState() => _PediatricDoseCalculatorPageState();
}

class _PediatricDoseCalculatorPageState extends State<PediatricDoseCalculatorPage> {
  Drug? _selectedDrug;
  DrugRoute? _selectedRoute;
  //bool _isKg = false; // If false, user entering lbs
  String _weightUnit = 'lbs';
  String _weightInput = "";

  TextEditingController _drugController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select a drug if desired
    // _selectedDrug = drugs.first;
    // _selectedRoute = _selectedDrug?.routes.length == 1 ? _selectedDrug!.routes.first : null;
  }

  double? _calculateDoseMg() {
    if (_selectedDrug == null || _selectedRoute == null) return null;
    if (_weightInput.isEmpty) return null;

    double weight;
    // Convert input to kg if needed
    try {
      final enteredValue = double.parse(_weightInput);
      weight = _weightUnit == 'kg' ? enteredValue : enteredValue * 0.453592; // lbs to kg
    } catch (e) {
      return null; // Invalid input
    }

    final doseMg = weight * _selectedRoute!.dosePerKgMg; 
    return doseMg;
  }

  double? _calculateVolumeMl() {
    final doseMg = _calculateDoseMg();
    if (doseMg == null) return null;

    // volume = dose (mg) / concentration (mg/mL)
    return doseMg / _selectedRoute!.concentration;
  }
@override
  Widget build(BuildContext context) {
    final doseMg = _calculateDoseMg();
    final volumeMl = _calculateVolumeMl();

    return Scaffold(
      appBar: AppBar(
        title: Text("Pediatric Dose Calculator"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Autocomplete for drug selection
            Autocomplete<Drug>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return drugs;
                }
                return drugs.where((d) => d.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              displayStringForOption: (Drug d) => d.name,
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                _drugController = controller;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Select Drug",
                    border: OutlineInputBorder(),
                    suffixIcon: _selectedDrug != null
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _selectedDrug = null;
                                _selectedRoute = null;
                                _weightInput = '';  // Clear weight input as well
                                _drugController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                );
              },
              onSelected: (Drug d) {
                setState(() {
                  _selectedDrug = d;
                  _weightInput = ''; // Reset weight when new drug is selected
                  _selectedRoute = null;
                  if (_selectedDrug!.routes.length == 1) {
                    _selectedRoute = _selectedDrug!.routes.first;
                  }
                });
              },
            ),

            SizedBox(height: 16.0),

            // If multiple routes, show selection. If one route, it's auto-selected above.
            if (_selectedDrug != null && _selectedDrug!.routes.length > 1)
              // We allow empty selection so user doesn't see pre-computed results instantly.
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _selectedDrug!.routes.map((r) {
                  final isSelected = _selectedRoute == r;
                  return ChoiceChip(
                    label: Text(r.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRoute = selected ? r : null;
                        // Clear weight input to prevent stale results if desired:
                        // _weightInput = '';
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.1),
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.black,
                    ),
                  );
                }).toList(),
              ),

            SizedBox(height: 16.0),

            // Weight input row with a dropdown for units (default lbs)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Weight (${_weightUnit})",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        _weightInput = val;
                      });
                    },
                    // Clear input if needed when changing route/drug if you want:
                    // controller: weightController,
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: _weightUnit,
                  onChanged: (value) {
                    setState(() {
                      _weightUnit = value ?? 'lbs';
                      // Optionally clear weight to force re-entry:
                      // _weightInput = '';
                    });
                  },
                  items: [
                    DropdownMenuItem(value: 'lbs', child: Text('lbs')),
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.0),

            // Display results
            if (_selectedDrug != null && _selectedRoute != null && doseMg != null && volumeMl != null && _weightInput.isNotEmpty) ...[
              Text(
                "Dose: ${doseMg.toStringAsFixed(2)} mg",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              SizedBox(height: 8.0),
              Text(
                "Volume: ${volumeMl.toStringAsFixed(2)} mL",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent),
              ),
              SizedBox(height: 16.0),
              Text(
                _selectedRoute!.note,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.left,
              ),
            ] else if (_selectedDrug != null && _selectedRoute != null) ...[
              // If drug and route are selected but no valid weight/dose yet:
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("Enter weight to calculate dose.", style: TextStyle(color: Colors.grey)),
              )
            ],
          ],
        ),
      ),
    );
  }
}