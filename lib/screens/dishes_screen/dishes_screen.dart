import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class DishesScreen extends StatelessWidget {
  const DishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(title: "Dishes"),
      body: Center(child: Text('Hello UHO!')),
    );
  }
}
