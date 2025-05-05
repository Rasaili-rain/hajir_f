import 'package:flutter/material.dart';
import 'subject_modal.dart';

class ManageSubjectsTab extends StatelessWidget {
  final List<Subject> subjects;
  final GlobalKey<FormState> formKey;
  final TextEditingController subjectController;
  final VoidCallback addSubject;
  final Function(int) deleteSubject;

  const ManageSubjectsTab({
    super.key,
    required this.subjects,
    required this.formKey,
    required this.subjectController,
    required this.addSubject,
    required this.deleteSubject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Form to add new subject
          Form(
            key: formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a subject name';
                      }
                      if (subjects.any((s) => s.name.toLowerCase() == value.trim().toLowerCase())) {
                        return 'Subject already exists';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addSubject,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // List of subjects with delete option
          Expanded(
            child: subjects.isEmpty
                ? const Center(child: Text('No subjects to manage.'))
                : ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(subjects[index].name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteSubject(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}