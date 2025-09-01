import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/habit_card.dart';
import 'add_edit_habit_screen.dart';
import 'habit_detail_screen.dart';

class HabitsListScreen extends StatelessWidget {
  const HabitsListScreen({Key? key}) : super(key: key);

  void _navigateToAddHabit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditHabitScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to see your habits")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Habits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddHabit(context),
          ),
        ],
      ),
      body: StreamBuilder<List<HabitModel>>(
        stream: FirestoreService().getHabits(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, size: 48, color: Colors.pink),
                  const SizedBox(height: 16),
                  const Text(
                    "No habits yet🤔",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Start building your life from today😊!",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _navigateToAddHabit(context),
                    child: const Text("Lets start with Your First Habit😊"),
                  ),
                ],
              ),
            );
          }

          final habits = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return HabitCard(habit: habit);
            },
          );
        },
      ),
    );
  }
}