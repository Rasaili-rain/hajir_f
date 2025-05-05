import 'package:flutter/material.dart';
import 'progress_bar.dart';
import 'subject_modal.dart';

class AttendanceTab extends StatelessWidget {
  final List<Subject> subjects;
  final Function(int, Subject) updateSubject;

  const AttendanceTab({
    super.key,
    required this.subjects,
    required this.updateSubject,
  });

  @override
  Widget build(BuildContext context) {
    return subjects.isEmpty
        ? const Center(child: Text('No subjects added yet.'))
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              return ProgressBar(
                subject: subjects[index],
                index: index,
                updateSubject: updateSubject,
              );
            },
          );
  }
}