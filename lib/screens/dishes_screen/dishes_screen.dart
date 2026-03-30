import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/dish.dart';
import 'package:uho/models/dish_global_rating.dart';
import 'package:uho/widgets/bottom_bar/bottom_bar.dart';
import 'package:uho/widgets/dish_global_rating_card/dish_global_rating_card.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class DishesScreen extends StatefulWidget {
  const DishesScreen({super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  late Future<List<(Dish, DishGlobalRating)>> _ratingsFuture;

  @override
  void initState() {
    super.initState();
    _ratingsFuture = DbClient.fetchGlobalRatings(limit: 10);
  }

  Future<void> _refreshDishes() async {
    setState(() {
      _ratingsFuture = DbClient.fetchGlobalRatings(limit: 10);
    });
    await _ratingsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(title: "Jídla"),
      body: RefreshIndicator(
        onRefresh: _refreshDishes,
        child: FutureBuilder<List<(Dish, DishGlobalRating)>>(
          future: _ratingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 200),
                  Center(child: Text('Error: ${snapshot.error}')),
                ],
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      'Žádné hodnocení není k dispozici.',
                      style: TextStyle(fontSize: UhoFontSize.medium),
                    ),
                  ),
                ],
              );
            } else {
              final ratings = snapshot.data!;
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  return DishGlobalRatingCard(
                    dish: ratings[index].$1,
                    rating: ratings[index].$2,
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: UhoBottomBar(),
    );
  }
}
