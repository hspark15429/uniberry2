import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniberry/core/common/providers/tab_navigator.dart';
import 'package:uniberry/core/common/widgets/gradient_background.dart';
import 'package:uniberry/core/common/widgets/title_text.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/res/colours.dart';
import 'package:uniberry/core/res/res.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/src/profile/presentation/views/edit_profile_view.dart';
import 'package:uniberry/src/profile/presentation/widgets/pop_up_item.dart';
import 'package:uniberry/src/profile/presentation/widgets/profile_body.dart';
import 'package:uniberry/src/profile/presentation/widgets/profile_header.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final auth = FirebaseAuth.instance;
  NavigatorState? navigator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigator ??= Navigator.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const TitleText(text: 'Profile'),
            actions: [
              PopupMenuButton(
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem<void>(
                    child: const PopupItem(
                      title: 'ニックネーム変更',
                      icon: Icon(Icons.edit_outlined),
                    ),
                    onTap: () {
                      context
                          .read<TabNavigator>()
                          .push(TabItem(child: const EditProfileView()));
                    },
                  ),
                  const PopupMenuItem<void>(
                    child: PopupItem(
                      title: 'Help',
                      icon: Icon(Icons.help_outline_outlined),
                    ),
                  ),
                  PopupMenuItem<void>(
                    height: 1,
                    padding: EdgeInsets.zero,
                    child: Divider(
                      height: 1,
                      color: Colors.grey[300],
                      endIndent: 16,
                      indent: 16,
                    ),
                  ),
                  PopupMenuItem<void>(
                    child: const PopupItem(
                      title: 'Logout',
                      icon: Icon(Icons.logout_rounded),
                    ),
                    onTap: () async {
                      await sl<SharedPreferences>().clear();
                      await FirebaseAuth.instance.signOut();
                      unawaited(
                        navigator!.pushNamedAndRemoveUntil(
                          '/',
                          (route) => false,
                        ),
                      );
                    },
                  ),
                ],
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                ProfileHeader(),
                ProfileBody(),
              ],
            ),
          ),
        );
      },
    );
  }
}
