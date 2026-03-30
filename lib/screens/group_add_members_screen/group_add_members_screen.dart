import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/group.dart';
import 'package:uho/models/profile.dart';
import 'package:uho/widgets/header/header.dart';
import 'package:uho/widgets/user_card/user_card.dart';

@RoutePage()
class GroupAddMembersScreen extends StatefulWidget {
  final Group group;

  const GroupAddMembersScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupAddMembersScreen> createState() => _GroupAddMembersScreenState();
}

class _GroupAddMembersScreenState extends State<GroupAddMembersScreen> {
  late Future<List<Profile>> _usersFuture;
  final Set<String> _selectedUserIds = {};
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadAvailableUsers();
  }

  Future<List<Profile>> _loadAvailableUsers() async {
    final allUsers = await DbClient.fetchUsers();
    final currentMembers = await DbClient.fetchGroupMembers(
      widget.group.id,
      includeUserIds: [widget.group.ownerId],
    );

    final memberIds = currentMembers.map((m) => m.userId).toSet();
    return allUsers.where((u) => !memberIds.contains(u.userId)).toList()
      ..sort((a, b) => a.username.compareTo(b.username));
  }

  Future<void> _addSelectedMembers() async {
    if (_selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vyberte alespoň jednoho uživatele.')),
      );
      return;
    }

    setState(() {
      _isAdding = true;
    });

    try {
      await DbClient.addUsersToGroup(
        groupId: widget.group.id,
        userIds: _selectedUserIds.toList(),
      );

      if (mounted) {
        context.router.maybePop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nepodařilo se přidat členy: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(
        title: 'Přidat členy',
        onBack: () => context.router.maybePop(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(UhoPadding.medium),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Profile>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Chyba při načítání uživatelů: ${snapshot.error}'),
                    );
                  }

                  final users = snapshot.data ?? [];
                  if (users.isEmpty) {
                    return const Center(
                      child: Text('Nejsou dostupní žádní uživatelé k přidání.'),
                    );
                  }

                  return ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final profile = users[index];
                      final isSelected = _selectedUserIds.contains(profile.userId);

                      return UserCard(
                        profile: profile,
                        isSelected: isSelected,
                        isEnabled: !_isAdding,
                        onChanged: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedUserIds.add(profile.userId);
                            } else {
                              _selectedUserIds.remove(profile.userId);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: UhoPadding.medium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAdding ? null : _addSelectedMembers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: UhoColor.highlight,
                  disabledBackgroundColor: UhoColor.card,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isAdding
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        'Přidat',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}