import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/models/group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UhoPadding.small,
        vertical: UhoPadding.verySmall,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
        onTap: onTap,
        child: Card(
          color: UhoColor.card,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
          ),
          child: Padding(
            padding: const EdgeInsets.all(UhoPadding.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      color: UhoColor.text1,
                      fontSize: UhoFontSize.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: UhoPadding.small),
                Text(
                  '${group.memberCount} členů',
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