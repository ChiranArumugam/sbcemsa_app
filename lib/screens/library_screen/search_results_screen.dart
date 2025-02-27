// lib/screens/library_screen/search_results_screen.dart

import 'package:flutter/material.dart';
import '../../models/pdf_document.dart';
import '../../models/search_result.dart';
import 'pdf_viewer_screen.dart';
import 'widgets/search_result_card.dart';
import 'widgets/filter_button.dart'; // Import the FilterButton widget
import '../../UI/colors.dart';
import 'package:provider/provider.dart';
import '../../view_models/library_view_model.dart';


class SearchResultsScreen extends StatefulWidget {
  final String query;
  final List<Map<String, dynamic>> searchResults;

  SearchResultsScreen({required this.query, required this.searchResults});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  // Variables to hold selected filters
  String? selectedCategory;
  String? selectedSubcategory;

  // Variables to hold filtered results
  List<Map<String, dynamic>> filteredResults = [];

  @override
  void initState() {
    super.initState();
    // Initialize filteredResults with all searchResults initially
    filteredResults = widget.searchResults;
  }

  // Method to open PDF viewer screen
  void _openPdf(BuildContext context, Map<String, dynamic> result, String query) {
    //print("made it to open pdf");
    PdfDocClass pdf = PdfDocClass(filePath: result['filePath'], pdfName: result['pdfName'], category: result['category'], subcategory: result['subcategory'], version: result['version'], fileDriveId: result['fileDriveID'] ?? null );
    Navigator.push(
      context,
      MaterialPageRoute(
        
        builder: (_) => PdfViewerScreen(
          pdf: pdf,
          initialPage: result['pageNumber'],
          query: query
        ),
      ),
    );
    //if(selectedCategory != null && selectedSubcategory != null) {
      //print("error");
      final libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
      //print('LibraryViewModel accessed: $libraryViewModel');

      // Add to recently viewed
      libraryViewModel.addRecentlyViewed(PdfDocClass(filePath: result['filePath'], pdfName: result['pdfName'], category: result['category'], subcategory: result['subcategory']));
    //}
  }

  // Method to apply filters based on selectedCategory and selectedSubcategory
  void _applyFilter(String? category, String? subcategory) {
    setState(() {
      selectedCategory = category;
      selectedSubcategory = subcategory;
      filteredResults = widget.searchResults.where((result) {
        bool matchesCategory = selectedCategory == null ||
            result['category'] == selectedCategory;
        bool matchesSubcategory = selectedSubcategory == null ||
            result['subcategory'] == selectedSubcategory;
        return matchesCategory && matchesSubcategory;
      }).toList();
    });
  }

  // Method to reset all filters
  void _resetFilter() {
    setState(() {
      selectedCategory = null;
      selectedSubcategory = null;
      filteredResults = widget.searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract unique categories and subcategories from searchResults
    final categories = widget.searchResults
        .map((result) => result['category'] as String)
        .toSet()
        .toList();
    final subcategories = widget.searchResults
        .map((result) => result['subcategory'] as String)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result(s) for "${widget.query}"'),
        backgroundColor: AppColors.background, // Updated AppBar color
        iconTheme: IconThemeData(color: AppColors.primary), // Icon color in AppBar
        titleTextStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ), // Title text style
      ),
      backgroundColor: AppColors.background, // Scaffold background color
      body: widget.searchResults.isEmpty
          ? Center(
              child: Text(
                'No results found.',
                style: TextStyle(
                  fontSize: 18.0,
                  color: AppColors.primary,
                ),
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
                children: [
                  // Header with the number of results
                  Text(
                    '${filteredResults.length} results found for "${widget.query}"',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Filter Button (left-aligned and smaller)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilterButton(
                      categories: categories,
                      subcategories: subcategories,
                      selectedCategory: selectedCategory,
                      selectedSubcategory: selectedSubcategory,
                      onApplyFilters: _applyFilter,
                      onResetFilters: _resetFilter,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Expanded ListView to display search results
                  Expanded(
                    child: filteredResults.isEmpty
                        ? Center(
                            child: Text(
                              'No results match the selected filters.',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredResults.length,
                            itemBuilder: (context, index) {
                              final result = filteredResults[index];
                              return SearchResultCard(
                                pdfName: result['pdfName'],
                                filePath: result['filePath'],
                                category: result['category'],
                                subcategory: result['subcategory'],
                                pageNumber: result['pageNumber'],
                                snippet: result['content'],
                                version: result['version'],
                                fileDriveId: result['fileDriveID'],
                                query: widget.query,
                                onTap: () => _openPdf(context, result, widget.query),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
