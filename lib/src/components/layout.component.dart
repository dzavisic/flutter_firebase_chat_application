import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/components/conversations.component.dart';
import 'package:flutter_firebase_chat_application/src/components/home.component.dart';
import 'package:flutter_firebase_chat_application/src/components/profile.component.dart';

class LayoutComponent extends StatefulWidget {
  @override
  State<LayoutComponent> createState() => _LayoutComponentState();
}

class _LayoutComponentState extends State<LayoutComponent> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      HomeComponent(),
      ConversationsComponent(selectedIndex: _selectedIndex),
      const ProfileComponent(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (BuildContext context, int value, Widget? child2) {
          return IndexedStack(
              index: _selectedIndex.value,
              children: screens
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (BuildContext context, int selectedIndex, Widget? child) {
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: selectedIndex,
            onTap: bumpSelectedIndex,
          );
        },
      ),
    );
  }

  void bumpSelectedIndex(int index) {
    _selectedIndex.value = index;
  }
}
