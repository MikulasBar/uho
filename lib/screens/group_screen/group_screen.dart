import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uho/core/constants.dart';
import 'package:uho/core/db_client.dart';
import 'package:uho/models/group.dart';
import 'package:uho/providers/auth_provider.dart';
import 'package:uho/widgets/header/header.dart';

@RoutePage()
class GroupScreen extends StatefulWidget {
  final Group group;

  const GroupScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool _isDeleting = false;

  Future<void> _deleteGroup() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await DbClient.deleteGroup(groupId: widget.group.id);
      if (mounted) {
        context.router.maybePop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chyba při mazání skupiny: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isOwner = auth.user?.id == widget.group.ownerId;

    return Scaffold(
      appBar: UhoHeader.preferredSize(
        title: widget.group.name,
        onBack: () => context.router.maybePop(),
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
              child: Column(
                children: const [
                  ListTile(
                    title: Text(
                      'Členové',
                      style: TextStyle(color: UhoColor.text1),
                    ),
                    trailing: Icon(Icons.chevron_right, color: UhoColor.text2),
                  ),
                  Divider(height: 1, color: UhoColor.text2),
                  ListTile(
                    title: Text(
                      'Recenze jídel',
                      style: TextStyle(color: UhoColor.text1),
                    ),
                    trailing: Icon(Icons.chevron_right, color: UhoColor.text2),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (isOwner)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isDeleting ? null : _deleteGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: UhoPadding.medium),
                  ),
                  child: _isDeleting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Smazat skupinu',
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