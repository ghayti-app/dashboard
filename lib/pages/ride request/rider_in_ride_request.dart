 
import 'package:cloud_firestore/cloud_firestore.dart';

const String newRideRequest = 'new_ride_request';
const String arriving = 'arriving';
const String canceled = 'canceled';
const String completed = 'completed';
const String arrived = 'arrived';
const String inProgress = "in_progress";
const cashCollecting = 'cash_collecting';
const String reviewing = 'reviewing';
const String completeByDriver = 'complete_by_driver';
const String completeByrRider = 'complete_by_rider';

Future<bool> chickRideRequest(String riderID) async {
  final collection = await FirebaseFirestore.instance
      .collection("rideRequest")
      .where("userId", isEqualTo: riderID)
      .where("state", whereIn: [
    newRideRequest,
    arriving,
    arrived,
    inProgress,
    cashCollecting,
    reviewing,
    completeByDriver
  ]).get();
  if (collection.docs.isNotEmpty) {
    // CashHelper.putString(    key: Keys.rideRequestID, value: collection.docs[0].id);
    // return RideRequestModel.fromMap(collection.docs[0].data());
    return true;
  } else {
    return false;
  }
}
