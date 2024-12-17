// main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/authentication/view/intro_screen.dart';
import 'package:mad_project/home_screens/master_nav/master_nav.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'pages/pages.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize controllers
  Get.put(PostController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return MasterNav();
          } else {
            return IntroScreen();
          }
        },
      ),
      getPages: AppPages.routes,
    );
  }
}

Future<void> checkFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  Get.offAllNamed(hasSeenIntro ? '/login' : '/intro');
}



sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
  scheme: FlexScheme.bahamaBlue,
  appBarStyle: FlexAppBarStyle.primary,
  appBarElevation: 4.0,
  bottomAppBarElevation: 8.0,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  subThemesData: const FlexSubThemesData(
    useM2StyleDividerInM3: true,
    adaptiveElevationShadowsBack: FlexAdaptive.all(),
    adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
    defaultRadius: 4.0,
    elevatedButtonSchemeColor: SchemeColor.onPrimary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    inputDecoratorSchemeColor: SchemeColor.onSurface,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: 13,
    inputDecoratorBorderSchemeColor: SchemeColor.primary,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
    listTileMinVerticalPadding: 4.0,
    fabUseShape: true,
    fabAlwaysCircular: true,
    fabSchemeColor: SchemeColor.secondary,
    chipSchemeColor: SchemeColor.primary,
    chipRadius: 20.0,
    popupMenuElevation: 8.0,
    alignedDropdown: true,
    tooltipRadius: 4,
    dialogElevation: 24.0,
    datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    appBarScrolledUnderElevation: 4.0,
    tabBarIndicatorSize: TabBarIndicatorSize.tab,
    tabBarIndicatorWeight: 2,
    tabBarIndicatorTopRadius: 0,
    tabBarDividerColor: Color(0x00000000),
    drawerElevation: 16.0,
    drawerWidth: 304.0,
    bottomSheetElevation: 10.0,
    bottomSheetModalElevation: 20.0,
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: true,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedIcon: true,
    bottomNavigationBarElevation: 8.0,
    menuElevation: 8.0,
    menuBarRadius: 0.0,
    menuBarElevation: 1.0,
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedLabel: true,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedIcon: true,
    navigationBarIndicatorSchemeColor: SchemeColor.secondary,
    navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
    navigationBarElevation: 0.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedLabel: true,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedIcon: true,
    navigationRailUseIndicator: true,
    navigationRailIndicatorSchemeColor: SchemeColor.secondary,
    navigationRailLabelType: NavigationRailLabelType.all,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
  scheme: FlexScheme.bahamaBlue,
  appBarStyle: FlexAppBarStyle.material,
  appBarElevation: 4.0,
  bottomAppBarElevation: 8.0,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  subThemesData: const FlexSubThemesData(
    useM2StyleDividerInM3: true,
    adaptiveElevationShadowsBack: FlexAdaptive.all(),
    adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
    defaultRadius: 4.0,
    elevatedButtonSchemeColor: SchemeColor.onPrimary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    inputDecoratorSchemeColor: SchemeColor.onSurface,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: 20,
    inputDecoratorBorderSchemeColor: SchemeColor.primary,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
    listTileMinVerticalPadding: 4.0,
    fabUseShape: true,
    fabAlwaysCircular: true,
    fabSchemeColor: SchemeColor.secondary,
    chipSchemeColor: SchemeColor.primary,
    chipRadius: 20.0,
    popupMenuElevation: 8.0,
    alignedDropdown: true,
    tooltipRadius: 4,
    dialogElevation: 24.0,
    datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    appBarScrolledUnderElevation: 4.0,
    tabBarIndicatorSize: TabBarIndicatorSize.tab,
    tabBarIndicatorWeight: 2,
    tabBarIndicatorTopRadius: 0,
    tabBarDividerColor: Color(0x00000000),
    drawerElevation: 16.0,
    drawerWidth: 304.0,
    bottomSheetElevation: 10.0,
    bottomSheetModalElevation: 20.0,
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: true,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedIcon: true,
    bottomNavigationBarElevation: 8.0,
    menuElevation: 8.0,
    menuBarRadius: 0.0,
    menuBarElevation: 1.0,
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedLabel: true,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedIcon: true,
    navigationBarIndicatorSchemeColor: SchemeColor.secondary,
    navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
    navigationBarElevation: 0.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedLabel: true,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedIcon: true,
    navigationRailUseIndicator: true,
    navigationRailIndicatorSchemeColor: SchemeColor.secondary,
    navigationRailLabelType: NavigationRailLabelType.all,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}