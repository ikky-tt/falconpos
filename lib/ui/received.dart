import 'dart:async';

import 'package:barcode_scan2/gen/protos/protos.pb.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../api/constant.dart';
import '../theme/textshow.dart';
import 'login.dart';

class received extends StatefulWidget {
  const received({Key? key}) : super(key: key);

  @override
  State<received> createState() => _receivedState();
}

class _receivedState extends State<received> {
  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _brachid = 0;
  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;
      print(_brachid);
      LoadProduct(_brachid);
      if (prefs.getInt('login') != 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }
  late ScanResult scanResult;
  StreamController _stream = StreamController();
  void LoadProduct (brachid) {
    print(_brachid);

    ApiSerivces().Getserailbranch(brachid).then((res) async {
      _stream.add(res.data);
    });


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  _stream = new StreamController();
    GetLogin();
  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: (){

              Navigator.of(context).pop();

            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text('Received',style: textBodyLage,),
          centerTitle: true,
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (Orientation.portrait  == currentOrientation) {
              print(orientation);
              return P();
            } else {
              return L();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scan();
          },
          child: Icon(LineIcons.qrcode),
        
    ),
    );
}
Widget P() {
    return Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      decoration: inputForm1('serialnumber'),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: (){},
                          child: Icon(LineIcons.search,size: 30,color: Colors.white,)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child:  StreamBuilder(
              stream: _stream.stream,
              builder: (context, stream) {
                if (!stream.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No Data',
                        style: textLanadscapL,
                      )
                    ],
                  );
                }
                if (stream.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child:Text(''));
                }
                if (stream.hasError) {
                  return Center(child: Text(stream.error.toString()));
                }
                var querySnapshot = stream.data;
                print(querySnapshot);
                return ListView.builder(
                    itemCount: stream.data.length,
                    itemBuilder: (context,i){
                      return ListTile(
                        leading:  stream.data[i]['path']!=null? ClipRRect(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: urlpic+ stream.data[i]['path'],
                            placeholder: (context, url) => Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                )),
                            errorWidget: (context, url, error) => Icon(LineIcons.imageAlt),
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,

                          ),

                        ):Row(),
                        title: Text('${querySnapshot[i]['serialnumber']}',style: textBodyLage.copyWith(color: Colors.black),),
                        subtitle: Text('${querySnapshot[i]['name']}',style: textBodyLage.copyWith(color: Colors.black),),
                      );
                    });
              },
            ))

          ],
        )
    );
}
  Widget L() {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    decoration: inputForm1('serialnumber'),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                     onPressed: (){},
                     child: Icon(LineIcons.search,size: 30,color: Colors.white,)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child:  StreamBuilder(
            stream: _stream.stream,
            builder: (context, stream) {
              if (!stream.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No Data',
                      style: textLanadscapL,
                    )
                  ],
                );
              }
              if (stream.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child:Text(''));
              }
              if (stream.hasError) {
                return Center(child: Text(stream.error.toString()));
              }
              var querySnapshot = stream.data;
              print(querySnapshot);
              return ListView.builder(
                  itemCount: stream.data.length,
                  itemBuilder: (context,i){
                return ListTile(
                  leading:  stream.data[i]['path']!=null? ClipRRect(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: urlpic+ stream.data[i]['path'],
                      placeholder: (context, url) => Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          )),
                      errorWidget: (context, url, error) => Icon(LineIcons.imageAlt),
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,

                    ),

                  ):Row(),
                  title: Text('${querySnapshot[i]['serialnumber']}',style: textBodyLage.copyWith(color: Colors.black),),
                  subtitle: Text('${querySnapshot[i]['name']}',style: textBodyLage.copyWith(color: Colors.black),),
                );
              });
            },
          ))

        ],
      )
    );
  }
  final _aspectTolerance = 0.00;
  final _selectedCamera = -1;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;
  Future scan() async {
    try {
      var options = ScanOptions(

        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      setState(() async {
        var scanResult  = result;
        print('----------------------');
        print(scanResult.rawContent);
        if(scanResult.rawContent != '') {

          if(scanResult.rawContent != '') {


          ApiSerivces().updateserailbranch(_brachid,scanResult.rawContent).then((value) => LoadProduct(_brachid));


          } else {



          }
          //

        }


      });


    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );


      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );


      });
    }
  }
}