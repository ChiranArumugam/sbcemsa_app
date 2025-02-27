import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For persistence
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../database/database_helper.dart';
import '../models/pdf_document.dart';
import '../models/pdf_library.dart';
import '../models/category.dart';
import '../models/note.dart'; // Import the Note model
import 'package:http/http.dart' as http;
import 'notes_manager.dart';
import 'favorites_manager.dart';
import 'recently_viewed_manager.dart';
import 'pdf_manager.dart';

class LibraryViewModel extends ChangeNotifier with WidgetsBindingObserver {
  // ---------------------- Initialization ----------------------
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PdfManager _pdfManager = PdfManager();
  PdfLibrary? pdfLibrary;
  bool _isInitialized = false;
  double _initializationProgress = 0.0; // For initialization progress
  double get initializationProgress => _initializationProgress;

  // ---------------------- Updates ----------------------
  bool _isCheckingUpdates = false;
  bool _showNotification = false;
  double _updateProgress = 0.0; // For update progress
  String _notificationMessage = "";
  bool get showNotification => _showNotification;
  double get updateProgress => _updateProgress;
  String get notificationMessage => _notificationMessage;
  // Notification state
  bool _hasUnreadNotifications = false;
  List<Map<String, String>> _updatedPdfs = []; // List of updated PDFs with name and version
  bool get hasUnreadNotifications => _hasUnreadNotifications;
  List<Map<String, String>> get updatedPdfs => List.unmodifiable(_updatedPdfs);


  // ---------------------- Favorites & Recently Viewed ----------------------
  final FavoritesManager _favoritesManager = FavoritesManager();
  final RecentlyViewedManager _recentlyViewedManager = RecentlyViewedManager();
  List<PdfDocClass> get favorites => _favoritesManager.favorites;
  List<PdfDocClass> get recentlyViewed => _recentlyViewedManager.recentlyViewed;

  // ---------------------- Notes ----------------------
  final NotesManager _notesManager = NotesManager();
  List<Note> get notes => _notesManager.notes;

  // ---------------------- Constructor ----------------------
  LibraryViewModel();

  // ---------------------- Lifecycle ----------------------
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_isCheckingUpdates) {
      _isCheckingUpdates = true;
      _pdfManager
          .checkForUpdatesWithViewModel(
            onUpdateStart: () => _showUpdateNotification("Checking for updated PDFs..."),
            onUpdateProgress: (progress) => _updateUpdateProgress(progress),
            onUpdateEnd: () {
              _hideUpdateNotification();
              _isCheckingUpdates = false;
            },
            libraryViewModel: this,
          )
          .then((_) => _isCheckingUpdates = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dbHelper.close(); // Close the database when disposing the ViewModel
    super.dispose();
  }

  // ---------------------- Initialization ----------------------
  Future<void> initialize() async {
    const int totalSteps = 6;
    int currentStep = 0;

    try {
      WidgetsBinding.instance.addObserver(this);

      final prefs = await SharedPreferences.getInstance();
      final isInitialLoadDone = prefs.getBool('isInitialLoadDone') ?? false;

      final directory = await getApplicationDocumentsDirectory();
      final localJsonPath = '${directory.path}/pdf_library_local.json';

      if (!isInitialLoadDone) {
        await _pdfManager.loadBaselineJsonAndSave(localJsonPath);
        await prefs.setBool('isInitialLoadDone', true);
      } else {
        await _pdfManager.loadPdfLibrary(localJsonPath);
      }

      _isInitialized = true;
      notifyListeners();

      currentStep++;
      _updateInitializationProgress(currentStep, totalSteps);

      if (_pdfManager.pdfLibrary != null) {
        await _pdfManager.initializeDatabase(getAllPdfs(_pdfManager.pdfLibrary!.getAllCategories()));
      }
      currentStep++;
      _updateInitializationProgress(currentStep, totalSteps);

      await loadFavorites(_pdfManager.pdfLibrary!);
      currentStep++;
      _updateInitializationProgress(currentStep, totalSteps);

      await loadRecentlyViewed(_pdfManager.pdfLibrary!);
      currentStep++;
      _updateInitializationProgress(currentStep, totalSteps);

      await loadNotes();
      currentStep++;
      _updateInitializationProgress(currentStep, totalSteps);

      _pdfManager.checkForUpdatesWithViewModel(
        onUpdateStart: () => _showUpdateNotification("Updating PDFs..."),
        onUpdateProgress: (progress) => _updateUpdateProgress(progress),
        onUpdateEnd: () {
          _hideUpdateNotification();
          _isCheckingUpdates = false;
        },
        libraryViewModel: this,
      );
      currentStep++;
      _updateInitializationProgress(currentStep, totalSteps);
    } catch (e, stackTrace) {
      print('Initialization Error: $e');
      print(stackTrace);
    }
  }

  void _updateInitializationProgress(int currentStep, int totalSteps) {
    _initializationProgress = currentStep / totalSteps;
    notifyListeners();
  }

  // ---------------------- Updates ----------------------
  void _showUpdateNotification(String message) {
    _notificationMessage = message;
    _showNotification = true;
    notifyListeners();
  }

  void _updateUpdateProgress(double progress) {
    _updateProgress = progress;
    notifyListeners();
  }

  Future<void> _hideUpdateNotification() async {
    //await Future.delayed(Duration(milliseconds: 200));
    _showNotification = false;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 200));
    _updateProgress = 0.0;
    _notificationMessage = "";
    notifyListeners();
  }
  
  Future<void> markNotificationsAsRead() async {
    _hasUnreadNotifications = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasUnreadNotifications', false);
  }

  Future<void> addUpdatedPdfs(List<Map<String, String>> pdfs) async {
    _updatedPdfs.addAll(pdfs);
    _hasUnreadNotifications = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasUnreadNotifications', true);
    prefs.setString('updatedPdfs', jsonEncode(_updatedPdfs));
  }

  Future<void> loadNotificationState() async {
    final prefs = await SharedPreferences.getInstance();
    _hasUnreadNotifications = prefs.getBool('hasUnreadNotifications') ?? false;
    final storedPdfs = prefs.getString('updatedPdfs');
    if (storedPdfs != null) {
      _updatedPdfs = List<Map<String, String>>.from(jsonDecode(storedPdfs));
    }
    notifyListeners();
  }

  // ---------------------- PDF Management ----------------------
  Future<void> _loadPdfLibrary(String jsonPath) async {
    await _pdfManager.loadPdfLibrary(jsonPath);
  }

  List<PdfDocClass> getAllPdfs(List<Category> categories) {
    return _pdfManager.getAllPdfs(categories);
  }

  Future<List<Map<String, dynamic>>> searchPdfs(String query) async {
    return _pdfManager.searchPdfs(query);
  }

  List<Category> getCategories() {
    return _pdfManager.pdfLibrary?.getAllCategories() ?? [];
  }

  // ---------------------- Favorites ----------------------
  void toggleFavorite(PdfDocClass pdf) {
    _favoritesManager.toggleFavorite(pdf);
    notifyListeners();
  }

  Future<void> loadFavorites(PdfLibrary pdfLibrary) async {
    await _favoritesManager.loadFavorites(pdfLibrary);
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    await _favoritesManager.saveFavorites();
    notifyListeners();
  }

  // ---------------------- Recently Viewed ----------------------
  void addRecentlyViewed(PdfDocClass pdf) {
    _recentlyViewedManager.addRecentlyViewed(pdf);
    notifyListeners();
  }

  Future<void> loadRecentlyViewed(PdfLibrary pdfLibrary) async {
    await _recentlyViewedManager.loadRecentlyViewed(pdfLibrary);
    notifyListeners();
  }

  Future<void> saveRecentlyViewed() async {
    await _recentlyViewedManager.saveRecentlyViewed();
    notifyListeners();
  }

  // ---------------------- Notes ----------------------
  Future<void> addNote(String name, String content) async {
    await _notesManager.addNote(name, content);
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await _notesManager.deleteNote(id);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await _notesManager.updateNote(note);
    notifyListeners();
  }

  Future<void> loadNotes() async {
    await _notesManager.loadNotes();
    notifyListeners();
  }

  Future<List<Note>> searchNotes(String query) async {
    return await _notesManager.searchNotes(query);
  }

  bool get isNotesEmpty => _notesManager.isNotesEmpty;
}
