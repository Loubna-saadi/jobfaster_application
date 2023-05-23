import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final jobOffers = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: jobOffers.length,
          itemBuilder: (context, index) {
            final jobOffer = jobOffers[index].data() as Map<String, dynamic>;

            final title = jobOffer['jobTitle'] as String? ?? '';
            final city = jobOffer['city'] as String? ?? '';
            final salary = jobOffer['salary']?.toString() ?? '';
            final description = jobOffer['description'] as String? ?? '';
            final requirement = jobOffer['requirement'] as String? ?? '';

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  // Company logo here
                  Image.network(
                    jobOffer['companyLogo'] as String? ??
                        '', // Replace with your company logo field
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
