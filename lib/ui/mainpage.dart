import 'dart:async';

import 'package:app_version_update/app_version_update.dart';
import 'package:falconpos/theme/textshow.dart';

import 'package:falconpos/ui/POSPortraitmode.dart';
import 'package:falconpos/ui/dashboard.dart';
import 'package:falconpos/ui/login.dart';
import 'package:falconpos/ui/mainpos.dart';

import 'package:falconpos/ui/poslandscapemode.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:find_dropdown/find_dropdown.dart';
import '../api/apiservice.dart';

class MainPage extends StatefulWidget {
  final custid;
  final custname;
  final custcode;
  final genorder;

  MainPage({Key? key, this.custid, this.custname, this.custcode ,this.genorder})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var countriesKey = GlobalKey<FindDropdownState>();
  final oCcy = NumberFormat("#,###.##", "th_TH");

  String _docno = '';
  late String genorder;

  String _count = "0";

  String _chkdisconut = '1';
  num _tax = 0;
  num _sumtot = 0;
  num _subtot = 0;
  num _discount = 0;
  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _brachid = 0;

  late FocusNode _nodfocus;

  String _date = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  String _time = DateFormat("HH:mm").format(DateTime.now()).toString();

  final StreamController _streamController = StreamController.broadcast();
  final StreamController _streamController2 = StreamController.broadcast();
  final StreamController _stream = StreamController.broadcast();
  final StreamController _stream3 = StreamController.broadcast();
  final TextEditingController _scr = TextEditingController();
  final TextEditingController _barcodetext = TextEditingController();

  DocNo() async {
    await ApiSerivces().ApiDocno().then((res) {
      setState(() {
        _docno = res.data['docno'].toString();
      });
    });
  }

  int? _login = 0;
  int _lv = 0;

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empname = prefs.getString('name')??'';
      _brach = prefs.getString('branch')??'';
      _brachid = prefs.getInt('branchid')??0;
      _wh = prefs.getString('wh')??'';
      _login = prefs.getInt('login')??0;
      _lv = prefs.getInt("lv")??0;
      print(_brachid);
      print(_login);
      if ( _login != 1 ) {
        print("logingo");

        if(kIsWeb){ print("logingo22");

          GoRouter.of(context).go('/login');
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }

      }
      print(_lv);
      if(_lv == 1){

        if(kIsWeb){
          print('+v');
          context.go('/pos');
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPOS()));
        }
      } else {
        if(kIsWeb){
          (context).go('/login');
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPOS()));
        }
      }
    });
  }

  clercust() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('custid');
    });
  }

  bool _folded = true;

  @override
  initState() {


    // TODO: implement initState
    super.initState();

    GetLogin();



  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return  Center(
      child: Image.asset('assets/images/logow.png'),
    );

  }
}