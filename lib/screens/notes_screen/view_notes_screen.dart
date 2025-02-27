// lib/screens/notes_screen/view_note_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/library_view_model.dart';
import '../../models/note.dart';
import '../../UI/colors.dart';
import 'note_editor_screen.dart'; // Import AppColors

class ViewNoteScreen extends StatelessWidget {
  final Note note;

  const ViewNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch the latest version of the note from the provider
    final updatedNote = Provider.of<LibraryViewModel>(context)
        .notes
        .firstWhere((n) => n.id == note.id, orElse: () => note);

    return Scaffold(
      appBar: AppBar(
        title: Text('View Note'),
        backgroundColor: AppColors.background, // Ensure consistent AppBar color
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit Note',
            onPressed: () {
              // Navigate to EditNoteScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteEditorScreen(note: updatedNote),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
          children: [
            // Main Content (Title and Content)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                  children: [
                    // Note Name (Title)
                    Text(
                      updatedNote.name,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0), // Spacing for visual balance

                    // Divider to separate title from content
                    Divider(
                      color: Colors.grey, // Customize color as needed
                      thickness: 1.0, // Customize thickness as needed
                    ),
                    SizedBox(height: 8.0), // Spacing after the divider

                    // Note Content
                    Text(
                      updatedNote.content,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.left, // Ensure text is left-aligned
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0), // Padding between content and button

            // Delete Note Button
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color to indicate a destructive action
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0, // Vertical padding
                    horizontal: 20.0, // Horizontal padding
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0), // More rounded corners
                  ),
                  minimumSize: Size(100, 40), // Set a minimum size
                ),
                onPressed: () {
                  _showDeleteConfirmation(context, updatedNote);
                },
              ),
            ),
            SizedBox(height: 24.0), // Additional padding from the bottom
          ],
        ),
      ),
    );
  }

  // Method to show the delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Delete the note using the ViewModel
                Provider.of<LibraryViewModel>(context, listen: false)
                    .deleteNote(note.id!);
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.of(context).pop(); // Navigate back to the previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Note "${note.name}" deleted')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
