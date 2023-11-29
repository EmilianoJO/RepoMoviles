import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queries/queries.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: FirestoreListView(
        padding: EdgeInsets.symmetric(horizontal: 18),
        query: FirebaseFirestore.instance.collection("chats"),
        itemBuilder: (BuildContext context,
            QueryDocumentSnapshot<Map<String, dynamic>> document) {
          String lastModifiedAt = DateFormat.yMd()
              .format(document.data()['lastModifiedAt'].toDate());

          return FutureBuilder<int>(
            future: numMessages(document.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                int messagesCount = snapshot.data ?? 0;
                return ListTile(
                  title: Text('Chat ID: ${document.id}'),
                  subtitle: Text(
                      'Last modified: $lastModifiedAt \nMessages: $messagesCount'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
