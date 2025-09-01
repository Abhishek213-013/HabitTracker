import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Sample data (replace later with Firestore habit completion history)
  final List<int> weeklyData = [1, 0, 1, 1, 0, 1, 1]; // 1 = completed, 0 = missed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Progress & Streaks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MY Weekly Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Chart for last 7 days
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1.2,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ["S", "S", "M", "T", "W", "T", "F"];
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: List.generate(weeklyData.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weeklyData[index].toDouble(),
                          color: weeklyData[index] == 1
                              ? Colors.blue
                              : Colors.redAccent,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Current Streak",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.blue.shade50,
              child: ListTile(
                leading: const Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 40),
                title: const Text(
                  "🔥🤯 5 Days",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Keep going! You're a superstar 😎💪"),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Upcoming Goals",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.check_circle_outline, color: Colors.teal),
                    title: Text("Drink 8 glasses of water"),
                    subtitle: Text("Goal: Daily"),
                  ),
                  ListTile(
                    leading: Icon(Icons.book_outlined, color: Colors.deepPurple),
                    title: Text("Read 20 pages"),
                    subtitle: Text("Goal: Daily"),
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center, color: Colors.red),
                    title: Text("Workout 3 times a week"),
                    subtitle: Text("Goal: Weekly"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}