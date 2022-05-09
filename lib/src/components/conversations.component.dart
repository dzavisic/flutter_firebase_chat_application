import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/components/chat.component.dart';
import 'package:flutter_firebase_chat_application/src/components/create_conversation.component.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/services/message.service.dart';

class ConversationsComponent extends StatefulWidget {
  const ConversationsComponent({Key? key, required this.selectedIndex}) : super(key: key);

  final ValueNotifier<int> selectedIndex;

  @override
  State<ConversationsComponent> createState() => _ConversationsComponentState();
}

class _ConversationsComponentState extends State<ConversationsComponent> {
  final FirebaseService _firebaseService = FirebaseService();
  final MessageService _messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        leading: avatar(),
        actions: [
          createConversationButton(),
        ],
      ),
      body: conversationsList(),
    );
  }

  Widget avatar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: StreamBuilder(
        stream: _firebaseService.getDocumentChanges('users', _firebaseService.getUserAuth()!.uid),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                widget.selectedIndex.value = 2;
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data!.data()!['photo']),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                widget.selectedIndex.value = 2;
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/img/avatar.png'),
              ),
            );
          }
        },
      ),
    );
  }

  Widget chatAvatar(String participantId) {
    return StreamBuilder(
      stream: _firebaseService.getDocumentChanges('users', participantId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!.data()!['photo']),
            radius: 40.0,
          );
        } else {
          return const CircleAvatar(
            backgroundImage: AssetImage('assets/img/avatar.png'),
            radius: 40.0,
          );
        }
      },
    );
  }

  Widget createConversationButton() {
    return IconButton(
      icon: const Icon(CupertinoIcons.pencil, size: 30),
      onPressed: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => CreateConversationComponent(selectedIndex: widget.selectedIndex),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ));
      },
    );
  }

  Widget conversationsList() {
    return StreamBuilder(
      stream: _messageService.getUserInMembers(_firebaseService.getUserAuth()!.uid),
      builder: (context, AsyncSnapshot conversationsSnapshot) {
        if (conversationsSnapshot.hasError) {
          return Text('Error: ${conversationsSnapshot.error}');
        }
        if (conversationsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return FutureBuilder(
            future: _messageService.getUserConversations(_firebaseService.getUserAuth()!.uid, conversationsSnapshot.data),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> chat = snapshot.data[index];
                    final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(chat['timestamp']);

                    return FutureBuilder(
                      future: _firebaseService.getDocument('users', chat['participantId']),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {

                        if (snap.hasError) {
                          return Text('Error: ${snap.error}');
                        }
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListTile(
                          leading: chatAvatar(chat['participantId']),
                          contentPadding: const EdgeInsets.only(left: 5.0, right: 10.0),
                          title: Text(snap.data!['firstName'] + ' ' + snap.data!['lastName']),
                          subtitle: Text(chat['lastMessage']),
                          trailing: Text('${timestamp.hour}:${timestamp.minute}'),
                          onTap: () {
                            Map<String, dynamic> participantUserData = {
                              'firstName': snap.data!['firstName'],
                              'lastName': snap.data!['lastName'],
                              'phone': snap.data!['phone'],
                              'email': snap.data!['email'],
                              'photo': snap.data!['photo'],
                              'id': snap.data!.id,
                            };

                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      ChatComponent(
                                        selectedIndex: widget.selectedIndex,
                                        participantUser: participantUserData,
                                      ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }
        );
      },
    );
  }
}
