import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  var drivers = [].obs;
  var users = [].obs;
  var balance = [].obs;
  var totalRides = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
    fetchUsers();
    fetchPayments();
    fetchTotalRides();
  }

  void fetchDrivers() async {
    var data = await FirebaseFirestore.instance.collection('drivers').get();
    drivers.value = data.docs;
  }

  void fetchUsers() async {
    var data = await FirebaseFirestore.instance.collection('users').get();
    users.value = data.docs;
  }

  void fetchPayments() async {
    var data = await FirebaseFirestore.instance.collection('payments').get();
    //balance.value = data.docs ;
    balance.value = data.docs;
  }

  void fetchTotalRides() async {
    var data = await FirebaseFirestore.instance.collection('payments').get();
    totalRides.value = data.docs;
  }
}
