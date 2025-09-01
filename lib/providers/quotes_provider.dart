import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/firestore_service.dart';

class QuotesProvider extends ChangeNotifier {
  final String userId;
  final FirestoreService _firestoreService = FirestoreService();

  List<QuoteModel> favorites = [];
  List<QuoteModel> categoryQuotes = [];
  List<String> categories = [];
  bool isLoading = false;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  // Local category-based quotes
  final Map<String, List<String>> localQuotes = {
    "Motivation": [
      "Believe in yourself and all that you are.",
      "Small steps in the right direction can turn out to be the biggest step of your life.",
      "Don't wait for opportunity. Create it.",
      "Your only limit is you.",
      "Hard work beats talent when talent doesn’t work hard.",
      "Stay positive, work hard, make it happen.",
      "Success is the sum of small efforts repeated day in and day out.",
      "Dream big. Start small. Act now.",
      "The key to success is to focus on goals, not obstacles.",
      "What you do today can improve all your tomorrows."
    ],
    "Discipline": [
      "Discipline is the silent force behind every success story.",
      "Small consistent actions lead to big results.",
      "The secret to success is staying disciplined even when no one is watching.",
      "Discipline is doing what needs to be done, even when you don’t feel like it.",
      "Focus on progress, not perfection.",
      "Your future is created by what you do today, not tomorrow.",
      "Discipline is the difference between dreams and reality.",
      "Consistency compounds over time.",
      "Strong habits build strong results.",
      "Control your mind, control your life."
    ],
    "Success": [
      "Success is earned, not given.",
      "Great achievements start with a single step.",
      "Success comes to those who persist when others quit.",
      "Dream big, work hard, stay focused.",
      "Your actions today shape your success tomorrow.",
      "Success is the result of preparation meeting opportunity.",
      "Don’t chase success—chase excellence, and success will follow.",
      "The harder you work, the luckier you get.",
      "Success is built on a foundation of failure and learning.",
      "Every small effort counts toward your big goal."
    ],
    "Habits": [
      "Small consistent habits lead to extraordinary results.",
      "Your daily habits shape your destiny.",
      "Greatness is built one habit at a time.",
      "Discipline your mind, and your habits will follow.",
      "Habits are the invisible architecture of your life.",
      "Focus on creating habits, not just goals.",
      "Every action you repeat becomes a part of who you are.",
      "Positive habits compound into positive results.",
      "Change your habits, change your life.",
      "The secret of your future is hidden in your daily routines."
    ],
    "Growth": [
      "Personal growth starts with self-awareness.",
      "To grow, you must embrace discomfort and uncertainty.",
      "Every challenge is an opportunity to grow stronger.",
      "Growth happens when you step outside what’s familiar.",
      "Invest in yourself; your growth is your greatest asset.",
      "The journey of growth is continuous—never stop learning.",
      "Mistakes are lessons that fuel growth.",
      "True growth comes from facing your fears.",
      "Your mindset determines the height of your growth.",
      "Small improvements every day lead to massive growth over time."
    ],
  };

  QuotesProvider({required this.userId}) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadFavorites(),
      loadCategories(),
    ]);
  }

  Future<void> loadCategories() async {
    categories = localQuotes.keys.toList();
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    isLoading = true;
    notifyListeners();

    favorites = await _firestoreService.getFavoriteQuotes(userId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadQuotesByCategory(String category) async {
    isLoading = true;
    _selectedCategory = category;
    notifyListeners();

    if (localQuotes.containsKey(category)) {
      categoryQuotes = localQuotes[category]!
          .asMap()
          .entries
          .map(
            (entry) => QuoteModel(
          id: '${category}_${entry.key}',
          text: entry.value,
          author: category,
          tags: [category],
          isFavorite:
          favorites.any((f) => f.id == '${category}_${entry.key}'),
        ),
      )
          .toList();
    } else {
      categoryQuotes = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(QuoteModel quote) async {
    final updatedQuote = quote.copyWith(isFavorite: !quote.isFavorite);

    if (updatedQuote.isFavorite) {
      await _firestoreService.addFavoriteQuote(userId, updatedQuote);
    } else {
      await _firestoreService.removeFavoriteQuote(userId, updatedQuote);
    }

    await loadFavorites();
  }
}