import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/widgets/header/header.dart';
import 'package:uho/models/profile.dart';
import 'package:uho/widgets/user_card/user_card.dart';

@RoutePage()
class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final Set<String> _selectedUserIds = {};
  late Future<List<Profile>> _usersFuture;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _usersFuture = DbClient.fetchUsers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Zadejte název skupiny")),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      await DbClient.createGroup(
        name: _nameController.text,
        userIds: _selectedUserIds.toList(),
      );

      if (mounted) {
        context.router.maybePop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Chyba při tvoření skupiny: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UhoHeader.preferredSize(
        title: "Nová skupina",
        onBack: () => context.router.maybePop(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Group name input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "jméno skupiny",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: UhoColor.card,
              ),
              enabled: !_isCreating,
            ),
            const SizedBox(height: 16),
            // Users list
            Expanded(
              child: FutureBuilder<List<Profile>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Chyba při načítání uživatelů: ${snapshot.error}"),
                    );
                  }


                  if (snapshot.data?.isEmpty ?? true) {
                    return const Center(child: Text("Žádní uživatelé nejsou k dispozici."));
                  }

                  final users = snapshot.data!;

                  return ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final profile = users[index];
                      final isSelected = _selectedUserIds.contains(profile.userId);

                      return UserCard(
                        profile: profile,
                        isSelected: isSelected,
                        isEnabled: !_isCreating,
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
            const SizedBox(height: 16),
            // Create button
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCreating ? null : _createGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UhoColor.highlight,
                    disabledBackgroundColor: UhoColor.card,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isCreating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          "Vytvořit",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
