import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShowMessages extends StatefulWidget {
  final String ticketId;
  final String phone;
  final String userid;
  final String role;
  final String state;

  const ShowMessages(
      {super.key, required this.ticketId,
      required this.phone,
      required this.userid,
      required this.role,
      required this.state});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ShowMessages> {
  final _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _firestore
          .collection('supportTickets')
          .doc(widget.ticketId)
          .collection('messages')
          .add({
        'message': message,
        'time': Timestamp.now(),
        //'uId': FirebaseAuth.instance.currentUser!.uid,
        'uId': widget.ticketId,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: widget.phone)); // نسخ النص إلى الحافظة
                Get.snackbar(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  "Copied to clipboard!".tr,
                  "Phone number copied to clipboard".tr,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.blue[300],
                  duration: const Duration(seconds: 2),
                );
              },
              child: Row(children: [
                CustomText(
                  size: 25,
                  text: widget.phone == "Rider" ? "Rider".tr : "Driver".tr,
                ),
              ]),
            ),
            const SizedBox(
              width: 20,
            ),
          
          
          
            CustomText(
              size: 25,
              text: widget.phone ?? 'N/A',
            ),
          ],
        ),
        actions: [
          MaterialButton(
            height: 50,
            minWidth: 50,
            color: Colors.blue,
            child: Text(
              " Back".tr,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              //  navigationController.navigateTo();

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('supportTickets')
                  .doc(widget.ticketId)
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs
                      .map((doc) => Message(
                            id: doc.id,
                            content: doc.get('message'),
                            timestamp: (doc.get('time') as Timestamp).toDate(),
                            senderId: doc.get('uId'),
                          ))
                      .toList();

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(
                        message: message,
                        isMe: message.senderId == widget.userid,
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (widget.state == "open")
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter message'.tr,
                      ),
                    ),
                  ),
                if (widget.state == "open")
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class Message {
  String id;
  String content;
  DateTime timestamp;
  String senderId;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
  });
}
