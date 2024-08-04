import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uniberry/core/common/widgets/title_text.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForumAppBar({required this.onRefresh, super.key});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const TitleText(text: 'ホーム'),
      // backgroundColor: Colors.black, // AppBar 배경색을 검정색으로 설정
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
