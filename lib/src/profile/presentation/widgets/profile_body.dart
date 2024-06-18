import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/common/views/loading_view.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry2/src/comment/presentation/widgets/comment_card.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().getCommentsByUserId(
          context.read<UserProvider>().user!.uid,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '내가 작성한 글',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocConsumer<CommentCubit, CommentState>(
              listener: (context, state) {
                if (state is CommentInitial || state is CommentDeleted) {
                  context.read<CommentCubit>().getCommentsByUserId(
                        context.read<UserProvider>().user!.uid,
                      );
                }
              },
              builder: (context, state) {
                if (state is CommentsFetched) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      return CommentCard(comment: comment);
                    },
                  );
                }
                debugPrint('ProfileBody: $state');
                return const LoadingView();
              },
            ),
          ],
        );
      },
    );
  }
}
