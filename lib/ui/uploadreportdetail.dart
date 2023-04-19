import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconpos/api/apiservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/constant.dart';
import '../theme/textshow.dart';
import 'login.dart';

class UPloadReportDetail extends StatefulWidget {
  final gencode;
  const UPloadReportDetail({Key? key, this.gencode}) : super(key: key);

  @override
  State<UPloadReportDetail> createState() => _UPloadReportDetailState();
}

class _UPloadReportDetailState extends State<UPloadReportDetail> {
  List<imgModel> _imageFileList = [];
  final oCcy = NumberFormat("#,###.##", "th_TH");

  num _discount = 0;
  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _empid = 0;
  int _brachid = 0;

 String _de = '';
 String _date =  DateFormat('dd/MM/yy').format(DateTime.now());




  int? _login = 0;

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empname = prefs.getString('name')!;
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;
      _empid = prefs.getInt('id')!;
      print(_brachid);

      if (prefs.getInt('login') != 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }




  GetData(gencode) async {

   await  ApiSerivces().ReportDetailDaygencode(gencode).then((e) {
      setState(() {
        print(e.data[0]['date']);
        _de = e.data[0]['detail'];
        _date = DateFormat('dd/MM/yy').format(DateTime.parse(e.data[0]['date']));

      });
    });

   await  ApiSerivces().ReportDetailDaygencodeimg(gencode).then((e) {

     e.data.forEach((e) {
       print(e);
       setState(() {
         _imageFileList.add(imgModel(id: e['id'], path: e['path']));
       });
     });

   });


  }


  bool _folded = true;

  @override
  initState() {
    GetLogin();

    GetData(widget.gencode);

    // TODO: implement initState
    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
      //resizeToAvoidBottomInset: false,

      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Report Upload',
          style: textBodyLage.copyWith(fontSize: 20),
        ),
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
    );
  }
  Widget L(){
    return Row(
      children: [
        Expanded(child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(
              height:  MediaQuery.of(context).size.height*.8,
              width: MediaQuery.of(context).size.width*.5,
              child: _previewImages(),
            ),

          ],
        ),),
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
          padding: const EdgeInsets.only(left: 20.0),
    child: Text(
        '${_date != ''?_date:''}',
        style: textBodyLage.copyWith(fontSize: 20,color: Colors.black),),
    ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Note',style: textBodyLage.copyWith(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('${_de}',style: textBodyMedium.copyWith(color: Colors.black),)
            ),

            SizedBox(
              height: 30,
            )

          ],
        ))
      ],
    );
  }
  Widget P(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                '${_date != ''?_date:''}',
                style: textBodyLage.copyWith(fontSize: 20,color: Colors.black),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('Note',style: textBodyLage.copyWith(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),),
            ),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('${_de}',style: textBodyMedium.copyWith(color: Colors.black),)
            ),

            SizedBox(
              height: 30,
            ),
           Expanded(child:  _previewImages(),)

          ],
        )),


      ],
    );;
  }
  Widget _previewImages() {


    if (_imageFileList != null) {

      return ListView.builder(
        shrinkWrap: true,

        itemBuilder: (BuildContext context, int index) {
          // Why network for web?
          // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
          return Container(
              padding: EdgeInsets.all(20),

              child: CachedNetworkImage(
                imageUrl: urlpic + "report/" +
                    _imageFileList[index].path,
                placeholder:
                    (context, url) =>
                    Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            CircularProgressIndicator(
                              color: Theme.of(
                                  context)
                                  .primaryColor,
                            ),
                          ],
                        )),
                errorWidget: (context,
                    url, error) =>
                const Icon(LineIcons
                    .imageAlt),
                fit: BoxFit.fill,
              ));

        },
        itemCount: _imageFileList!.length,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Icon(LineIcons.imagesAlt,size: 60,),
            onTap: (){},
          )

        ],
      );
    }
  }
}

class  imgModel {
  late final int id;
  late final String path;

  imgModel({required this.id, required this.path, });

  factory imgModel.fromJson(Map<String, dynamic> json) {

    return imgModel(
      id: json["id"],
      path: json["name"],
    );
  }

  static List<imgModel> fromJsonList(List list) {
    return list.map((item) => imgModel.fromJson(item)).toList();
  }

}

