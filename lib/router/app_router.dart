import 'package:auto_route/auto_route.dart';
import 'package:uho/screens/dishes_screen/dishes_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: DishesRoute.page, initial: true),
  ];
}