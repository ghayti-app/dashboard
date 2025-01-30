import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchRiderScreen extends StatefulWidget {
  final Function(String, String, String) onRiderSelected;

  const SearchRiderScreen({super.key, required this.onRiderSelected});

  @override
  _SearchRiderScreenState createState() => _SearchRiderScreenState();
}

class _SearchRiderScreenState extends State<SearchRiderScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot<Object?>> allRiders = [];
  List<QueryDocumentSnapshot<Object?>> filteredRiders = [];
  @override
  void initState() {
    super.initState();
    fetchAllRiders();
  }

  Future<void> fetchAllRiders() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        allRiders = querySnapshot.docs;
        filteredRiders = allRiders;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Rider'.tr),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter Rider Phone Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filterRiders(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRiders.length,
              itemBuilder: (context, index) {
                var rider = filteredRiders[index];
                return ListTile(
                  title: Text("${rider['phoneNumber']}  ${rider["userName"]}"),
                  onTap: () {
                    //  widget.onRiderSelected(    rider.id,  rider['phoneNumber'],   rider['userName'],  );

                    Navigator.pop(context, {
                      'id': rider.id,
                      'phone': rider['phoneNumber'],
                      'name': rider['userName'],
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void filterRiders(String value) {
    setState(() {
      filteredRiders = allRiders
          .where((rider) => rider['phoneNumber']
              .toString()
              .startsWith("+222${value.toLowerCase()}"))
          .toList();
    });
  }
}
