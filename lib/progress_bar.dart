import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'subject_modal.dart';

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

  Color interpolateColor(double percentage) {
    if (percentage == 100 ) return const Color(0xFF4ECDC4);
    final ratio = (percentage - 1).abs() / 99;
    final r = (139 + (78 - 139) * ratio).round();
    final g = (0 + (205 - 0) * ratio).round();
    final b = (0 + (196 - 0) * ratio).round();
    return Color.fromRGBO(r, g, b, 1.0);
  }

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
    final isWarning = percentage < 85 ;
    final screenWidth = MediaQuery.of(context).size.width;

    final dataMap = <String, double>{
      "Present": percentage,
      "Remaining": 100 - percentage,
    };
    final colorList = [
      interpolateColor(percentage),
      const Color(0xFFDDE1E8),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFFFF5F5) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFFDDE1E8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Container: Description and Buttons
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Description
                  Text(
                    subject.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFF2D3748),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${subject.presentDays}/${subject.totalDays}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Buttons in a horizontal row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildButton(
                        label: 'Undo',
                        color: const Color(0xFF6A0DAD),
                        onPressed: () => handleAction('decrement'),
                      ),
                      const SizedBox(width: 4.0),
                      _buildButton(
                        label: 'Absent',
                        color: const Color(0xFFFF6B6B),
                        onPressed: () => handleAction('absent'),
                      ),
                      const SizedBox(width: 4.0),
                      _buildButton(
                        label: 'Present',
                        color: const Color(0xFF4ECDC4),
                        onPressed: () => handleAction('present'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Right Container: Pie Chart
          SizedBox(
            width: screenWidth * 0.35,
            height: screenWidth * 0.35,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  dataMap: dataMap,
                  colorList: colorList,
                  chartRadius: screenWidth * 0.35,
                  legendOptions: const LegendOptions(showLegends: false),
                  chartValuesOptions: const ChartValuesOptions(showChartValues: false),
                ),
                Text(
                  '${percentage.toInt()}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        minimumSize: const Size(60, 30),
        textStyle: const TextStyle(fontSize: 16),
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