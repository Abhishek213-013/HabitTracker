import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/firestore_service.dart';

class HabitProvider extends ChangeNotifier {
  final String userId;
  final FirestoreService _firestoreService = FirestoreService();

  HabitProvider({required this.userId}) {
    fetchHabits();
  }

  List<HabitModel> _habits = [];
  List<HabitModel> get habits => _habits;

  /// Fetch habits from Firestore and update state
  void fetchHabits() {
    _firestoreService.getHabits(userId).listen((habitList) {
      _habits = habitList;
      notifyListeners();
    });
  }

  /// Add a new habit or update an existing one
  Future<void> addOrUpdateHabit(HabitModel habit) async {
    await _firestoreService.saveHabit(userId, habit);
    // Updates will be reflected automatically via listener
  }

  /// Delete a habit by ID
  Future<void> deleteHabit(String habitId) async {
    await _firestoreService.deleteHabit(userId, habitId);
  }

  /// Toggle completion status of a habit for a specific date
  Future<void> toggleHabitDate(HabitModel habit, DateTime date) async {
    if (habit.completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day)) {
      // Remove date if already completed
      habit.completedDates.removeWhere((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day);
    } else {
      // Add date if not completed
      habit.completedDates.add(date);
    }
    await _firestoreService.saveHabit(userId, habit);
  }

  /// Mark habit as complete for today
  Future<void> toggleHabitCompletion(HabitModel habit) async {
    await toggleHabitDate(habit, DateTime.now());
  }

  /// Get all habits completed within a given week
  List<HabitModel> getHabitsForWeek(DateTime weekStart) {
    return _habits.where((habit) {
      return habit.completedDates.any((date) =>
          date.isAfter(weekStart) &&
          date.isBefore(weekStart.add(const Duration(days: 7))));
    }).toList();
  }

  /// Calculate average completion rate across all habits
  double get overallCompletionRate {
    if (_habits.isEmpty) return 0.0;

    double total = 0.0;
    for (var habit in _habits) {
      total += habit.completionPercentage;
    }
    return total / _habits.length;
  }
}
