import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'apply_screen.dart';

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

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('companies')
                  .doc(jobOffer['companyId'])
                  .get(),
              builder: (context, companySnapshot) {
                if (companySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SizedBox.shrink();
                }

                if (companySnapshot.hasError) {
                  return SizedBox.shrink();
                }

                final companyData =
                    companySnapshot.data?.data() as Map<String, dynamic>?;
                final companyLogo =
                    companyData?['profileImage'] as String? ?? '';

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
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ApplyScreen.screenRoute,
                        arguments: {
                          'jobOffer': jobOffer,
                          'jobId': jobOffer['id'] as String? ?? '',
                          'companyId': jobOffer['companyId'] as String? ?? '',
                        },
                      );
                    },
                    child: Column(
                      children: [
                        // Company logo here
                        companyLogo.isNotEmpty
                            ? Image.network(
                                companyLogo,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : SizedBox.shrink(),
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
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
