import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:uho/widgets/bottom_bar/bottom_bar.dart';

@RoutePage()
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Groups screen"),
      bottomNavigationBar: UhoBottomBar(),
    );
  }
}
