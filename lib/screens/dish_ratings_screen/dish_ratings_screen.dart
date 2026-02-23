
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/dish.dart';
import 'package:uho/models/dish_rating.dart';
import 'package:uho/router/app_router.dart';
import 'package:uho/widgets/bottom_bar/bottom_bar.dart';
import 'package:uho/widgets/dish_rating_card/dish_rating_card.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class DishRatingsScreen extends StatelessWidget {
  final Dish dish;

  const DishRatingsScreen({super.key, required this.dish});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(title: dish.name, onBack: () => context.router.pop()),
      body: FutureBuilder<List<DishRating>>(
        future: DbClient.fetchDishRatings(dish.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Žádné hodnocení není k dispozici.', style: TextStyle(fontSize: UhoFontSize.medium)));
          } else {
            final ratings = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: UhoPadding.small),
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final rating = ratings[index];
                return DishRatingCard(rating: rating);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        context.router.push(
          NewDishRatingRoute(dish: dish), // your route to new screen
        );
      },
      backgroundColor: UhoColor.card,
      child: const Icon(Icons.add, color: UhoColor.highlight),
    ),
      bottomNavigationBar: UhoBottomBar(),
    );
  }
}