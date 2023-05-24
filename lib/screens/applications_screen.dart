import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationsScreen extends StatelessWidget {
  static const String screenRoute = 'applications_screen';

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If the user is not logged in, you can handle it accordingly
      // For example, you can show a login screen or redirect the user to the login page
      return Scaffold(
        appBar: AppBar(
          title: Text('Applications'),
        ),
        body: Center(
          child: Text('Please login to view applications.'),
        ),
      );
    }

    final companyId = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Applications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where('companyId', isEqualTo: companyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return Text('No applications found.');
          }

          final applications = snapshot.data!.docs;

          if (applications.isEmpty) {
            return Text('No applications found.');
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              final userId = application['userId'] as String?;
              final userName = application['userName'] as String?;
              final userProfileImage = application['userProfileImage'] as String?;
              final jobId = application['jobId'] as String?;
              final applicationDate = application['applicationDate'] as Timestamp?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('jobs').doc(jobId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return Text('Loading job...');
                  }

                  final jobData = snapshot.data!.data() as Map<String, dynamic>?;
                  final jobTitle = jobData?['jobTitle'] as String?;

                  return Card(
                    child: ListTile(
                      leading: userProfileImage != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(userProfileImage),
                            )
                          : Icon(Icons.person),
                      title: Text(userName ?? 'N/A'),
                      subtitle: Text(jobTitle ?? 'N/A'),
                      trailing: Text(
                        applicationDate != null
                            ? applicationDate.toDate().toString()
                            : 'N/A',
                      ),
                      onTap: () {
                        // Handle the onTap event to download the user's CV
                        // You can implement the logic to download the CV here
                        print('Download CV for application: ${application.id}');
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
