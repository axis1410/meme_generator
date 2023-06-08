import 'package:flutter/material.dart';
import 'package:meme_generator/landing_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var status = await Permission.photos.status;
  if (status.isDenied) {
    status = await Permission.photos.request();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Meme Generator',
      home: const LandingPage(),
    );
  }
}
