import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
              final jobId = application['jobOfferId'] as String?;
              final userProfileImage = application['userProfileImage'] as String?;
              final userName = application['userName'] as String?;
              final applicationDate = application['applicationDate'] as Timestamp?;

              if (jobId == null || jobId.isEmpty) {
                return ListTile(
                  title: Text('Job data missing'),
                );
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('test').doc(userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return Text('Loading user CV...');
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>?;
                  final userCVFile = userData?['cvFile'] as String?;

                  return Card(
                    child: ListTile(
                      leading: userProfileImage != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(userProfileImage),
                            )
                          : Icon(Icons.person),
                      title: Text(userName ?? 'N/A'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (userCVFile != null) {
                            downloadCV(userCVFile);
                          }
                        },
                        child: Text('Download CV'),
                      ),
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

  // Method to download the CV file
  void downloadCV(String userCVFile) async {
    final taskId = await FlutterDownloader.enqueue(
      url: userCVFile,
      savedDir: 'path/to/save/directory', // Replace with your desired directory path
      fileName: 'cv_file.pdf', // Replace with your desired file name
      showNotification: true,
      openFileFromNotification: true,
    );

    FlutterDownloader.registerCallback((id, status, _) {
      if (id == taskId && status == DownloadTaskStatus.complete) {
        // File has been downloaded successfully
        // You can implement additional logic here, such as showing a success message
      }
    });
  }
}
