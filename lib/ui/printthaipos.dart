import 'dart:async';

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:falconpos/function/function.dart';
import 'package:falconpos/ui/listorder.dart';
import 'package:falconpos/ui/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../theme/textshow.dart';
class PrintThaiPos extends StatefulWidget {
  final genorder;
  const PrintThaiPos({Key? key, this.genorder}) : super(key: key);

  @override
  State<PrintThaiPos> createState() => _PrintThaiPosState();
}

class _PrintThaiPosState extends State<PrintThaiPos> {
  final StreamController _streamController = StreamController();
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

  final oCcy = NumberFormat("#,###.00", "th_TH");
  final oCcy2 = NumberFormat("#,###.##", "th_TH");

  GetLogin()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getString('branchid')!;
      _wh = prefs.getString('wh')!;
    });
  }
  List<ListItemshow> _itemshowprint = [];
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
      res.data.forEach((e) {
        setState(() {
          if(e['name'].length < 20 ) {

            _itemshowprint.add(ListItemshow(name: e['name'], qty: e['qty'].toString(), price: e['totprice'].toString()));
          } else {
            _itemshowprint.add(ListItemshow(name: e['name'].substring(0, 25), qty: e['qty'].toString(), price: e['totprice'].toString()));
            _itemshowprint.add(ListItemshow(name: " " + e['name'].substring(25, e['name'].length), qty: "", price: ""));
          }


        });
      });
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
        _docdate = DateFormat('dd/MM/yyyy  H:mm ').format(DateTime.now()).toString();

        _befordiscount = res.data[0]['amountbeforeshipping'];
      });
    });
  }

  String localIp = '192.168.1.200';
  List<String> devices = [];
  bool isDiscovering = false;



  void PosPrint(
      BuildContext ctx, String printname, String ip, double pixelRatio ,num chk) async {
    print(printname);
    print(ip);
    print(pixelRatio);
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load(name: printname);
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
    await printer.connect('192.168.1.200', port: 9100);

    print(res.msg);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      if(chk ==1) {
        await convertWidgetToImage(printer, pixelRatio);
      } else {
        await PrintEng(printer, pixelRatio);
      }
      // TEST PRINT
      // await testReceipt(printer);
      printer.disconnect();
    }
  }

  Future<Uint8List?> widget2Image() async {
    RenderRepaintBoundary? renderRepaintBoundary = _containerKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary?;

    ui.Image? boxImage = await renderRepaintBoundary?.toImage(
      pixelRatio: 1,
    );
    ByteData? byteData =
    await boxImage?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? uint8list = byteData?.buffer.asUint8List();
    print(byteData.toString());
    return uint8list;
  }

  Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = utf8.encode(str);
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  Future<void> convertWidgetToImage(
      NetworkPrinter printer, double pixelRatio) async {
    // printer.textEncoded(convertStringToUint8List('สวัสดี'),styles: PosStyles(codeTable: 'CP874'));
    //  printer.text('Receipt',styles: PosStyles(align: PosAlign.center));
    //  printer.text('kewlkeen',styles: PosStyles(align: PosAlign.center,bold: true, height: PosTextSize.size1,
    //    width: PosTextSize.size1,));
    RenderRepaintBoundary? renderRepaintBoundary = _containerKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary?;

    ui.Image? boxImage = await renderRepaintBoundary?.toImage(
      pixelRatio: 1,
    );
    ByteData? byteData =
    await boxImage?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? uint8list = byteData?.buffer.asUint8List();
    print(byteData.toString());
    final image = decodeImage(uint8list!)!;
    printer.image(image);
    printer.feed(2);
    printer.cut();

    printer.drawer(pin: PosDrawer.pin2);
  }
  Future<void> PrintEng(
      NetworkPrinter printer, date) async {
    // printer.textEncoded(convertStringToUint8List('สวัสดี'),styles: PosStyles(codeTable: 'CP874'));

    printer.text('Receipt',styles: PosStyles(align: PosAlign.center));
    printer.feed(2);
    final ByteData data = await rootBundle.load('assets/images/kewlkeen_logo.jpg');
    Uint8List? uint8list = data.buffer.asUint8List();
    final image = decodeImage(uint8list!)!;
    printer.image(image);

    printer.feed(2);
    printer.text(
        'VENICH SOCIAL COMMERCE Co.,Ltd.',styles: PosStyles(align: PosAlign.center),linesAfter: 1);
    printer.text(
        'Tax ID : 0105561025421',styles: PosStyles(align: PosAlign.center),linesAfter: 1);
    printer.text(
        'B207 Building B, 2nd Floor, Soi Chula 7, Rama 4 Road, ',linesAfter: 1);
    printer.text(
        'Wang Mai, Pathum Wan, Bangkok 10330, ',linesAfter: 1);

    printer.text(
        'TEL : (+66)0-2351-0168',linesAfter: 1);
    printer.feed(1);
    printer.text(
        'NO : ${_docid}',linesAfter: 1);
    printer.feed(1);
    printer.row([
      PosColumn(text: 'Date : ${_docdate}', width: 6),
      PosColumn(text: 'By : ${_empname}', width: 6),

    ]);
    printer.feed(1);
    printer.text('------------------------------------------------------', styles: PosStyles(align: PosAlign.center));
    printer.feed(1);
    printer.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 8,styles: PosStyles(align: PosAlign.center)),

      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '', width: 1, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.feed(1);

    for (var i = 0; i < _itemshowprint.length; i++) {
      printer.feed(1);
      printer.row([
        PosColumn(text: '${_itemshowprint[i].qty}', width: 1),
        PosColumn(text: '${_itemshowprint[i].name}', width: 8),
        PosColumn(
            text: '${_itemshowprint[i].price !=''?oCcy2.format(num.parse(_itemshowprint[i].price)):''}', width: 2, styles: PosStyles(align: PosAlign.right)),
        PosColumn(
            text: '', width: 1, styles: PosStyles(align: PosAlign.right)),
      ]);
    }
    printer.feed(1);
    printer.text('------------------------------------------------------', styles: PosStyles(align: PosAlign.center));
    printer.feed(1);
    printer.text('Items : ${_count}');
    printer.feed(1);
    printer.text('------------------------------------------------------', styles: PosStyles(align: PosAlign.center));
    printer.feed(1);
    printer.feed(1);
    printer.row([
      PosColumn(
          text: 'Subtottal',
          width: 6 ,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: '${_befordiscount != 0?oCcy.format(_befordiscount + _dicount).toString():"0.00"}',
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '', width: 1, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.feed(1);
    _dicount!=0?printer.row([
      PosColumn(
          text: 'Discount',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: '${oCcy.format(_dicount)}',
          width: 5,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: '', width: 1, styles: PosStyles(align: PosAlign.right)),
    ]):null;
    _dicount!=0?printer.feed(1):null;
    printer.row([
      PosColumn(
          text: 'BeforVat',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: '${_beforvat != 0 ? oCcy.format(_beforvat).toString():"0.00"}',
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '', width: 1, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.feed(1);
    printer.row([
      PosColumn(
          text: 'Vat 7%',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: '${_vatamount != 0 ? oCcy.format(_vatamount).toString():"0.00"}',
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '', width: 1, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.feed(1);
    printer.row([
      PosColumn(
          text: 'Total ',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: '${_amonut != 0 ? oCcy.format(_amonut).toString():"0.00"}',
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '', width: 1, styles: PosStyles(align: PosAlign.right)),
    ]);



    printer.feed(2);
    printer.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    printer.feed(1);
    printer.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    printer.feed(2);
    printer.cut();

    printer.drawer(pin: PosDrawer.pin2);
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'Thai Slip',
                style: textBodyLage.copyWith(fontSize: 20),
              ),
              centerTitle: true,
            ),
            body: Row(
              children: [
                SizedBox(
                    width: 600,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              boxShadow: kElevationToShadow[
                              1], // Use This kElevationToShadow ***********
                            ),
                            child: Container(
                              width: 500,
                              color: Colors.white,
                              padding: const EdgeInsets.all(5),
                              child: RepaintBoundary(
                                key: _containerKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [

                                            Center(
                                              child: Text(
                                                "Receipt",
                                                style: GoogleFonts.getFont('KoHo').copyWith(fontSize: 40,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${_band}",
                                                style: GoogleFonts.getFont('KoHo').copyWith(fontSize: 60 ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,left: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_companyname}",
                                                    style: GoogleFonts.getFont('Sarabun').copyWith(fontSize: 30,fontWeight: FontWeight.w900),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "เลขประจำตัวผู้เสียภาษี ${_taxid}",
                                                    style: textBody.copyWith(
                                                        fontSize: 24,fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Center(
                                                child: Text(
                                                  "${_address}",
                                                  style: textBody.copyWith(
                                                      fontSize: 20,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Tel ${_compantel}",
                                                    style: textBody.copyWith(
                                                        fontSize: 20,fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'เลขที่  ${_docid}',
                                                  style: textBody.copyWith(
                                                      fontSize: 23,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex:2,
                                                  child: Text(
                                                    'วันที่   ${_docdate}',
                                                    style: textBody.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:1,
                                                  child: Text(
                                                    ' ${_empname}',
                                                    style: textBody.copyWith(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    const Divider(
                                      height: 5,
                                      thickness: 4,
                                      endIndent: 0,
                                      color: Colors.black,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'QTY',
                                              style: textBody.copyWith(
                                                  fontSize: 24,fontWeight: FontWeight.bold),
                                            )),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ITEM',
                                                  style: textBody.copyWith(
                                                      fontSize: 24,
                                                      color: Colors.black, fontWeight: FontWeight.bold
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'TOTAL',
                                                  style: textBody.copyWith(
                                                      fontSize: 24,fontWeight: FontWeight.bold),
                                                ))),
                                      ],
                                    ),
                                    StreamBuilder(
                                      stream: _streamController.stream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              var post = snapshot.data[index];

                                              return Container(
                                                padding:
                                                const EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: 50,
                                                        child: Text(
                                                          '${post['qty']}',
                                                          style:
                                                          textBody.copyWith(
                                                              fontSize: 24,fontWeight: FontWeight.bold),
                                                        )),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            bottom: 8),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              post['name'],
                                                              style: textBody
                                                                  .copyWith(
                                                                  fontSize: 24,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${oCcy.format(post['totprice'])}',
                                                              style: textBody
                                                                  .copyWith(
                                                                  fontSize:
                                                                  24,fontWeight: FontWeight.bold),
                                                            ))),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                        return const Text("....");
                                      },
                                    ),
                                    const Divider(
                                      height: 5,
                                      thickness: 4,
                                      endIndent: 0,
                                      color: Colors.black,
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 20),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "รวม",
                                                    style: textBody.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                const EdgeInsets.only(right: 20),
                                                alignment:
                                                Alignment.centerRight,
                                                child: Text(
                                                  "  ${_befordiscount != 0 ? oCcy.format(_befordiscount + _dicount).toString() : "0.00"} บาท",
                                                  style: textBody.copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 20),
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    "ส่วนลด",
                                                    style: textBody.copyWith(
                                                        fontSize: 26,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                const EdgeInsets.only(right: 20),
                                                alignment:
                                                Alignment.centerRight,
                                                child: Text(
                                                  "  ${_dicount != 0 ? oCcy.format(_dicount).toString() : "0.00"} บาท",
                                                  style: textBody.copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 5,
                                      thickness: 4,
                                      endIndent: 0,
                                      color: Colors.black,
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 26),
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    "$_count รายาร",
                                                    style: textBody.copyWith(
                                                        fontSize: 26,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 20),
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    "รวมเงิน",
                                                    style: textBody.copyWith(
                                                        fontSize: 26,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                const EdgeInsets.only(right: 20),
                                                alignment:
                                                Alignment.centerRight,
                                                child: Text(
                                                  "  ${_amonut != null ? oCcy.format(_amonut).toString() : "0.00"} บาท",
                                                  style: textBody.copyWith(
                                                      fontSize: 26,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 26),
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    "มูลค่าสินค้า",
                                                    style: textBody.copyWith(
                                                        fontSize: 26,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                const EdgeInsets.only(right: 20),
                                                alignment:
                                                Alignment.centerRight,
                                                child: Text(
                                                  "  ${_beforvat != null ? oCcy.format(_beforvat).toString() : "0.00"} บาท",
                                                  style: textBody.copyWith(
                                                      fontSize: 26,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 20),
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    "ภาษีมูลค่าเพิ่ม 7%",
                                                    style: textBody.copyWith(
                                                        fontSize: 26,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                const EdgeInsets.only(right: 20),
                                                alignment:
                                                Alignment.centerRight,
                                                child: Text(
                                                  "  ${_vatamount != null ? oCcy.format(_vatamount).toString() : "0.00"} บาท",
                                                  style: textBody.copyWith(
                                                      fontSize: 26,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      right: 26),
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child: Text(
                                                    "ยอดรวม",
                                                    style: textBody.copyWith(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                const EdgeInsets.only(right: 20),
                                                alignment:
                                                Alignment.centerRight,
                                                child: Text(
                                                  "  ${_amonut != null ? oCcy.format(_amonut).toString() : "0.00"} บาท",
                                                  style: textBody.copyWith(
                                                      fontSize: 26,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              child: Text(
                                                "",
                                                style:
                                                textBody.copyWith(fontSize: 18),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0,right: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                                onPressed: () async {
                                  PosPrint(context, 'XP-N160I', localIp, 1.5 ,1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan,

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:CrossAxisAlignment.center ,
                                    children: [
                                      const Icon(
                                        LineIcons.print,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("PrintThai", style: textBodyLage.copyWith(fontSize: 18)),
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    )),
              ],
            )));
  }

  Widget NumberButton(
      int number, double size, TextEditingController controller) {
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor('e0e7ee'),
          elevation: 0,
          side: const BorderSide(
              color: Colors.white12, width: 0, style: BorderStyle.solid),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 5),
          ),
        ),
        onPressed: () {
          setState(() {

            if(_paynumshow == '0') {

              _paynumshow = number.toString();
            } else {

              _paynumshow += number.toString();
            }



            if(num.parse(_paynumshow) > _amonut) {
              _change =  num.parse(_paynumshow) - _amonut;
            }



          });
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
          ),
        ),
      ),
    );
  }
  Future ConfirmOrderPay(){

    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(

            content: SizedBox(
              height: MediaQuery.of(context).size.height*.3,
              width: MediaQuery.of(context).size.width*.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_outline,size: 124,color: Theme.of(context).primaryColor,),
                        Text('Confirmation?',style: textBodyMedium.copyWith(fontSize: 16,color: Colors.black),)
                      ],
                    ),
                  )),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Cancel',style: textBodyLage.copyWith(fontSize: 18)),
                          )),
                      ElevatedButton(
                          onPressed: () async {
                            await ApiSerivces().UpdatePayment(_id, _paynumshow, _payme).then((e) {

                              ApiSerivces().Updatestockoutapi(widget.genorder, _empname).then((i) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage())));

                            });

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Confirm',style: textBodyLage.copyWith(fontSize: 18),),
                          )),


                    ],
                  ),
                ],
              ),
            )

        )
    );
  }
  Future AddNote(){

    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(

            content: SizedBox(
              height: MediaQuery.of(context).size.height*.4,
              width: MediaQuery.of(context).size.width*.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.note_add,size: 24,color: Theme.of(context).primaryColor,),
                            Text(' Add Note ',style: textBodyMedium.copyWith(fontSize: 18,color: Colors.black),),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(child: TextFormField(
                              decoration: inputForm1(''),
                              maxLines: 5,
                              controller: _textnote,
                            ))
                          ],
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
                              backgroundColor: Colors.redAccent
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Cancel',style: textBodyLage.copyWith(fontSize: 18)),
                          )),
                      ElevatedButton(
                          onPressed: () async {

                            await ApiSerivces().PosAddNote(_id, _textnote.text).then((e) {

                              Navigator.of(context).pop();


                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('Add Note',style: textBodyLage.copyWith(fontSize: 18),),
                          )),


                    ],
                  ),
                ],
              ),
            )

        )
    );
  }

}
class ListItemshow {
  String name;
  String  qty;
  String  price;

  ListItemshow({required this.name,required this.qty,required this.price});

}
