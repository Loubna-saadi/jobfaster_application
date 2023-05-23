import 'package:flutter/material.dart';

class ApplyScreen extends StatelessWidget {
   static const String screenRoute = 'apply_screen';
  final Map<String, dynamic> jobOffer;

  ApplyScreen({required this.jobOffer});

  @override
  Widget build(BuildContext context) {
    final title = jobOffer['jobTitle'] as String? ?? '';
    final city = jobOffer['city'] as String? ?? '';
    final salary = jobOffer['salary']?.toString() ?? '';
    final description = jobOffer['description'] as String? ?? '';
    final requirement = jobOffer['requirement'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'City: $city',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Salary: $salary',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description: $description',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Requirement: $requirement',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add your apply logic here
              },
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
