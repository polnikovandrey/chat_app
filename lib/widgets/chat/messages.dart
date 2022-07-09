import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, chatSnapshot) {
        final data = chatSnapshot.data;
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (data == null || !chatSnapshot.hasData) {
          return const Text('No Data');
        } else {
          var currentUser = FirebaseAuth.instance.currentUser;
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              return MessageBubble(
                username: doc['username'],
                message: doc['text'],
                isMe: doc['userId'] == currentUser?.uid,
                key: ValueKey(doc.id),
              );
            },
            reverse: true,
          );
        }
      },
    );
  }
}
