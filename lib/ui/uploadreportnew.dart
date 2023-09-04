
import 'package:falconpos/ui/uploadreport.dart';
import 'package:falconpos/widget/alert.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/constant.dart';
import '../theme/textshow.dart';
import 'login.dart';

class UPloadreportnew extends StatefulWidget {
  const UPloadreportnew({Key? key}) : super(key: key);

  @override
  State<UPloadreportnew> createState() => _UPloadreportnewState();
}

class _UPloadreportnewState extends State<UPloadreportnew> {

  List<XFile>? _imageFileList;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }
  List<dynamic> _data = [];
  final oCcy = NumberFormat("#,###.##", "th_TH");

  String _docno = '';
  late String gencode;

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
  DateTime _dateshow = DateTime.now();
  String valueChanged2 ='';
  int _empid = 0;
  String _date = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  String _time = DateFormat("HH:mm").format(DateTime.now()).toString();

  final TextEditingController _de = TextEditingController();
  final TextEditingController _dateedit = TextEditingController();

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(int.parse(DateFormat('yyyy').format(DateTime.now().toLocal()))),
      lastDate: DateTime(int.parse(DateFormat('yyyy').format(DateTime.now().toLocal()))+1),
    );

    if (date != null) {
      setState(() {
        valueChanged2 = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

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


  bool _folded = true;

  @override
  initState() {
    GetLogin();

    // TODO: implement initState
    super.initState();
    gencode = new DateTime.now().millisecondsSinceEpoch.toString();
    valueChanged2 = DateFormat('dd/MMM/yyyy').format(_dateshow);


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
          'Add New Report ${DateFormat('dd/MM/yy').format(DateTime.now())}',
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
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      chooseImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(LineIcons.image,color: Colors.white,),
                          Text(' Select Image',style: textBodyLage,),
                        ],
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height:  MediaQuery.of(context).size.height*.5,
              width: MediaQuery.of(context).size.width*.5,
              child: _previewImages(),
            ),

          ],
        ),),
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                    child: InkWell(
                      onTap: ()=>displayDatePicker(context),
                      child: Text('${valueChanged2}'),
                    )
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Note',style: textBodyLage.copyWith(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: inputForm1(''),
                maxLines: 10,
                controller: _de,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        uploadImages(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(LineIcons.save,color: Colors.white,),
                            Text(' Save',style: textBodyLage,),
                          ],
                        ),
                      )),
                ],
              ),
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
      children: [
        Expanded(child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      chooseImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(LineIcons.image,color: Colors.white,),
                          Text(' Select Image',style: textBodyLage,),
                        ],
                      ),
                    )),
              ],
            ),
           
            Expanded(child: _previewImages(),)

          ],
        ),),
        Expanded(
          flex: 2,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: InkWell(
                      onTap: ()=>displayDatePicker(context),
                      child: Text('${valueChanged2}'),
                    )
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('Note',style: textBodyLage.copyWith(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800),),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: inputForm1(''),
                maxLines: 10,
                controller: _de,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        uploadImages(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(LineIcons.save,color: Colors.white,),
                            Text(' Save',style: textBodyLage,),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            )

          ],
        ))
      ],
    );
  }

  chooseImage() async {
    List<XFile>? xfile = await ImagePicker()
        .pickMultiImage( maxWidth: 400);
    if (kDebugMode) {
     print(xfile);
    }
    setState(() {
      _imageFileList = xfile;
    });
  }
  Widget _previewImages() {


    if (_imageFileList != null) {


      return ListView.builder(

        itemBuilder: (BuildContext context, int index) {
          // Why network for web?
          // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
          return kIsWeb
              ? Container(
            padding: EdgeInsets.all(20),
            width: 200,
              height: 200,
              child: Image.network(_imageFileList![index].path,width: MediaQuery.of(context).size.width*.3,scale: 1,))
              :Row();
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
            onTap: ()=>chooseImage(),
          )

        ],
      );
    }
  }

  // uploadImage(context) async {
  //
  //    Dio _dio = new Dio();
  //
  //    print(_data.length);
  //
  //    List<MultipartFile> files = [];
  //    for(int i=0; i< _imageFileList!.length; i++ ){
  //
  //      var   _filename = _imageFileList![i].name;
  //      final bytes =  await _imageFileList![i].readAsBytes();
  //
  //      files.add(await MultipartFile.fromBytes(bytes,filename: _filename)
  //      );
  //
  //    }
  //
  //
  //    FormData formData = FormData.fromMap({"images": files});
  //
  //    print(formData.files);
  //  await _dio.post(url + '/settinguploadreportnew', data: {'data':formData},
  //       options: Options(headers: {
  //         "Content-Type": "multipart/form-data",
  //         }));
  //
  //  //  var res =
  //
  // }
  Future<void> uploadImages(context) async {

    if( _imageFileList != null ) {
      print(_imageFileList);
    final urlx = url + '/settinguploadreportnew';

    final request = http.MultipartRequest('POST', Uri.parse(urlx));
    for(int i=0; i< _imageFileList!.length; i++ ){

           var   _filename = _imageFileList![i].name;
           var bytes =  await _imageFileList![i].readAsBytes();
           final multipartFile = await http.MultipartFile.fromBytes('images',bytes,filename: _filename);
           request.files.add(multipartFile);
         }

      request.fields.addAll({'gencode':gencode,'dateshow':_dateedit.text,'empid':_empid.toString(),'de':_de.text,'branchid':_brachid.toString()});

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Images uploaded successfully');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>UPloadReport()));
    } else {

      AlertShow( context, 'Failed to upload images Type Again');

      print('Failed to upload images');


    }
  } else {
      AlertShow( context, 'Select Images');
    }
  }
}
