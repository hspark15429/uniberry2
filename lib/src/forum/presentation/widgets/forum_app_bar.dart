import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForumAppBar({required this.onRefresh, super.key});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      actions: [
        IconButton(
          onPressed: onRefresh,
          // refresh icon
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(IconlyLight.notification),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
