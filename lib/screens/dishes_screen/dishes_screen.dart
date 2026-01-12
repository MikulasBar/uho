import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DishesScreen extends StatelessWidget {
  const DishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Hello UHO!')));
  }
}
