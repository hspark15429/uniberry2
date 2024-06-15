import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/res/colours.dart';
import 'package:uniberry2/src/auth/data/models/user_model.dart';
import 'package:uniberry2/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:uniberry2/src/dashboard/presentation/utils/dashboard_utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is LocalUserModel) {
          context.read<UserProvider>().user = snapshot.data;
        }
        return Consumer<DashboardController>(
          builder: (_, controller, __) {
            return Scaffold(
              body: IndexedStack(
                index: controller.currentIndex,
                children: controller.screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.currentIndex,
                showSelectedLabels: false,
                backgroundColor: Colors.white,
                elevation: 8,
                onTap: controller.changeIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 0
                          ? IconlyBold.home
                          : IconlyLight.home,
                      color: controller.currentIndex == 0
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 1
                          ? IconlyBold.calendar
                          : IconlyLight.calendar,
                      color: controller.currentIndex == 1
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'Timetable',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 2
                          ? IconlyBold.chart
                          : IconlyLight.chart,
                      color: controller.currentIndex == 2
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'Chart',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 3
                          ? IconlyBold.chat
                          : IconlyLight.chat,
                      color: controller.currentIndex == 3
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'Message',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 4
                          ? IconlyBold.profile
                          : IconlyLight.profile,
                      color: controller.currentIndex == 4
                          ? Colours.primaryColour
                          : Colors.grey,
                    ),
                    label: 'User',
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}