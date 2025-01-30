
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';




class UserRiderProfilePage extends StatelessWidget {
  final String userId;

  const UserRiderProfilePage({super.key, required this.userId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:   Text('User Profile'.tr,style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        actions: [
          MaterialButton(
            height: 50,
            minWidth: 50,
            color: Colors.blue,
            child:   Text(" Back ".tr,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding:   const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return   const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return   Center(child: Text('No data found'.tr));
              }
              // var userData = snapshot.data
              var userData = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Card(
                          child: Padding(
                            padding:   const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      userData['profilePictureUrl'] ?? 'https://via.placeholder.com/150'),
                                ),
                                  const SizedBox(height: 16),
                                Text(
                                  userData['name'] ?? 'No Name',
                                  style:   const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                  const SizedBox(height: 8),
                                Text(userData['email'] ?? 'No Email'),
                                  const SizedBox(height: 8),
                                Text(userData['phone'] ?? 'No Phone'),
                                  const SizedBox(height: 8),
                                Text('Address: ${userData['address'] ?? 'No Address'}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                        const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Card(
                              child: Padding(
                                padding:   const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                      'Bank Detail'.tr,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                      const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Bank Name'.tr,
                                              hintText: userData['bankName'] ?? 'No Bank Name',
                                            ),
                                          ),
                                        ),
                                          const SizedBox(width: 16),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Account Number'.tr,
                                              hintText: userData['accountNumber'] ?? 'No Account Number',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                      const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Swift Code'.tr,
                                              hintText: userData['swiftCode'] ?? 'No Swift Code',
                                            ),
                                          ),
                                        ),
                                          const SizedBox(width: 16),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'IBAN'.tr,
                                              hintText: userData['iban'] ?? 'No IBAN',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                              const SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding:   const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                      'Add Order'.tr,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                      const SizedBox(height: 16),
                                      Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Order'.tr,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Transaction Type'.tr,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                      const SizedBox(height: 16),
                                      TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Description'.tr,
                                      ),
                                    ),
                                      const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child:   Text('Add Order'.tr),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                    const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding:   const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                            'Market History List'.tr,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                            const SizedBox(height: 16),
                          DataTable(
                            columns:   [
                              DataColumn(label: Text('Order ID'.tr.tr)),
                              DataColumn(label: Text('Name'.tr)),
                              DataColumn(label: Text('Status'.tr)),
                              DataColumn(label: Text('Date'.tr)),
                              DataColumn(label: Text('Amount'.tr)),
                            ],
                            rows:   const [
                              DataRow(cells: [
                                DataCell(Text('1')),
                                DataCell(Text('Order 1')),
                                DataCell(Text('Completed')),
                                DataCell(Text('2023-10-01')),
                                DataCell(Text('\$100')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('2')),
                                DataCell(Text('Order 2')),
                                DataCell(Text('Pending')),
                                DataCell(Text('2023-10-02')),
                                DataCell(Text('\$200')),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}