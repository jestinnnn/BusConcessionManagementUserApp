import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final dynamic Function(int) onTabTapped;
  final Color? backgroundColor;

  const CommonScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
    required this.onTabTapped,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        
        
        currentIndex: currentIndex,
        onTap: onTabTapped,
        selectedItemColor:
            Color.fromARGB(255, 15, 66, 107), // Set selected item color
        unselectedItemColor:
            Color.fromARGB(255, 134, 191, 220), // Set unselected item color
        items: [
          _buildNavigationBarItem(Icons.home, 'Home'),
          _buildNavigationBarItem(Icons.airplane_ticket, 'Ticket History'),
          _buildNavigationBarItem(Icons.map, 'Map'),
          _buildNavigationBarItem(Icons.qr_code, 'Qr'),
          // _buildNavigationBarItem(Icons.person, 'Profile'), Do we really need this?
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
