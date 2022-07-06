import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) => Container(
          padding: const EdgeInsets.all(8),
          child: const Text('This works'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final firebaseApp = await Firebase.initializeApp();
          final firestore = FirebaseFirestore.instanceFor(app: firebaseApp);
          final chatsCollectionSnapshot = await firestore.collection('chats').get();
          final messagesCollectionSnapshot = await chatsCollectionSnapshot.docs.first.reference.collection('messages').get();
          messagesCollectionSnapshot.docs.forEach((document) => print(document.data()['text']));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
