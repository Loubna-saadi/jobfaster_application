import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplyScreen extends StatelessWidget {
  static const String screenRoute = 'apply_screen';
  final Map<String, dynamic> jobOffer;
  final String jobId;
  final String companyId;

  ApplyScreen({
    required this.jobOffer,
    required this.jobId,
    required this.companyId,
  });

  void submitApplication(String userId, String userName, String userProfileImage, String userCVFile) async {
    try {
      final applicationData = {
        'userId': userId,
        'jobOfferId': jobId,
        'companyId': companyId,
        'userProfileImage': userProfileImage,
        'userName': userName,
        'userCVFile': userCVFile,
        'applicationDate': DateTime.now(),
      };

      await FirebaseFirestore.instance.collection('applications').add(applicationData);
      print('Application submitted successfully!');
    } catch (error) {
      print('Failed to submit application: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;
    final userName = currentUser?.displayName;
    final userProfileImage = currentUser?.photoURL;

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
                submitApplication(userId!, userName!, userProfileImage!, 'userCVFile');
              },
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
