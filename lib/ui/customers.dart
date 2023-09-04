import 'dart:async';

import 'package:country_picker/country_picker.dart';

import 'package:falconpos/theme/textshow.dart';
import 'package:falconpos/ui/mainpage.dart';
import 'package:falconpos/ui/mainpos.dart';
import 'package:falconpos/widget/alert.dart';

import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiselectprovice.dart';
import '../api/apiservice.dart';
import '../function/function.dart';
import '../widget/autocompletethaiprovice.dart';

class Custoumers extends StatefulWidget {
  var genoder;
   Custoumers({Key? key , this.genoder}) : super(key: key);

  @override
  State<Custoumers> createState() => _CustoumersState();
}

class _CustoumersState extends State<Custoumers> {
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
  String _bday = '';
  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(int.parse(DateFormat('yyyy').format(DateTime.now().toLocal()))),
      lastDate: DateTime(int.parse(DateFormat('yyyy').format(DateTime.now().toLocal()))+1),
    );

    if (date != null) {
      setState(() {
        _bday = DateFormat('yyyy-MM-dd').format(date);
      });
    }
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
        _bday = res.data[0]['birthday'].toString();

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
        title: Text(
          'Customers',
          style: textBodyLage.copyWith(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                                 Expanded(child:  Container(
                                   padding: const EdgeInsets.all(20),
                                   child: TextFormField(
                                     controller: _scr,
                                     decoration: inputForm1('Scerch  Customers'),
                                     onChanged: (e) {
                                       setState(() {
                                         LoadCustomer(e, 0, 10);
                                       });
                                     },
                                   ),
                                 ),),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(onPressed: (){
                                    setState(() {
                                      _id = 0;
                                      _name.clear();

                                      _tel.clear();
                                      _email.clear();
                                      _gender = "";
                                      _purpose = "";
                                      _age = "";
                                      keygender.currentState?.setSelectedItem('');
                                      keyage.currentState?.setSelectedItem('');
                                      keypurpose.currentState?.setSelectedItem('');
                                      _address.clear();
                                      _social.clear();
                                      _country.clear();
                                      _brithday.clear();
                                      _provice.clear();
                                      _subdist.clear();
                                      _distic.clear();


                                      _zipcode.clear();
                                      _remark.clear();
                                    });
                                  }, icon: Icon(LineIcons.userPlus,size: 42,)),
                                  SizedBox(
                                    width: 20,
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
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
                            if (stream.connectionState == ConnectionState
                                .waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (stream.hasError) {
                              return Center(
                                  child: Text(stream.error.toString()));
                            }
                            var querySnapshot = stream.data;

                            if (stream.data!.length == 0) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      const Icon(
                                        LineIcons.exclamationTriangle,
                                        size: 50,
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
                                          size: 40,
                                        ),
                                        title: Text(
                                          querySnapshot[i]['name'],
                                          style: textLanadscapL.copyWith(
                                              color: Colors.black),
                                        ),
                                        trailing: SizedBox(
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(onPressed: () async {
                                                print(querySnapshot[i]['id']);
                                                await LoadCustomerid(
                                                    querySnapshot[i]['id']);
                                              },
                                                icon: const Icon(
                                                    LineIcons.userEdit),),
                                              IconButton(
                                                icon: const Icon(
                                                    LineIcons.removeUser),
                                                onPressed: () async {
                                                  ConfirmAlert(() async {
                                                    await ApiSerivces()
                                                        .Coustomerdel(
                                                        querySnapshot[i]['id'])
                                                        .then((e) {
                                                      LoadCustomer(
                                                          _scr.text, start,
                                                          stop);
                                                      Navigator.pop(context);
                                                    });
                                                  }, context,
                                                      'How do you confirm delete?');
                                                },
                                              ),
                                              _chkd == querySnapshot[i]['id'].toString()?IconButton(
                                                icon: const Icon(
                                                    LineIcons.checkCircle),
                                                onPressed: () async {
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                 setState(() {

                                                   prefs.remove('custid');
                                                   getSelect();

                                                 });
                                                }
                                                ,
                                              ):IconButton(
                                                icon: const Icon(
                                                    LineIcons.check),
                                                onPressed: () async {
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  setState(() {


                                                    prefs.setString('custid', querySnapshot[i]['id'].toString());
                                                    getSelect();
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                MainPOS(
                                                                  custid: querySnapshot[i]['id'],
                                                                  custcode: querySnapshot[i]['code'],
                                                                  custname: querySnapshot[i]['name'],
                                                                genorder: widget.genoder,)));
                                                  });
                                                }
                                                ,
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
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .9,
                      child: Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: _id == 0?Text(
                                      'Add New Customer',
                                      style: textLanadscapL.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ):Text(
                                      'Edit New Customer',
                                      style: textLanadscapL.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                ),

                                IconButton(
                                    onPressed: () async {
                                      if (_id == 0) {
                                        ConfirmAlert(() async {
                                          await ApiSerivces()
                                              .Coustomeradd(
                                              _name.text,
                                              _lname.text,
                                              _tel.text,
                                              _email.text,
                                              _gender,
                                              _purpose,
                                              _age,
                                              _bday,
                                              _social.text,
                                              _country.text,
                                              _address.text,
                                              _provice.text,
                                              _distic.text,
                                              _subdist.text,
                                              _zipcode.text,
                                              _remark.text)
                                              .then((value) =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                       Custoumers(genoder: widget.genoder,))));
                                        }, context, 'How do you confirm');
                                      } else {
                                        ConfirmAlert(() async {
                                          await ApiSerivces()
                                              .Coustomeredit(
                                              _id,
                                              _name.text,
                                              _lname.text,
                                              _tel.text,
                                              _email.text,
                                              _gender,
                                              _purpose,
                                              _age,
                                              _bday,
                                              _social.text,
                                              _country.text,
                                              _address.text,
                                              _provice.text,
                                              _distic.text,
                                              _subdist.text,
                                              _zipcode.text,
                                              _remark.text)
                                              .then((value) =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                       Custoumers(genoder: widget.genoder,))));
                                        }, context, 'How do you confirm');
                                      }
                                    },
                                    icon:  Icon(
                                      _id==0?LineIcons.plusCircle:LineIcons.save,
                                      size: 32,
                                    )),

                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: inputForm1('Name'),
                                    controller: _name,
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: inputForm1('Tel'),
                                    controller: _tel,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: inputForm1('Email'),
                                    controller: _email,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: FindDropdown<String>(
                                      key: keygender,
                                      showSearchBox: false,
                                      items: const ["Male", "Female", "LGBTQ+"],

                                      onChanged: (String? item) {
                                        setState(() {
                                          _gender = item!;
                                        });
                                      },
                                      dropdownBuilder: (BuildContext context,
                                          item) {
                                        return Container(
                                            padding: const EdgeInsets.all(14),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(15.0),
                                              border: Border.all(
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              color: Colors.white,
                                            ),
                                            child: item == null
                                                ? Row(
                                              children: [
                                                Expanded(
                                                  child: Text('Gender',
                                                      style: textBody.copyWith(
                                                          fontSize: 14,
                                                          color: Theme
                                                              .of(context)
                                                              .primaryColor)),
                                                ),
                                                const Icon(Icons
                                                    .keyboard_arrow_down_sharp)
                                              ],
                                            )
                                                : Row(
                                              children: [
                                                Text('${item}',
                                                    style: textBody.copyWith(
                                                        fontSize: 14,
                                                        color: Colors.black))
                                              ],
                                            ));
                                      },
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: FindDropdown(
                                      key: keypurpose,
                                      showSearchBox: false,
                                      items: const ["Gift", "Use", "Etc"],
                                      onChanged: (String? item) {
                                        setState(() {
                                          _purpose = item!;
                                        });
                                      },
                                      dropdownBuilder: (BuildContext context,
                                          item) {
                                        return Container(
                                            padding: const EdgeInsets.all(14),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(15.0),
                                              border: Border.all(
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              color: Colors.white,
                                            ),
                                            child: item == null
                                                ? Row(
                                              children: [
                                                Expanded(
                                                  child: Text('Purpose',
                                                      style: textBody.copyWith(
                                                          fontSize: 14,
                                                          color: Theme
                                                              .of(context)
                                                              .primaryColor)),
                                                ),
                                                const Icon(Icons
                                                    .keyboard_arrow_down_sharp)
                                              ],
                                            )
                                                : Row(
                                              children: [
                                                Text('${item}',
                                                    style: textBody.copyWith(
                                                        fontSize: 14,
                                                        color: Colors.black))
                                              ],
                                            ));
                                      },
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: FindDropdown(
                                      key: keyage,
                                      showSearchBox: false,
                                      items: const [
                                        "12-20",
                                        "20-25",
                                        "26-30",
                                        "31-35",
                                        "36-40",
                                        "41-45",
                                        "46-50",
                                        "51-55",
                                        "56-60",
                                        '60-70',
                                        'over 71'
                                      ],
                                      onChanged: (String? item) {
                                        setState(() {
                                          _age = item!;
                                        });
                                      },
                                      dropdownBuilder: (BuildContext context,
                                          item) {
                                        return Container(
                                            padding: const EdgeInsets.all(14),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(15.0),
                                              border: Border.all(
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor,
                                                  width: 1),
                                              color: Colors.white,
                                            ),
                                            child: item == null
                                                ? Row(
                                              children: [
                                                Expanded(
                                                  child: Text('Age',
                                                      style: textBody.copyWith(
                                                          fontSize: 14,
                                                          color: Theme
                                                              .of(context)
                                                              .primaryColor)),
                                                ),
                                                const Icon(Icons
                                                    .keyboard_arrow_down_sharp)
                                              ],
                                            )
                                                : Row(
                                              children: [
                                                Text('${item}',
                                                    style: textBody.copyWith(
                                                        fontSize: 14,
                                                        color: Colors.black))
                                              ],
                                            ));
                                      },
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: ()=>displayDatePicker,
                                    child: Row(
                                      children: [
                                        Icon(LineIcons.birthdayCake),
                                        Text('${_bday}')
                                      ],
                                    ) ,
                                  )
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: TextFormField(
                                      decoration: inputForm1('Social Meadia'),
                                      controller: _social,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                controller: _country,
                                decoration: inputForm1('Country'),
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    countryListTheme: CountryListThemeData(
                                        flagSize: 25,
                                        backgroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                        bottomSheetHeight: 500,
                                        // Optional. Country list modal height
                                        //Optional. Sets the border radius for the bottomsheet.
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        //Optional. Styles the search field.
                                        inputDecoration: inputForm1('Search')),
                                    onSelect: (Country country) {
                                      setState(() {
                                        _country.text = country.name;
                                      });
                                    },
                                  );
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: inputForm1('Address'),
                              controller: _address,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: inputForm1('Provice'),
                                          controller: _provice,
                                          onTap: ()=> _showProv(),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: inputForm1('District'),
                                          controller: _distic,
                                          onTap: ()=> _showProv(),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: inputForm1('SubDistrict'),
                                          controller: _subdist,
                                          onTap: ()=> _showProv(),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: inputForm1('Zipcode'),
                                    controller: _zipcode,
                                    onTap: ()=> _showProv(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                      decoration: inputForm1('Note'),
                                      controller: _remark,
                                      maxLines: 3,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  Future _showProv() {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
               title: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   InkWell(
                     child: Container(

                       child: const Icon(LineIcons.timesCircle)
                     ),
                     onTap:(){
                       Navigator.pop(context);
                     },
                   ),
                 ],
               ),

                content: AuotProivceShow(
                  pv: _provice, amp: _distic, dis: _subdist, zip: _zipcode,)

            )
    );
  }
}