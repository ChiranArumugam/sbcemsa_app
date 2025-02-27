// lib/screens/home_screen/contacts_list.dart

import 'package:flutter/material.dart';
import '../../UI/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final List<Map<String, String>> _builtInContacts = [
    {'name': 'Poison Control Center', 'phone': '8002221222'},
    {'name': 'Driver\'s Alert Network', 'phone': '9876543210'},
    {'name': 'CHEMTREC', 'phone': '9876543210'},
  ];

  List<Map<String, String>> _userAddedContacts = [];

  @override
  void initState() {
    super.initState();
    _loadUserAddedContacts();
  }

  Future<void> _loadUserAddedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user_added_contacts');
    if (jsonString != null) {
      List<dynamic> decoded = jsonDecode(jsonString);
      setState(() {
        _userAddedContacts = decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  Future<void> _saveUserAddedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_added_contacts', jsonEncode(_userAddedContacts));
  }

  void _openContact(String phoneNumber) async {
    final Uri contactUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(contactUri)) {
      await launchUrl(contactUri);
    } else {
      print('Could not open contact for $phoneNumber');
    }
  }

  void _addNewContact() {
  String name = '';
  String phone = '';
  String? errorMessage;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          Future<void> validateAndAdd() async {
            // Basic validations
            if (name.isEmpty || phone.isEmpty) {
              setStateDialog(() {
                errorMessage = 'Name and phone cannot be empty.';
              });
              return; // Don't proceed further
            }

            // Check phone format
            final phoneRegex = RegExp(r'^[0-9]+$');
            if (!phoneRegex.hasMatch(phone) || phone.length != 10) {
              setStateDialog(() {
                errorMessage = 'Please enter a valid phone number.';
              });
              return; // Don't proceed further
            }

            // If we reach here, validation passed
            setState(() {
              _userAddedContacts.add({'name': name, 'phone': phone});
            });
            await _saveUserAddedContacts();
            Navigator.of(context).pop(); // Close the dialog now that we've added the contact
          }

          return AlertDialog(
            title: Text('Add New Contact'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Contact Name',
                  ),
                  onChanged: (value) {
                    name = value;
                    if (errorMessage != null) {
                      setStateDialog(() {
                        errorMessage = null;
                      });
                    }
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    errorText: errorMessage,
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    phone = value;
                    if (errorMessage != null) {
                      setStateDialog(() {
                        errorMessage = null;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: AppColors.accent)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Add', style: TextStyle(color: AppColors.primary)),
                onPressed: () {
                  validateAndAdd();
                },
              ),
            ],
          );
        },
      );
    },
  );
}


  void _removeContact(int index) {
    setState(() {
      _userAddedContacts.removeAt(index);
    });
    _saveUserAddedContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView(
        children: [
          // Built-in Contacts Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Built-in Contacts',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          ..._builtInContacts.map((contact) => _buildContactTile(contact, false)).toList(),

          // User-Added Contacts Section
          if (_userAddedContacts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'User-Added Contacts',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            ..._userAddedContacts.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> contact = entry.value;
              return _buildContactTile(contact, true, index: index);
            }).toList(),
          ],
          if (_userAddedContacts.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Text(
                'No user-added contacts yet. Tap the + button to add some.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
          SizedBox(height: 80), // Padding at the bottom
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContact,
        backgroundColor: AppColors.accent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContactTile(Map<String, String> contact, bool isUserAdded, {int index = -1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () => _openContact(contact['phone']!),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.person, size: 40.0, color: AppColors.accent),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name']!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        contact['phone']!,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUserAdded)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      _removeContact(index);
                    },
                  )
                else
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.grey[600],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
