import 'package:aral_mezunlar_mobile/constant/color_constants.dart';
import 'package:aral_mezunlar_mobile/view/calendar/calendar_view.dart';
import 'package:aral_mezunlar_mobile/view/community/community_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:flutter/material.dart';
import '../main_menu/main_menu_view.dart';
import '../profile/profile_view.dart';

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  _BottomNavigationBarView createState() => _BottomNavigationBarView();
}

class _BottomNavigationBarView extends State<BottomNavigationBarView> {


  List<Widget> _screens(){
    return [
      const MainMenuView(),
      const CommunityView(),
      const CalendarView(),
      const ProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarItems(){
    return[
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Anasayfa",
        activeColorPrimary: ColorConstants.primaryButtonColor,
        inactiveColorPrimary: ColorConstants.secondaryButtonColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.group),
        title: "Keşfet",
        activeColorPrimary: ColorConstants.primaryButtonColor,
        inactiveColorPrimary: ColorConstants.secondaryButtonColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_month),
        title: "Etkinlik",
        activeColorPrimary: ColorConstants.primaryButtonColor,
        inactiveColorPrimary: ColorConstants.secondaryButtonColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle),
        title: "Profil",
        activeColorPrimary: ColorConstants.primaryButtonColor,
        inactiveColorPrimary: ColorConstants.secondaryButtonColor,
      )
    ];
  }



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child){
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text("Aral Mezunlar Mobile"),
              centerTitle: true,
              elevation: 3,
              toolbarHeight: ScreenUtil.defaultSize.height * 8 / 100,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("lib/assets/aral.png"),
                ),
              ],
              shadowColor: Colors.black,
              titleTextStyle: Theme.of(context).textTheme.headlineMedium,
              backgroundColor: ColorConstants.primaryButtonColor,
            ),
            body: PersistentTabView(
              context,
              screens: _screens(),
              backgroundColor: CupertinoColors.white,
              items: navBarItems(),
              navBarHeight: 50.h,
              bottomScreenMargin: 40.h,
              navBarStyle: NavBarStyle.style13,
              hideNavigationBarWhenKeyboardShows: true,
            ),
          ),
        );
      }
    );
  }
}