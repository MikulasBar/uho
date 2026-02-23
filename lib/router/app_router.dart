import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:uho/models/dish.dart';

import 'package:uho/screens/dishes_screen/dishes_screen.dart';
import 'package:uho/screens/canteens_screen/canteens_screen.dart';
import 'package:uho/screens/groups_screen/groups_screen.dart';
import 'package:uho/screens/friends_screen/friends_screen.dart';
import 'package:uho/screens/dish_ratings_screen/dish_ratings_screen.dart';
import 'package:uho/screens/settings_screen/settings_screen.dart';
import 'package:uho/screens/new_dish_rating_screen/new_dish_rating_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: DishesRoute.page, initial: true),
    AutoRoute(page: CanteensRoute.page),
    AutoRoute(page: GroupsRoute.page),
    AutoRoute(page: FriendsRoute.page),
    AutoRoute(page: DishRatingsRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: NewDishRatingRoute.page),
  ];
}