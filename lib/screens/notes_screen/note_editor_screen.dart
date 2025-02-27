// lib/screens/notes_screen/note_editor_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/library_view_model.dart';
import '../../models/note.dart';
import '../../UI/colors.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // If null, we are creating a new note; if not null, editing

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _content = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      // Populate controllers with existing note data
      _nameController.text = widget.note!.name;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    _nameFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final libraryVM = Provider.of<LibraryViewModel>(context, listen: false);

      if (isEditing) {
        // Update existing note
        Note updatedNote = Note(
          id: widget.note!.id,
          name: _name,
          content: _content,
        );
        libraryVM.updateNote(updatedNote);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note "$_name" updated')),
        );
      } else {
        // Create new note
        libraryVM.addNote(_name, _content);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note "$_name" added')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double maxContentHeight = screenHeight * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Note' : 'New Note',
          style: TextStyle(color: AppColors.primary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Done',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a note title';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!.trim(),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                  height: 1,
                ),
                SizedBox(height: 8.0),
                // Content Field
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 100.0,
                      maxHeight: maxContentHeight,
                    ),
                    child: SingleChildScrollView(
                      child: TextFormField(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                        decoration: InputDecoration(
                          hintText: isEditing
                              ? 'Edit your note...'
                              : 'Start typing your note...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                        style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                        onSaved: (value) => _content = value!.trim(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
