import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/group.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class RatingVisibilityScreen extends StatefulWidget {
  final bool initialIsPublic;
  final List<String> initialGroupIds;

  const RatingVisibilityScreen({
    super.key,
    required this.initialIsPublic,
    required this.initialGroupIds,
  });

  @override
  State<RatingVisibilityScreen> createState() => _RatingVisibilityScreenState();
}

class _RatingVisibilityScreenState extends State<RatingVisibilityScreen> {
  late bool _isPublic;
  late Set<String> _selectedGroupIds;
  late Future<List<Group>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _isPublic = widget.initialIsPublic;
    _selectedGroupIds = widget.initialGroupIds.toSet();
    _groupsFuture = DbClient.fetchCurrentUserGroups();
  }

  void _goBackWithConfig() {
    context.router.maybePop({
      'isPublic': _isPublic,
      'groupIds': _selectedGroupIds.toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(
        title: 'Viditelnost hodnocení',
        onBack: _goBackWithConfig,
      ),
      body: Padding(
        padding: const EdgeInsets.all(UhoPadding.medium),
        child: Column(
          children: [
            Card(
              color: UhoColor.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Veřejné hodnocení',
                  style: TextStyle(color: UhoColor.text1),
                ),
                subtitle: const Text(
                  'Bude viditelné mimo skupiny',
                  style: TextStyle(color: UhoColor.text2),
                ),
                value: _isPublic,
                activeThumbColor: UhoColor.highlight,
                inactiveThumbColor: UhoColor.card,
                inactiveTrackColor: UhoColor.background,
                onChanged: (value) => setState(() => _isPublic = value),
              ),
            ),
            const SizedBox(height: UhoPadding.medium),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sdílet do skupin',
                style: TextStyle(
                  color: UhoColor.text1,
                  fontSize: UhoFontSize.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: UhoPadding.small),
            Expanded(
              child: FutureBuilder<List<Group>>(
                future: _groupsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Chyba při načítání skupin: ${snapshot.error}'),
                    );
                  }

                  final groups = snapshot.data ?? [];
                  if (groups.isEmpty) {
                    return const Center(
                      child: Text('Nejste členem žádné skupiny.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final isSelected = _selectedGroupIds.contains(group.id);

                      return Card(
                        color: UhoColor.card,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          activeColor: UhoColor.highlight,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedGroupIds.add(group.id);
                              } else {
                                _selectedGroupIds.remove(group.id);
                              }
                            });
                          },
                          title: Text(
                            group.name,
                            style: const TextStyle(color: UhoColor.text1),
                          ),
                          subtitle: Text(
                            '${group.memberCount} členů',
                            style: const TextStyle(color: UhoColor.text2),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}