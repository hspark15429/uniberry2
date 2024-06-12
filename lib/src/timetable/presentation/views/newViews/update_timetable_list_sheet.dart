import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/enums/update_user_enum.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

class UpdateTimetableListSheet extends StatefulWidget {
  const UpdateTimetableListSheet({
    required this.switchCurrentTimetable,
    super.key,
  });

  final Function(TimetableModel) switchCurrentTimetable;

  @override
  State<UpdateTimetableListSheet> createState() =>
      _UpdateTimetableListSheetState();
}

class _UpdateTimetableListSheetState extends State<UpdateTimetableListSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, __) {
        context
            .read<TimetableCubit>()
            .getTimetables(provider.user!.timetableIds);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    '시간표 목록',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog<AlertDialog>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('새 시간표 추가'),
                            content: TextField(
                              controller: controller,
                              decoration:
                                  const InputDecoration(hintText: '시간표 이름'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  '추가',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () async {
                                  if (controller.text.isNotEmpty) {
                                    await context
                                        .read<TimetableCubit>()
                                        .createTimetable(
                                          TimetableModel.empty().copyWith(
                                            name: controller.text,
                                          ),
                                        );
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  '취소',
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
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<TimetableCubit, TimetableState>(
                builder: (context, state) {
                  if (state is TimetableLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TimetableError) {
                    return const Center(child: Text('시간표가 없습니다!'));
                  } else if (state is TimetablesFetched) {
                    return ListView.builder(
                      itemCount: provider.user!.timetableIds.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.timetables[index].name),
                          onTap: () {
                            widget.switchCurrentTimetable(
                              state.timetables[index] as TimetableModel,
                            );
                            Navigator.pop(context);
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () async => await context
                                .read<TimetableCubit>()
                                .deleteTimetable(
                                  state.timetables[index].timetableId,
                                ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('시간표가 없습니다.'));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
