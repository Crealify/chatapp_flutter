import 'package:chatapp_flutter/chat/screen/chat_list_screen.dart';
import 'package:chatapp_flutter/chat/screen/user_list_screen.dart';
import 'package:flutter/material.dart';

import 'profile_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  // bool _hasInitialized = false;

  //screen for each tab
  //@override
  final List<Widget> _screens = [
    ChatListScreen(),
    UserListScreen(),
    ProfileScreen(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        unselectedFontSize: 14,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "chats"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
