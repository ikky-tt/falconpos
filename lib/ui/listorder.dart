import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:falconpos/ui/mainmenu.dart';
import 'package:falconpos/ui/orderdetail.dart';
import 'package:falconpos/ui/sumpay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../api/apiservice.dart';
import '../function/function.dart';
import '../theme/textshow.dart';
import '../widget/editdata.dart';

class ListOrder extends StatefulWidget {
  const ListOrder({Key? key}) : super(key: key);

  @override
  State<ListOrder> createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  final oCcy = NumberFormat("#,###.##", "th_TH");
  bool _cview = false;
  bool _cviem = false;
  bool _cviewd = false;
  late DateTime start;
  late DateTime stop;
  int i = 1;
  String _range = '';
  String mounth = DateFormat('MMMM yyyy', 'th').format(DateTime.now());
  String _selectedDate = '';
  String _dateCount = '';
  String _rangeCount = '';

  int nowmo = int.parse(DateFormat('MM').format(DateTime.now()));
  TextEditingController _datenow = TextEditingController(
      text: DateFormat("dd/MM/yyyy").format(DateTime.now()).toString());
  DateTime dateshow =
      DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
  final StreamController _streamController = StreamController();

  LoadInvicesub(
    start,
    stop,
    int brachid,
  ) async {
    ApiSerivces().PosReportapiAll(start, stop, _brachid).then((res) async {
      _streamController.add(res.data);
    });
  }

  Future<void> _handleRefresh(start, stop, brachid) async {
    ApiSerivces().PosReportapi(start, stop, brachid).then((res) async {
      _streamController.add(res.data);
    });

    return null;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      print("star" + args.value.startDate.toString());
      print("stop" + args.value.endDate.toString());

      if (args.value is PickerDateRange) {
        start = args.value.startDate;
        stop = args.value.endDate;

        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _brachid = 0;
  int _lv = 0;

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;

      print(_brachid);
      start = DateTime.now();
      stop = DateTime.now();
      _lv = prefs.getInt('lv')!;

      LoadInvicesub(DateFormat("yyyy-MM-dd 00:00:00").format(start),
          DateFormat("yyyy-MM-dd 24:00:00").format(stop), _brachid);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    GetLogin();
    super.initState();
    DateTime now = DateTime.now();
    start = DateTime.now();
    stop = DateTime.now();
    print(DateFormat("yyyy-MM-dd 00:00").format(start));
    print(_brachid);
    _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
        // ignore: lines_longer_than_80_chars
        ' ${DateFormat('dd/MM/yyyy').format(stop)}';
  }

  Future<List<SelectBranchModel>> getBranch() async {
    var response = await ApiSerivces().GetBranch();

    final data = response.data;
    // print(data);
    if (data != null) {
      return SelectBranchModel.fromJsonList(data);
    }

    return [];
  }
  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainMenu()));
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Order',
            style: textBodyLage,
          ),
          centerTitle: true,
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (Orientation.portrait == currentOrientation) {
              print(orientation);

              return P();
            } else {
              return L();
            }
          },
        ));
  }

  Widget L() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0,left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(Icons.arrow_back_ios),
                      onTap: () {
                        setState(() {
                          var now = DateTime.now();
                          nowmo--;

                          mounth = DateFormat('MMMM yyyy', 'th').format(DateTime(
                            now.year,
                            nowmo,
                          ));
                          start = DateTime(now.year, nowmo, 1);
                          stop = DateTime(now.year, nowmo + 1, 0);
                          LoadInvicesub(start, stop, _brachid);
                          _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
                              // ignore: lines_longer_than_80_chars
                              ' ${DateFormat('dd/MM/yyyy').format(stop)}';
                        });
                      },
                    ),
                    Text(' ${mounth} ',
                        style: textLanadscapL.copyWith(
                            fontSize: 24, color: Colors.black)),
                    InkWell(
                      child: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        setState(() {
                          var now = DateTime.now();

                          nowmo++;

                          mounth = DateFormat('MMMM yyyy', 'th').format(DateTime(
                            now.year,
                            nowmo,
                          ));
                          start = DateTime(now.year, nowmo, 1);
                          stop = DateTime(now.year, nowmo + 1, 0);
                          LoadInvicesub(start, stop, _brachid);
                          _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
                              // ignore: lines_longer_than_80_chars
                              ' ${DateFormat('dd/MM/yyyy').format(stop)}';
                        });
                      },
                    ),

                  ],
                ),
              ),
              Expanded(
                  child: Text(
                '${_range}',
                style: textLanadscapL.copyWith(fontSize: 24, color: Colors.black),
              )),
              _lv ==1? SizedBox(
                width: 150,
                child: DropdownSearch<SelectBranchModel>(
                  asyncItems: (String? filter) => getBranch(),
                  popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text('',style: textBodyLage.copyWith(color: Colors.black),),
                    ),
                    showSelectedItems: true,
                    showSearchBox:false,
                    itemBuilder: (BuildContext context, SelectBranchModel item, bool isSelected) {
                      return Container(

                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: !isSelected
                            ? null
                            : BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          selected: isSelected,
                          title: Text(item.name,style: textBodyLage.copyWith(color: Colors.black,fontSize: 14),),
                        ),
                      );
                    },

                  ),
                  compareFn: (item, sItem) => item.id == sItem.id,
                  onChanged: (e){
                    print(e!.wh);
                    setState(() {
                      _brachid = int.parse(e!.id.toString());
                      _brach = e.name.toString();
                      _wh = e.wh.toString();
                      LoadInvicesub(start, stop, _brachid);
                    });
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:  BorderSide(color: HexColor('3ea3d4'), width: 1.0),
                      ),
                      labelStyle: textBody.copyWith(fontSize: 14,color: HexColor('3ea3d4')),
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(width: 1, color: HexColor('3ea3d4'),),
                      ),
                      labelText: '${_brach}',
                      filled: true,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    baseStyle:  textBody.copyWith(fontSize: 14,color: HexColor('3ea3d4')),
                  ),
                ),
              ):Row(),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Date'),
                        content: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width * .5,
                          child: SfDateRangePicker(
                            onSelectionChanged: _onSelectionChanged,
                            view: DateRangePickerView.month,
                            selectionMode: DateRangePickerSelectionMode.range,
                            showActionButtons: true,
                            onSubmit: (e) {
                              setState(() {
                                LoadInvicesub(start, stop, _brachid);
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 24,
                        ),
                        Text(
                          ' Select Date',
                          style: textLanadscapL.copyWith(
                              color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  )),

              SizedBox(
                width: 10,
              ),

            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height * .65,
          child: StreamBuilder(
            stream: _streamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetail(
                                          genorder: snapshot.data[i]['gencode'],
                                        )));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                leading: snapshot.data[i]['status'] != 3
                                    ? InkWell(
                                        child: Icon(
                                          LineIcons.receipt,
                                          size: 36,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SumPay(
                                                        genorder: snapshot
                                                            .data[i]['gencode'],
                                                      )));
                                        },
                                      )
                                    : Icon(
                                        LineIcons.timesCircle,
                                        size: 36,
                                        color: Colors.red,
                                      ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(snapshot.data[i]['docdate']).toLocal())}',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${snapshot.data[i]['docno']}'),
                                        snapshot.data[i]['cusotomername'] != ''
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(LineIcons.userCircle),
                                                  Text(
                                                      ' ${snapshot.data[i]['cusotomername']}'),
                                                ],
                                              )
                                            : Row(),
                                        snapshot.data[i]['description'] != ''
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(LineIcons.bookmark),
                                                  Text(
                                                      ' ${snapshot.data[i]['description']}'),
                                                ],
                                              )
                                            : Row(),
                                      ],
                                    )),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        snapshot.data[i]['amount'] != null
                                            ? Text(
                                                ' ${oCcy.format(snapshot.data[i]['amount'])}',
                                                style: textBodyLage.copyWith(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              )
                                            : Text(
                                                '0',
                                                style: textBodyLage.copyWith(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                        SizedBox(
                                          width: 20,
                                        )
                                      ],
                                    )),
                                    Expanded(
                                        child: Row(
                                      children: [
                                        snapshot.data[i]['status'] == 2
                                            ? Card(
                                                color: snapshot.data[i][
                                                            'tmppaymentname'] ==
                                                        'cash'
                                                    ? Colors.cyan
                                                    : snapshot.data[i][
                                                                'tmppaymentname'] ==
                                                            'qr'
                                                        ? Colors.blue
                                                        : Colors.green,
                                                child: Container(
                                                  height: 40,
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '${snapshot.data[i]['tmppaymentname']}',
                                                    style:
                                                        textBodyLage.copyWith(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                              )
                                            : snapshot.data[i]['status'] == 3
                                                ? Container(
                                                    height: 40,
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'cancel',
                                                      style:
                                                          textBodyLage.copyWith(
                                                              fontSize: 18,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  )
                                                : Card(
                                                    color: Colors.yellow,
                                                    child: Container(
                                                      height: 40,
                                                      width: 100,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'on hold',
                                                        style: textBodyLage
                                                            .copyWith(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                  ),
                                      ],
                                    ))
                                  ],
                                ),
                                trailing: Icon(
                                  LineIcons.alternateArrowCircleRight,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                );
              }
              return const Text("NO DATA");
            },
          ),
        )
      ],
    );
  }

  Widget P() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () {
                      setState(() {
                        var now = DateTime.now();
                        nowmo--;

                        mounth = DateFormat('MMMM yyyy', 'th').format(DateTime(
                          now.year,
                          nowmo,
                        ));
                        start = DateTime(now.year, nowmo, 1);
                        stop = DateTime(now.year, nowmo + 1, 0);
                        LoadInvicesub(start, stop, _brachid);
                        _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
                            // ignore: lines_longer_than_80_chars
                            ' ${DateFormat('dd/MM/yyyy').format(stop)}';
                      });
                    },
                  ),
                  Text(' ${mounth} ',
                      style: textLanadscapL.copyWith(
                          fontSize: 14, color: Colors.black)),
                  InkWell(
                    child: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      setState(() {
                        var now = DateTime.now();

                        nowmo++;

                        mounth = DateFormat('MMMM yyyy', 'th').format(DateTime(
                          now.year,
                          nowmo,
                        ));
                        start = DateTime(now.year, nowmo, 1);
                        stop = DateTime(now.year, nowmo + 1, 0);
                        LoadInvicesub(start, stop, _brachid);
                        _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
                            // ignore: lines_longer_than_80_chars
                            ' ${DateFormat('dd/MM/yyyy').format(stop)}';
                      });
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Date'),
                      content: Container(
                        height: MediaQuery.of(context).size.height * .5,
                        width: MediaQuery.of(context).size.width * .5,
                        child: SfDateRangePicker(
                          onSelectionChanged: _onSelectionChanged,
                          view: DateRangePickerView.month,
                          selectionMode: DateRangePickerSelectionMode.range,
                          showActionButtons: true,
                          onSubmit: (e) {
                            setState(() {
                              LoadInvicesub(start, stop, _brachid);
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 24,
                      ),
                      Text(
                        ' Select Date',
                        style: textLanadscapL.copyWith(
                            color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                )),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_range}',
              style: textLanadscapL.copyWith(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height * .65,
          child: StreamBuilder(
            stream: _streamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetail(
                                          genorder: snapshot.data[i]['gencode'],
                                        )));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                leading: snapshot.data[i]['status'] != 3
                                    ? InkWell(
                                        child: Icon(
                                          LineIcons.receipt,
                                          size: 32,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SumPay(
                                                        genorder: snapshot
                                                            .data[i]['gencode'],
                                                      )));
                                        },
                                      )
                                    : Icon(
                                        LineIcons.timesCircle,
                                        size: 32,
                                        color: Colors.red,
                                      ),
                                title: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                      '${DateFormat('dd/MM/yy HH:mm').format(DateTime.parse(snapshot.data[i]['docdate']).toLocal())}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                '${snapshot.data[i]['docno']}'),
                                            snapshot.data[i]['status'] == 2
                                                ? Card(
                                              color: snapshot.data[i][
                                              'tmppaymentname'] ==
                                                  'cash'
                                                  ? Colors.cyan
                                                  : snapshot.data[i][
                                              'tmppaymentname'] ==
                                                  'qr'
                                                  ? Colors.blue
                                                  : Colors.green,
                                              child: Container(
                                                height: 20,
                                                width: 40,
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  '${snapshot.data[i]['tmppaymentname']}',
                                                  style: textBodyLage
                                                      .copyWith(
                                                      fontSize:
                                                      10,
                                                      color: Colors
                                                          .white),
                                                ),
                                              ),
                                            )
                                                : snapshot.data[i]
                                            ['status'] ==
                                                3
                                                ? Container(
                                              height: 30,
                                              width: 60,
                                              alignment: Alignment
                                                  .center,
                                              child: Text(
                                                'cancel',
                                                style: textBodyLage.copyWith(
                                                    fontSize: 12,
                                                    color: Colors
                                                        .red,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            )
                                                : Card(
                                              color:
                                              Colors.yellow,
                                              child: Container(
                                                height: 20,
                                                width: 60,
                                                alignment:
                                                Alignment
                                                    .center,
                                                child: Text(
                                                  'on hold',
                                                  style: textBodyLage
                                                      .copyWith(
                                                      fontSize:
                                                      10,
                                                      color: Colors
                                                          .black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                    snapshot.data[i]['cusotomername'] != ''
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(LineIcons.userCircle),
                                              Text(
                                                  ' ${snapshot.data[i]['cusotomername']}'),
                                            ],
                                          )
                                        : Row(),
                                    snapshot.data[i]['description'] != ''
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(LineIcons.bookmark),
                                              Text(
                                                  ' ${snapshot.data[i]['description']}'),
                                            ],
                                          )
                                        : Row(),
                                      ],
                                    ),
                                    Expanded(child:   Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                snapshot.data[i]
                                                ['amount'] !=
                                                    null
                                                    ? Text(
                                                  ' ${oCcy.format(snapshot.data[i]['amount'])}',
                                                  style: textBodyLage
                                                      .copyWith(
                                                      fontSize:
                                                      16,
                                                      color: Colors
                                                          .black),
                                                )
                                                    : Text(
                                                  '0',
                                                  style: textBodyLage
                                                      .copyWith(
                                                      fontSize:
                                                      18,
                                                      color: Colors
                                                          .black),
                                                ),

                                              ],

                                            )),

                                      ],
                                    ))
                                  ],
                                ),
                                trailing: Icon(
                                  LineIcons.alternateArrowCircleRight,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                );
              }
              return const Text("NO DATA");
            },
          ),
        )
      ],
    );
  }


}

class  SelectBranchModel {
  final int id;
  final String name;
  final String wh;

  SelectBranchModel({required this.id, required this.name,  required this.wh });

  factory SelectBranchModel.fromJson(Map<String, dynamic> json) {

    return SelectBranchModel(
        id: json["id"],
        name: json["branch_name"],
        wh:  json['wh'].toString()
    );
  }

  static List<SelectBranchModel> fromJsonList(List list) {
    return list.map((item) => SelectBranchModel.fromJson(item)).toList();
  }

  String toString() => name;

  @override
  operator ==(o) => o is SelectBranchModel && o.id == id;



}