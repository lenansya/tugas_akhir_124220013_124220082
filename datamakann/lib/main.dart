import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pesanmakan/screens/login_screen.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Inisialisasi Hive
  Hive.registerAdapter(UserAdapter()); // Registrasi adapter User
  await Hive.openBox<User>('users'); // Membuka box 'users'

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Makan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(), // Mengatur LoginScreen sebagai layar utama
    );
  }
}
