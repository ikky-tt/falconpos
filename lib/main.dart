import 'dart:io';
import 'dart:typed_data';

import 'package:falconpos/ui/dashboard.dart';
import 'package:falconpos/ui/mainpage.dart';
import 'package:falconpos/ui/mainpos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'function/scroll.dart';
import 'theme/theme.dart';
import 'theme/theme_services.dart';
import 'ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  var login = prefs.getInt('login');
  if(kIsWeb == false) {
    ByteData data = await PlatformAssetBundle().load(
        'assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(
        data.buffer.asUint8List());
  }
  runApp( MyApp(login: login,));
}

class MyApp extends StatelessWidget {
  final login;
   MyApp({super.key, required this.login});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return kIsWeb?MaterialApp.router(
      scrollBehavior: MyCustomScrollBehavior(),
      routerConfig: login == null?_routerlogin:_router,
      title: 'Falcon POS',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: themeService().theme,
      localizationsDelegates: const [

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('th', ''), // Spanish, no country code
      ],
     ):GetMaterialApp(
      title: 'Falcon POS',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: themeService().theme,
      localizationsDelegates: const [

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('th', ''), // Spanish, no country code
      ],
      home:  login == null?const LoginPage():MainPage(),
    );
  }
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MainPage(),

      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),

      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashBorad(),

      ),
      GoRoute(
        path: '/pos',
        builder: (context, state) => MainPOS(),

      ),

    ],
  );
  final _routerlogin = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginPage(),

      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MainPage(),

      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),

      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashBorad(),

      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashBorad(),

      ),
      GoRoute(
        path: '/pos',
        builder: (context, state) => MainPOS(),

      ),

    ],
  );
}
