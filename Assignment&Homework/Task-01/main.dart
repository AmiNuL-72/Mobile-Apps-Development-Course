import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // controllers
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final regController = TextEditingController();
  final deptController = TextEditingController();
  final batchController = TextEditingController();
  final dobController = TextEditingController();
  final distController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String gender = "Male";
  String? profileImagePath;
  String? coverImagePath;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 🧠 SharedPreferences থেকে ডেটা লোড
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      rollController.text = prefs.getString('roll') ?? '';
      regController.text = prefs.getString('reg') ?? '';
      deptController.text = prefs.getString('dept') ?? '';
      batchController.text = prefs.getString('batch') ?? '';
      dobController.text = prefs.getString('dob') ?? '';
      distController.text = prefs.getString('dist') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      gender = prefs.getString('gender') ?? 'Male';
      profileImagePath = prefs.getString('profile');
      coverImagePath = prefs.getString('cover');
    });
  }

  // 💾 ডেটা সেভ
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('roll', rollController.text);
    await prefs.setString('reg', regController.text);
    await prefs.setString('dept', deptController.text);
    await prefs.setString('batch', batchController.text);
    await prefs.setString('dob', dobController.text);
    await prefs.setString('dist', distController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('gender', gender);
    if (profileImagePath != null)
      await prefs.setString('profile', profileImagePath!);
    if (coverImagePath != null) await prefs.setString('cover', coverImagePath!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );
  }

  // 🖼️ ইমেজ বাছাই
  Future<void> pickImage(bool isCover) async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      if (isCover) {
        coverImagePath = img.path;
      } else {
        profileImagePath = img.path;
      }
    });
  }

  // 📅 তারিখ বাছাই
  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: DateTime(2025),
    );
    if (date != null) {
      dobController.text = "${date.day}/${date.month}/${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🖼️ Cover + Profile Section
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => pickImage(true),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.deepPurple.shade100,
                    child: coverImagePath == null
                        ? const Icon(Icons.camera_alt,
                            size: 50, color: Colors.deepPurple)
                        : Image.file(File(coverImagePath!), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  child: GestureDetector(
                    onTap: () => pickImage(false),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: profileImagePath != null
                          ? FileImage(File(profileImagePath!))
                          : null,
                      child: profileImagePath == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.deepPurple)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // 🔤 Info fields
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildTextField("Full Name", nameController),
                  buildTextField("Class Roll", rollController),
                  buildTextField("Registration No", regController),
                  buildTextField("Department", deptController),
                  buildTextField("Batch", batchController),
                  buildTextField("Date of Birth", dobController,
                      isDate: true, onTap: pickDate),
                  buildTextField("Home District", distController),
                  buildTextField("Phone", phoneController,
                      keyboard: TextInputType.phone),
                  buildTextField("Email", emailController,
                      keyboard: TextInputType.emailAddress),
                  const SizedBox(height: 10),

                  // 🧍 Gender Dropdown
                  DropdownButtonFormField(
                    value: gender,
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (v) => setState(() => gender = v!),
                  ),
                  const SizedBox(height: 30),

                  // 💾 Save Button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: saveData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isDate = false, VoidCallback? onTap, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: isDate,
        onTap: onTap,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
