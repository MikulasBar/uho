import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/utilities.dart';
import 'package:uho/models/dish_rating.dart';


class DishRatingCard extends StatelessWidget {
  final DishRating rating;

  const DishRatingCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UhoPadding.small, vertical: UhoPadding.verySmall),
      child: InkWell(
        borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: UhoColor.background,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(UhoCornerRadius.huge)),
            ),
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.65,
                child: _buildBottomSheet(context),
              );
            }
          );
        },
        child: Card(
          color: UhoColor.card,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UhoCornerRadius.medium)),
          child: Padding(
            padding: const EdgeInsets.all(UhoPadding.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rating.userName,
                      style: const TextStyle(
                        color: UhoColor.text1,
                      ),
                    ),
                    Text(
                      '${rating.userRatingCount ?? 0} recenzí',
                      style: const TextStyle(color: UhoColor.text2),
                    ),
                  ],
                ),
                const SizedBox(height: UhoPadding.small),
                buildStars(rating.overallRating, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: UhoPadding.medium,
        left: UhoPadding.medium,
        right: UhoPadding.medium,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(UhoPadding.medium),
              decoration: BoxDecoration(
                color: UhoColor.card,
                borderRadius: BorderRadius.circular(UhoCornerRadius.huge),
              ),
              child: Text(
                rating.userName,
                style: const TextStyle(
                  fontSize: UhoFontSize.big,
                  color: UhoColor.text1,
                ),
              ),
            ),
            const SizedBox(height: UhoPadding.medium),

            _buildRatingRow('Celkové hodnoceni', rating.overallRating),
            _buildRatingRow('Chut', rating.tasteRating),
            _buildRatingRow('Velikost porce', rating.portionSizeRating),

            if (rating.description.isNotEmpty) ...[
              const SizedBox(height: UhoPadding.medium),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(UhoPadding.medium),
                decoration: BoxDecoration(
                  color: UhoColor.card,
                  borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
                ),
                child: Text(
                  rating.description,
                  style: const TextStyle(color: UhoColor.text1),
                ),
              ),
            ],

            const SizedBox(height: UhoPadding.big),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, double value) {
    return Container(
      padding: const EdgeInsets.all(UhoPadding.small),
      margin: const EdgeInsets.symmetric(vertical: UhoPadding.verySmall),
      decoration: BoxDecoration(
        color: UhoColor.card,
        borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UhoPadding.verySmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: UhoColor.text1)),
            buildStars(value, size: 24),
          ],
        ),
      ),
    );
  }
}