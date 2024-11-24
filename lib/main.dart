import "package:fabric/pages/counter/counter.dart";
import 'package:flutter/material.dart';
import "package:get_storage/get_storage.dart";

void main() async {
  await GetStorage.init('counter');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        home: const Scaffold(body: Counter()));
  }
}
