import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../theme/textshow.dart';
import '../ui/customersweb.dart';
import 'alert.dart';
import 'autocompletethaiprovice.dart';

class AddNewCustomer extends StatefulWidget {
  var genoder;
  var custid;
   AddNewCustomer({Key? key ,this.genoder,this.custid}) : super(key: key);

  @override
  State<AddNewCustomer> createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends State<AddNewCustomer> {
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

    if(widget.custid != null) {
      LoadCustomerid(widget.custid);
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomerWeb(genoder: widget.genoder,)));
          }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text(
          'Add New Customers',
          style: textBodyLage.copyWith(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _id == 0
                            ? Text(
                          'Add New Customer',
                          style: textLanadscapL.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                            : Text(
                          'Edit New Customer',
                          style: textLanadscapL.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
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
                                  _brithday.text,
                                  _social.text,
                                  _country.text,
                                  _address.text,
                                  _provice.text,
                                  _distic.text,
                                  _subdist.text,
                                  _zipcode.text,
                                  _remark.text)
                                  .then((value) =>
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomerWeb(genoder: widget.genoder,))));
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
                                  _brithday.text,
                                  _social.text,
                                  _country.text,
                                  _address.text,
                                  _provice.text,
                                  _distic.text,
                                  _subdist.text,
                                  _zipcode.text,
                                  _remark.text)
                                  .then((value) =>
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomerWeb(genoder: widget.genoder,))));
                            }, context, 'How do you confirm');
                          }
                        },
                        icon: Icon(
                          _id == 0
                              ? LineIcons.plusCircle
                              : LineIcons.save,
                          size: 32,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
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
                          dropdownBuilder: (BuildContext context, item) {
                            return Container(
                                padding: const EdgeInsets.all(14),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
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
                                              color: Theme.of(context)
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
                          dropdownBuilder: (BuildContext context, item) {
                            return Container(
                                padding: const EdgeInsets.all(14),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
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
                                              color: Theme.of(context)
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
                          dropdownBuilder: (BuildContext context, item) {
                            return Container(
                                padding: const EdgeInsets.all(14),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
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
                                              color: Theme.of(context)
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
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'yyyy-MM-dd',
                        controller: _brithday,
                        //initialValue: _initialValue,
                        firstDate: DateTime(1800),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
                        dateHintText: 'วันที่เกิด',

                        decoration: inputForm1('วันที่เกิด'),

                        locale: const Locale('th', 'TH'),

                        onChanged: (val) => setState(() {
                          _britdaytext = val;

                          setState(() {});
                        }),
                        validator: (val) {
                          setState(() => _britdaytext = val ?? '');
                          return null;
                        },
                        onSaved: (val) =>
                            setState(() => _britdaytext = val ?? ''),
                      ),
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
                                fontSize: 16, color: Colors.blueGrey),
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
                              onTap: () => _showProv(),
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
                              onTap: () => _showProv(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
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
                              onTap: () => _showProv(),
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
                        onTap: () => _showProv(),
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

