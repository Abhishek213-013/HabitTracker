import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit_model.dart';
import '../../providers/habit_provider.dart';
import 'habit_calendar_tab.dart';
import 'habit_statistics_tab.dart';

class HabitDetailScreen extends StatefulWidget {
  final HabitModel habit;

  const HabitDetailScreen({Key? key, required this.habit}) : super(key: key);

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today)),
            Tab(icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HabitCalendarTab(habit: widget.habit),
          HabitStatisticsTab(habit: widget.habit),
        ],
      ),
    );
  }
}