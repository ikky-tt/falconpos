import 'dart:async';
import 'dart:convert';

import 'package:falconpos/api/apiservice.dart';
import 'package:falconpos/theme/textshow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final oCcy = NumberFormat("#,###.##");
  num sumtot = 0;
  num sumpertot = 0;
  final StreamController _streamController = StreamController();
  TextEditingController _controller1 =
  TextEditingController(text: DateTime.now().toString());
  TextEditingController _controller2 =
  TextEditingController(text: DateTime.now().toString());
  String _valueChanged1 = '';
  String _valueChanged2 = '';
  String _valueToValidate1 = '';
  String _valueToValidate2 = '';
  String _valueToValidateemp1 = '';
  String _valueToValidateemp2 = '';
  String _dateemp1 = '';
  String _dateemp2 = '';
  num _textvat = 0;
  num _textbeforvat = 0;
  num _texdiscount = 0;

  late Stream Listfire;
  late Stream Listfire2;
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List filteredNames =  []; // names filtered by search text

  List<modelSalereport> _reportshow = [];
  List<modelSalereportitem> _reportitem = [];

  Widget _appBarTitle =  Text( "Report",style: textBodyLage,);
  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _brachid = 0;
  GetLogin()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      start =   DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
      stop  =   DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));

      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;
      rePort(start, stop,_brachid);
      sumReport(start, stop,_brachid);
      sumitem(start, stop,_brachid);
    });
  }
  Future<void> rePort(start,stop,branch) async {
await ApiSerivces().PosReportapi(start, stop,branch).then((res) {
  _reportshow.clear();

 res.data.forEach((e) {

   setState(() {
     print(e['discounttext']);

     _reportshow.add(modelSalereport(date: e['docdate'], docno: e['docno'], amount: e['amount']==null?0:e['amount'], disconunt: e['discounttext']==null?0:e['discounttext'], beforvat: e['amountbeforvat']==null?0:e['amountbeforvat'], vat: e['vatamount']==null?0:e['vatamount']));

   });


 });
});
  }
  Future<void> sumitem(start,stop,branch) async {
    _reportitem.clear();
    await ApiSerivces().PosReportsumitemapi(start, stop,branch).then((res) {
      print(res.data);
      res.data.forEach((e) {
        setState(() {
          _reportitem.add(modelSalereportitem(sku: e['sku'], name: e['name'], qty: e['qty']));
        });
      });
    });
  }
  Future<void> sumReport(start,stop,branch) async {
    await ApiSerivces().PosReportsumapi(start, stop, branch).then((res){
      print(res);
      print(res.data);
        setState(() {
          if(res.data[0]['tot'] != null) {
            sumtot = res.data[0]['tot'];
          }else {
            sumtot = 0;
          }

          if(res.data[0]['discounttot'] != null) {
            _texdiscount = res.data[0]['discounttot'];
          } else {
            _texdiscount = 0;
          }
          if(res.data[0]['beforvar'] != null) {
            _textbeforvat = res.data[0]['beforvar'];
          } else {
            _textbeforvat = 0;
          }
          if(res.data[0]['vat'] != null) {
            _textvat = res.data[0]['vat'];
          } else {
            _textvat = 0;
          }


        });
    });
  }
  int i = 1;
  String _range = '';
  String mounth  = DateFormat('MMMM yyyy','th').format(DateTime.now());
  String _selectedDate = '';
  String _dateCount = '';
  String _rangeCount = '';
  late DateTime start;
  late DateTime stop;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

    setState(() {

      print("star" + args.value.startDate.toString());
      print("stop" + args.value.endDate.toString());

      if (args.value is PickerDateRange) {

        start = args.value.startDate;
        stop = args.value.endDate;

        if(start.toString() == stop.toString()) {
          _range = '${DateFormat('dd/MM/yyyy').format(start)}';

        } else {
          _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
          // ignore: lines_longer_than_80_chars
              ' ${DateFormat('dd/MM/yyyy').format(stop)}';
        }
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
  int nowmo  = int.parse(DateFormat('MM').format(DateTime.now()));
  TextEditingController _datenow = TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()).toString());
  DateTime  dateshow =  DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetLogin();
    DateTime  createdAt =  DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));

    start =   DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    stop  =   DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));




    if(start.toString() == stop.toString()) {
      _range = '${DateFormat('dd/MM/yyyy').format(start)}';

    } else {
      _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
      // ignore: lines_longer_than_80_chars
          ' ${DateFormat('dd/MM/yyyy').format(stop)}';
    }

  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
      appBar: AppBar(
  leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: _appBarTitle,
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
      )
    );
  }
  Widget P(){
    return  SingleChildScrollView(
      child: Column(

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
                          rePort(start, stop,_brachid);
                          sumReport(start, stop,_brachid);
                          sumitem(start, stop,_brachid);
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
                          rePort(start, stop,_brachid);
                          sumReport(start, stop,_brachid);
                          sumitem(start, stop,_brachid);
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
                                rePort(start, stop,_brachid);
                                sumReport(start, stop,_brachid);
                                sumitem(start, stop,_brachid);
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
                style: textLanadscapL.copyWith(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Card(
                child: Container(
                  alignment: Alignment.centerRight,

                  padding: EdgeInsets.all(20),
                  child: Text('Discount ${oCcy.format(_texdiscount)} บาท',style: TextStyle(fontSize: 12),),
                ),
              ),) ,
              Expanded(child:  Card(
                child: Container(
                  alignment: Alignment.centerRight,

                  padding: EdgeInsets.all(20),
                  child: Text('Before tax ${oCcy.format(_textbeforvat)} บาท',style: TextStyle(fontSize: 12),),
                ),
              ),)
            ],
          ),
          Row(
            children: [
              Expanded(child:  Card(
                child: Container(
                  alignment: Alignment.centerRight,

                  padding: EdgeInsets.all(20),
                  child: Text('Tax ${oCcy.format(_textvat)} บาท',style: TextStyle(fontSize: 12),),
                ),
              ),),
              Expanded(child: Card(
                child: Container(
                  alignment: Alignment.centerRight,

                  padding: EdgeInsets.all(20),
                  child: Text('Amount ${oCcy.format(sumtot)} บาท',style: TextStyle(fontSize: 12),),
                ),
              ),)
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height*.4,
            padding: EdgeInsets.only(right: 20),

            child: SingleChildScrollView(
              child: Scrollbar(
                thumbVisibility: true,
                
                child: DataTable(
                  columns:  [
                    DataColumn(label: Text('Date',style: textBodyLage.copyWith(color: Colors.black,fontSize: 12))),

                    DataColumn(label: Text('Discount',style: textBodyLage.copyWith(color: Colors.black,fontSize: 12))),

                    DataColumn(label: Text('Amount'))
                  ],
                  rows: _reportshow.map((e) {
                    return DataRow(
                        cells: [
                          DataCell(
                              Container(
                                child: Column(
                                  children: [
                                    Text('${e.docno}',style: textBodyLage.copyWith(color: Colors.black,fontSize: 10)),
                                    Text(DateFormat("dd/MM/yy HH:mm").format(DateTime.parse(e.date).toLocal()),style: textBodyLage.copyWith(color: Colors.black,fontSize: 10),),
                                  ],
                                ),
                              )),

                          DataCell(
                              Container(
                                alignment: Alignment.centerRight,
                                child: Column(

                                  children: [
                                    Text(' ${oCcy.format(e.disconunt)}',style: textBodyLage.copyWith(color: Colors.black,fontSize: 10)),

                                  ],
                                ),
                              )),
                          DataCell(
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text('${oCcy.format(e.amount)}',style: textBodyLage.copyWith(color: Colors.black,fontSize: 10)),
                              ))
                        ]

                    );
                  }).toList(),

                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          DataTable(
            columns: const [

              DataColumn(label: Text('ITEM')),
              DataColumn(label: Text('Qty')),
            ],
            rows: _reportitem.map((e) {
              return DataRow(
                  cells: [


                    DataCell(
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(e.name,style: textBodyLage.copyWith(color: Colors.black,fontSize: 10)),
                        )),
                    DataCell(
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text('${oCcy.format(e.qty)}',style: textBodyLage.copyWith(color: Colors.black,fontSize: 10)),
                        )),

                  ]

              );
            }).toList(),

          ),



        ],
      ),
    );
  }
  Widget L(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height*.8,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Icon(Icons.arrow_back_ios),
                          onTap: (){

                            setState((){

                              var  now  = DateTime.now();
                              nowmo--;

                              mounth = DateFormat('MMMM yyyy','th').format(DateTime(now.year,nowmo,));
                              start = DateTime(now.year,nowmo,1);
                              stop  = DateTime(now.year,nowmo + 1,0);

                              if(start.toString() == stop.toString()) {
                                _range = '${DateFormat('dd/MM/yyyy').format(start)}';

                              } else {
                                _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
                                // ignore: lines_longer_than_80_chars
                                    ' ${DateFormat('dd/MM/yyyy').format(stop)}';
                              }
                              rePort(start, stop,_brachid);
                              sumReport(start, stop,_brachid);
                              sumitem(start, stop,_brachid);

                            });

                          },

                        ),
                        Text(' ${mounth} ',style: textLanadscapL.copyWith(fontSize: 24,color: Colors.black)),
                        InkWell(
                          child: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            setState((){

                              var  now  = DateTime.now();

                              nowmo++;

                              mounth = DateFormat('MMMM yyyy','th').format(DateTime(now.year,nowmo,));
                              start = DateTime(now.year,nowmo,1);
                              stop  = DateTime(now.year,nowmo + 1,0);
                              rePort(start, stop,_brachid);
                              sumReport(start, stop,_brachid);
                              sumitem(start, stop,_brachid);
                              if(start.toString() == stop.toString()) {
                                _range = '${DateFormat('dd/MM/yyyy').format(start)}';

                              } else {
                                _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
                                // ignore: lines_longer_than_80_chars
                                    ' ${DateFormat('dd/MM/yyyy').format(stop)}';
                              }
                            });

                          },

                        ),
                      ],
                    ),),
                    Expanded(child: Text('${_range}',style: textLanadscapL.copyWith(fontSize: 24,color: Colors.black),)),
                    ElevatedButton(
                        onPressed: (){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Date'),
                              content: Container(
                                height: MediaQuery.of(context).size.height*.5,
                                width: MediaQuery.of(context).size.width*.5,
                                child: SfDateRangePicker(
                                  onSelectionChanged: _onSelectionChanged,
                                  view: DateRangePickerView.month,
                                  selectionMode: DateRangePickerSelectionMode.range,
                                  showActionButtons: true,
                                  onSubmit: (e){
                                    setState((){
                                      rePort(start, stop,_brachid);
                                      sumReport(start, stop,_brachid);
                                      sumitem(start, stop,_brachid);
                                      Navigator.of(context).pop();
                                      if(start.toString() == stop.toString()) {
                                        _range = '${DateFormat('dd/MM/yyyy').format(start)}';

                                      } else {
                                        _range = '${DateFormat('dd/MM/yyyy').format(start)} -'
                                        // ignore: lines_longer_than_80_chars
                                            ' ${DateFormat('dd/MM/yyyy').format(stop)}';
                                      }
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
                            children:  [
                              Icon(Icons.calendar_month,color: Colors.white,size: 24,),
                              Text(' Select Date',style: textBody.copyWith(color: Colors.white,fontSize: 18),)
                            ],
                          ),
                        )),

                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Container(
                          alignment: Alignment.centerRight,

                          padding: EdgeInsets.all(20),
                          child: Text('Discount ${oCcy.format(_texdiscount)} บาท',style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(
                          alignment: Alignment.centerRight,

                          padding: EdgeInsets.all(20),
                          child: Text('Before tax ${oCcy.format(_textbeforvat)} บาท',style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(
                          alignment: Alignment.centerRight,

                          padding: EdgeInsets.all(20),
                          child: Text('Tax ${oCcy.format(_textvat)} บาท',style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(
                          alignment: Alignment.centerRight,

                          padding: EdgeInsets.all(20),
                          child: Text('Amount ${oCcy.format(sumtot)} บาท',style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: MediaQuery.of(context).size.height*.57,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex:2,
                          child:   SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Date Time')),
                                DataColumn(label: Text('No')),
                                DataColumn(label: Text('Disconut')),
                                DataColumn(label: Text('Total')),
                                DataColumn(label: Text('tax')),

                                DataColumn(label: Text('Amount'))
                              ],
                              rows: _reportshow.map((e) {
                                return DataRow(
                                    cells: [
                                      DataCell(
                                          Container(
                                            child: Text(DateFormat("dd/MM/yy").format(DateTime.parse(e.date).toLocal()),style: textBodyLage.copyWith(color: Colors.black),),
                                          )),  DataCell(
                                          Container(
                                            child: Text('${e.docno}',style: textBodyLage.copyWith(color: Colors.black)),
                                          )),
                                      DataCell(
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('${oCcy.format(e.disconunt)}',style: textBodyLage.copyWith(color: Colors.black)),
                                          )),
                                      DataCell(
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('${oCcy.format(e.beforvat)}',style: textBodyLage.copyWith(color: Colors.black)),
                                          )),
                                      DataCell(
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('${oCcy.format(e.vat)}',style: textBodyLage.copyWith(color: Colors.black)),
                                          )),
                                      DataCell(
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('${oCcy.format(e.amount)}',style: textBodyLage.copyWith(color: Colors.black)),
                                          ))
                                    ]

                                );
                              }).toList(),

                            ),
                          ),),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child:   SingleChildScrollView(
                          child: DataTable(
                            columns: const [

                              DataColumn(label: Text('ITEM')),
                              DataColumn(label: Text('Qty')),
                            ],
                            rows: _reportitem.map((e) {
                              return DataRow(
                                  cells: [


                                    DataCell(
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(e.name,style: textBodyLage.copyWith(color: Colors.black)),
                                        )),
                                    DataCell(
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${oCcy.format(e.qty)}',style: textBodyLage.copyWith(color: Colors.black)),
                                        )),

                                  ]

                              );
                            }).toList(),

                          ),
                        ),)
                      ],
                    )
                )

              ],
            ),
          ),
        )

      ],
    );
  }
}
class modelSalereport {
  modelSalereport({
    required this.date,
    required this.docno,
    required this.disconunt,
    required this.beforvat,
    required this.vat,
    required this.amount,


  });

  String date;
  String docno;
  num beforvat;
  num disconunt;
  num vat;
  num amount;
}
class modelSalereportitem {
  modelSalereportitem({
    required this.sku,
    required this.name,
    required this.qty,



  });

  String sku;
  String name;
  num qty;
}
