import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:falconpos/api/apiservice.dart';
import 'package:falconpos/api/constant.dart';
import 'package:falconpos/ui/printtest.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/textshow.dart';

class SettingSlip extends StatefulWidget {
  const SettingSlip({Key? key}) : super(key: key);

  @override
  State<SettingSlip> createState() => _SettingSlipState();
}

class _SettingSlipState extends State<SettingSlip> {
  TextEditingController _name = TextEditingController();
  TextEditingController _address1 = TextEditingController();
  TextEditingController _address2 = TextEditingController();
  TextEditingController _line1 = TextEditingController();
  TextEditingController _line2 = TextEditingController();
  TextEditingController _line3 = TextEditingController();
  TextEditingController _ip = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _vatid = TextEditingController();
  String _empname = '';
  String _brach = '';
  String _brachid = '';
  String _wh = '';
  String _nameshow = '';
  String _vatidshow = '';
  String _telshow = '';
  String _address1show = '';
  String _address2show = '';
  String _line1show = '';
  String _line2show = '';
  String _line3show = '';
  String _logo = '';

  File? file;
  String _filename = '';

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      Getsetting(_brach);
      _brachid = prefs.getString('branchid')!;
      _wh = prefs.getString('wh')!;
      print(_brach);
    });
  }

  Getsetting(brach) async {
    ApiSerivces().settingselectslip(brach).then((res) {
      print(res.data[0]);
      setState(() {
        _ip = TextEditingController(text: res.data[0]['ipprint']);
        _name = TextEditingController(text: res.data[0]['name']);
        _address1 = TextEditingController(text: res.data[0]['address1']);
        _address2 = TextEditingController(text: res.data[0]['address2']);
        _tel = TextEditingController(text: res.data[0]['tel']);
        _vatid = TextEditingController(text: res.data[0]['vatid']);
        _line1 = TextEditingController(text: res.data[0]['endline1']);
        _line2 = TextEditingController(text: res.data[0]['endline2']);
        _line3 = TextEditingController(text: res.data[0]['endline3']);

        _nameshow = res.data[0]['name'];
        _vatidshow = res.data[0]['vatid'];
        _telshow = res.data[0]['tel'];
        _address1show = res.data[0]['address1'];
        _address2show = res.data[0]['address2'];
        _line1show = res.data[0]['endline1'];
        _line2show = res.data[0]['endline2'];
        _line3show = res.data[0]['endline3'];
        _logo = res.data[0]['logo'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetLogin();
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
          'Setting Slip',
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

  Widget P(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('IP Printer'),
              controller: _ip,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Company Name'),
              controller: _name,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Vat ID'),
              controller: _vatid,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Address Line 1'),
              controller: _address1,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Address Line 2'),
              controller: _address2,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Tel'),
              controller: _tel,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Text Line 1'),
              controller: _line1,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Text Line 2'),
              controller: _line2,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: inputForm1('Text Line 3'),
              controller: _line3,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                      onPressed: () {


                        ApiSerivces()
                            .settingslip(
                            _name.text,
                            _vatid.text,
                            _tel.text,
                            _address1.text,
                            _address2.text,
                            _line1.text,
                            _line2.text,
                            _line3.text,
                            _ip.text,
                            _brach)
                            .then((value) {
                          setState(() {

                          });
                          uploadImage(context);
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            LineIcons.save,
                            color: Colors.white,
                          ),
                          Text(
                            ' Save',
                            style: textBodyLage,
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lime
                      ),
                      onPressed: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PrintTest()));


                      },
                      child: Row(
                        children: [
                          const Icon(
                            LineIcons.print,
                            color: Colors.white,
                          ),
                          Text(
                            ' TEST',
                            style: textBodyLage,
                          )
                        ],
                      ),
                    ))
              ],
            ),
            Container(
                width: 400,
                height: MediaQuery.of(context).size.height * .8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                        spreadRadius: 2,
                        offset: Offset(0, 4))
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Receipt',
                          style: textLanadscapL.copyWith(
                              color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _logo == ''
                            ? file != null
                            ? InkWell(
                            onTap: () => chooseImage(),
                            child: Container(
                              width: 300,
                              height: 40,
                              child: Image.file(file!,width: 300,fit: BoxFit.fitWidth,),
                            )
                        )
                            : InkWell(
                          onTap: () => chooseImage(),
                          child: Row(
                            children: [
                              const Icon(LineIcons.image),
                              Text(
                                ' JPEG  WIDTH: 300 ',
                                style:
                                textLanadscapL.copyWith(
                                    color:
                                    Colors.black),
                              )
                            ],
                          ),
                        )
                            : Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              height: 50,
                              width: 310,
                              alignment: AlignmentDirectional.center,
                              child: InkWell(
                                child: Image.network(urlpic+"logo/"+_logo,width: 300,),
                              ),
                            ),
                            Positioned(
                              right: 0,

                              child: InkWell(
                                child:
                                CircleAvatar(
                                  backgroundColor: Colors.brown,
                                  radius: 15,
                                  child:  IconButton(onPressed: ()=>chooseImage(), icon: Icon(Icons.edit,color: Colors.white,size: 12,)),
                                ),
                              ),
                            )

                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_nameshow == '' ? "companyname" : _nameshow}',
                          style: textLanadscapL.copyWith(
                              color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'TAX ID : ${_vatidshow == '' ? " " : _vatidshow}',
                          style: textLanadscapL.copyWith(
                              color: Colors.black,fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_address1show == '' ? "Address Line1" : _address1show}',
                          style: textLanadscapL.copyWith(
                              color: Colors.black,fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_address2show == '' ? "Address Line2" : _address2show}',
                          style: textLanadscapL.copyWith(
                              color: Colors.black,fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tel : ${_telshow == '' ? " " : _telshow}',
                          style: textLanadscapL.copyWith(
                              color: Colors.black,fontSize: 14),
                        )
                      ],
                    ),
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_line1show == '' ? "Text Line1" : _line1show}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black,fontSize: 14),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_line2show == '' ? "Text Line2" : _line2show}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black,fontSize: 14),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_line3show == '' ? "Text Line3" : _line3show}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black,fontSize: 14),
                                )
                              ],
                            ),
                          ],
                        ))
                  ],
                )),

          ],
        ),
      ),
    );
  }
  Widget L(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * .83,
                child: Column(
                  children: [
                    Container(
                        width: 470,
                        height: MediaQuery.of(context).size.height * .8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius: 2,
                                offset: Offset(0, 4))
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Receipt',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _logo == ''
                                    ? file != null
                                    ? InkWell(
                                    onTap: () => chooseImage(),
                                    child: Container(
                                      width: 300,
                                      height: 40,
                                      child: Image.file(file!,width: 300,fit: BoxFit.fitWidth,),
                                    )
                                )
                                    : InkWell(
                                  onTap: () => chooseImage(),
                                  child: Row(
                                    children: [
                                      const Icon(LineIcons.image),
                                      Text(
                                        ' JPEG  WIDTH: 300 ',
                                        style:
                                        textLanadscapL.copyWith(
                                            color:
                                            Colors.black),
                                      )
                                    ],
                                  ),
                                )
                                    : Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 310,
                                      alignment: AlignmentDirectional.center,
                                      child: InkWell(
                                        child: Image.network(urlpic+"logo/"+_logo,width: 300,),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,

                                      child: InkWell(
                                        child:
                                        CircleAvatar(
                                          backgroundColor: Colors.brown,
                                          radius: 15,
                                          child:  IconButton(onPressed: ()=>chooseImage(), icon: Icon(Icons.edit,color: Colors.white,size: 12,)),
                                        ),
                                      ),
                                    )

                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_nameshow == '' ? "companyname" : _nameshow}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'TAX ID : ${_vatidshow == '' ? " " : _vatidshow}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_address1show == '' ? "Address Line1" : _address1show}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_address2show == '' ? "Address Line2" : _address2show}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Tel : ${_telshow == '' ? " " : _telshow}',
                                  style: textLanadscapL.copyWith(
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_line1show == '' ? "Text Line1" : _line1show}',
                                          style: textLanadscapL.copyWith(
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_line2show == '' ? "Text Line2" : _line2show}',
                                          style: textLanadscapL.copyWith(
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_line3show == '' ? "Text Line3" : _line3show}',
                                          style: textLanadscapL.copyWith(
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: inputForm1('IP Printer'),
                          controller: _ip,
                        ),
                        TextFormField(
                          decoration: inputForm1('Company Name'),
                          controller: _name,
                        ),
                        TextFormField(
                          decoration: inputForm1('Vat ID'),
                          controller: _vatid,
                        ),
                        TextFormField(
                          decoration: inputForm1('Address Line 1'),
                          controller: _address1,
                        ),
                        TextFormField(
                          decoration: inputForm1('Address Line 2'),
                          controller: _address2,
                        ),
                        TextFormField(
                          decoration: inputForm1('Tel'),
                          controller: _tel,
                        ),
                        TextFormField(
                          decoration: inputForm1('Text Line 1'),
                          controller: _line1,
                        ),
                        TextFormField(
                          decoration: inputForm1('Text Line 2'),
                          controller: _line2,
                        ),
                        TextFormField(
                          decoration: inputForm1('Text Line 3'),
                          controller: _line3,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                  onPressed: () {


                                    ApiSerivces()
                                        .settingslip(
                                        _name.text,
                                        _vatid.text,
                                        _tel.text,
                                        _address1.text,
                                        _address2.text,
                                        _line1.text,
                                        _line2.text,
                                        _line3.text,
                                        _ip.text,
                                        _brach)
                                        .then((value) {
                                      setState(() {

                                      });
                                      uploadImage(context);
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        LineIcons.save,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Save',
                                        style: textBodyLage,
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lime
                                  ),
                                  onPressed: () {

                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PrintTest()));


                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        LineIcons.print,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' TEST',
                                        style: textBodyLage,
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
  chooseImage() async {
    XFile? xfile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 300);
    if (kDebugMode) {
      print(xfile?.path);
    }

    setState(() {
      file = File(xfile!.path);
      print(file!.path);
      _filename = xfile.name;
    });
  }

  uploadImage(context) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file!.path, filename: _filename),
      "name": _brach
    });
    Dio _dio = new Dio();

    try {
      Response res =
          await _dio.post(url + '/settinguploadlogo', data: formData);
      if (res.statusCode == 200) {
        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
}
