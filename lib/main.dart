import 'dart:io';
import 'dart:typed_data';

import 'package:falconpos/ui/mainpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/theme.dart';
import 'ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  var loginname = prefs.getInt('login');
  if(kIsWeb == false) {
    ByteData data = await PlatformAssetBundle().load(
        'assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(
        data.buffer.asUint8List());
  }
  runApp( MyApp(loingname: loginname,));
}

class MyApp extends StatelessWidget {
  final loingname;
   MyApp({super.key, required this.loingname});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Falcon POS',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,

      localizationsDelegates: const [

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('th', ''), // Spanish, no country code
      ],
      home:  loingname == null?const LoginPage():MainPage(),
    );
  }
}
