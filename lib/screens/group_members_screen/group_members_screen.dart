import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/group.dart';
import 'package:uho/models/profile.dart';
import 'package:uho/providers/auth_provider.dart';
import 'package:uho/router/app_router.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class GroupMembersScreen extends StatefulWidget {
  final Group group;

  const GroupMembersScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  late Future<List<Profile>> _membersFuture;
  bool _isProcessing = false;

  List<String> _requiredUserIds(String? currentUserId) {
    final ids = <String>{widget.group.ownerId};
    if (currentUserId != null && currentUserId.isNotEmpty) {
      ids.add(currentUserId);
    }
    return ids.toList();
  }

  @override
  void initState() {
    super.initState();
    final currentUserId = context.read<AuthProvider>().user?.id;
    _membersFuture = DbClient.fetchGroupMembers(
      widget.group.id,
      includeUserIds: _requiredUserIds(currentUserId),
    );
  }

  Future<void> _refreshMembers() async {
    final currentUserId = context.read<AuthProvider>().user?.id;
    setState(() {
      _membersFuture = DbClient.fetchGroupMembers(
        widget.group.id,
        includeUserIds: _requiredUserIds(currentUserId),
      );
    });
  }

  Future<void> _confirmKick(Profile profile) async {
    final shouldKick = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vyhodit člena'),
          content: Text('Opravdu chcete vyhodit uživatele ${profile.username} ze skupiny?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Zrušit'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Vyhodit', style: TextStyle(color: UhoColor.danger)),
            ),
          ],
        );
      },
    );

    if (shouldKick != true) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await DbClient.removeUserFromGroup(
        groupId: widget.group.id,
        userId: profile.userId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${profile.username} byl odebrán ze skupiny.')),
        );
        await _refreshMembers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nepodařilo se odebrat člena: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isOwner = auth.user?.id == widget.group.ownerId;
    final currentUserId = auth.user?.id;

    return Scaffold(
      appBar: UhoHeader.preferredSize(
        title: 'Členové',
        onBack: () => context.router.maybePop(),
      ),
      body: FutureBuilder<List<Profile>>(
        future: _membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Chyba při načítání členů: ${snapshot.error}'),
            );
          }

          final members = [...(snapshot.data ?? [])]
            ..sort((a, b) {
              final aIsOwner = a.userId == widget.group.ownerId;
              final bIsOwner = b.userId == widget.group.ownerId;
              if (aIsOwner && !bIsOwner) return -1;
              if (!aIsOwner && bIsOwner) return 1;
              return a.username.compareTo(b.username);
            });

          if (members.isEmpty) {
            return const Center(child: Text('Skupina zatím nemá žádné členy.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshMembers,
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final isGroupOwner = member.userId == widget.group.ownerId;
                final isCurrentUser = member.userId == currentUserId;
                final canKick = isOwner && !isGroupOwner && !_isProcessing;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UhoPadding.small,
                    vertical: UhoPadding.verySmall,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
                    onTap: canKick ? () => _confirmKick(member) : null,
                    child: Card(
                      color: isGroupOwner
                          ? UhoColor.highlight.withAlpha(85)
                          : UhoColor.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UhoCornerRadius.medium),
                        side: isGroupOwner
                            ? const BorderSide(color: UhoColor.highlight, width: 1.2)
                            : BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(UhoPadding.medium),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                member.username,
                                style: const TextStyle(
                                  color: UhoColor.text1,
                                  fontSize: UhoFontSize.medium,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${member.ratingsCount} recenzí',
                              style: const TextStyle(
                                color: UhoColor.text2,
                                fontSize: UhoFontSize.small,
                              ),
                            ),
                            if (canKick) ...[
                              const SizedBox(width: UhoPadding.small),
                              const Icon(Icons.person_remove, color: UhoColor.danger),
                            ],
                            if (isGroupOwner) ...[
                              const SizedBox(width: UhoPadding.small),
                              const Text(
                                'Vlastník',
                                style: TextStyle(color: UhoColor.text2),
                              ),
                            ],
                            if (isCurrentUser) ...[
                              const SizedBox(width: UhoPadding.small),
                              const Text(
                                'Vy',
                                style: TextStyle(color: UhoColor.text2),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () async {
                final added = await context.router.push(
                  GroupAddMembersRoute(group: widget.group),
                );

                if (added == true && mounted) {
                  await _refreshMembers();
                }
              },
              backgroundColor: UhoColor.card,
              child: const Icon(Icons.person_add, color: UhoColor.highlight),
            )
          : null,
    );
  }
}