import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForumAppBar({required this.onRefresh, super.key});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Home',
        style: TextStyle(color: Colors.white), // 제목 텍스트 색상을 흰색으로 설정
      ),
      backgroundColor: Colors.black, // AppBar 배경색을 검정색으로 설정
      actions: [
        IconButton(
          onPressed: onRefresh,
          icon:
              const Icon(Icons.refresh, color: Colors.white), // 아이콘 색상을 흰색으로 설정
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(IconlyLight.notification,
        //       color: Colors.white), // 아이콘 색상을 흰색으로 설정
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
