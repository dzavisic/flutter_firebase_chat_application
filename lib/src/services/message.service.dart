import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

/// Collection => members: [
///   "chatKey": {
///     "senderUid": true,
///     "receiverUid": true,
///   },
///   ...
/// ]
///
/// Collection => messages: [
///  "chatKey": [
///    "message1": {
///      "sender": senderUid,
///      "message": message,
///      "timestamp": timestamp
///    },
///    ...
///  ],
///  ...
/// ]
///
/// Collection => chats: [
///  "chatKey": {
///    "lastMessage": message,
///    "timestamp": timestamp
///  },
///  ...
/// ]

class MessageService {
  /// messageData: {
  ///  "sender": senderUid,
  ///  "receiver": receiverUid,
  ///  "message": messageController.text,
  ///  "timestamp": DateTime.now().millisecondsSinceEpoch
  /// }
  sendSingleUserMessage(Map<String, dynamic> messageData) async {
    try {
      bool chatExists = false;

      /// Get members collection to see if chat with given users exists
      await FirebaseDatabase.instance
          .ref('members')
          .get()
          .then((membersSnapshot) => {
        /// Iterate trough members collection
        membersSnapshot.children.forEach((chats) async {
          Map<String, dynamic> chatMembers = json
              .decode(json.encode(chats.value)) as Map<String, dynamic>;

          bool sender = (chatMembers[messageData['sender']] == null)
              ? false
              : true;
          bool receiver = (chatMembers[messageData['receiver']] == null)
              ? false
              : true;

          /// Chat exists
          if (sender && receiver) {
            chatExists = true;

            /// Add message to chat
            await FirebaseDatabase.instance
                .ref('messages')
                .child(chats.key.toString())
                .push()
                .set({
              'sender': messageData['sender'],
              'message': messageData['message'],
              'timestamp': messageData['timestamp']
            });

            /// Update chat last message and timestamp
            await FirebaseDatabase.instance
                .ref('chats')
                .child(chats.key.toString())
                .set({
              'lastMessage': messageData['message'],
              'timestamp': messageData['timestamp']
            });
          }

          /// Chat does not exist
          if (!chatExists) {
            var newChat =
            FirebaseDatabase.instance.ref('members').push();
            var chatKey = newChat.key;

            /// Create chat members
            newChat.set({
              messageData['sender']: true,
              messageData['receiver']: true
            }).then((newChat) async {
              /// Create first message
              await FirebaseDatabase.instance
                  .ref('messages')
                  .child(chatKey.toString())
                  .push()
                  .set({
                'sender': messageData['sender'],
                'message': messageData['message'],
                'timestamp': messageData['timestamp']
              });

              /// Create chat last message and timestamp
              await FirebaseDatabase.instance
                  .ref('chats')
                  .child(chatKey.toString())
                  .set({
                'lastMessage': messageData['message'],
                'timestamp': messageData['timestamp']
              });
            });
          }
        })
      });
    } catch (e) {
      print(e);
    }
  }

  /// Get chat id from members collection between two users
  getChatKeyBetweenTwo(String sender, String receiver) async {
    try {
      String chatKey = '';

      /// Get members collection to see if chat with given users exists
      await FirebaseDatabase.instance
          .ref('members')
          .get()
          .then((membersSnapshot) => {
        /// Iterate trough members collection
        membersSnapshot.children.forEach((chats) {
          Map<String, dynamic> chatMembers = json
              .decode(json.encode(chats.value)) as Map<String, dynamic>;

          bool senderExists =
          (chatMembers[sender] == null) ? false : true;
          bool receiverExists =
          (chatMembers[receiver] == null) ? false : true;

          /// Chat exists
          if (senderExists && receiverExists) {
            chatKey = chats.key.toString();
          }
        })
      });

      return chatKey;
    } catch (e) {
      print(e);
    }
  }

  Stream getUserInMembers(String userId) {
    return FirebaseDatabase.instance
        .ref('members')
        .orderByChild(userId)
        .equalTo(true)
        .onValue;
  }

  /// Get user chats/conversations
  getUserConversations(String userId, DatabaseEvent snap) async {
    try {
      /// Get members collection to see if chat with given users exists
      List<Map<String, dynamic>> chats = [];

      /// If chats exist, take all chats keys into chatKeys
      List<Map<String, dynamic>> chatKeys = [];
      for (var chats in snap.snapshot.children) {
        String participantId = '';
        Map<String, dynamic> chatMembers =
        json.decode(json.encode(chats.value)) as Map<String, dynamic>;
        List<String> listOfKeys = chatMembers.keys.toList();
        listOfKeys.removeWhere((element) => element == userId);
        participantId = listOfKeys[0];
        chatKeys.add(
            {'key': chats.key.toString(), 'participantId': participantId});
      }

      /// Get chats collection to get chat data with chatKey
      for (var chatKey in chatKeys) {
        await FirebaseDatabase.instance
            .ref('chats')
            .child(chatKey['key'])
            .once()
            .then((chatSnapshot) {
          Map<String, dynamic> chatData =
          json.decode(json.encode(chatSnapshot.snapshot.value))
          as Map<String, dynamic>;
          chats.add({
            'chatKey': chatKey['key'],
            'participantId': chatKey['participantId'],
            'lastMessage': chatData['lastMessage'],
            'timestamp': chatData['timestamp']
          });
        });
      }

      return chats;

    } catch (e) {
      print(e);
      throw e;
    }
  }

  MessageService();
}
