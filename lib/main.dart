import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redidit Clone',
      theme: Pallete.darkModeAppTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello Reddit'),
        ),
      ),
    );
  }
}
