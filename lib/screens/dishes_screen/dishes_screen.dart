import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/dish_global_rating.dart';
import 'package:uho/widgets/bottom_bar/bottom_bar.dart';
import 'package:uho/widgets/dish_global_rating_card/dish_global_rating_card.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class DishesScreen extends StatelessWidget {
  const DishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(title: "Dishes"),
      // body: Container(
      //   color: Colors.white,
      //   child: ListView(
      //     children: List.generate(
      //       10,
      //       (i) => const Text(
      //         'VISIBLE',
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //   ),
      // ),
      body: FutureBuilder<List<DishGlobalRating>>(
        future: DbClient.fetchGlobalRatings(limit: 10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ratings available.', style: TextStyle(fontSize: UhoFontSize.medium)));
          } else {
            final ratings = snapshot.data!;
            print(ratings.length);
            return ListView.builder(
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                return DishGlobalRatingCard(rating: ratings[index]);
              },
            );
          }
        },
      ),
      bottomNavigationBar: UhoBottomBar(),
    );
  }
}
