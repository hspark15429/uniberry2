import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry/core/enums/update_user_enum.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry/src/timetable/presentation/cubit/timetable_cubit.dart';

class TimetableUpdateListSheet extends StatefulWidget {
  const TimetableUpdateListSheet({
    required this.currentIndex,
    super.key,
  });

  final int currentIndex;

  @override
  State<TimetableUpdateListSheet> createState() =>
      _TimetableUpdateListSheetState();
}

class _TimetableUpdateListSheetState extends State<TimetableUpdateListSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  '時間割リスト',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () async {
                    final newTimetableName = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            '新しい時間割を作成',
                            style: TextStyle(color: Colors.black),
                          ),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'タイトル',
                              hintStyle: TextStyle(color: Colors.black54),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.white,
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                '追加',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  Navigator.pop(context, controller.text);
                                }
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'キャンセル',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (newTimetableName != null) {
                      if (context.mounted) {
                        await context.read<TimetableCubit>().createTimetable(
                              TimetableModel.empty().copyWith(
                                name: newTimetableName,
                              ),
                            );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TimetableCubit, TimetableState>(
              builder: (context, state) {
                if (state is TimetableLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (state is TimetableError) {
                  return const Center(
                    child: Text(
                      'ERROR!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else if (state is TimetableCreated) {
                  return const Center(
                    child: Text(
                      '生成しました。',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else if (state is TimetableDeleted) {
                  return const Center(
                    child: Text(
                      '削除されました',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else if (state is TimetablesFetched) {
                  return ListView.builder(
                    itemCount: state.timetables.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: index == widget.currentIndex
                              ? Colors.black12
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            state.timetables[index].name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: index == widget.currentIndex
                              ? const Text(
                                  '選択中',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                )
                              : null,
                          onTap: () {
                            Navigator.pop(
                              context,
                              state.timetables[index] as TimetableModel,
                            );
                          },
                          trailing: index == widget.currentIndex
                              ? null
                              : IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    await context
                                        .read<TimetableCubit>()
                                        .deleteTimetable(
                                          state.timetables[index].timetableId,
                                        );
                                  },
                                ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      '時間割がありません。',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
