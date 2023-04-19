import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:falconpos/ui/customersweb.dart';
import 'package:falconpos/ui/sumpay.dart';
import 'package:falconpos/widget/discountmobile.dart';
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
import '../model/subposmodal.dart';
import '../model/usermodel.dart';
import '../theme/textshow.dart';
import '../widget/barcodescan.dart';
import '../widget/discount.dart';
import '../widget/divbraek.dart';
import '../widget/editdata.dart';
import '../widget/numpad.dart';
import '../widget/posorderlist.dart';
import 'customers.dart';
import 'login.dart';
import 'mainmenu.dart';
import 'mainpage.dart';
import 'package:barcode_scan2/gen/protos/protos.pb.dart';
import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';

class POSPortraitMode extends StatefulWidget {
  var custid;
  var custname;
  var custcode;
  var genorder;
   POSPortraitMode({Key? key,required this.genorder,this.custcode,this.custid,this.custname}) : super(key: key);

  @override
  State<POSPortraitMode> createState() => _POSPortraitModeState();
}

class _POSPortraitModeState extends State<POSPortraitMode> {
  var countriesKey = GlobalKey<FindDropdownState>();
  ScrollController yourScrollController = ScrollController();
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
  String _salechanel = '';

  num _vd = 0;

  String _dicounttext = '';

  late FocusNode _nodfocus;

  bool _chkmodifile = false;



  String _date = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  String _time = DateFormat("HH:mm").format(DateTime.now()).toString();

  final StreamController _streamController = StreamController();
  final StreamController _streamController2 = StreamController();
  final StreamController _stream = StreamController();
  final StreamController _stream3 = StreamController();
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
  int? _lv = 0;

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
      print(prefs.getInt('id'));
      if (prefs.getInt('login') != 1) {
        


            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));


      } else {
       await ApiSerivces().chklogin(prefs.getInt('id')).then((e) async {

         if(e.data.length == 0 || e.data[0]['emp_status'] == 2){

           prefs.clear();
          await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));

         }


        });
      }
    });
  }
  late ScanResult scanResult;

  final _aspectTolerance = 0.00;
  final _selectedCamera = -1;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;

  DateTime _dateshow = DateTime.now();

  clercust() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('custid');
    });
  }

  List<Iterable> addItem = [];

  List<SubPosModal> subpos = [];

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

  Future<List<SubPosModal>> ShowOrder(genorder) async {


   var response = await  ApiSerivces().ShowChart(genorder);



   final data = response.data;

   // print(data);
   if (data != null) {



     return SubPosModal.fromJsonList(data);

   }
   return [];

  }



  CountOrder(docno) async {
    ApiSerivces().ContChart(docno).then((e) {
      //  print(e.data[0]['co']);

      setState(() {
        _count = e.data[0]['co'].toString();

      });
    });
  }

  SumPos(ordergen) async {

    print("sum");

    await  CountOrder(ordergen);
   await ApiSerivces().SumChart(ordergen).then((e) {

     print("sumtot" + e.data[0]['sum'].toString());

      setState(() {

        if(e.data[0]['sum'] == 'null'){
          _tax = 0;
          _sum = '0';
          _subtot = 0;
          _sumtot = 0;
          _discount = 0;

        } else {
          if (_chkdisconut == '1') {
            if (e.data[0]['sum'] != null) {
              print('nu1');
              _tax = (e.data[0]['sum'] - _discount) * (7 / 107);
              _sum = oCcy.format(e.data[0]['sum']);
              _subtot = e.data[0]['sum'] - _tax;
              _sumtot = e.data[0]['sum'] - _discount;
              _dicounttext = oCcy.format(_discount);
            } else {
              _tax = 0;
              _sum = '0';
              _subtot = 0;
              _sumtot = 0;
              _dicounttext =  oCcy.format(0);
              _discount = 0;
            }
          } else {

            if (e.data[0]['sum'] != null) {

              _vd = e.data[0]['sum']*(_discount/100);

              print('nu2');
              _tax = (e.data[0]['sum'] - _vd) * (7 / 107);
              _sum = oCcy.format(e.data[0]['sum']);
              _subtot = e.data[0]['sum'] - _tax;
              _sumtot = e.data[0]['sum'] - _vd;
              _dicounttext =  oCcy.format(_vd);
            } else {
              _tax = 0;
              _sum = '0';
              _subtot = 0;
              _sumtot = 0;
              _discount = 0;
              _vd = 0;
              _dicounttext =  oCcy.format(0);
            }
          }
        }
      });
    });
  }
 Future<List<SumModel>> sumtot(ordergen) async {

    print("sum");

    await  CountOrder(ordergen);
    var response = await  ApiSerivces().SumChart(genorder);

    final data = response.data;

    // print(data);
    if (data != null) {

      return SumModel.fromJsonList(data);

    }
    return [];
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

    // TODO: implement initState
    super.initState();
    DocNo();

    _nodfocus = FocusNode();
    _controller2.text = DateFormat('dd/MM/yy HH:mm').format(DateTime.now());

    LoadProducttype();

    if(widget.genorder == null) {
      //genorder = new DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      genorder = widget.genorder as String;
    }
    print(genorder);

    SumPos(genorder);
     kIsWeb?_salechanel='Web POS':_salechanel=='POS';

  }

  TextEditingController _controller2 = TextEditingController();

  String _valueChanged2 = '';
  String _valueSaved2 = '';
  @override
  void dispose() {
    yourScrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(

                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Theme.of(context).primaryColor, //<-- SEE HERE
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 20,
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
                              width: 5,
                            ),
                            Container(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Theme.of(context).primaryColor, //<-- SEE HERE
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.list,
                                    color: Colors.white,
                                    size: 20,
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
                              width: 5,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Container(
                                    decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    height: 40,
                                    width: MediaQuery.of(context).size.width*.45,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Icon(
                                                LineIcons.userCircle,
                                                size: 22,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${_empname}',
                                                  maxLines: 1,
                                                  style: textLanadscapL.copyWith(
                                                      fontSize: 12, color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Icon(
                                                LineIcons.store,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                '${_brach}',
                                                maxLines: 1,
                                                style: textLanadscapL.copyWith(
                                                    fontSize: 12, color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        _lv==1&&MediaQuery.of(context).size.width>600?Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0),
                                            child: Row(
                                              children: [
                                                Icon(LineIcons.clipboard,color: Colors.white,),
                                                Text(' ${_salechanel}',style: textBodyMedium.copyWith(color: Colors.white),),
                                              ],
                                            ),
                                          ),
                                        ):Row()
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CustomerWeb(genoder: genorder,))),
                                    child: Container(
                                      decoration:  BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width*.24,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Icon(
                                            LineIcons.userEdit,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          widget.custid == null
                                              ? InkWell(
                                            child: Icon(LineIcons.plus, size: 18,  color: Colors.white,),
                                          )
                                              : Container(

                                            width: MediaQuery.of(context).size.width*.13,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${widget.custname}',
                                                    maxLines: 1,
                                                    style: textLanadscapL.copyWith(
                                                        fontSize: 8,
                                                        color: Colors.white),
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
                                                    icon:
                                                    Icon(LineIcons.timesCircle,size: 18,color: Colors.white,))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            )


                          ],
                        ),


                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                               alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              decoration:  BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(DateFormat('dd/MM/yy').format(_dateshow),style: textBodyMedium.copyWith(color: Colors.white,fontSize: 10),),
                                  ),

                                  Row(),
                                  _lv==1?Container(
                                    padding: EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      alignment: Alignment.center,
                                        onPressed: (){

                                      EditDate();

                                    },
                                        icon: Icon(Icons.edit,color: Colors.white,size: 14,)),
                                  ):Row(),


                                ],
                              ),

                            ),

                          Flexible(child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _scr,
                              style: TextStyle(fontSize: 13),
                              decoration: inputForm1('search'),
                              onChanged: (v) {
                                LoadProudct(v, _brachid);
                              },
                            ),
                          )),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: kIsWeb?CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Theme.of(context).primaryColor, //<-- SEE HERE
                                child: IconButton(
                                  icon: const Icon(
                                    LineIcons.barcode,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {

                                    BarcCodeScan().then((value) => SystemChannels
                                        .textInput
                                        .invokeMethod('TextInput.hide'));

                                  },
                                ),
                              ):CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Theme.of(context).primaryColor, //<-- SEE HERE
                                child: IconButton(
                                  icon: const Icon(
                                    LineIcons.qrcode,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {

                                    scan();

                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),


                          ]
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(2.0),
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
                                        width: 50,
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
                                width: 5,
                                height: 40,
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
                                  color: Colors.white,size: 1,
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
                                        shrinkWrap: true,
                                        physics:
                                        const AlwaysScrollableScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                              padding: const EdgeInsets.all(2.0),
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
                                                    BorderRadius.circular(10),
                                                    //set border radius more than 50% of height and width to make circle
                                                  ),
                                                  child: Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 3,
                                                        right: 10,
                                                        bottom: 3),
                                                    height: 50,
                                                    child: Text(
                                                        '${snapshot.data[i]['name']}',
                                                        style:
                                                        textBodyLage.copyWith(
                                                            fontSize: 12,
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
                                width: 5,
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
                                  size: 1,
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
                                   SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: MediaQuery.of(context).size.width>800?4:MediaQuery.of(context).size.width>500?3:2),
                                  physics: const AlwaysScrollableScrollPhysics(),
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
                                                snapshot.data[i]['sellprice'],
                                                snapshot.data[i]['sellprice'],
                                                snapshot.data[i]
                                                ['discount'] !=
                                                    null
                                                    ? snapshot.data[i]
                                                ['discount']
                                                    : 0,
                                                _wh)
                                                .then((value){
                                                  setState(() {
                                                    SumPos(genorder);
                                                    ShowOrder(genorder);
                                                  });
                                            });
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
                                                        ['path']!=null?CachedNetworkImage(
                                                          imageUrl: urlpic +
                                                              snapshot.data[i]
                                                              ['path'],
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
                                                          fit: BoxFit.cover,
                                                        ):Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                                            EdgeInsets.all(4),
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
                                                      snapshot.data[i]
                                                      ['discount'] !=
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
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                  .circular(
                                                                  8)),
                                                              color:
                                                              Colors.red,
                                                            ),
                                                            child: Text(
                                                                '${snapshot.data[i]['discount']}%',
                                                                style: textLanadscapL
                                                                    .copyWith(
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
                                                      snapshot.data[i]['sqty'] !=
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
          ],
        ),
      ),
        floatingActionButton: Visibility(
          visible: true,
          child: FloatingActionButton.extended(
            onPressed: () {
               yourScrollController = new ScrollController(initialScrollOffset: 0);
              showModalBottomSheet<void>(
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(25),
                    topStart: Radius.circular(25),
                  ),
                ),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(

                    builder: (BuildContext context, StateSetter setState ) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height*.8 ,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width*.8 ,


                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[
                              IconButton(onPressed: () => Navigator.pop(context),
                                  icon: Icon(LineIcons.timesCircle)),
                              Flexible(
                                flex: 2,
                                child: FutureBuilder<List<SubPosModal>>(
                                  future: ShowOrder(widget.genorder),
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
                                    return ListView.builder(
                                        itemCount: stream.data?.length,
                                        itemBuilder: (context, i) {
                                          num qtyd = 0;
                                          qtyd = querySnapshot![i].qty;

                                          var id = querySnapshot[i].id;
                                          _controllerlist2.add(TextEditingController(
                                              text: qtyd.toString()));

                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            height: 75,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                    width: MediaQuery.of(context).size.width*.3,
                                                    child: Text(
                                                      querySnapshot[i].name,
                                                      style: textLanadscapL.copyWith(
                                                          fontSize: 14,color: Colors.black),
                                                    )),
                                                Card(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 50,
                                                    child: Text(
                                                        oCcy.format(
                                                            querySnapshot[i].price),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: textLanadscapL.copyWith(
                                                            fontSize: 14,
                                                            color: Colors.black)),
                                                  ),
                                                ),
                                                Card(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 80,
                                                    padding: EdgeInsets.all(5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: (){

                                                            qtyd = qtyd - 1;

                                                            var price = qtyd * querySnapshot[i].price;

                                                            if(qtyd==0) {
                                                              ApiSerivces()
                                                                  .DeleteItem(id)
                                                                  .then((e) {

                                                                setState((){

                                                                  _discount = 0;
                                                                  ShowOrder(widget.genorder);
                                                                  SumPos(widget.genorder);
                                                                });

                                                              });
                                                            } else {
                                                              ApiSerivces().UpDateItem(id, qtyd, price).then((value) {
                                                                setState(() {


                                                                  ShowOrder(widget.genorder);
                                                                   SumPos(widget.genorder);

                                                                });
                                                              });
                                                            }

                                                          },
                                                          child: Icon
                                                            (LineIcons.minusCircle),
                                                        ),

                                                        Text('${qtyd}',
                                                            style: textLanadscapL.copyWith(
                                                                fontSize: 14,
                                                                color: Colors.black)),
                                                        InkWell(
                                                          onTap: (){
                                                            qtyd = qtyd + 1;

                                                            var price = qtyd * querySnapshot[i].price;

                                                            if(qtyd==0) {
                                                              ApiSerivces()
                                                                  .DeleteItem(id)
                                                                  .then((e) {

                                                                setState((){

                                                                  ShowOrder(widget.genorder);
                                                                  SumPos(widget.genorder);
                                                                  _discount = 0;
                                                                });

                                                              });

                                                            } else {
                                                              ApiSerivces().UpDateItem(id, qtyd, price).then((e) {

                                                                setState(() {
                                                                   print('ee');
                                                                  ShowOrder(widget.genorder);
                                                                  SumPos(widget.genorder);



                                                                });
                                                              });
                                                            }


                                                          },
                                                          child: Icon(LineIcons.plusCircle),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: querySnapshot[i].disconut ==
                                                        0
                                                        ? Container(
                                                      alignment:
                                                      Alignment.centerRight,
                                                      child: Text(
                                                          oCcy.format(
                                                              querySnapshot[i].price *
                                                                  qtyd),
                                                          style: textLanadscapL
                                                              .copyWith(
                                                              fontSize: 14,color: Colors.black)),
                                                    )
                                                        : Container(
                                                      alignment:
                                                      Alignment.centerRight,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              oCcy.format(
                                                                  querySnapshot[i].totprice),
                                                              style: textLanadscapL
                                                                  .copyWith(
                                                                  fontSize:
                                                                  16,color: Colors.black)),
                                                          Text(
                                                              oCcy.format(
                                                                  querySnapshot[i].price *
                                                                      qtyd),
                                                              style: textLanadscapL
                                                                  .copyWith(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .red,
                                                                  decoration:
                                                                  TextDecoration
                                                                      .lineThrough)),
                                                        ],
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  child: Icon(Icons.remove_circle),
                                                  onTap: () {
                                                    ApiSerivces()
                                                        .DeleteItem(id)
                                                        .then((e) {

                                                     setState((){

                                                       SumPos(widget.genorder);
                                                       ShowOrder(widget.genorder);
                                                     });

                                                    });


                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FutureBuilder(
                                future: sumtot(widget.genorder),
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
                                  var _sumt  = querySnapshot!.first.sum;
                                  print(_sumt);
                                  print("zxxx");
                                  print(_discount);
                                  if (_chkdisconut == '1') {
                                    if (_sum != null) {
                                      print('nu1');
                                      _tax = (_sumt - _discount) * (7 / 107);
                                      _sum = oCcy.format(_sumt);
                                      _subtot = _sumt - _tax;
                                      _sumtot = _sumt - _discount;
                                      _dicounttext = oCcy.format(_discount);
                                    } else {
                                      _tax = 0;
                                      _sum = '0';
                                      _subtot = 0;
                                      _sumtot = 0;
                                      _discount = 0;
                                    }
                                  } else {

                                    if (_sumt != null) {
                                      print('nu2xxx');

                                      _vd = _sumt * (_discount/100);

                                      _tax = (_sumt - _vd) * (7 / 107);
                                      _sum = oCcy.format(_sumt);
                                      _subtot = _sumt - _tax;
                                      _sumtot = _sumt - _vd;
                                      _dicounttext =  oCcy.format(_vd);
                                    } else {
                                      _tax = 0;
                                      _sum = '0';
                                      _subtot = 0;
                                      _sumtot = 0;
                                      _discount = 0;
                                    }
                                  }

                                  return  SizedBox(
                                      height: 220,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 20.0, left: 20),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Subtotal ${_count!= '0' ?"Item : ${_count}":''}', style: textLanadscapL.copyWith(color: Colors.black)),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text("${oCcy.format(_subtot)}",
                                                          style: textLanadscapL.copyWith(color: Colors.black))
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
                                                Text('Tax', style: textLanadscapL.copyWith(color: Colors.black)),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(oCcy.format(_tax),
                                                          style: textLanadscapL.copyWith(color: Colors.black))
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
                                                Text('Discount', style: textLanadscapL.copyWith(color: Colors.black)),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(_dicounttext,
                                                          style: textLanadscapL.copyWith(color: Colors.black))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width:
                                                  MediaQuery.of(context).size.width * .3,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                          HexColor('7CB4D9')),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        discount(genorder);
                                                      },
                                                      child: Text(
                                                        'Discount',
                                                        style: textLanadscapL.copyWith(
                                                            fontSize: 14),
                                                      )),
                                                ),

                                                SizedBox(
                                                  width:
                                                  MediaQuery.of(context).size.width * .3,
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

                                              ],
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            elevation: 0,
                                                            backgroundColor: Theme.of(context)
                                                                .primaryColor),
                                                        onPressed: () {
                                                          _count != '0'
                                                              ? ConfirmOrder()
                                                              : null;
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'PLACE ORDER ฿ ${oCcy.format(_sumtot)} ',
                                                                style: textBodyLage.copyWith(
                                                                    fontWeight:
                                                                    FontWeight.w800,
                                                                    fontSize: 18
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                  );
                                },
                              ),

                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      );
                    },

                  );
                },
              );
            },
            label: Row(
              children: [
            badges.Badge(
                  badgeContent: Text('${_count}', style: textBody.copyWith(
                      fontSize: 13, fontWeight: FontWeight.bold),),
                  child: Icon(LineIcons.shoppingBasket, size: 24,color: Colors.white,),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.white
                )

                ),
                SizedBox(
                  width: 20,
                ),
                Text('Total : ${oCcy.format(_sumtot)}',style: textBody.copyWith(color: Colors.white),)
              ],
            ),
            backgroundColor: Colors.red,
          ),
        )
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
              style: textBodyLage.copyWith(fontSize: 18,color: Colors.black),
            ),
            content: DiscountMobile(
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
                    SumPos(genorder);
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
                                 _chkdisconut == '1'? _discount:_vd,
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
                                 _chkdisconut == '1'? _discount:_vd,
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
                width: MediaQuery.of(context).size.width * .8,
                child: Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(LineIcons.timesCircle,size: 42,))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BarcodeScan(
                      barCodecontroller: _barcodetext, countorder:   CountOrder(genorder),wh: _wh,genorder: genorder,brachid: _brachid,
                      submit: ()=>SumPos(genorder),
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

                    SumPos(genorder);
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
          content: Container(
            padding: EdgeInsets.only(top: 20,bottom: 20),
            height: MediaQuery.of(context).size.height*.35,
            child: EditDateDate(
              dateshow: _dateshow,
              controller2: _controller2,
              onSubmit: (){
                setState((){

                  _chkmodifile = true;

                  print(_controller2.text);

                  _dateshow = DateTime.parse(_controller2.text);
                  _salechanel = _textsalech.text;
                  _brach = _textb.text;
                  _brachid = int.parse(_textbid.text);
                  _wh = _textwh.text;

                  Navigator.pop(context);

                  print(_salechanel);
                  LoadProudct('', _brachid);

                });

              },
              branchid: _textbid, brancname: _textb, salechanel: _textsalech,wh: _textwh,),
          ),

        );
      },
    );
  }

}


class SumModel {
   num sum;

   SumModel( {  required this.sum});

   factory SumModel.fromJson(Map<String, dynamic> json) {
     return SumModel(
         sum: json["sum"],


     );
   }

   static List<SumModel> fromJsonList(List list) {
     return list.map((item) => SumModel.fromJson(item)).toList();
   }
}
