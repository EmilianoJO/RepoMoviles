import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queries/queries.dart';

CircleAvatar? createAvatarSender(
    String senderId, String currentUserId, String firstLetter) {
  if (currentUserId == senderId) {
    return CircleAvatar(
      child: Text("$firstLetter"),
    );
  } else {
    return null;
  }
}

CircleAvatar? createAvatarUser(
    String senderId, String currentUserId, String firstLetter) {
  if (currentUserId != senderId) {
    return CircleAvatar(
      child: Text("$firstLetter"),
    );
  } else {
    return null;
  }
}

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: FirestoreListView(
              padding: EdgeInsets.symmetric(horizontal: 18),
              pageSize: 15,
              query: FirebaseFirestore.instance
                  .collection("chats")
                  .doc('4G3sYLXuCzB6vQy5tyfV')
                  .collection('messages'),
              itemBuilder: (BuildContext context,
                  QueryDocumentSnapshot<Map<String, dynamic>> document) {
                Map<String, dynamic> contentMap = document.data()['content'];
                List<dynamic> values = contentMap.values.toList();

                String currentUserId = '1';

                String senderName = document.data()['senderName'];
                String firstLetter = senderName[0];

                String msg = values.isNotEmpty ? values[0] : '';
                print(values);
                List<dynamic> filesUrls = values.isNotEmpty ? values[1] : '';

                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Message: $msg'),
                      if (filesUrls.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          children: filesUrls.map((url) {
                            // String fileExtension = getFileExtensionFromUrl(url);

                            return Icon(
                              Icons.file_open_sharp,
                              size: 20,
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                  subtitle: Text('Sender: ${document.data()['senderName']}'),
                  leading: createAvatarUser(
                      document.data()['senderId'], currentUserId, firstLetter),
                  trailing: createAvatarSender(
                      document.data()['senderId'], currentUserId, firstLetter),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              List<File> files = await pickFiles();
              List<String> fileUrls = await uploadFiles(files);
              updateExistingChatFiles('1', fileUrls);
            },
            child: Text('Upload files'),
          ),
        ],
      ),
    );
  }
}
