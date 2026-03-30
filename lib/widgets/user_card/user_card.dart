import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/models/profile.dart';

class UserCard extends StatelessWidget {
  final Profile profile;
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final bool isEnabled;

  const UserCard({
    super.key,
    required this.profile,
    required this.isSelected,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UhoPadding.small,
        vertical: UhoPadding.verySmall,
      ),
      child: Card(
        color: UhoColor.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
        ),
        child: InkWell(
          onTap: isEnabled ? () => onChanged(!isSelected) : null,
          borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
          child: Padding(
            padding: const EdgeInsets.all(UhoPadding.medium),
            child: Row(
              children: [
                Checkbox(
                  activeColor: UhoColor.highlight,
                  value: isSelected,
                  onChanged: isEnabled ? (bool? value) => onChanged(value ?? false) : null,
                ),
                Expanded(
                  child: Text(
                    profile.username,
                    style: const TextStyle(
                      color: UhoColor.text1,
                      fontSize: UhoFontSize.medium,
                    ),
                  ),
                ),
                Text(
                  '${profile.ratingsCount} recenzí',
                  style: const TextStyle(
                    color: UhoColor.text2,
                    fontSize: UhoFontSize.small,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
