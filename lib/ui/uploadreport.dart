import 'dart:async';
import 'dart:isolate';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:falconpos/ui/sumpay.dart';
import 'package:falconpos/ui/uploadreportnew.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../api/apiservice.dart';
import '../function/function.dart';
import '../theme/textshow.dart';
import '../widget/alert.dart';
import 'mainmenu.dart';
import 'orderdetail.dart';
import 'uploadreportdetail.dart';

class UPloadReport extends StatefulWidget {
  const UPloadReport({Key? key}) : super(key: key);

  @override
  State<UPloadReport> createState() => _UPloadReportState();
}

class _UPloadReportState extends State<UPloadReport> {
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

  List<Reportdaymodel> _reportdata = [];

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

   await  ApiSerivces().ReportDetailDay(start, stop, _brachid).then((res) async {

      for( var  e in  res.data) {

        print(e['gencode']);


         setState(() {
           _reportdata.add(Reportdaymodel(id: e['id'], detail: e['detail'], date: e['date'],gencode: e['gencode']));
         });


      }


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

  String _datechk = DateFormat('yyyy-MM-dd').format(DateTime.now());

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;

      print(_brachid);
      stop = DateTime.now();
      start = DateTime(DateTime.now().year,DateTime.now().month,1);
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
    stop = DateTime.now();
    start = DateTime(DateTime.now().year,DateTime.now().month,1);
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
            'UPLOAD REPORT DAY',
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
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context)=>UPloadreportnew()));

        },
        child: Icon(LineIcons.plusCircle),

      ),
    );

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
                            fontSize: 18, color: Colors.black)),
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
                    style: textLanadscapL.copyWith(fontSize: 18, color: Colors.black),
                  )),
              SizedBox(
                width: 10,
              ),
              _lv ==1? SizedBox(
                width: 120,
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
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UPloadreportnew()));
                  },
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(LineIcons.plusCircle,size: 24,color: Colors.white,),
                    Text(' Addnew',style: textLanadscapL.copyWith(
                        color: Colors.white, fontSize: 18),),
                  ],
                ),
              ))

            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 30,right: 30),
          height: MediaQuery.of(context).size.height * .65,
          child: ListView.builder(
            itemCount: _reportdata.length,
            itemBuilder: (context, i) {
              return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UPloadReportDetail(
                                gencode: _reportdata[i].gencode,
                              )));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          leading: Text(
                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(_reportdata[i].date).toLocal())}',
                              style: TextStyle(fontSize: 22)),

                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_reportdata[i].detail}',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),

                            ],
                          ),
                          trailing: _lv == 1?InkWell(
                            onTap: (){
                              ConfirmAlert(
                                      () async {
                                    await ApiSerivces().ReportDetailDaydel(_reportdata[i].gencode).then((value) => {
                                      setState(() {
                                        LoadInvicesub(start, stop, _brachid);
                                        Navigator.of(context).pop();
                                      })
                                    });

                                  },context,'Delete'
                              );
                            },
                            child: Icon(
                              LineIcons.timesCircle,
                              size: 32,
                            ),
                          ):SizedBox(
                            height: 40,
                            width: 40,
                            child: _datechk == DateFormat("yyyy-MM-dd").format(DateTime.parse(_reportdata[i].date))?InkWell(
                              onTap: (){
                                ConfirmAlert(
                                        () async {
                                      await ApiSerivces().ReportDetailDaydel(_reportdata[i].gencode).then((value) => {
                                        setState(() {
                                          LoadInvicesub(start, stop, _brachid);
                                          Navigator.of(context).pop();
                                        })
                                      });

                                    },context,'Delete'
                                );
                              },
                              child: Icon(
                                LineIcons.timesCircle,
                                size: 32,
                              ),
                            ):Icon(
                              LineIcons.minusCircle,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          )
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
        Padding(
          padding: const EdgeInsets.only(right: 18.0,left: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_range}',
                style: textLanadscapL.copyWith(fontSize: 16, color: Colors.black),
              ),

              _lv ==1? SizedBox(
                width: 190,
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
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height * .65,
          child: ListView.builder(
            itemCount: _reportdata.length,
            itemBuilder: (context, i) {
              return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UPloadReportDetail(
                                gencode: _reportdata[i].gencode,
                              )));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          leading: Text(
                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(_reportdata[i].date).toLocal())}',
                              style: TextStyle(fontSize: 16)),

                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_reportdata[i].detail}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                            ],
                          ),
                          trailing: _lv == 1?InkWell(
                            onTap: (){
                              ConfirmAlert(
                                      () async {
                                    await ApiSerivces().ReportDetailDaydel(_reportdata[i].gencode).then((value) => {
                                      setState(() {
                                        LoadInvicesub(start, stop, _brachid);
                                        Navigator.of(context).pop();
                                      })
                                    });

                                  },context,'Delete'
                              );
                            },
                            child: Icon(
                              LineIcons.timesCircle,
                              size: 32,
                            ),
                          ):SizedBox(
                            height: 40,
                            width: 40,
                            child: _datechk == DateFormat("yyyy-MM-dd").format(DateTime.parse(_reportdata[i].date))?InkWell(
                              onTap: (){
                                ConfirmAlert(
                                        () async {
                                      await ApiSerivces().ReportDetailDaydel(_reportdata[i].gencode).then((value) => {
                                        setState(() {
                                          LoadInvicesub(start, stop, _brachid);
                                          Navigator.of(context).pop();
                                        })
                                      });

                                    },context,'Delete'
                                );
                              },
                              child: Icon(
                                LineIcons.timesCircle,
                                size: 32,
                              ),
                            ):Icon(
                              LineIcons.minusCircle,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
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

class  Reportdaymodel {
  final int id;
  final String gencode;
  final String detail;
  final String date;

  Reportdaymodel( {required this.id, required this.detail,  required this.date ,required this.gencode });

  factory Reportdaymodel.fromJson(Map<String, dynamic> json) {

    return Reportdaymodel(
        id: json["id"],
        detail: json["detail"],
        date:  json['date'],
      gencode: json['gencode']
    );
  }

  static List<Reportdaymodel> fromJsonList(List list) {
    return list.map((item) => Reportdaymodel.fromJson(item)).toList();
  }


}