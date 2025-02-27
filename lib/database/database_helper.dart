// lib/database/database_helper.dart

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern to ensure only one instance of DatabaseHelper exists
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Updated database version to 2 to handle new tables (Notes)
  static const int _databaseVersion = 2;

  /// Getter for the database. Initializes the database if it's not already initialized.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the SQLite database.
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'pdf_search.db');

    // Open the database, creating it if it doesn't exist, and handle upgrades
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Called when the database is created for the first time.
  Future<void> _onCreate(Database db, int version) async {
    // Create PDFs table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PDFs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pdfName TEXT NOT NULL,
        filePath TEXT NOT NULL,
        category TEXT NOT NULL,
        subcategory TEXT NOT NULL,
        version TEXT NOT NULL,
        fileDriveID TEXT
      )
    ''');

    // Create PDFText virtual table using FTS4 for full-text search (FTS5 compatibility issues)
    await db.execute('''
      CREATE VIRTUAL TABLE IF NOT EXISTS PDFText USING fts4(
        pdfId,
        pageNumber,
        content
      )
    ''');

    // Create Notes table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');
  }

  /// Called when the database needs to be upgraded.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create Notes table if it doesn't exist (for existing installations upgrading to version 2)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          content TEXT NOT NULL
        )
      ''');
    }
    // Future upgrades can be handled here
  }

  // ---------------- PDF Related Methods ----------------

  /// Inserts or updates a PDF record in the PDFs table.
  Future<int> upsertPDF(Map<String, dynamic> pdf) async {
    try {
      Database db = await database;

      // Check if the PDF exists by pdfName or fileDriveID
      final existingPdf = await db.query(
        'PDFs',
        where: 'pdfName = ? OR fileDriveID = ?',
        whereArgs: [pdf['pdfName'], pdf['fileDriveID']],
      );

      if (existingPdf.isNotEmpty) {
        // Update the existing record
        return await db.update(
          'PDFs',
          pdf,
          where: 'id = ?',
          whereArgs: [existingPdf.first['id']],
        );
      } else {
        // Insert as a new record
        return await db.insert('PDFs', pdf);
      }
    } catch (e) {
      print('Error upserting PDF: $e');
      rethrow; // Propagate the error after logging
    }
  }

  /// Inserts a PDF record into the PDFs table.
  Future<int> insertPDF(Map<String, dynamic> pdf) async {
    try {
      Database db = await database;
      return await db.insert('PDFs', pdf);
    } catch (e) {
      print('Error inserting PDF: $e');
      rethrow; // Propagate the error after logging
    }
  }

  /// Inserts extracted PDF text into the PDFText virtual table.
  Future<void> insertPDFText(Map<String, dynamic> pdfText) async {
    try {
      Database db = await database;
      await db.insert('PDFText', pdfText);
    } catch (e) {
      print('Error inserting PDFText: $e');
      rethrow;
    }
  }
  
  Future<List<Map<String, dynamic>>> searchPdfs(String query) async {
    try {
      Database db = await database;
      final results = await db.rawQuery('''
        SELECT 
          PDFs.id AS pdfId, 
          PDFs.pdfName, 
          PDFs.filePath, 
          PDFs.category, 
          PDFs.subcategory,
          PDFs.version,
          PDFs.fileDriveID, 
          PDFText.pageNumber, 
          PDFText.content
        FROM PDFText
        JOIN PDFs ON PDFText.pdfId = PDFs.id
        WHERE PDFText MATCH ?
      ''', ["$query*"]);
      return results;
    } catch (e) {
      print('Error searching PDFs: $e');
      return []; // Return empty list on error
    }
  }


  /// Checks if the PDFs table is empty.
  Future<bool> isDatabaseEmpty() async {
    try {
      Database db = await database;
      var res = await db.rawQuery('SELECT COUNT(*) as count FROM PDFs');
      int? count = Sqflite.firstIntValue(res);
      return (count ?? 0) == 0;
    } catch (e) {
      print('Error checking if database is empty: $e');
      return true; // Assume empty if there's an error
    }
  }

  // ---------------- Notes Related Methods ----------------

  /// Inserts a new note into the Notes table.
  Future<int> insertNote(Map<String, dynamic> note) async {
    try {
      Database db = await database;
      return await db.insert('Notes', note);
    } catch (e) {
      print('Error inserting Note: $e');
      rethrow;
    }
  }

  /// Retrieves all notes from the Notes table.
  Future<List<Map<String, dynamic>>> getNotes() async {
    try {
      Database db = await database;
      return await db.query(
        'Notes',
        orderBy: 'id DESC', // Order by latest first
      );
    } catch (e) {
      print('Error retrieving Notes: $e');
      return [];
    }
  }

  /// Deletes a note from the Notes table by its id.
  Future<int> deleteNote(int id) async {
    try {
      Database db = await database;
      return await db.delete(
        'Notes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting Note: $e');
      return 0;
    }
  }

  /// Updates an existing note in the Notes table.
  Future<int> updateNote(Map<String, dynamic> note) async {
    try {
      if (!note.containsKey('id')) {
        throw Exception('Note ID is missing');
      }
      Database db = await database;
      return await db.update(
        'Notes',
        note,
        where: 'id = ?',
        whereArgs: [note['id']],
      );
    } catch (e) {
      print('Error updating Note: $e');
      return 0;
    }
  }

  /// Checks if the Notes table is empty.
  Future<bool> isNotesEmpty() async {
    try {
      Database db = await database;
      var res = await db.rawQuery('SELECT COUNT(*) as count FROM Notes');
      int? count = Sqflite.firstIntValue(res);
      return (count ?? 0) == 0;
    } catch (e) {
      print('Error checking if Notes table is empty: $e');
      return true; // Assume empty if there's an error
    }
  }

  /// Searches notes by name or content.
  Future<List<Map<String, dynamic>>> searchNotes(String query) async {
    try {
      Database db = await database;
      return await db.query(
        'Notes',
        where: 'name LIKE ? OR content LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'id DESC',
      );
    } catch (e) {
      print('Error searching Notes: $e');
      return [];
    }
  }

  // ---------------- Utility Methods ----------------

  /// Closes the database connection.
  Future<void> close() async {
    try {
      Database db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      print('Error closing database: $e');
    }
  }
}
