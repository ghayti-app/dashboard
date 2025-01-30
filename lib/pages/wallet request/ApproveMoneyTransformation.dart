import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApproveMoneyTransformation extends StatefulWidget {
  const ApproveMoneyTransformation({
    super.key,
    required this.walletID,
    required this.customer,
  });
  final String walletID;
  final Map<String, dynamic> customer;
  @override
  State<ApproveMoneyTransformation> createState() =>
      _ApproveMoneyTransformationState();
}

class _ApproveMoneyTransformationState
    extends State<ApproveMoneyTransformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        title: Text('Approve Money Transformation'.tr),
        actions: [
         SizedBox(
                    width: 90,
                    child: MaterialButton(
                      height: 45,
                      color: Colors.blue,
                      child: Text(
                        " Back".tr,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
        ],  
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Text(
              "Are You Sure To Accept This Request Or Not".tr,
              style: const TextStyle(fontSize: 23),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.verified_sharp,
                    size: 50,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    // navigationController
                    //               .navigateTo(showWalletPageRoute);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Are You Sure? '.tr,
                            style: const TextStyle(fontSize: 20),
                          ),
                          content: SingleChildScrollView(
                            child: Text(
                              'To Accept This Request'.tr,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('NO'.tr),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Yes'.tr),
                              onPressed: () async {
                                String? adminId =
                                    FirebaseAuth.instance.currentUser?.uid;
                                final db = FirebaseFirestore.instance;
                                final batch = db.batch();

                                if (adminId != null) {
                                  final batch = db.batch();

                                  var adminActionRef =
                                      db.collection('adminActions').doc();
                                  batch.set(adminActionRef, {
                                    'adminId': adminId,
                                    'adminEmail': FirebaseAuth
                                        .instance.currentUser?.email,
                                    'Name': widget.customer['id'],
                                    'Id': widget.walletID,
                                    'newState': widget.customer['isAccepted'],
                                    'type': 'change Wallet Request State',
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });
                                  // await db
                                  //     .collection('adminActions')
                                  //     .add({
                                  //   'adminId': adminId,
                                  //   'adminEmail': FirebaseAuth
                                  //       .instance.currentUser?.email,
                                  //   'Name': widget.customer['id'],
                                  //   'Id': widget.walletID,
                                  //   'newState': widget.customer['isAccepted'],
                                  //   'type': 'change Wallet Request State',
                                  //   'timestamp': FieldValue.serverTimestamp(),
                                  // });
                                  //   (
                                  //     "addActoins============================================");
                                } else {
                                  ('No admin is signed in.'.tr);
                                }

                                //   (
                                //     "done============================================");
                                if (widget.customer['role'] == "driver" &&
                                    widget.customer['type'] == "addMoney") {
                                  //   (
                                  //     "addMoneys============================================");

                                  var updatePatch =
                                      db //FirebaseFirestore.instance
                                          .collection("drivers")
                                          .doc(widget.customer['id']);
                                  batch.update(updatePatch, {
                                    "balance": FieldValue.increment(
                                        double.parse(
                                            widget.customer['balance']))
                                  });

                                  //     .update({
                                  //   "balance": FieldValue.increment(
                                  //       double.parse(
                                  //           widget.customer['balance']))
                                  // });
                                  //   (
                                  //     "drivers Balance============================================");

                                  var updatePatch1 = FirebaseFirestore.instance
                                      .collection("payments")
                                      .doc("paymentsTest");
                                  //.doc(snapshot.data!.docs[0]["currentBalance"]
                                  batch.update(updatePatch1, {
                                    "currentBalance": FieldValue.increment(
                                        double.parse(
                                            widget.customer['balance']))
                                  });
                                  // .update({
                                  //   "currentBalance": FieldValue.increment(
                                  //       double.parse(
                                  //           widget.customer['balance']))
                                  // });
                                  //   (
                                  //     "Company Current Balance============================================");
                                  var updateRef2 = FirebaseFirestore.instance
                                      .collection("payments")
                                      .doc("paymentsTest");

                                  batch.update(updateRef2, {
                                    "DriversWalletsBalance":
                                        FieldValue.increment(double.parse(
                                            widget.customer['balance']))
                                  });
                                  //.doc(snapshot.data!.docs[0]["currentBalance"]
                                  //     .update({
                                  //   "DriversWalletsBalance":
                                  //       FieldValue.increment(double.parse(
                                  //           widget.customer['balance']))
                                  // });
                                } else if (widget.customer['role'] ==
                                        "driver" &&
                                    widget.customer['type'] ==
                                        "withdrawMoney") {
                                    (
                                      "withDrow============================================");
                                  //  widget.customer['done'] = true;
                                  var update3 = FirebaseFirestore.instance
                                      .collection("drivers")
                                      .doc(widget.customer['id']);
                                  batch.update(update3, {
                                    "balance": FieldValue.increment(
                                        double.parse(
                                                widget.customer['balance']) *
                                            -1)
                                  });
                                  // .update({
                                  //   "balance": FieldValue.increment(
                                  //       double.parse(
                                  //               widget.customer['balance']) *
                                  //           -1)
                                  // });
                                    (
                                      "withDrow Balance============================================");
                                  var update4 = FirebaseFirestore.instance
                                      .collection("payments")
                                      .doc("paymentsTest");
                                  //.doc(snapshot.data!.docs[0]["currentBalance"]
                                  batch.update(update4, {
                                    "DriversWalletsBalance":
                                        FieldValue.increment(double.parse(
                                                widget.customer['balance']) *
                                            -1)
                                  });
                                  //   .update({
                                  // "DriversWalletsBalance":
                                  //     FieldValue.increment(double.parse(
                                  //             widget.customer['balance']) *
                                  //         -1)
                                  //  });
                                    (
                                      "withDrow Drivaer Balance============================================");

                                  var update5 = FirebaseFirestore.instance
                                      .collection("payments")
                                      .doc("paymentsTest");
                                  //.doc(snapshot.data!.docs[0]["currentBalance"]
                                  batch.update(update5, {
                                    "currentBalance": FieldValue.increment(
                                        double.parse(
                                                widget.customer['balance']) *
                                            -1)
                                  });
                                  // .update({
                                  //   "currentBalance": FieldValue.increment(
                                  //       double.parse(
                                  //               widget.customer['balance']) *
                                  //           -1)
                                  // });
                                }
                                if (widget.customer['role'] == "rider" &&
                                    widget.customer['type'] == "addMoney") {
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.customer['id'])
                                      .update({
                                    "balance": FieldValue.increment(
                                        double.parse(
                                            widget.customer['balance']))
                                  });
                                }
                                  (
                                    "Users Balance============================================");
                                var up1 = FirebaseFirestore.instance
                                    .collection("payments")
                                    .doc("paymentsTest");

                                batch.update(up1, {
                                  "currentBalance": FieldValue.increment(
                                      double.parse(widget.customer['balance'])),
                                  "ridersWalletsBalance": FieldValue.increment(
                                      double.parse(widget.customer['balance']))
                                });
                                // .update({
                                //   "currentBalance": FieldValue.increment(
                                //       double.parse(widget.customer['balance']))
                                // });
                                // await FirebaseFirestore.instance
                                //     .collection("payments")
                                //     .doc("paymentsTest")
                                //     .update({
                                //   "ridersWalletsBalance": FieldValue.increment(
                                //       double.parse(widget.customer['balance']))
                                // });

                                var up11 = FirebaseFirestore.instance
                                    .collection('wallet')
                                    .doc(widget.walletID);
                                batch.update(up11, {
    'isAccepted': true,
                                  "done": true,

                                }) ;
                                // .update({
                                //   'isAccepted': true,
                                //   "done": true,
                                // });
                                // navigationController
                                //     .navigateTo(showWalletPageRoute);


      // await batch.commit();
      //   navigationController
      //                                 .navigateTo(showWalletPageRoute);
      //                           Navigator.of(context).pop();

batch.commit().then((_) {
                      navigationController
                                      .navigateTo(showWalletPageRoute);
                                Navigator.of(context).pop();
});

                            //    Navigator.of(context).pop();
                                setState(() {
                                  // widget.customer['done'] = true;

                                  //                  navigationController
                                  //     .navigateTo(showWalletPageRoute);
                                  // Navigator.of(context).pop();
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  width: 50,
                ),
                IconButton(
                  color: Colors.green,
                  icon: const Icon(
                    Icons.block,
                    color: Colors.red,
                    size: 50,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Are You Sure? '.tr,
                            style: const TextStyle(fontSize: 20),
                          ),
                          content: SingleChildScrollView(
                            child: Text(
                              'To Decline This Request'.tr,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('NO'.tr),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Yes'.tr),
                              onPressed: () async {
                                navigationController
                                    .navigateTo(showWalletPageRoute);
                                Navigator.of(context).pop();

                                await FirebaseFirestore.instance
                                    .collection("wallet")
                                    .doc(widget.walletID)
                                    .update({
                                  "done": true,
                                });

                                await FirebaseFirestore.instance
                                    .collection('wallet')
                                    .doc(widget.walletID)
                                    .update(
                                        {'isAccepted': false, "done": true});
                                setState(() {
                                  //      isAccepted = false;
                                  // widget.customer['done'] = true;
                                  // widget.customer['done'] == true;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                    // _updateVerificationStatus(true , customerid.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
