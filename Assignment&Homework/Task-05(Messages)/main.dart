import 'package:flutter/material.dart';

void main() => runApp(const MessagesApp());

class MessagesApp extends StatelessWidget {
  const MessagesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessagesScreen(),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {"name": "John Smith", "time": "Just Now"},
    {"name": "Aron Peterson", "time": "4 min ago"},
    {"name": "Brothers Together (15)", "time": "12 Jun, 2023 7:30am"},
    {"name": "Charles Smith", "time": "12 Jun, 2023 7:30am"},
    {"name": "Brad Al Hasan", "time": "12 Jun, 2023 7:30am"},
    {"name": "Chuck Stack", "time": "12 Jun, 2023 7:30am"},
    {"name": "David Mall", "time": "12 Jun, 2023 7:30am"},
  ];

  MessagesScreen({super.key});

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
                  Text("Messages",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
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
                  tabItem(Icons.group, "My Friends", false),
                  tabItem(Icons.person_add_alt, "Friend Request", false),
                  tabItem(Icons.message, "Messages", true),
                ],
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search friend",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final m = messages[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(m["name"]![0])),
                    title: Text(m["name"]!),
                    trailing: Text(m["time"]!,
                        style: const TextStyle(color: Colors.grey)),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorite'),
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
          style: TextStyle(
              color: active ? Colors.orange : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
