import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobOfferScreen extends StatefulWidget {
  static const String screenRoute = 'Joboffer_screen';

  const JobOfferScreen({Key? key}) : super(key: key);

  @override
  _JobOfferScreenState createState() => _JobOfferScreenState();
}

class _JobOfferScreenState extends State<JobOfferScreen> {
  final _jobTitleController = TextEditingController();
  final _cityController = TextEditingController();
  final _salaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementController = TextEditingController();

  void submitJobOffer() {
    final jobTitle = _jobTitleController.text;
    final city = _cityController.text;
    final salary = double.parse(_salaryController.text);
    final description = _descriptionController.text;
    final requirement = _requirementController.text;

    addJobOffer(jobTitle, city, salary, description, requirement);
  }

  Future<void> addJobOffer(
    String jobTitle,
    String city,
    double salary,
    String description,
    String requirement,
  ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final companyId = currentUser?.uid;

      final jobOfferData = {
        'jobTitle': jobTitle,
        'city': city,
        'salary': salary,
        'description': description,
        'requirement': requirement,
        'companyId': companyId,
      };

      await FirebaseFirestore.instance.collection('jobs').add(jobOfferData);
      print('Job offer added successfully!');
    } catch (error) {
      print('Failed to add job offer: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Offer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _jobTitleController,
              decoration: InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _salaryController,
              decoration: InputDecoration(labelText: 'Salary'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _requirementController,
              decoration: InputDecoration(labelText: 'Requirement'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitJobOffer,
              child: Text('Submit'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .where('companyId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final jobOffers = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: jobOffers.length,
                    itemBuilder: (context, index) {
                      final jobOffer = jobOffers[index].data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          title: Text(jobOffer['jobTitle']),
                          subtitle: Text(jobOffer['city']),
                          trailing: Text(jobOffer['salary'].toString()),
                          onTap: () {
                            // Handle job offer details
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
