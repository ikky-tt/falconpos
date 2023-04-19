import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:falconpos/theme/textshow.dart';
import 'package:falconpos/ui/mainpage.dart';
import 'package:falconpos/widget/addnewcustomer.dart';
import 'package:falconpos/widget/alert.dart';

import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiselectprovice.dart';
import '../api/apiservice.dart';
import '../function/function.dart';
import '../widget/autocompletethaiprovice.dart';

class CustomerWeb extends StatefulWidget {
  var genoder;

  CustomerWeb({Key? key, this.genoder}) : super(key: key);

  @override
  State<CustomerWeb> createState() => _CustomerWebState();
}

class _CustomerWebState extends State<CustomerWeb> {
  final _key = GlobalKey<FormState>();
  var keyprovie = GlobalKey<FindDropdownState>();
  var keyamp = GlobalKey<FindDropdownState>();
  var keydistic = GlobalKey<FindDropdownState>();
  var keyage = GlobalKey<FindDropdownState>();
  var keygender = GlobalKey<FindDropdownState>();
  var keypurpose = GlobalKey<FindDropdownState>();

  int start = 0;
  int stop = 9;
  bool _loadingmore = false;

  String _sex = '';
  TextEditingController _address = TextEditingController();
  TextEditingController _zipcode = TextEditingController();
  TextEditingController _brithday = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _social = TextEditingController();
  TextEditingController _provice = TextEditingController();
  TextEditingController _distic = TextEditingController();
  TextEditingController _subdist = TextEditingController();
  TextEditingController _pvcode = TextEditingController();
  TextEditingController _disticcode = TextEditingController();
  String _gender = '';
  String _purpose = '';
  String _age = '';

  TextEditingController _country = TextEditingController();
  TextEditingController _remark = TextEditingController();
  String _britdaytext = '';

  String _userDataubdistic = '';
  String _userDatadistic = '';
  String _userDataprovice = '';
  String _userDatazipcode = '';
  dynamic _proviceid = '';
  dynamic _ampid = '';

  int _id = 0;
  String? _chkd = '';
  final ScrollController _scrollController = ScrollController();

  TextEditingController _scr = TextEditingController();

  final StreamController _streamController = StreamController();

  LoadCustomer(scr, start, stop) async {
    ApiSerivces().CoustomerShow(scr, start, stop).then((res) async {
      _streamController.add(res.data);

      print(res.data);
    });
  }

  Future<void> LoadCustomerid(id) async {
    ApiSerivces().CoustomerShowSelect(id).then((res) async {
      print(res.data[0]);
      setState(() {
        _id = res.data[0]['id'];
        _name.text = res.data[0]['name'].toString();

        _tel.text = res.data[0]['tel1'];
        _email.text = res.data[0]['email'];
        _gender = res.data[0]['gender'].toString();
        _purpose = res.data[0]['purpose'];
        _age = res.data[0]['age'];
        keygender.currentState?.setSelectedItem(_gender);
        keyage.currentState?.setSelectedItem(_age);
        keypurpose.currentState?.setSelectedItem(_purpose);
        _address.text = res.data[0]['address'];
        _social.text = res.data[0]['social'];
        _country.text = res.data[0]['country'];
        _brithday.text = res.data[0]['birthday'].toString();

        _provice.text = res.data[0]['province'];
        _subdist.text = res.data[0]['district'];
        _distic.text = res.data[0]['amphur'];

        _zipcode.text = res.data[0]['postcode'];
        _remark.text = res.data[0]['remark'];
      });
    });
  }

  getSelect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _chkd = prefs.getString('custid');
      print(_chkd);
    });
  }

  Future<void> scrollLister() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _loadingmore = true;
      });
      stop = stop + 8;

      await LoadCustomer('', start, stop);
      setState(() {
        _loadingmore = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadCustomer('', start, stop);
    _scrollController.addListener(scrollLister);
    getSelect();
    print(widget.genoder);
  }

  late String countryValue;
  String stateValue = "";
  String cityValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
           onPressed: () {
             Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(
                 builder: (
                 context) =>
                 MainPage(
                   genorder: widget.genoder,)));
           }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text(
          'Customers',
          style: textBodyLage.copyWith(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _scr,
                                decoration: inputForm1('Scerch  Customers'),
                                onChanged: (e) {
                                  setState(() {
                                    LoadCustomer(e, 0, 10);
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),


                        ],
                      ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Card(
                    child: StreamBuilder(
                      stream: _streamController.stream,
                      builder: (context, stream) {
                        if (!stream.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(LineIcons.exclamationCircle),
                                  Text('No Data',
                                      style: textLanadscapL.copyWith(
                                          color: Colors.black)),
                                ],
                              )
                            ],
                          );
                        }
                        if (stream.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (stream.hasError) {
                          return Center(child: Text(stream.error.toString()));
                        }
                        var querySnapshot = stream.data;

                        if (stream.data!.length == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    LineIcons.exclamationTriangle,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('No Data',
                                      style: textLanadscapL.copyWith(
                                          color: Colors.black)),
                                ],
                              )
                            ],
                          );
                        }

                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: _loadingmore
                                ? stream.data!.length + 1
                                : stream.data!.length,
                            itemBuilder: (context, i) {
                              if (i < stream.data!.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    leading: const Icon(
                                      LineIcons.userCircle,
                                      size: 30,
                                    ),
                                    title: Text(
                                      querySnapshot[i]['name'],
                                      style: textLanadscapL.copyWith(
                                          color: Colors.black,fontSize:14),
                                    ),
                                    trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width*.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              print(querySnapshot[i]['id']);
                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewCustomer(genoder: widget.genoder,custid: querySnapshot[i]['id'],)));

                                            },
                                            icon:
                                                const Icon(LineIcons.userEdit ,size: 20,),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                LineIcons.removeUser, size: 20,),
                                            onPressed: () async {
                                              ConfirmAlert(() async {
                                                await ApiSerivces()
                                                    .Coustomerdel(
                                                        querySnapshot[i]['id'])
                                                    .then((e) {
                                                  LoadCustomer(
                                                      _scr.text, start, stop);
                                                  Navigator.pop(context);
                                                });
                                              }, context,
                                                  'How do you confirm delete?');
                                            },
                                          ),
                                          _chkd ==
                                                  querySnapshot[i]['id']
                                                      .toString()
                                              ? IconButton(
                                                  icon: const Icon(
                                                      LineIcons.checkCircle, size: 20,),
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    setState(() {
                                                      prefs.remove('custid');
                                                      getSelect();
                                                    });
                                                  },
                                                )
                                              : IconButton(
                                                  icon: const Icon(
                                                      LineIcons.check,size:20),
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    setState(() {
                                                      prefs.setString(
                                                          'custid',
                                                          querySnapshot[i]['id']
                                                              .toString());
                                                      getSelect();
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MainPage(
                                                                        custid: querySnapshot[i]
                                                                            ['id'],
                                                                        custcode:
                                                                            querySnapshot[i]['code'],
                                                                        custname:
                                                                            querySnapshot[i]['name'],
                                                                        genorder:
                                                                            widget.genoder,
                                                                      )));
                                                    });
                                                  },
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      },
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {

            Navigator.push(context,MaterialPageRoute(builder: (context)=>AddNewCustomer(genoder: widget.genoder,)));

          }, child: Icon(LineIcons.userPlus)),
    );
  }

  Future _showProv() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(child: const Icon(LineIcons.timesCircle)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            content: AuotProivceShow(
              pv: _provice,
              amp: _distic,
              dis: _subdist,
              zip: _zipcode,
            )));
  }
}
