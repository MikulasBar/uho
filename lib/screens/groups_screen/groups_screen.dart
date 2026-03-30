import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/group.dart';
import 'package:uho/providers/auth_provider.dart';
import 'package:uho/router/app_router.dart';
import 'package:uho/widgets/bottom_bar/bottom_bar.dart';
import 'package:uho/widgets/group_card/group_card.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late Future<List<Group>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = DbClient.fetchGroups();
  }

  Future<void> _refreshGroups() async {
    setState(() {
      _groupsFuture = DbClient.fetchGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: UhoHeader.preferredSize(
        title: "Skupiny",
      ),
      body: RefreshIndicator(
        onRefresh: _refreshGroups,
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

            if (snapshot.data?.isEmpty ?? true) {
              return ListView(
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('Zatím nemáte žádné skupiny.')),
                ],
              );
            }

            final groups = snapshot.data!;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];

                return GroupCard(
                  group: group,
                  onTap: () async {
                    await context.router.push(GroupRoute(group: group));
                    if (mounted) {
                      await _refreshGroups();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: auth.isLoggedIn
          ? FloatingActionButton(
              onPressed: () async {
                await context.router.push(const NewGroupRoute());
                if (mounted) {
                  await _refreshGroups();
                }
              },
              backgroundColor: UhoColor.card,
              child: const Icon(Icons.add, color: UhoColor.highlight),
            )
          : null,
      bottomNavigationBar: UhoBottomBar(),
    );
  }
}
