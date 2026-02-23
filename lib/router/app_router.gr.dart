// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CanteensScreen]
class CanteensRoute extends PageRouteInfo<void> {
  const CanteensRoute({List<PageRouteInfo>? children})
    : super(CanteensRoute.name, initialChildren: children);

  static const String name = 'CanteensRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CanteensScreen();
    },
  );
}

/// generated route for
/// [DishRatingsScreen]
class DishRatingsRoute extends PageRouteInfo<DishRatingsRouteArgs> {
  DishRatingsRoute({
    Key? key,
    required Dish dish,
    List<PageRouteInfo>? children,
  }) : super(
         DishRatingsRoute.name,
         args: DishRatingsRouteArgs(key: key, dish: dish),
         initialChildren: children,
       );

  static const String name = 'DishRatingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DishRatingsRouteArgs>();
      return DishRatingsScreen(key: args.key, dish: args.dish);
    },
  );
}

class DishRatingsRouteArgs {
  const DishRatingsRouteArgs({this.key, required this.dish});

  final Key? key;

  final Dish dish;

  @override
  String toString() {
    return 'DishRatingsRouteArgs{key: $key, dish: $dish}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DishRatingsRouteArgs) return false;
    return key == other.key && dish == other.dish;
  }

  @override
  int get hashCode => key.hashCode ^ dish.hashCode;
}

/// generated route for
/// [DishesScreen]
class DishesRoute extends PageRouteInfo<void> {
  const DishesRoute({List<PageRouteInfo>? children})
    : super(DishesRoute.name, initialChildren: children);

  static const String name = 'DishesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DishesScreen();
    },
  );
}

/// generated route for
/// [FriendsScreen]
class FriendsRoute extends PageRouteInfo<void> {
  const FriendsRoute({List<PageRouteInfo>? children})
    : super(FriendsRoute.name, initialChildren: children);

  static const String name = 'FriendsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FriendsScreen();
    },
  );
}

/// generated route for
/// [GroupsScreen]
class GroupsRoute extends PageRouteInfo<void> {
  const GroupsRoute({List<PageRouteInfo>? children})
    : super(GroupsRoute.name, initialChildren: children);

  static const String name = 'GroupsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GroupsScreen();
    },
  );
}

/// generated route for
/// [NewDishRatingScreen]
class NewDishRatingRoute extends PageRouteInfo<NewDishRatingRouteArgs> {
  NewDishRatingRoute({
    Key? key,
    required Dish dish,
    List<PageRouteInfo>? children,
  }) : super(
         NewDishRatingRoute.name,
         args: NewDishRatingRouteArgs(key: key, dish: dish),
         initialChildren: children,
       );

  static const String name = 'NewDishRatingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewDishRatingRouteArgs>();
      return NewDishRatingScreen(key: args.key, dish: args.dish);
    },
  );
}

class NewDishRatingRouteArgs {
  const NewDishRatingRouteArgs({this.key, required this.dish});

  final Key? key;

  final Dish dish;

  @override
  String toString() {
    return 'NewDishRatingRouteArgs{key: $key, dish: $dish}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NewDishRatingRouteArgs) return false;
    return key == other.key && dish == other.dish;
  }

  @override
  int get hashCode => key.hashCode ^ dish.hashCode;
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}
