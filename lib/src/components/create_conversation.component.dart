import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/app.dart';
import 'package:flutter_firebase_chat_application/src/components/chat.component.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/shared/utils/debouncer.dart';

class CreateConversationComponent extends StatefulWidget {
  const CreateConversationComponent({Key? key, required this.selectedIndex}) : super(key: key);

  final ValueNotifier<int> selectedIndex;

  @override
  State<CreateConversationComponent> createState() => _CreateConversationComponentState();
}

class _CreateConversationComponentState extends State<CreateConversationComponent> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController searchController = TextEditingController();
  late List<dynamic> usersData;
  ValueNotifier<List<Widget>> usersWidgetList = ValueNotifier([]);
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Conversation'),
      ),
      body: Column(
        children: [
          searchInput(),
          users(),
        ],
      ),
    );
  }

  Widget searchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: TextFormField(
            controller: searchController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.grey
                      : Colors.grey),
              prefixIcon: Icon(
                  Icons.search,
                  color: MyApp.themeNotifier.value == ThemeMode.light
                      ? Colors.orange
                      : Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                color: MyApp.themeNotifier.value == ThemeMode.light
                    ? Colors.orange
                    : Colors.grey,
                onPressed: () {
                  searchController.clear();
                  usersWidgetList.value = [];
                },
              ),
              border: InputBorder.none,
            ),
            onChanged: (String value) async {
              if (value.isNotEmpty) {
                _debouncer.run(() async {
                  /// fetch users with relevantSearch
                  usersData = await _firebaseService.relevantSearch(value);
                  /// empty previous users in list
                  usersWidgetList.value = [];
                  setState(() {
                    /// for every user found with relevantSearch
                    /// add a Widget to list with that users data
                    for (var user in usersData) {
                      usersWidgetList.value.add(
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['photo']),
                            radius: 30,
                          ),
                          title: Text(user['firstName'] + ' ' + user['lastName']),
                          subtitle: Text(user['email']),
                          onTap: () {
                            Map<String, dynamic> participantUser = Map<String, dynamic>.from(user);

                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      ChatComponent(
                                        selectedIndex: widget.selectedIndex,
                                        participantUser: participantUser,
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
                        ),
                      );
                    }
                  });
                });
              } else {
                /// if user clears search input
                usersWidgetList.value = [];
              }
            }
        ),
      ),
    );
  }

  Widget users() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: usersWidgetList,
              builder: (BuildContext context, List<Widget> value, Widget? child) {
                return ListView.builder(
                  itemCount: value.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 200),
                  itemBuilder: (BuildContext context, int index) {
                    return value[index];
                  },
                );
              }
          )
        ],
      ),
    );
  }
}
