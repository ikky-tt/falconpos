import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../theme/textshow.dart';

class ShoworderDetail extends StatefulWidget {
  final genorder;
  const ShoworderDetail(this.genorder, {Key? key}) : super(key: key);

  @override
  State<ShoworderDetail> createState() => _ShoworderDetailState();
}

class _ShoworderDetailState extends State<ShoworderDetail> {
  final StreamController _streamController = StreamController();
  final StreamController _streamController2 = StreamController();
  TextEditingController _pay = TextEditingController();
  TextEditingController _textnote = TextEditingController();

  GlobalKey _containerKey = GlobalKey();
  String _selectpay = 'cash';
  String _payme = 'cash';
  num _paynum = 0;
  num _change = 0;
  String _paynumshow = '0';
  String _empname = '';
  String _wh = '';
  String _brach = '';
  String _brachid = '';

  String _companyname = '';
  String _compantel = '';
  String _taxid = '';
  String _address = '';
  String _band = '';
  num _beforvat = 0;
  num _amonut = 0;
  num _vatamount = 0;
  num _sumtot = 0;
  String _docid = '';
  int _count = 0;
  num _dicount = 0;
  num _befordiscount = 0;
  int _id = 0;
  String _docdate = '';
  num _status = 0;
  String _salename = '';
  String _salebrach = '';

  final oCcy = NumberFormat("#,###.00", "th_TH");
  final oCcy2 = NumberFormat("#,###.##", "th_TH");

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getString('branchid')!;
      _wh = prefs.getString('wh')!;
    });
  }

  LoadInvicesub(gencode) async {
    ApiSerivces().companyinfo().then((res) {
      print(res.data[0]);
      setState(() {
        _companyname = res.data[0]['name'];
        _band = res.data[0]['bandname'];
        _address = res.data[0]['address'];
        _compantel = res.data[0]['phone'];
        _taxid = res.data[0]['vatid'];
      });
    });
    ApiSerivces().saleorderSub(widget.genorder).then((res) async {
      setState(() {
        _streamController.add(res.data);
        _count = res.data.length;
      });
    });
    ApiSerivces().saleorder(gencode).then((res) async {
      print(res.data[0]['docdate']);
      setState(() {
        _id = res.data[0]['id'];
        _beforvat = res.data[0]['amountbeforvat'];
        _amonut = res.data[0]['amount'];
        _vatamount = res.data[0]['vatamount'];
        _docid = res.data[0]['docno'];
        _dicount = res.data[0]['discounttext'];
        _docdate =
            DateFormat('dd/MM/yyyy  H:mm ').format(DateTime.now()).toString();

        _textnote = TextEditingController(text: res.data[0]['description']);

        _befordiscount = res.data[0]['amountbeforeshipping'];
        if (res.data[0]['tmppaymentname'] != null) {
          _payme = res.data[0]['tmppaymentname'];
        } else {
          _payme = '';
        }

        _status = res.data[0]['status'];
        _salename = res.data[0]['sellname'];
        _salebrach = res.data[0]['branch'];
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    GetLogin();
    LoadInvicesub(widget.genorder);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, stream) {
        if (!stream.hasData) {
          return Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.center,
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
              child:
              Text(stream.error.toString()));
        }
        var querySnapshot = stream.data;

        return  Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
                itemCount: stream.data!.length,
                itemBuilder: (context, i) {
                  num qtyd = 0;
                  qtyd = querySnapshot[i]['qty'];

                  var id = querySnapshot[i]['id'];

                  return ListTile(
                    title: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(
                              querySnapshot[i]
                              ['name'],
                              maxLines: 2,
                              style: textLanadscapL
                                  .copyWith(
                                  fontSize: 12),
                            )),
                        Card(
                          child: Container(
                            alignment:
                            Alignment.center,
                            width: 80,
                            padding:
                            const EdgeInsets.all(5),
                            child: Text(
                                oCcy.format(
                                    querySnapshot[i]
                                    ['price']),
                                overflow: TextOverflow
                                    .ellipsis,
                                style: textLanadscapL
                                    .copyWith(
                                    fontSize: 12,
                                    color: Colors
                                        .black)),
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment:
                            Alignment.center,
                            width: 40,
                            padding:
                            const EdgeInsets.all(5),
                            child: Text('${qtyd}',
                                style: textLanadscapL
                                    .copyWith(
                                    fontSize: 12,
                                    color: Colors
                                        .black)),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: querySnapshot[i]['disconut']!=0?Container(
                              alignment: Alignment
                                  .centerRight,
                              child: Column(
                                children: [
                                  Text(
                                      oCcy.format(
                                          querySnapshot[i]
                                          ['price'] *
                                              qtyd),
                                      style: textLanadscapL
                                          .copyWith(
                                          fontSize: 12,
                                          color: Colors
                                              .red,
                                          decoration:
                                          TextDecoration
                                              .lineThrough)),
                                  Text(
                                      oCcy.format(
                                          querySnapshot[i]
                                          ['totprice']),
                                      style: textLanadscapL
                                          .copyWith(
                                        fontSize: 12,
                                        color: Colors
                                            .black,
                                      )),
                                ],
                              ),
                            ):Container(
                              alignment: Alignment
                                  .centerRight,
                              child: Text(
                                  oCcy.format(
                                      querySnapshot[i]
                                      ['price'] *
                                          qtyd),
                                  style: textLanadscapL
                                      .copyWith(
                                      fontSize:
                                      12)),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  );
                }));
      },
    );
  }
}
