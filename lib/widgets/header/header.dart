import 'package:flutter/material.dart';
import 'package:uho/core/theme.dart';

class UhoHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  static PreferredSize preferredSize({required String title, VoidCallback? onBack}) {
    return PreferredSize(preferredSize: Size.fromHeight(80), child: UhoHeader(title: title, onBack: onBack));
  }

  const UhoHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: UhoColor.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UhoCornerRadius.huge),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(
        UhoPadding.big, // left
      ),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: UhoFontSize.big),
              ),
            ),
            if (onBack != null)
              Positioned(
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
