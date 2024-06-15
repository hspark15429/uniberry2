import 'package:flutter/material.dart';
import 'package:uniberry2/src/forum/presentation/widgets/forum_app_bar.dart';
import 'package:uniberry2/src/forum/presentation/widgets/forum_body.dart';

class ForumView extends StatefulWidget {
  const ForumView({super.key});

  @override
  State<ForumView> createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ForumAppBar(),
      body: ForumBody(),
    );
  }
}
