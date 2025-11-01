import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PhotosScreen(),
  ));
}

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // 🔶 Top Orange AppBar Section
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left App Logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "A",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 22),
                  ),
                ),
              ),

              const Text(
                "Photos",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),

              // Profile Picture
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=12"), // random avatar
              ),
            ],
          ),
        ),
      ),

      // 🔷 Body Section
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "ADD PHOTOS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                  const Divider(height: 25, color: Colors.grey),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildPhotoOption(Icons.camera_alt, "Mobile\nCamera"),
                      _buildPhotoOption(Icons.photo_library, "Phone\nGallery"),
                      _buildPhotoOption(
                          Icons.photo_album, "Amulette Photos\nLibrary"),
                      _buildPhotoOption(
                          Icons.auto_awesome, "Generate\nAI Image"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔻 Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bottomIcon(Icons.favorite, "Favorite", false),
            _bottomIcon(Icons.photo, "Photos", true),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Text(
                "A",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 22),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _bottomIcon(Icons.people, "Friends", false),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Text("3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            _bottomIcon(Icons.add, "Add New", false),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget for Photo Option
  Widget _buildPhotoOption(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: 35),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Bottom Icon Widget
  Widget _bottomIcon(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.orange : Colors.grey, size: 26),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.orange : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
