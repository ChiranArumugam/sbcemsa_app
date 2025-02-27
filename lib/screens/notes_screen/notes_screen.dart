// lib/screens/notes_screen/notes_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_editor_screen.dart';
import '../../view_models/library_view_model.dart';
import '../../models/note.dart';
import 'view_notes_screen.dart';
import '../../UI/colors.dart'; // Assuming AppColors is defined here

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LibraryViewModel>(
        builder: (context, viewModel, child) {
          List<Note> notes = viewModel.notes;

          if (notes.isEmpty) {
            // Display a centered message with a "+" tile when there are no notes
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  SizedBox(height: 16.0),
                  Text(
                    'No notes yet!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Click on the + button to create your first note.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.0),
                  // Add Note Tile
                  _buildAddNoteTile(context),
                ],
              ),
            );
          }

          // When notes exist, display the list with the add note tile at the end
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: notes.length + 1, // Extra item for the add note tile
            itemBuilder: (context, index) {
              if (index < notes.length) {
                // Existing Note Tile
                Note note = notes[index];
                return _buildNoteTile(context, note);
              } else {
                // Add Note Tile
                return _buildAddNoteTile(context);
              }
            },
          );
        },
      ),
    );
  }

  /// Builds a tile for an existing note
  Widget _buildNoteTile(BuildContext context, Note note) {
    return GestureDetector(
      onTap: () {
        // Navigate to ViewNoteScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewNoteScreen(note: note),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.background, // Define card background color in AppColors
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            Icons.note,
            color: AppColors.accent, // Define accent color in AppColors
            size: 30.0,
          ),
          title: Text(
            note.name,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            _getContentPreview(note.content),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          trailing: Icon(
            Icons.arrow_forward_ios,
            //color: AppColors.iconColor,
            size: 16.0,
          ),
        ),
      ),
    );
  }

  String _getContentPreview(String? content, {int maxWords = 10}) {
  if (content == null || content.isEmpty) {
    return ''; // Return empty if content is null or empty
  }

  // Split content into words
  List<String> words = content.split(' ');

  // Check if content has fewer words than the max
  if (words.length <= maxWords) {
    return content; // Return full content if it's short enough
  }

  // Take the first `maxWords` and append ellipsis
  return words.take(maxWords).join(' ') + '...';
}

  /// Builds the "Add Note" tile
  Widget _buildAddNoteTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to NoteEditorScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoteEditorScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.background, // Same as note tiles
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppColors.accent,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        child: ListTile(
          leading: Icon(
            Icons.add,
            color: AppColors.accent,
            size: 30.0,
          ),
          title: Text(
            'Add New Note',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
