import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncx/screens/provisioning_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Provisioning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProvisioningScreen(),
    );
  }
}
