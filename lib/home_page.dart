import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendance_tab.dart';
import 'manage_subjects_tab.dart';
import 'subject_modal.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List of subjects
  List<Subject> subjects = [];

  // Controller for the subject name input
  final TextEditingController _subjectController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // SharedPreferences key for saving subjects
  static const String _subjectsKey = 'subjects';

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  // Load subjects from SharedPreferences
  Future<void> _loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getString(_subjectsKey);
    if (subjectsJson != null) {
      try {
        final List<dynamic> subjectsList = jsonDecode(subjectsJson);
        setState(() {
          subjects = subjectsList.map((json) => Subject.fromJson(json)).toList();
        });
      } catch (e) {
        // Handle JSON parsing errors by keeping the default empty list
        print('Error loading subjects: $e');
      }
    } else {
      // Initialize with default subjects if no saved data
      setState(() {
        subjects = [
          Subject(name: "Mathematics"),
          Subject(name: "Physics"),
          Subject(name: "Chemistry"),
        ];
      });
      _saveSubjects();
    }
  }

  // Save subjects to SharedPreferences
  Future<void> _saveSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = jsonEncode(subjects.map((s) => s.toJson()).toList());
    await prefs.setString(_subjectsKey, subjectsJson);
  }

  // Function to update subject data
  void updateSubject(int index, Subject updated) {
    setState(() {
      subjects[index] = updated;
    });
    _saveSubjects();
  }

  // Function to add a new subject
  void addSubject() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        subjects.add(Subject(
          name: _subjectController.text.trim(),
        ));
        _subjectController.clear();
      });
      _saveSubjects();
    }
  }

  // Function to delete a subject
  void deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
    _saveSubjects();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          toolbarHeight: 20,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Attendance'),
              Tab(text: 'Manage Subjects'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Attendance Tab
            AttendanceTab(
              subjects: subjects,
              updateSubject: updateSubject,
            ),
            // Manage Subjects Tab
            ManageSubjectsTab(
              subjects: subjects,
              formKey: _formKey,
              subjectController: _subjectController,
              addSubject: addSubject,
              deleteSubject: deleteSubject,
            ),
          ],
        ),
      ),
    );
  }
}