import 'dart:async';

import 'package:app_version_update/app_version_update.dart';
import 'package:falconpos/theme/textshow.dart';

import 'package:falconpos/ui/POSPortraitmode.dart';
import 'package:falconpos/ui/dashboard.dart';
import 'package:falconpos/ui/login.dart';

import 'package:falconpos/ui/poslandscapemode.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:find_dropdown/find_dropdown.dart';
import '../api/apiservice.dart';


class MainPOS extends StatefulWidget {
  final custid;
  final custname;
  final custcode;
  final genorder;
  const MainPOS({super.key, this.custid, this.custname, this.custcode, this.genorder});

  @override
  State<MainPOS> createState() => _MainPOSState();
}

class _MainPOSState extends State<MainPOS> {
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
      _lv = prefs.getInt("lv")!;
      print(_brachid);
      print("login");
      print(_lv);

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
    DocNo();
    GetLogin();
    _nodfocus = FocusNode();

    if (widget.genorder == null) {
      genorder = new DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      genorder = widget.genorder;


    }
    print("widget.custid" + widget.custid.toString() );
    print(widget.custid);
    if(kIsWeb == false) {
      _verifyVersion();
    }

  }
  void _verifyVersion() async {
    await AppVersionUpdate.checkForUpdates(
        appleId: '6446825944', playStoreId: 'com.falconcirrus.falconpos', country: 'th')
        .then((data) async {
      print(data.canUpdate);

      // await AppVersionUpdate.showBottomSheetUpdate(context: context, appVersionResult: appVersionResult)
      // await AppVersionUpdate.showPageUpdate(context: context, appVersionResult: appVersionResult)
      if(data.canUpdate!){
        await AppVersionUpdate.showAlertUpdate(
          appVersionResult: data,
          context: context,
          backgroundColor: Colors.grey[200],
          title: 'New Version.',
          content:
          'New version avaible? ${data.storeVersion}',
          updateButtonText: 'UPDATE',
          updateButtonStyle: ButtonStyle(
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),

            textStyle: MaterialStatePropertyAll<TextStyle>(textBodyMedium),
            backgroundColor:  MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
          ),
          cancelButtonStyle:  ButtonStyle(
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),

            textStyle: MaterialStatePropertyAll<TextStyle>(textBodyMedium),
            backgroundColor:  MaterialStatePropertyAll<Color>(Colors.grey),
          ),
          cancelButtonText: 'CANCEL',
          titleTextStyle: textBodyMedium.copyWith( color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.0),
          contentTextStyle: textBodyMedium.copyWith( color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16.0),

        );
      }
    });
    // TODO: implement initState
  }


  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return  OrientationBuilder(
      builder: (context, orientation) {
        if (Orientation.portrait  == currentOrientation) {
          print(orientation);
          return POSPortraitMode(
            genorder: genorder,
            custcode: widget.custcode,
            custid: widget.custid,
            custname: widget.custname,
          );
        } else {

          if(MediaQuery.of(context).size.width>1000){

            return POSLandscape(
              genorder: genorder,
              custcode: widget.custcode,
              custid: widget.custid,
              custname: widget.custname,
            );
          } else {
            return POSPortraitMode(
              genorder: genorder,
              custcode: widget.custcode,
              custid: widget.custid,
              custname: widget.custname,
            );

          }


        }
      },
    );

  }
}