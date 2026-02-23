

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/router/app_router.dart';

class UhoBottomBar extends StatelessWidget {
  const UhoBottomBar({super.key});

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 26,
        color: isActive ? UhoColor.highlight : UhoColor.background,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = context.router.root;
    final currentRoute = router.topRoute.name;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: UhoPadding.medium,
        vertical: UhoPadding.big,
      ),
      child: Card(
        color: UhoColor.card,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UhoCornerRadius.huge),
        ),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(
                context,
                icon: Icons.lunch_dining,
                isActive: currentRoute == DishesRoute.name,
                onTap: () => router.replaceAll([const DishesRoute()]),
              ),
              _item(
                context,
                icon: Icons.restaurant,
                isActive: currentRoute == CanteensRoute.name,
                onTap: () => router.replaceAll([const CanteensRoute()]),
              ),
              _item(
                context,
                icon: Icons.groups,
                isActive: currentRoute == GroupsRoute.name,
                onTap: () => router.replaceAll([const GroupsRoute()]),
              ),
              _item(
                context,
                icon: Icons.person,
                isActive: currentRoute == FriendsRoute.name,
                onTap: () => router.replaceAll([const FriendsRoute()]),
              ),
              _item(
                context,
                icon: Icons.settings,
                isActive: currentRoute == SettingsRoute.name,
                onTap: () => router.replaceAll([const SettingsRoute()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}