import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/app.dart';
import 'package:flutter_firebase_chat_application/src/components/message.component.dart';
import 'package:flutter_firebase_chat_application/src/components/participant_info.component.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/services/message.service.dart';

class ChatComponent extends StatefulWidget {
  const ChatComponent({
    Key? key,
    required this.selectedIndex,
    required this.participantUser
  }) : super(key: key);

  final ValueNotifier<int> selectedIndex;
  final Map<String, dynamic> participantUser;

  @override
  State<ChatComponent> createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  final MessageService messageService = MessageService();
  late ValueNotifier<String> chatKey = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    getChatKey();
  }

  getChatKey() async {
    chatKey.value = await messageService.getChatKeyBetweenTwo(
        firebaseService.getUserAuth()!.uid, widget.participantUser['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.participantUser['firstName']} ${widget.participantUser['lastName']}'),
        centerTitle: false,
        leadingWidth: 90,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            avatar(),
          ],
        ),
        actions: [
          chatInfo(),
        ],
      ),
      body: Scaffold(
        bottomNavigationBar: bottomAppBar(),
        body: SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 80,
            child: FutureBuilder(
                future: listMessages(),
                builder: (BuildContext context, AsyncSnapshot<Widget> newWidget) {
                  return newWidget.hasData ? newWidget.data! : Container();
                }
            )
        ),
      ),

    );
  }

  Widget avatar() {
    if (widget.participantUser['photo'].isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.participantUser['photo']),
      );
    }
    return const Padding(
      padding: EdgeInsets.only(left: 5.0),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/img/avatar.png'),
      ),
    );
  }

  Widget chatInfo() {
    return IconButton(
      icon: const Icon(CupertinoIcons.info_circle, size: 30),
      onPressed: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ParticipantInfoComponent(participantUser: widget.participantUser),
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

  Widget bottomAppBar() {
    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            messageInput(),
            sendButton(),
          ],
        ),
      ),
    );
  }

  Widget messageInput() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 5),
            child: TextFormField(
              controller: messageController,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.grey
                        : Colors.grey),
                border: InputBorder.none,
              ),
              onEditingComplete: () {
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: () async {
        await messageService.sendSingleUserMessage({
          'sender': widget.participantUser['id'],
          'receiver': firebaseService.getUserAuth()!.uid,
          'message': messageController.text,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });

        getChatKey();

        setState(() {
          messageController.clear();
        });
      },
    );
  }

  Future<Widget> listMessages() async {
    return ValueListenableBuilder(
        valueListenable: chatKey,
        builder: (BuildContext context, String newChatKey, Widget? childWid) {
          if (newChatKey.isEmpty) {
            return const Center(
              child: Text('No messages yet'),
            );
          }
          return StreamBuilder(
            stream: FirebaseDatabase.instance.ref('messages').child(newChatKey).onValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> map = json.decode(json.encode(
                    snapshot.data.snapshot.value)) as Map<String, dynamic>;
                List<dynamic> list = map.values.toList();

                list.sort((a, b) {
                  return a['timestamp'] - b['timestamp'];
                });
                list = list.reversed.toList();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ListView.builder(
                    itemCount: list.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageComponent(
                        message: list[index]['message'],
                        isOwnMessage: list[index]['sender'] == firebaseService.getUserAuth()!.uid,
                        timestamp: list[index]['timestamp'],
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
    );
  }
}

