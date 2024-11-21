import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../menu/time_converter_popup.dart';
import 'package:http/http.dart' as http;
import 'package:pesanmakan/models/user_model.dart';
import 'package:pesanmakan/screens/login_screen.dart';
import 'dart:convert';
import '../menu/category_meals_screen.dart';
import 'pesan_dan_kesan_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _categories = data['categories'] ?? [];
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat kategori');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToCategoryMeals(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryMealsScreen(category: category),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showTimeConverter() {
    showDialog(
      context: context,
      builder: (context) => const TimeConverterPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 120,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/resto.jpeg'), // Ganti dengan path gambar Anda
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 120,
                color: Colors.black.withOpacity(0.3), // Overlay gelap untuk kontras teks
                alignment: Alignment.center,
                child: Text(
                  'Quick Bites',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 180, 145, 28),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          color: const Color.fromARGB(255, 58, 90, 130),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                category['strCategoryThumb'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              category['strCategory'],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            subtitle: Text(category['strCategoryDescription'] ??
                                'Tidak ada deskripsi', style: const TextStyle(color: Colors.white),),
                            onTap: () {
                              _navigateToCategoryMeals(category['strCategory']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      Column(
  children: [
    Stack(
      children: [
        // Layer pertama: Gambar background
        Container(
          width: double.infinity,
          height: 120,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/resto.jpeg'), // Ganti dengan path gambar Anda
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Layer kedua: Overlay gelap
        Container(
          width: double.infinity,
          height: 120,
          color: Colors.black.withOpacity(0.3), // Overlay untuk kontras teks
        ),
        // Layer ketiga: Teks
        Positioned.fill(
          child: Center(
            child: Text(
              'Pesan & Kesan', // Teks pengganti 'Quick Bites'
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 180, 145, 28), // Warna teks
              ),
            ),
          ),
        ),
      ],
    ),
    // Expanded untuk konten lainnya
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PesanDanKesanScreen(), // Konten utama di bawah header
      ),
    ),
  ],
),
      Column(
  children: [
    Stack(
      children: [
        // Layer pertama: Gambar background
        Container(
          width: double.infinity,
          height: 120,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/resto.jpeg'), // Ganti dengan path gambar Anda
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Layer kedua: Overlay gelap
        Container(
          width: double.infinity,
          height: 120,
          color: Colors.black.withOpacity(0.3), // Overlay untuk kontras teks
        ),
        // Layer ketiga: Teks
        Positioned.fill(
          child: Center(
            child: Text(
              'Profile', // Teks pengganti 'Quick Bites'
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 180, 145, 28), // Warna teks
              ),
            ),
          ),
        ),
      ],
    ),
    // Expanded untuk konten lainnya
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProfileScreen(), // Konten utama di bawah header
      ),
    ),
  ],
)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hi, ${widget.user.username}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 64, 102),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: _showTimeConverter,
            color: Colors.white,
            iconSize: 30,
            tooltip: 'Konversi Waktu',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            color: Colors.white,
            iconSize: 30,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Pesan & Kesan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 180, 145, 28),
        unselectedItemColor: const Color(0xFFF9F2ED),
        backgroundColor: const Color.fromARGB(255, 39, 64, 102),
      ),
    );
  }
}
