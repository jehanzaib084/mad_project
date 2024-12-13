import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/create_post.dart';
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
      CreatePostScreen(),
      MyPostsScreen(),
      SettingsList(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: kBottomNavigationBarHeight,
            child: Obx(() => screens[navController.selectedIndex.value]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
              return Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: navController.selectedIndex.value,
                  onTap: navController.changeTabIndex,
                  type: BottomNavigationBarType.fixed,
                  // backgroundColor: Colors.transparent, // Handled by Container
                  selectedItemColor: isDarkMode
                      ? Assets.btnBgColor.withOpacity(0.9)
                      : Assets.btnBgColor,
                  unselectedItemColor:
                      isDarkMode ? Colors.white70 : Colors.grey,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  items: [
                    _buildNavItem(
                      Icons.home_outlined,
                      Icons.home,
                      "Home",
                      isDarkMode,
                    ),
                    _buildNavItem(
                      Icons.favorite_border,
                      Icons.favorite,
                      "Favorites",
                      isDarkMode,
                    ),
                    _buildNavItem(
                      Icons.add_circle_outline,
                      Icons.add_circle,
                      "Create",
                      isDarkMode,
                    ),
                    _buildNavItem(
                      Icons.article_outlined,
                      Icons.article,
                      "My Posts",
                      isDarkMode,
                    ),
                    _buildNavItem(
                      Icons.settings_outlined,
                      Icons.settings,
                      "Settings",
                      isDarkMode,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
    bool isDarkMode,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(
        unselectedIcon,
        color: isDarkMode ? Colors.white70 : Colors.grey,
      ),
      activeIcon: Icon(
        selectedIcon,
        color: isDarkMode
            ? Assets.btnBgColor.withOpacity(0.9)
            : Assets.btnBgColor,
      ),
      label: label,
    );
  }
}