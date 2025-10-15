import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SermonProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _sermons = [];
  String _searchQuery = '';
  String _sortBy = 'date';
  bool _hasError = false;
  String _errorMessage = '';
  bool _isInitialized = false;
  
  // PWA Install Prompt Properties
  bool _showInstallPrompt = false;
  int _appUsageCount = 0;
  bool _hasSeenInstallPrompt = false;

  List<Map<String, dynamic>> get filteredSermons {
    var filtered = _sermons.where((sermon) {
      if (_searchQuery.isEmpty) return true;
      
      final query = _searchQuery.toLowerCase();
      final title = sermon['title']?.toString().toLowerCase() ?? '';
      final preacher = sermon['preacher']?.toString().toLowerCase() ?? '';
      final date = sermon['date']?.toString().toLowerCase() ?? '';
      
      return title.contains(query) || 
             preacher.contains(query) ||
             date.contains(query);
    }).toList();

    filtered.sort((a, b) {
      if (_sortBy == 'date') {
        try {
          final dateA = _parseDate(a['date'] ?? '');
          final dateB = _parseDate(b['date'] ?? '');
          return dateB.compareTo(dateA);
        } catch (e) {
          final dateA = a['date'] ?? '';
          final dateB = b['date'] ?? '';
          return dateB.compareTo(dateA);
        }
      } else {
        final titleA = a['title']?.toString().toLowerCase() ?? '';
        final titleB = b['title']?.toString().toLowerCase() ?? '';
        return titleA.compareTo(titleB);
      }
    });

    return filtered;
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateFormat('dd MMM yyyy').parse(dateString);
    } catch (e) {
      try {
        return DateFormat('MMM dd yyyy').parse(dateString);
      } catch (e) {
        return DateTime.parse(dateString);
      }
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  String get sortBy => _sortBy;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  
  // PWA Install Prompt Getters
  bool get showInstallPrompt => _showInstallPrompt;
  int get appUsageCount => _appUsageCount;
  bool get hasSeenInstallPrompt => _hasSeenInstallPrompt;

  Stream<List<Map<String, dynamic>>> getSermonsStream() {
    return _firestore
        .collection('sermons')
        .snapshots()
        .handleError((error) {
          _hasError = true;
          _errorMessage = 'Firestore error: $error';
          notifyListeners();
        })
        .map((snapshot) {
          _hasError = false;
          _errorMessage = '';
          return snapshot.docs
              .map((doc) {
                final data = doc.data();
                return {...data, 'id': doc.id};
              })
              .toList();
        });
  }

  void updateSermons(List<Map<String, dynamic>> sermons) {
    _sermons = sermons;
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      // Pre-load some initial data or perform any setup needed
      // This runs in background while splash screen is visible
      
      // You can pre-fetch initial sermons or perform any other initialization
      // For example, load the first batch of sermons
      final initialQuery = await _firestore
          .collection('sermons')
          .orderBy('date', descending: true)
          .limit(10)
          .get();
      
      _sermons = initialQuery.docs
          .map((doc) {
            final data = doc.data();
            return {...data, 'id': doc.id};
          })
          .toList();
      
      _isInitialized = true;
      notifyListeners();
      
    } catch (e) {
      // If initialization fails, still mark as initialized to allow app to proceed
      _isInitialized = true;
      _hasError = true;
      _errorMessage = 'Initialization error: $e';
      notifyListeners();
    }
  }

  // PWA Install Prompt Methods
  
  /// Increments app usage counter and shows install prompt after 3 uses
  void incrementAppUsage() {
    _appUsageCount++;
    
    // Show install prompt after user has used the app 3 times
    // AND hasn't seen the prompt before
    // AND the prompt isn't already showing
    if (_appUsageCount >= 3 && !_hasSeenInstallPrompt && !_showInstallPrompt) {
      _showInstallPrompt = true;
      notifyListeners();
    }
  }
  
  /// Hides the install prompt and marks it as seen
  void hideInstallPrompt() {
    _showInstallPrompt = false;
    _hasSeenInstallPrompt = true;
    notifyListeners();
  }
  
  /// Resets the install prompt (for testing or if you want to show it again)
  void resetInstallPrompt() {
    _showInstallPrompt = false;
    _hasSeenInstallPrompt = false;
    _appUsageCount = 0;
    notifyListeners();
  }
  
  /// Force show the install prompt (for manual trigger from settings)
  void showInstallPromptManually() {
    _showInstallPrompt = true;
    notifyListeners();
  }
}