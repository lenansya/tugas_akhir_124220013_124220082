import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, String>> profiles = [
    {
      'profileImage': 'assets/foto.jpg',
      'name': 'Ahmad Faiq Syah Putra',
      'nim': '124220013',
      'email': 'williamputra@gmail.com',
    },
    {
      'profileImage': 'assets/foto.jpg',
      'name': 'Lenansya Ersa Salsabila',
      'nim': '124220082',
      'email': 'lenansyaersas@gmail.com',
    },
  ];

  void _addProfile() {
    setState(() {
      profiles.add({
        'profileImage': 'assets/images/logo.png',
        'name': '',
        'nim': '',
        'email': '',
      });
    });
  }

  void _deleteAllProfiles() {
    setState(() {
      profiles.clear();
    });
  }

  void _editProfile(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController =
            TextEditingController(text: profiles[index]['name']);
        final nimController =
            TextEditingController(text: profiles[index]['nim']);
        final emailController =
            TextEditingController(text: profiles[index]['email']);

        return AlertDialog(
          title: const Text("Edit Profil"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(profiles[index]['profileImage']!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                TextField(
                  controller: nimController,
                  decoration: const InputDecoration(labelText: "NIM"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  profiles[index]['name'] = nameController.text;
                  profiles[index]['nim'] = nimController.text;
                  profiles[index]['email'] = emailController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _deleteProfile(int index) {
    setState(() {
      profiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < profiles.length; i++)
                        Card(
                          color: const Color.fromARGB(255, 58, 90, 130),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage(profiles[i]['profileImage']!),
                                  radius: 50,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profiles[i]['name']!.isNotEmpty
                                            ? profiles[i]['name']!
                                            : "Nama belum diisi",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        profiles[i]['nim']!.isNotEmpty
                                            ? profiles[i]['nim']!
                                            : "NIM belum diisi",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        profiles[i]['email']!.isNotEmpty
                                            ? profiles[i]['email']!
                                            : "Email belum diisi",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      onPressed: () => _editProfile(i),
                                      icon: const Icon(Icons.edit),
                                      tooltip: "Edit Profil ${i + 1}",
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteProfile(i),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      tooltip: "Hapus Profil ${i + 1}",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _deleteAllProfiles,
            heroTag: "deleteAll",
            backgroundColor: const Color.fromARGB(255, 58, 90, 130),
            tooltip: "Hapus Semua Profil",
            child: const Icon(Icons.delete, color: Colors.white,),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _addProfile,
            heroTag: "addProfile",
            backgroundColor: const Color.fromARGB(255, 58, 90, 130),
            tooltip: "Tambah Profil Baru",
            child: const Icon(Icons.add, color: Colors.white,),
          ),
        ],
      ),
    );
  }
}
