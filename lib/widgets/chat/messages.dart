import 'package:cloud_firestore/cloud_firestore.dart';
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
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) => Text(data.docs[index]['text']),
            reverse: true,
          );
        }
      },
    );
  }
}
