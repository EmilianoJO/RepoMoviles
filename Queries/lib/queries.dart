import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<void> updateExistingChat() async {
  try {
    CollectionReference chatMessagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc('4G3sYLXuCzB6vQy5tyfV')
        .collection('messages');

    Map<String, dynamic> content = {'msg': 'bien, y tu?', 'files': []};
    Map<String, dynamic> content2 = {'msg': 'bien tbm', 'files': []};
    Timestamp timestamp = Timestamp.now();

    await chatMessagesCollection.add({
      'content': content,
      'createdAt': timestamp,
      'senderId': '1',
      'senderName': 'Emiliano',
    });
    await chatMessagesCollection.add({
      'content': content2,
      'createdAt': timestamp,
      'senderId': '0',
      'senderName': 'Pedro',
    });
  } catch (e) {}
}

Future<void> addNewChat() async {
  CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  Map<String, dynamic> nuevoChat = {
    'chatters': ['Emiliano', 'Pedro'],
    'createdAt': FieldValue.serverTimestamp(),
    'lastModifiedAt': FieldValue.serverTimestamp(),
  };

  DocumentReference nuevoChatRef = await chatsCollection.add(nuevoChat);

  CollectionReference messagesCollection = nuevoChatRef.collection('messages');

  await messagesCollection.add({
    'content': {'msg': 'Hola', 'files': []},
    'createdAt': FieldValue.serverTimestamp(),
    'senderId': '1',
    'senderName': 'Emiliano'
  });
  await messagesCollection.add({
    'content': {'msg': 'Hola, como estas?', 'files': []},
    'createdAt': FieldValue.serverTimestamp(),
    'senderId': '0',
    'senderName': 'Pedro'
  });
}

Future<int> numMessages(String chatId) async {
  try {
    CollectionReference messagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');
    QuerySnapshot querySnapshot = await messagesCollection.get();
    return querySnapshot.size;
  } catch (e) {
    return 0;
  }
}

Future<List<Map<String, dynamic>>> getExistingChats() async {
  try {
    QuerySnapshot chatSnapshots =
        await FirebaseFirestore.instance.collection('chats').get();

    List<Map<String, dynamic>> chatList =
        chatSnapshots.docs.map((DocumentSnapshot chat) {
      Timestamp lastModified = chat['lastModified'] as Timestamp;
      int messageCount = chat['messages'].length;

      return {
        "chatId": chat.id,
        "lastModified": lastModified.toDate(),
        "messageCount": messageCount,
      };
    }).toList();

    return chatList;
  } catch (e) {
    return [];
  }
}

Future<List<File>> pickFiles() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    }
  } catch (e) {}
  return [];
}

Future<List<String>> uploadFiles(List<File> files) async {
  List<String> fileUrls = [];

  for (File file in files) {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(
          'files/4G3sYLXuCzB6vQy5tyfV/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      fileUrls.add(downloadUrl);
      print(downloadUrl);
    } catch (e) {}
  }

  return fileUrls;
}

Future<void> updateExistingChatFiles(
    String userId, List<String> fileUrls) async {
  try {
    CollectionReference chatMessagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc('4G3sYLXuCzB6vQy5tyfV')
        .collection('messages');

    Map<String, dynamic> content = {'msg': 'Ten los files', 'files': fileUrls};
    Timestamp timestamp = Timestamp.now();

    await chatMessagesCollection.add({
      'content': content,
      'createdAt': timestamp,
      'senderId': '1',
      'senderName': 'Emiliano',
    });
  } catch (e) {}
}
