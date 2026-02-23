import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/models/dish.dart';
import 'package:uho/models/dish_global_rating.dart';
import 'package:uho/router/app_router.dart';

class DishGlobalRatingCard extends StatelessWidget {
  final Dish dish;
  final DishGlobalRating rating;

  const DishGlobalRatingCard({super.key, required this.dish, required this.rating});

  @override
  Widget build(BuildContext context) {
    const double starSize = 24;

    Widget buildStars(double value) {
      List<Widget> stars = [];
      for (int i = 1; i <= 5; i++) {
        if (value >= i) {
          stars.add(const Icon(Icons.star, color: UhoColor.highlight, size: starSize));
        } else if (value > i - 1 && value < i) {
          stars.add(const Icon(Icons.star_half, color: UhoColor.highlight, size: starSize));
        } else {
          stars.add(const Icon(Icons.star_border, color: UhoColor.background, size: starSize));
        }
      }
      return Row(children: stars);
    }

    Widget buildRow(String label, double? value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: UhoPadding.verySmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: UhoColor.text1)),
            value == null
                ? const Text(
                    'Nehodnoceno',
                    style: TextStyle(color: UhoColor.text2),
                  )
                : buildStars(value),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UhoPadding.small),
      child: InkWell(
        borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
        onTap: () {
          context.router.push(DishRatingsRoute(dish: dish)); // push the ratings screen
        },
        child: Card(
          color: UhoColor.card,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UhoCornerRadius.medium)),
          child: Padding(
            padding: const EdgeInsets.all(UhoPadding.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: UhoFontSize.small,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${rating.ratingsCount} recenzí',
                      style: const TextStyle(
                        color: UhoColor.text2,
                        fontSize: UhoFontSize.small,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UhoPadding.medium),
                buildRow('Celkové hodnocení', rating.overallRating),
                buildRow('Chuť', rating.tasteRating),
                buildRow('Velikost porce', rating.portionSizeRating),
              ],
            ),
          ),
        ),
      ),
    );
  }
}