import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('test').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final employees = snapshot.data!.docs;

        return ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index].data() as Map<String, dynamic>;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        child: Container(
                           decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 139, 124, 247), Color(0xFF1BAFAF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
                          width: MediaQuery.of(context).size.width * 1,
                          height: 220,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.grey.shade800,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 220,
                                  child: Image.network(
                                    employee['profileImage'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              '${employee['name']} ${employee['familyName']},'),
                                         
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      Row(
                                        children: [
                                          Text(
                                            '${employee['specialty']} '),
                                          
                                         
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                         Row(
                                        children: [
                                        
                                          Text('city:''${employee['city']}'),
                                        ],
                                      ),
                                     
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
