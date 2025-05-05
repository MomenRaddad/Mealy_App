import 'package:flutter/material.dart';

class PrototypeAdminScreen extends StatelessWidget {
  const PrototypeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Prototype')),
      body: Center(child: Text('This is a prototype admin screen.')),
    );
  }
}
