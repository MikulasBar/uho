import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:uho/widgets/bottom_bar/bottom_bar.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class CanteensScreen extends StatelessWidget {
  const CanteensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(title: "Jídelny"),
      body: Text("TODO"),
      bottomNavigationBar: UhoBottomBar(),
    );
  }
}
