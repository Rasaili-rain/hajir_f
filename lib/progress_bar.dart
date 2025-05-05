import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

// Data model for a Subject
class Subject {
  String name;
  int presentDays;
  int totalDays;

  Subject({required this.name, this.presentDays = 0, this.totalDays = 0});

  // Convert Subject to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'presentDays': presentDays,
        'totalDays': totalDays,
      };

  // Create Subject from JSON
  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        name: json['name'] as String,
        presentDays: json['presentDays'] as int,
        totalDays: json['totalDays'] as int,
      );
}

class ProgressBar extends StatelessWidget {
  final Subject subject;
  final int index;
  final Function(int, Subject) updateSubject;

  const ProgressBar({
    super.key,
    required this.subject,
    required this.index,
    required this.updateSubject,
  });

  // Interpolate color based on percentage (ported from React Native)
  Color interpolateColor(double percentage) {
    if (percentage == 0 || percentage == 100) {
      return const Color(0xFF4ECDC4); // #4ECDC4
    }
    final ratio = (percentage - 1).abs() / 99;
    final r = (139 + (78 - 139) * ratio).round();
    final g = (0 + (205 - 0) * ratio).round();
    final b = (0 + (196 - 0) * ratio).round();
    return Color.fromRGBO(r, g, b, 1.0);
  }

  // Handle button actions
  void handleAction(String action) {
    Subject updated = Subject(
      name: subject.name,
      presentDays: subject.presentDays,
      totalDays: subject.totalDays,
    );
    switch (action) {
      case 'decrement':
        updated.presentDays = (updated.presentDays - 1).clamp(0, updated.presentDays);
        updated.totalDays = (updated.totalDays - 1).clamp(0, updated.totalDays);
        break;
      case 'absent':
        updated.totalDays += 1;
        break;
      case 'present':
        updated.presentDays += 1;
        updated.totalDays += 1;
        break;
    }
    updateSubject(index, updated);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = subject.totalDays == 0
        ? 100.0
        : ((subject.presentDays / subject.totalDays) * 100).roundToDouble();
    final isWarning = percentage < 85 && percentage != 0;
    final screenWidth = MediaQuery.of(context).size.width;

    // Pie chart data
    final dataMap = <String, double>{
      "Present": percentage,
      "Remaining": 100 - percentage,
    };
    final colorList = [
      interpolateColor(percentage),
      const Color(0xFFDDE1E8), // #DDE1E8
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFFFF5F5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFFDDE1E8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject name and attendance on left, pie chart on right
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Subject name and attendance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFF2D3748),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${subject.presentDays}/${subject.totalDays}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
              // Right: Pie chart
              SizedBox(
                width: screenWidth * 0.3, // 30% of screen width
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      dataMap: dataMap,
                      colorList: colorList,
                      chartRadius: screenWidth * 0.3, // Responsive size
                      legendOptions: const LegendOptions(showLegends: false),
                      chartValuesOptions: const ChartValuesOptions(showChartValues: false),
                    ),
                    Text(
                      '${percentage.toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Buttons at the bottom
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildButton(
                label: 'Undo',
                color: const Color(0xFF6A0DAD), // Purple
                onPressed: () => handleAction('decrement'),
              ),
              _buildButton(
                label: 'Absent',
                color: const Color(0xFFFF6B6B), // Red
                onPressed: () => handleAction('absent'),
              ),
              _buildButton(
                label: 'Present',
                color: const Color(0xFF4ECDC4), // Green
                onPressed: () => handleAction('present'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(70, 36),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}