import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry/core/enums/update_user_enum.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry/src/comment/domain/entities/comment.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';

class FlagButton extends StatefulWidget {
  const FlagButton({required this.item, super.key});

  final dynamic item;

  @override
  State<FlagButton> createState() => _FlagButtonState();
}

class _FlagButtonState extends State<FlagButton> {
  late LocalUser user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserProvider>().user!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackBar(
            context,
            'Operation successful. '
            'Please refresh the page if you blocked the user.',
          );
        }
      },
      child: IconButton(
        icon: const Icon(Icons.flag),
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('通報'),
                content: const Text(
                    'この投稿を通報してもよろしいですか? 弊社のチームが確認し、24 時間以内に適切な措置を行います。'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop('block');
                    },
                    child: const Text('このユーザーをブロック'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop('report');
                    },
                    child: const Text('ユーザーと投稿の通保'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop('cancel');
                    },
                    child: const Text('キャンセル'),
                  ),
                ],
              );
            },
          );
          if (result == 'block') {
            if (context.mounted && widget.item is Post) {
              final uid = (widget.item as Post).uid;
              await context.read<AuthenticationCubit>().updateUser(
                    action: UpdateUserAction.blockedUids,
                    userData: user.blockedUids + [uid],
                  );
            } else if (context.mounted && widget.item is Comment) {
              final uid = (widget.item as Comment).uid;
              await context.read<AuthenticationCubit>().updateUser(
                    action: UpdateUserAction.blockedUids,
                    userData: user.blockedUids + [uid],
                  );
            }
          } else if (result == 'report') {
            // hot fix, remove later
            if (context.mounted && widget.item is Post) {
              final postId = (widget.item as Post).postId;
              await context.read<AuthenticationCubit>().updateUser(
                    action: UpdateUserAction.reportedPostIds,
                    userData: user.enrolledCourseIds + [postId],
                  );
            } else if (context.mounted && widget.item is Comment) {
              final commentId = (widget.item as Comment).commentId;
              await context.read<AuthenticationCubit>().updateUser(
                    action: UpdateUserAction.reportedPostIds,
                    userData: user.enrolledCourseIds + [commentId],
                  );
            }
          }
        },
      ),
    );
  }
}
