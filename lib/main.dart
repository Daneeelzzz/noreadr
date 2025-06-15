import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/novel_detail_screen.dart';
import 'screens/reader_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'theme/theme_provider.dart';
import 'utils/platform_detector.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (PlatformDetector.isIOS()) {
      return CupertinoApp(
        title: 'Novel Reader',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
          primaryColor: themeProvider.isDarkMode 
              ? CupertinoColors.systemBlue.darkColor 
              : CupertinoColors.systemBlue,
          scaffoldBackgroundColor: themeProvider.isDarkMode 
              ? CupertinoColors.black 
              : CupertinoColors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/main': (context) => const MainNavigationScreen(),
          '/novel-detail': (context) => const NovelDetailScreen(),
          '/reader': (context) => const ReaderScreen(),
        },
      );
    } else {
      return MaterialApp(
        title: 'Novel Reader',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.lightTheme,
        darkTheme: themeProvider.darkTheme,
        themeMode: themeProvider.themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/main': (context) => const MainNavigationScreen(),
          '/novel-detail': (context) => const NovelDetailScreen(),
          '/reader': (context) => const ReaderScreen(),
        },
      );
    }
  }
}