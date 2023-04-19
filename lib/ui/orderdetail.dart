import 'dart:async';
import 'dart:typed_data';

import 'package:falconpos/ui/sumpay.dart';
import 'package:falconpos/widget/wigorderdetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../function/function.dart';
import '../theme/textshow.dart';
import '../widget/divbraek.dart';
import 'listorder.dart';

class OrderDetail extends StatefulWidget {
  final genorder;

  const OrderDetail({Key? key, this.genorder}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
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
    TextEditingController _pay = TextEditingController();
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListOrder()));
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'Detail ',
                style: textBodyLage.copyWith(fontSize: 20),
              ),
              centerTitle: true,
            ),
            body:  OrientationBuilder(
              builder: (context, orientation) {
                if (Orientation.portrait  == currentOrientation) {
                  print(orientation);

                  return P();
                } else {
                  return L();
                }
              },
            )
        ));
  }

  Future CancelConfirm() {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          LineIcons.exclamationCircle,
                          size: 70,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          ' Are you sure you want to delete? ',
                          style: textBodyMedium.copyWith(
                              fontSize: 13, color: Colors.black),
                        ),
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
                                style: textBodyLage.copyWith(fontSize: 13)),
                          )),
                      ElevatedButton(
                          onPressed: () async {
                            await ApiSerivces()
                                .CanelOrer(widget.genorder)
                                .then((e) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ListOrder()));
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Confirm',
                              style: textBodyLage.copyWith(fontSize: 13),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            )));
  }

  Widget P(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.only(top: 4),
                    height: MediaQuery.of(context).size.height * .4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, left: 4),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  height: 40,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      .14,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        LineIcons.receipt,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${_docid}',
                                        style: textLanadscapL.copyWith(
                                            fontSize: 10,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 2.0, left: 2),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  height: 40,
                                  alignment: Alignment.centerRight,

                                  child: Row(

                                    children: [
                                      const Icon(
                                        LineIcons.calendar,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${_docdate}',
                                        style: textLanadscapL.copyWith(
                                            fontSize: 10,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 2.0, left: 2),
                                  child: _status == 2
                                      ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: _payme == 'cash'
                                          ? Colors.cyan
                                          : _payme == 'qr'
                                          ? Colors.blue
                                          : Colors.green,
                                    ),
                                    alignment: Alignment.center,
                                    height: 40,
                                    child: Text(
                                      '${_payme}',
                                      style: textBodyLage.copyWith(
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  )
                                      : _status == 3
                                      ? Container(
                                    height: 40,
                                    decoration:
                                    const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              15)),
                                      color: Colors.red,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Cancel',
                                      style:
                                      textBodyLage.copyWith(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  )
                                      : Container(
                                    height: 40,
                                    decoration:
                                    const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              15)),
                                      color: Colors.yellow,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'on hold',
                                      style:
                                      textBodyLage.copyWith(
                                          fontSize: 13,
                                          color:
                                          Colors.black),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        divb(),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: ShoworderDetail(widget.genorder),
                        ),
                        divb(),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Subtotal',
                                          style: textLanadscapL
                                              .copyWith(fontSize: 12)),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                "${oCcy.format(_beforvat)}",
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 12))
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
                                      Text('Tax',
                                          style: textLanadscapL),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                oCcy.format(_vatamount),
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 12))
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
                                      Text('Discount',
                                          style: textLanadscapL
                                              .copyWith(fontSize: 12)),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(oCcy.format(_dicount),
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 12))
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
                                      Text('Total',
                                          style: textLanadscapL
                                              .copyWith(fontSize: 12)),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(oCcy.format(_amonut),
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 12))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Row(
                    children: [
                      Icon(
                        Icons.note_add,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        ' Add Note ',
                        style: textBodyMedium.copyWith(
                            fontSize: 13, color: Colors.black),
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
                            decoration: inputForm1(''),
                            maxLines: 2,
                            controller: _textnote,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await ApiSerivces()
                            .PosAddNote(_id, _textnote.text)
                            .then((e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                      content: SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            .3,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            .3,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle_outline,
                                                        size: 124,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      Text(
                                                        'Success Save Note',
                                                        style:
                                                        textBodyMedium.copyWith(
                                                            fontSize: 16,
                                                            color:
                                                            Colors.black),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          5.0),
                                                      child: Text(
                                                        'OK',
                                                        style: textBodyLage
                                                            .copyWith(
                                                            fontSize: 18),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.penSquare,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Save Note",
                                style: textBodyLage.copyWith(fontSize: 20)),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SumPay(genorder: widget.genorder)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.print,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Print",
                                style: textBodyLage.copyWith(fontSize: 20)),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  _status != 3
                      ? ElevatedButton(
                      onPressed: () async {
                        CancelConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.exclamation,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Cancel",
                                style: textBodyLage.copyWith(
                                    fontSize: 20)),
                          ],
                        ),
                      ))
                      : Row(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget L(){
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Padding(
              padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 10),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    height: MediaQuery.of(context).size.height * .8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10.0, left: 20),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  height: 40,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width *
                                      .14,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        LineIcons.receipt,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${_docid}',
                                        style: textLanadscapL.copyWith(
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 10.0, left: 20),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  height: 40,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        LineIcons.calendar,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${_docdate}',
                                        style: textLanadscapL.copyWith(
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, left: 20),
                                  child: _status == 2
                                      ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      color: _payme == 'cash'
                                          ? Colors.cyan
                                          : _payme == 'qr'
                                          ? Colors.blue
                                          : Colors.green,
                                    ),
                                    alignment: Alignment.center,
                                    height: 40,
                                    child: Text(
                                      '${_payme}',
                                      style: textBodyLage.copyWith(
                                          fontSize: 22,
                                          color: Colors.white),
                                    ),
                                  )
                                      : _status == 3
                                      ? Container(
                                    height: 40,
                                    decoration:
                                    const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              15)),
                                      color: Colors.red,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Cancel',
                                      style:
                                      textBodyLage.copyWith(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  )
                                      : Container(
                                    height: 40,
                                    decoration:
                                    const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              15)),
                                      color: Colors.yellow,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'on hold',
                                      style:
                                      textBodyLage.copyWith(
                                          fontSize: 13,
                                          color:
                                          Colors.black),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        divb(),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: ShoworderDetail(widget.genorder),
                        ),
                        divb(),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Subtotal',
                                          style: textLanadscapL
                                              .copyWith(fontSize: 15)),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                "${oCcy.format(_beforvat)}",
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 15))
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
                                      Text('Tax',
                                          style: textLanadscapL),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                oCcy.format(_vatamount),
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 15))
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
                                      Text('Discount',
                                          style: textLanadscapL
                                              .copyWith(fontSize: 15)),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(oCcy.format(_dicount),
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 15))
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
                                      Text('Total',
                                          style: textLanadscapL
                                              .copyWith(fontSize: 15)),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(oCcy.format(_amonut),
                                                style: textLanadscapL
                                                    .copyWith(
                                                    fontSize: 15))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )),
        Expanded(
            child: Padding(
              padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15)),
                          color: Theme.of(context).primaryColor,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * .14,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Icon(
                              LineIcons.userCircle,
                              size: 28,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${_salename}',
                              style: textLanadscapL.copyWith(
                                  fontSize: 13, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15)),
                          color: Theme.of(context).primaryColor,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width * .14,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Icon(
                              LineIcons.store,
                              size: 28,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${_salebrach}',
                              style: textLanadscapL.copyWith(
                                  fontSize: 13, color: Colors.white),
                            ),
                          ],
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
                  Row(
                    children: [
                      Icon(
                        Icons.note_add,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        ' Add Note ',
                        style: textBodyMedium.copyWith(
                            fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                            decoration: inputForm1(''),
                            maxLines: 5,
                            controller: _textnote,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await ApiSerivces()
                            .PosAddNote(_id, _textnote.text)
                            .then((e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                      content: SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            .3,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            .3,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle_outline,
                                                        size: 124,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      Text(
                                                        'Success Save Note',
                                                        style:
                                                        textBodyMedium.copyWith(
                                                            fontSize: 16,
                                                            color:
                                                            Colors.black),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          5.0),
                                                      child: Text(
                                                        'OK',
                                                        style: textBodyLage
                                                            .copyWith(
                                                            fontSize: 18),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.penSquare,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Save Note",
                                style: textBodyLage.copyWith(fontSize: 20)),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SumPay(genorder: widget.genorder)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.print,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Print",
                                style: textBodyLage.copyWith(fontSize: 20)),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  _status != 3
                      ? ElevatedButton(
                      onPressed: () async {
                        CancelConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.exclamation,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Cancel",
                                style: textBodyLage.copyWith(
                                    fontSize: 20)),
                          ],
                        ),
                      ))
                      : Row(),
                ],
              ),
            )),
      ],
    );
  }
}
