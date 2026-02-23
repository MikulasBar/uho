import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/providers/auth_provider.dart';
import 'package:uho/widgets/bottom_bar/bottom_bar.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: UhoHeader.preferredSize(title: "Nastavení"),
      body: ListView(
        padding: const EdgeInsets.all(UhoPadding.medium),
        children: [
          Container(
            padding: const EdgeInsets.all(UhoPadding.medium),
            decoration: BoxDecoration(
              color: UhoColor.card,
              borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  auth.isLoggedIn ? auth.username : "Nejste přihlášeni",
                  style: const TextStyle(
                    fontSize: UhoFontSize.big,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: UhoPadding.small),
                if (auth.isLoggedIn)
                  Text(
                    auth.user?.email ?? "",
                    style: const TextStyle(color: UhoColor.text2),
                  ),
              ],
            ),
          ),

          const SizedBox(height: UhoPadding.medium),

          if (!auth.isLoggedIn)
            ElevatedButton(
              onPressed: () => auth.signInWithGoogle(),
              child: const Text("Sign in with Google"),
            ),

          if (auth.isLoggedIn)
            ElevatedButton(
              onPressed: () => auth.signOut(),
              child: const Text("Logout"),
            ),
        ],
      ),
      bottomNavigationBar: UhoBottomBar(),
    );
  }
}
