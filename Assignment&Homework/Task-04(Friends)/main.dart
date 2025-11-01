import 'package:flutter/material.dart';

void main() => runApp(const FriendsApp());

class FriendsApp extends StatelessWidget {
  const FriendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FriendsScreen(),
    );
  }
}

class FriendsScreen extends StatelessWidget {
  final List<Map<String, String>> friends = [
    {"name": "Abid Smith", "group": "A"},
    {"name": "Aron Peterson", "group": "A"},
    {"name": "Brothers Together (15)", "group": "B"},
    {"name": "Bliz Stack", "group": "B"},
    {"name": "Brad David", "group": "B"},
    {"name": "Charles Smith", "group": "C"},
    {"name": "Chuck Stack", "group": "C"},
  ];

  FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Friends", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  Icon(Icons.group_add, color: Colors.white),
                ],
              ),
            ),

            // Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  tabItem(Icons.group, "My Friends", true),
                  tabItem(Icons.person_add_alt, "Friend Request", false),
                  tabItem(Icons.message, "Messages", false),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search friend",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),

            // Friend List
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final f = friends[index];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.orangeAccent, child: Text(f["name"]![0])),
                    title: Text(f["name"]!),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text("Message"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Photos'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add New'),
        ],
      ),
    );
  }

  Widget tabItem(IconData icon, String title, bool active) {
    return Column(
      children: [
        Icon(icon, color: active ? Colors.orange : Colors.grey),
        Text(
          title,
          style: TextStyle(color: active ? Colors.orange : Colors.grey, fontWeight: active ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
