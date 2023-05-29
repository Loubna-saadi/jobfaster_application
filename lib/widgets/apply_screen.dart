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

  void submitApplication(
    String userId,
    String userName,
    String userProfileImage,
    String userCVFile,
  ) async {
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

      await FirebaseFirestore.instance
          .collection('applications')
          .add(applicationData);
      print('Application submitted successfully!');
    } catch (error) {
      print('Failed to submit application: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;
    final userCollection = FirebaseFirestore.instance.collection('test');
    final title = jobOffer['jobTitle'] as String? ?? '';
    final city = jobOffer['city'] as String? ?? '';
    final salary = jobOffer['salary']?.toString() ?? '';
    final description = jobOffer['description'] as String? ?? '';
    final requirement = jobOffer['requirement'] as String? ?? '';

    print('userId: $userId');

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 139, 124, 247),
                Color(0xFF1BAFAF),
              ],
            ),
          ),
        ),
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
              onPressed: () async {
                if (userId != null) {
                  final userDoc = await userCollection.doc(userId).get();
                  if (userDoc.exists) {
                    final userData =
                        userDoc.data() as Map<String, dynamic>?;
                    final userName = userData?['name'] as String?;
                    final userProfileImage =
                        userData?['profileImage'] as String?;
                    if (userName != null && userProfileImage != null) {
                      submitApplication(
                          userId, userName, userProfileImage, 'cvFileUrl');
                    } else {
                      print('User information not available');
                    }
                  } else {
                    print('User document not found');
                  }
                } else {
                  print('User ID not available');
                }
              },
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
