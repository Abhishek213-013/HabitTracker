import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/quotes_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/habit_card.dart';
import 'profile/profile_screen.dart';
import 'progress/progress_screen.dart';
import 'quotes/quotes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  final Color appBarColor = const Color(0xFF2196F3); // Green color for app bar

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.uid ?? '';

    _screens = [
      ChangeNotifierProvider(
        create: (_) => HabitProvider(userId: userId),
        child: Consumer<HabitProvider>(
          builder: (context, habitProvider, child) {
            return Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Howdy👋!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: habitProvider.habits.length,
                      itemBuilder: (context, index) {
                        return HabitCard(habit: habitProvider.habits[index]);
                      },
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_edit_habit');
                },
                backgroundColor: appBarColor,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
      const ProgressScreen(),
      ChangeNotifierProvider(
        create: (_) => QuotesProvider(userId: userId),
        child: const QuotesScreen(),
      ),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: themeProvider.toggleTheme,
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Premium',
                style: TextStyle(color: Colors.amber[200]),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: appBarColor,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface, // Updated line
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_quote),
              label: 'Quotes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}