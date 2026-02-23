
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/core/utilities.dart';
import 'package:uho/models/dish.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class NewDishRatingScreen extends StatefulWidget {
  final Dish dish;
  const NewDishRatingScreen({super.key, required this.dish});

  @override
  State<NewDishRatingScreen> createState() => _NewDishRatingScreenState();
}

class _NewDishRatingScreenState extends State<NewDishRatingScreen> {
  double overall = 0;
  double taste = 0;
  double portion = 0;
  final TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  void _publishRating() async {
    setState(() => loading = true);

    try {
      await DbClient.insertDishRating(
        dishId: widget.dish.id,
        overallRating: overall,
        tasteRating: taste,
        portionSizeRating: portion,
        description: descriptionController.text,
      );
      context.router.pop(true); // return to previous screen
    } catch (e) {
      print("Error publishing rating: $e");
      setState(() => loading = false);
    }
  }

  Widget _ratingRow(String label, double value, ValueChanged<double> onChanged) {
    return Card(
      color: UhoColor.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UhoPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: UhoPadding.small),
            Slider(
              value: value,
              onChanged: onChanged,
              min: 0,
              max: 5,
              divisions: 10,
              activeColor: UhoColor.highlight,
              inactiveColor: UhoColor.background,
              label: value.toStringAsFixed(1),
            ),
            buildStars(value, size: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(title: widget.dish.name, onBack: () => context.router.pop()),
      body: ListView(
        padding: const EdgeInsets.all(UhoPadding.medium),
        children: [
          _ratingRow("Celkové hodnocení", overall, (v) => setState(() => overall = v)),
          _ratingRow("Chuť", taste, (v) => setState(() => taste = v)),
          _ratingRow("Velikost porce", portion, (v) => setState(() => portion = v)),
          Card(
            color: UhoColor.card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UhoCornerRadius.medium)),
            child: Padding(
              padding: const EdgeInsets.all(UhoPadding.medium),
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                style: const TextStyle(color: UhoColor.text1),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Popis (volitelně)",
                  hintStyle: TextStyle(color: UhoColor.text2),
                ),
              ),
            ),
          ),
          const SizedBox(height: UhoPadding.medium),
          ElevatedButton(
            onPressed: loading ? null : _publishRating,
            style: ElevatedButton.styleFrom(
              backgroundColor: UhoColor.highlight,
              foregroundColor: UhoColor.text1,
              padding: const EdgeInsets.symmetric(vertical: UhoPadding.medium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Publish Rating"),
          ),
        ],
      ),
    );
  }
}