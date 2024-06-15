import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/common/providers/tab_navigator.dart';
import 'package:uniberry2/core/common/views/persistent_view.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry2/src/profile/presentation/views/profile_view.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/newViews/timetable_view.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];

  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<TimetableCubit>()),
            ],
            child: const Placeholder(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<TimetableCubit>()),
            ],
            // child: ChangeNotifierProvider(
            //   create: (_) => DocumentsTabController(),
            //   child: const DocumentView(),
            // ),
            child: Consumer<UserProvider>(
              builder: (context, provider, __) {
                return Builder(
                  builder: (context) {
                    final String firstTimetableId;
                    if (context
                        .read<UserProvider>()
                        .user!
                        .timetableIds
                        .isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    firstTimetableId =
                        context.read<UserProvider>().user!.timetableIds.first;

                    return BlocConsumer<TimetableCubit, TimetableState>(
                      builder: (context, state) {
                        if (state is TimetableInitial) {
                          context
                              .read<TimetableCubit>()
                              .readTimetable(firstTimetableId);
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is TimetableLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TimetableRead) {
                          return BlocProvider(
                            create: (context) => sl<TimetableCubit>(),
                            child: TimetableView(
                              initialTimetable:
                                  state.timetable as TimetableModel,
                            ),
                          );
                        } else if (state is TimetableError) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                      listener: (BuildContext context, TimetableState state) {
                        if (state is TimetableError) {
                          CoreUtils.showSnackBar(context, state.message);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    BlocProvider(
      create: (context) => sl<AuthenticationCubit>(),
      child: ChangeNotifierProvider(
        create: (_) => TabNavigator(TabItem(child: const Placeholder())),
        child: const PersistentView(),
      ),
    ),
    BlocProvider(
      create: (context) => sl<AuthenticationCubit>(),
      child: ChangeNotifierProvider(
        create: (_) => TabNavigator(TabItem(child: const Placeholder())),
        child: const PersistentView(),
      ),
    ),
    BlocProvider(
      create: (_) => sl<AuthenticationCubit>(),
      child: ChangeNotifierProvider(
        create: (_) => TabNavigator(TabItem(child: const ProfileView())),
        child: const PersistentView(),
      ),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 4;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
