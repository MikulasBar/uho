import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/dish_rating.dart';
import 'package:uho/models/group.dart';
import 'package:uho/widgets/dish_rating_card/dish_rating_card.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class GroupDishRatingsScreen extends StatelessWidget {
  final Group group;

  const GroupDishRatingsScreen({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(
        title: 'Recenze jídel',
        onBack: () => context.router.maybePop(),
      ),
      body: FutureBuilder<List<DishRating>>(
        future: DbClient.fetchGroupDishRatings(group.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Chyba při načítání hodnocení: ${snapshot.error}'));
          }

          final ratings = snapshot.data ?? [];
          if (ratings.isEmpty) {
            return const Center(
              child: Text(
                'Ve skupině zatím nejsou žádné recenze jídel.',
                style: TextStyle(fontSize: UhoFontSize.medium),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: UhoPadding.small),
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              return DishRatingCard(rating: ratings[index]);
            },
          );
        },
      ),
    );
  }
}