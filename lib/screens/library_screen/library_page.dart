// lib/screens/library_screen/library_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../models/pdf_document.dart';
import '../../view_models/library_view_model.dart';
import 'pdf_viewer_screen.dart';
import 'subcategory_screen.dart';
import 'search_results_screen.dart';
import '../../UI/colors.dart'; // Import AppColors
import 'updates_section.dart';
import 'browse_section.dart';
import 'favorites_section.dart';
import 'recently_searched_section.dart'; 
import 'recently_viewed_section.dart';// Import the Recently Searched Section

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Performs a search based on the user's query.
  void _performSearch(String query, LibraryViewModel viewModel) async {
    if (query.trim().isEmpty) return;
    query = query.trim();
    List<Map<String, dynamic>> results = await viewModel.searchPdfs(query);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SearchResultsScreen(query: query, searchResults: results),
      ),
    );
  }


  void _handleRecentlyViewedTap(PdfDocClass pdf, LibraryViewModel viewModel) async {
    // Fetch the PDF document based on the pdfName
    if (pdf != null) {
      //viewModel.addRecentlyViewed(pdf);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(
            pdf: pdf,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF not found.')),
      );
    }
  }

  /// Handles the action when a favorite is tapped.
  void _handleFavoriteTap(int index, LibraryViewModel viewModel) {
    // Retrieve the PdfDocClass object using the index
    if (index >= 0 && index < viewModel.favorites.length) {
      PdfDocClass pdf = viewModel.favorites[index];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(
            pdf: pdf,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid favorite selection.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access LibraryViewModel via Provider
    return Consumer<LibraryViewModel>(
      builder: (context, viewModel, child) {
        final List<Category> categories = viewModel.getCategories();

        // Map favorites to a list of maps containing name and icon
        final List<Map<String, dynamic>> favorites = viewModel.favorites.map((pdf) {
          return {
            'name': pdf.pdfName,
            'icon': 'assets/icons/${pdf.category.toLowerCase()}.png', // Adjust as needed
          };
        }).toList();
        
        //Map recently viewed pdfs
        final List<PdfDocClass> recentlyViewed = viewModel.recentlyViewed;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
                children: [
                  // 1. Search Bar (Top)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (query) => _performSearch(query, viewModel),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),

                  // 2. Updates Section
                  
                  UpdatesSection(
                    onTap: () {
                      // Define action when the Updates card is tapped
                      // For example, navigate to an Updates Details page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Updates Card Clicked')),
                      );
                    },
                  ),

                  SizedBox(height: 24.0),

                  // 3. Favorites Section
                  Text(
                    "Favorites",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: AppColors.primary,
                    ),
                  ),
                  FavoritesSection(
                    favorites: favorites,
                    onFavoriteTap: (index) => _handleFavoriteTap(index, viewModel),
                    isEmpty: favorites.isEmpty, // Pass the empty state
                  ),

                  SizedBox(height: 24.0),

                  // 4. Browse Section
                  Text(
                    "Browse",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: AppColors.primary,
                    ),
                  ),
                  BrowseSection(
                    categories: categories,
                    onCategoryTap: (category) {
                      // Navigate to category-specific page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SubcategoryScreen(category: category),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24.0),
                  
                  // 5. Recently Viewed Section
                  Text(
                    "Recently Viewed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: AppColors.primary,
                    ),
                  ),
                  RecentlyViewedSection(
                    recentlyViewed: recentlyViewed,
                    onPdfTap: (pdf) => _handleRecentlyViewedTap(pdf, viewModel),
                  ),

                  SizedBox(height: 24.0),

                  // 6. Recently Searched Section
                  // Text(
                  //   "Recently Searched",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18.0,
                  //     color: AppColors.primary,
                  //   ),
                  // ),
                  // RecentlySearchedSection(
                  //   recentlySearched: recentlySearched,
                  //   onSearchTap: (query) =>
                  //       _handleRecentSearchTap(query, viewModel),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
