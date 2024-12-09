import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/my_posts.dart';
import 'package:mad_project/home_screens/master_nav/controller/master_nav_controller.dart';
import 'package:mad_project/home_screens/posts_screens/view/favourite_posts.dart';
import 'package:mad_project/home_screens/posts_screens/view/posts_list.dart';
import 'package:mad_project/home_screens/settings_screens/view/settings_list.dart';

class MasterNav extends StatelessWidget {
  const MasterNav({super.key});

  @override
  Widget build(BuildContext context) {
    final MasterNavController navController = Get.put(MasterNavController());
    final List<Widget> screens = [
      PostsList(),
      FavoritePostsScreen(),
      Center(child: Text('Create Post Screen')),
      MyPostsScreen(),
      SettingsList(),
    ];

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned.fill(
            bottom:
                kBottomNavigationBarHeight,
            child: Obx(() => screens[navController.selectedIndex.value]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    currentIndex: navController.selectedIndex.value,
                    onTap: navController.changeTabIndex,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    selectedItemColor: Assets.btnBgColor,
                    unselectedItemColor: Colors.grey,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    items: [
                      _buildNavItem(Icons.home_outlined, Icons.home, "Home"),
                      _buildNavItem(
                          Icons.favorite_border, Icons.favorite, "Favorites"),
                      _buildNavItem(
                          Icons.add_circle_outline, Icons.add_circle, "Create"),
                      _buildNavItem(
                          Icons.article_outlined, Icons.article, "My Posts"),
                      _buildNavItem(
                          Icons.settings_outlined, Icons.settings, "Settings"),
                    ],
                  ),
                )),
          )
        ]));
  }

  BottomNavigationBarItem _buildNavItem(
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(unselectedIcon),
      activeIcon: Icon(selectedIcon),
      label: label,
    );
  }
}
