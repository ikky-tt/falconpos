import 'dart:async';

import 'package:barcode_scan2/gen/protos/protos.pb.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconpos/ui/sumpay.dart';
import 'package:falconpos/widget/autoshowdistic.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../api/constant.dart';
import '../function/function.dart';
import '../model/usermodel.dart';
import '../theme/textshow.dart';
import '../widget/barcodescan.dart';
import '../widget/discount.dart';
import '../widget/divbraek.dart';
import '../widget/editdata.dart';
import '../widget/numpad.dart';
import 'customers.dart';
import 'login.dart';
import 'mainmenu.dart';
import 'mainpage.dart';

class POSLandscape extends StatefulWidget {
  var custid;
  var custname;
  var custcode;
  var genorder;

  POSLandscape(
      {Key? key,
      required this.genorder,
      this.custcode,
      this.custid,
      this.custname})
      : super(key: key);

  @override
  State<POSLandscape> createState() => _POSLandscapeState();
}

class _POSLandscapeState extends State<POSLandscape> {
  var countriesKey = GlobalKey<FindDropdownState>();
  final oCcy = NumberFormat("#,###.##", "th_TH");
  List _controllerlist = [];
  List _controllerlist2 = [];
  String _docno = '';
  late String genorder;
  String _sum = '0';
  String _custcode = '';
  String _custname = '';
  String _custid = '';
  String _tel = '';
  String _count = "0";
  String _set = "";
  String _chkdisconut = '1';
  num _tax = 0;
  num _sumtot = 0;
  num _subtot = 0;
  num _discount = 0;
  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _brachid = 0;

  String _discounttext = '';

  num _vd = 0;

  late FocusNode _nodfocus;

  String _date = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  String _time = DateFormat("HH:mm").format(DateTime.now()).toString();

  final StreamController _streamController = StreamController.broadcast();
  final StreamController _streamController2 = StreamController.broadcast();
  final StreamController _stream = StreamController.broadcast();
  final StreamController _stream3 = StreamController.broadcast();
  final TextEditingController _scr = TextEditingController();
  final TextEditingController _barcodetext = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  bool _chkmodifile = false;
  int _lv = 0;
  DateTime _dateshow = DateTime.now();
  late ScanResult scanResult;

  final _aspectTolerance = 0.00;
  final _selectedCamera = -1;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;

  DocNo() async {
    await ApiSerivces().ApiDocno().then((res) {
      setState(() {
        _docno = res.data['docno'].toString();
      });
    });
  }

  int? _login = 0;
  String _salechanel = '';

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;
      _lv = prefs.getInt('lv')!;
      print(_brachid);
      LoadProudct('', _brachid);
      if (prefs.getInt('login') != 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }else {
        await ApiSerivces().chklogin(prefs.getInt('id')).then((e) async {

          if(e.data.length == 0 || e.data[0]['emp_status'] == 2){

            prefs.clear();
            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));

          }


        });
      }
    });
  }

  clercust() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('custid');
    });
  }

  List<Iterable> addItem = [];

  LoadProudct(scr, branchid) async {
    ApiSerivces().GetProductPos(scr, branchid).then((res) async {
      _streamController.add(res.data);
    });
  }

  LoadProducttype() async {
    ApiSerivces().GetProducttype().then((res) async {
      _streamController2.add(res.data);

      //print(res.data);
    });
  }

  ShowOrder(genorder) async {
    print('xxx');

   await  ApiSerivces().ShowChart(genorder).then((res) async {
      _stream.add(res.data);
      _stream3.add(res.data);
    });
   await SumPos(genorder);
   await CountOrder(genorder);
  }

  CountOrder(docno) async {
    print('count');
   await ApiSerivces().ContChart(docno).then((e) {
      //  print(e.data[0]['co']);

      setState(() {
        _count = e.data[0]['co'].toString();

      });
    });
  }

  Future EditDate(){
    TextEditingController _textb  = TextEditingController();
    TextEditingController _textbid = TextEditingController();
    TextEditingController _textsalech = TextEditingController();
    TextEditingController _textwh = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: MediaQuery.of(context).size.height*.4,
            child: EditDateDate(
              dateshow: _dateshow,
              controller2: _controller2,
              onSubmit: (){
                setState((){

                  _chkmodifile = true;

                  _dateshow = DateTime.parse(_controller2.text);
                  _salechanel = _textsalech.text;
                  _brach = _textb.text;
                  _brachid = int.parse(_textbid.text);
                  _wh = _textwh.text;


                  Navigator.pop(context);

                  print(_brachid);
                  LoadProudct('', _brachid);

                });

              },
              branchid: _textbid, brancname: _textb, salechanel: _textsalech,wh: _textwh,),
          ),

        );
      },
    );
  }

  SumPos(ordergen) async {

    await  ApiSerivces().SumChart(ordergen).then((e) {
      print(e.data[0]['sum']);

      setState(() {
        if (_chkdisconut == '1') {
          if (e.data[0]['sum'] != null) {
            print('nu');
            _tax = (e.data[0]['sum'] - _discount) * (7 / 107);
            _sum = oCcy.format(e.data[0]['sum']);
            _subtot = e.data[0]['sum'] - _tax;
            _sumtot = e.data[0]['sum'] - _discount;
            _discounttext = oCcy.format(_discount);
          } else {
            _tax = 0;
            _sum = '0';
            _subtot = 0;
            _sumtot = 0;
            _discounttext = oCcy.format(0);
            _discount = 0;
          }
        } else {


          if (e.data[0]['sum'] != null) {
            _vd = e.data[0]['sum'] * (_discount / 100);
            print('nu');
            _tax = (e.data[0]['sum'] - _vd) * (7 / 107);
            _sum = oCcy.format(e.data[0]['sum']);
            _subtot = e.data[0]['sum'] - _tax;
            _sumtot = e.data[0]['sum'] - _vd;

            _discounttext = oCcy.format(_vd);
          } else {
            _tax = 0;
            _sum = '0';
            _subtot = 0;
            _sumtot = 0;
            _vd = 0;
            _discount = 0;
            _discounttext = oCcy.format(0);
          }
        }
      });
    });
  }

  Future<List<UserModelS>> getData(filter) async {
    var response = await ApiSerivces().CoustomerShowSelect(filter);

    final data = response.data;
    // print(data);
    if (data != null) {
      return UserModelS.fromJsonList(data);
    }
    return [];
  }

  bool _folded = true;

  @override
  initState() {
    GetLogin();
    StreamController _stream = new StreamController();
    StreamController _stream2 = new StreamController();
    StreamController _stream3 = new StreamController();
    StreamController _streamController = new StreamController();
    // TODO: implement initState
    super.initState();
    DocNo();
    _controller2.text = DateFormat('dd/MM/yy').format(DateTime.now());
    _nodfocus = FocusNode();

    LoadProducttype();

    if (widget.genorder == null) {
     // genorder = new DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      genorder = widget.genorder as String;
    }
    print("widget.genorder");
    print(widget.genorder);
    print("genorder");
    print(genorder);

    ShowOrder(genorder);
    kIsWeb?_salechanel='Web POS':_salechanel=='POS';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context)
                                    .primaryColor, //<-- SEE HERE
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainPage()));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context)
                                    .primaryColor, //<-- SEE HERE
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.list,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainMenu()));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(15),
                              decoration:  BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(DateFormat('dd/MM/yy').format(_dateshow),style: textBodyMedium.copyWith(color: Colors.white,fontSize: 16),),

                                  _lv==1?Container(
                                    padding: EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                        alignment: Alignment.center,
                                        onPressed: (){

                                          EditDate();

                                        },
                                        icon: Icon(Icons.edit,color: Colors.white,size: 16,)),
                                  ):Row(),


                                ],
                              ),

                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: _folded
                                      ? 56
                                      : MediaQuery.of(context).size.width * .4,
                                  height: 56,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: Theme.of(context).primaryColor,
                                      boxShadow: kElevationToShadow[0]),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 7, 10, 7),
                                        child: !_folded
                                            ? TextFormField(
                                                controller: _scr,
                                                decoration: InputDecoration(
                                                    hintText: 'search...'),
                                                onChanged: (v) {
                                                  LoadProudct(v, _brachid);
                                                },
                                              )
                                            : null,
                                      )),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: InkWell(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    _folded ? 32 : 0),
                                                topRight: Radius.circular(32),
                                                bottomLeft: Radius.circular(
                                                    _folded ? 32 : 0),
                                                bottomRight:
                                                    Radius.circular(32)),
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: _folded
                                                  ? Icon(
                                                      Icons.search,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(Icons.close),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _folded = !_folded;
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: kElevationToShadow[0]),
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(
                                    LineIcons.barcode,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                BarcCodeScan().then((value) => SystemChannels
                                    .textInput
                                    .invokeMethod('TextInput.hide'));
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            kIsWeb?Row():
                            InkWell(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: kElevationToShadow[0]),
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(
                                    LineIcons.qrcode,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                scan();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      LoadProudct('', _brachid);
                                    },
                                    child: Card(
                                      color: Colors.green,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      child: Container(
                                        width: 150,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            top: 3,
                                            right: 10,
                                            bottom: 3),
                                        height: 50,
                                        child: Text('All',
                                            style: textBodyLage.copyWith(
                                                fontSize: 14,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  )),
                              Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        offset: Offset(5, 0))
                                  ],
                                ),
                                child: Icon(
                                  LineIcons.angleDoubleLeft,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: StreamBuilder(
                                  stream: _streamController2.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: InkWell(
                                                onTap: () {
                                                  LoadProudct(
                                                      snapshot.data[i]['name'],
                                                      _brachid);
                                                },
                                                child: Card(
                                                  color: Colors.green,
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    //set border radius more than 50% of height and width to make circle
                                                  ),
                                                  child: Container(
                                                    width: 150,
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 3,
                                                        right: 10,
                                                        bottom: 3),
                                                    height: 50,
                                                    child: Text(
                                                        '${snapshot.data[i]['name']}',
                                                        style: textBodyLage
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white)),
                                                  ),
                                                ),
                                              ));
                                        },
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        offset: Offset(-5, 0))
                                  ],
                                ),
                                child: const Icon(
                                  LineIcons.angleDoubleRight,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: _streamController.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: InkWell(
                                          onTap: () async {
                                            await ApiSerivces()
                                                .AddItem(
                                                    genorder,
                                                    snapshot.data[i]['id'],
                                                    snapshot.data[i]['sku'],
                                                    snapshot.data[i]['name'],
                                                    1,
                                                    snapshot.data[i]
                                                        ['sellprice'],
                                                    snapshot.data[i]
                                                        ['sellprice'],
                                                    snapshot.data[i]
                                                                ['discount'] !=
                                                            null
                                                        ? snapshot.data[i]
                                                            ['discount']
                                                        : 0,
                                                    _wh)
                                                .then((value) =>
                                                    ShowOrder(genorder));
                                          },
                                          child: Container(
                                            constraints:
                                                const BoxConstraints.expand(),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: HexColor('7CB4D9'),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 3,
                                                    spreadRadius: 2,
                                                    offset: Offset(0, 2)),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    20)),
                                                        child: snapshot.data[i]
                                                                    ['path'] !=
                                                                null
                                                            ? CachedNetworkImage(
                                                                imageUrl: urlpic +
                                                                    snapshot.data[
                                                                            i][
                                                                        'path'],
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Container(
                                                                        child:
                                                                            Row(
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
                                                                        url,
                                                                        error) =>
                                                                    const Icon(
                                                                        LineIcons
                                                                            .imageAlt),
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(LineIcons
                                                                      .imageAlt)
                                                                ],
                                                              ),
                                                      ),
                                                      Positioned(
                                                          bottom: 2,
                                                          right: 5,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              8)),
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            child: Text(
                                                                snapshot.data[i]['pcost'] == '' ||
                                                                        snapshot.data[i]['pcost'] ==
                                                                            null
                                                                    ? oCcy.format(
                                                                        snapshot.data[i][
                                                                            'sellprice'])
                                                                    : oCcy.format(
                                                                        snapshot.data[i][
                                                                            'pcost']),
                                                                style: textLanadscapL
                                                                    .copyWith(
                                                                        fontSize: 18)),
                                                          )),
                                                      snapshot.data[i][
                                                                  'discount'] !=
                                                              null
                                                          ? Positioned(
                                                              top: 8,
                                                              left: 5,
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8)),
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                child: Text(
                                                                    '${snapshot.data[i]['discount']}%',
                                                                    style: textLanadscapL.copyWith(
                                                                        fontSize:
                                                                            16)),
                                                              ))
                                                          : Row()
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      top: 3,
                                                      right: 10,
                                                      bottom: 3),
                                                  height: 50,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            '${snapshot.data[i]['name']}',
                                                            style: textBodyLage
                                                                .copyWith(
                                                                    fontSize:
                                                                        14)),
                                                      ),
                                                      snapshot.data[i]
                                                                  ['sqty'] !=
                                                              null
                                                          ? Text(
                                                              ' (${snapshot.data[i]['sqty']})',
                                                              style: textBodyLage
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .red))
                                                          : Row(),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  },
                                );
                              }
                              return const Text("....");
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  color: Theme.of(context).primaryColor,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * .16,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      LineIcons.userCircle,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${_empname}',
                                      style: textLanadscapL.copyWith(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      LineIcons.store,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${_brach}',
                                          style: textLanadscapL.copyWith(
                                              fontSize: 12, color: Colors.black),
                                        ),
                                        _lv==1?Padding(
                                          padding: const EdgeInsets.only(left: 4.0),
                                          child: Text('${_salechanel}',style: textBodyMedium,),
                                        ):Row(),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Custoumers(
                                          genoder: genorder,
                                        ))),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.white,
                              ),
                              height: 50,
                              width: MediaQuery.of(context).size.width * .14,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    LineIcons.userEdit,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  widget.custid == null
                                      ? InkWell(
                                          child: Icon(LineIcons.plus),
                                        )
                                      : Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .1,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${widget.custname}',
                                                  maxLines: 1,
                                                  style:
                                                      textLanadscapL.copyWith(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.custid = null;
                                                      widget.custname = null;
                                                      widget.custcode = null;
                                                      clercust();
                                                    });
                                                  },
                                                  icon: Icon(
                                                      LineIcons.timesCircle))
                                            ],
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      divb(),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: StreamBuilder(
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
                                  child: CircularProgressIndicator());
                            }

                            if (stream.hasError) {
                              return Center(
                                  child: Text(stream.error.toString()));
                            }
                            var querySnapshot = stream.data;

                            return ListView.builder(
                                itemCount: stream.data!.length,
                                itemBuilder: (context, i) {
                                  num qtyd = 0;
                                  qtyd = querySnapshot[i]['qty'];

                                  var id = querySnapshot[i]['id'];
                                  _controllerlist.add(TextEditingController(
                                      text: qtyd.toString()));

                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 75,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              querySnapshot[i]['name'],
                                              style: textLanadscapL.copyWith(
                                                  fontSize: 14),
                                            )),
                                        Card(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            child: Text(
                                                oCcy.format(
                                                    querySnapshot[i]['price']),
                                                overflow: TextOverflow.ellipsis,
                                                style: textLanadscapL.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showqt(
                                                context,
                                                querySnapshot[i]['name'],
                                                qtyd,
                                                querySnapshot[i]['id'],
                                                querySnapshot[i]['price']);
                                          },
                                          child: Card(
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 50,
                                              padding: EdgeInsets.all(5),
                                              child: Text('${qtyd}',
                                                  style:
                                                      textLanadscapL.copyWith(
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: querySnapshot[i]
                                                        ['dicount'] ==
                                                    0
                                                ? Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        oCcy.format(
                                                            querySnapshot[i]
                                                                    ['price'] *
                                                                qtyd),
                                                        style: textLanadscapL
                                                            .copyWith(
                                                                fontSize: 20)),
                                                  )
                                                : Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            oCcy.format(
                                                                querySnapshot[i]
                                                                    [
                                                                    'totprice']),
                                                            style: textLanadscapL
                                                                .copyWith(
                                                                    fontSize:
                                                                        20)),
                                                        Text(
                                                            oCcy.format(
                                                                querySnapshot[
                                                                            i][
                                                                        'price'] *
                                                                    qtyd),
                                                            style: textLanadscapL
                                                                .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .red,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough)),
                                                      ],
                                                    ),
                                                  )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        InkWell(
                                          child: Icon(Icons.remove_circle),
                                          onTap: () {
                                            ApiSerivces()
                                                .DeleteItem(id)
                                                .then((e) {
                                              setState(() {

                                                ShowOrder(genorder);
                                              });
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                      divb(),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          height: 220,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Subtotal', style: textLanadscapL),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text("${oCcy.format(_subtot)}",
                                              style: textLanadscapL)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('Tax', style: textLanadscapL),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(oCcy.format(_tax),
                                              style: textLanadscapL)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('Discount', style: textLanadscapL),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(_discounttext,
                                              style: textLanadscapL)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .09,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  HexColor('7CB4D9')),
                                          onPressed: () {},
                                          child: Text(
                                            'Coupon',
                                            style: textLanadscapL.copyWith(
                                                fontSize: 14),
                                          )),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  HexColor('7CB4D9')),
                                          onPressed: () {
                                            discount(genorder);
                                          },
                                          child: Text(
                                            'Discount',
                                            style: textLanadscapL.copyWith(
                                                fontSize: 14),
                                          )),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: Colors.white),
                                            onPressed: () {
                                              _count != '0'
                                                  ? ConfirmOrder()
                                                  : null;
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'PLACE ORDER ฿ ${oCcy.format(_sumtot)} ',
                                                    style:
                                                        textBodyLage.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 21),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future showqt(context, String itemname, num qty, id, pricein) {
    TextEditingController _myController =
        TextEditingController(text: qty.toString());
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          itemname,
          style: textBodyLage.copyWith(fontSize: 18),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * .20,
          height: MediaQuery.of(context).size.height * .7,
          child: NumPad(
            buttonSize: MediaQuery.of(context).size.height * .11,
            iconColor: Theme.of(context).primaryColor,
            controller: _myController,
            delete: () {
              _myController.text = _myController.text
                  .substring(0, _myController.text.length - 1);
            },
            // do something with the input numbers
            onSubmit: () {
              debugPrint('qty: ${_myController.text}');

              var qty = num.parse(_myController.text);
              var price = pricein * qty;
              if (qty == 0) {
                ApiSerivces().DeleteItem(id).then((e) {
                  setState(() {

                    ShowOrder(genorder);
                  });
                });
              } else {
                ApiSerivces().UpDateItem(id, qty, price).then((value) {
                  setState(() {

                    ShowOrder(genorder);
                  });
                });
              }

              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Future discount(id) {
    TextEditingController _disconut = TextEditingController();
    TextEditingController _discountstats = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(
              'Discount',
              style: textBodyLage.copyWith(fontSize: 18,color: Colors.blueAccent),
            ),
            content: Discount(
                buttonSize: MediaQuery.of(context).size.height * .11,
                buttonColor: Colors.white38,
                controller: _disconut,
                discountstatus: _discountstats,
                onSubmit: () {
                  print(_disconut.text);
                  print(_discountstats.text);
                  setState(() {
                    _discount = num.parse(_disconut.text);
                    _chkdisconut = _discountstats.text;

                    ShowOrder(genorder);
                  });

                  Navigator.of(context).pop();
                })));
  }

  Future ConfirmOrder() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                content: SizedBox(
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width * .3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 124,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          'Please check your order confirmation',
                          style: textBodyMedium.copyWith(
                              fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Cancel',
                                style: textBodyLage.copyWith(fontSize: 18)),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            if(_chkmodifile){
                              ApiSerivces()
                                  .PosAdd2(
                                  _docno,
                                  genorder,
                                  widget.custid,
                                  widget.custcode,
                                  widget.custname,
                                  _sumtot,
                                  _tax,
                                  _subtot,
                                  _chkdisconut == '1'?_discount:_vd,
                                  _brach,
                                  _brachid,
                                  _wh,
                                  _empname,
                                  _salechanel,
                                  _dateshow)
                                  .then((e) => {
                                ApiSerivces()
                                    .Updatestockoutapi(genorder, _empname)
                                    .then((i) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SumPay(
                                            genorder: genorder))))
                              });
                            } else {
                              ApiSerivces()
                                  .PosAdd(
                                  _docno,
                                  genorder,
                                  widget.custid,
                                  widget.custcode,
                                  widget.custname,
                                  _sumtot,
                                  _tax,
                                  _subtot,
                                  _chkdisconut == '1'?_discount:_vd,
                                  _brach,
                                  _brachid,
                                  _wh,
                                  _empname)
                                  .then((e) => {
                                ApiSerivces()
                                    .Updatestockoutapi(genorder, _empname)
                                    .then((i) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SumPay(
                                            genorder: genorder))))
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Confirm',
                              style: textBodyLage.copyWith(fontSize: 18),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            )));
  }

  Future BarcCodeScan() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            content: SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .3,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              LineIcons.timesCircle,
                              size: 42,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BarcodeScan(
                      barCodecontroller: _barcodetext,
                      countorder: CountOrder(genorder),
                      wh: _wh,
                      genorder: genorder,
                      brachid: _brachid,
                      submit: ()=>ShowOrder(genorder),
                    ),
                  ],
                ))));
  }
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


            var s = scanResult.rawContent.split('-');

            print(s[1]);


            await   ApiSerivces().GetProductid(int.parse(s[1]),_brachid).then((ee) async {
              print(ee.data);
              if(ee.data.length > 0){
                ApiSerivces()
                    .AddItem(
                    widget.genorder,
                    ee.data[0]['id'],
                    ee.data[0]['sku'],
                    ee.data[0]['name'],
                    1,
                    ee.data[0]['sellprice'],
                    ee.data[0]['sellprice'],
                    ee.data[0]
                    ['discount'] ?? 0,
                    _wh)
                    .then((v) {
                  setState(() {

                    ShowOrder(genorder);
                  });

                  ApiSerivces().updateaddserail(widget.genorder, scanResult.rawContent);
                }
                );


              } else {

              }




            });




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
