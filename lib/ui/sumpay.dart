import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:falconpos/api/constant.dart';
import '../function/function.dart';
import 'listorder.dart';
import 'mainpage.dart';
import 'printthaipos.dart';
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


class SumPay extends StatefulWidget {
  final genorder;

  const SumPay({
    Key? key,
    required this.genorder,
  }) : super(key: key);

  @override
  State<SumPay> createState() => _SumPayState();
}

class _SumPayState extends State<SumPay> {
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
  int _brachid = 0;

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

  String _textsubtotal = '';
  String _textdiscount = '';
  String _textbeforevat = '';
  String _textvat = '';
  String _texttotal = '';

  num _statuorder = 0;

  final oCcy = NumberFormat("#,###.00", "th_TH");
  final oCcy2 = NumberFormat("#,###.##", "th_TH");

  GetLogin()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;
      Getsetting(_brach);
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
          print(e['name']);
          print(e['name'].length);
          print(e['name'].substring(20));
          _itemshowprint.add(ListItemshow(name: e['name'].substring(0, 20), qty: e['qty'].toString(), price: e['totprice'].toString()));
          _itemshowprint.add(ListItemshow(name: " " + e['name'].substring(20, e['name'].length), qty: "", price: ""));
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
        _statuorder = res.data[0]['status'];

        _docdate = DateFormat('dd/MM/yyyy  H:mm ').format(DateTime.now()).toString();
        print("dd" + _statuorder.toString());



        _befordiscount = res.data[0]['amountbeforeshipping'];

        _textsubtotal = oCcy.format(_befordiscount + _dicount).toString();
        _textdiscount = oCcy.format(_dicount).toString();
        _textbeforevat = oCcy.format(_beforvat);
        _textvat = oCcy.format(_vatamount);
        _texttotal = oCcy.format(_amonut);



      });
    });
  }

  String localIp = '192.168.1.200';
  List<String> devices = [];
  bool isDiscovering = false;
  String _nameshow = '';
  String _vatidshow = '';
  String _telshow = '';
  String _address1show = '';
  String _address2show = '';
  String _line1show = '';
  String _line2show = '';
  String? _line3show = '';
  String _logo = '';
  Getsetting(brach) async {
    ApiSerivces().settingselectslip(brach).then((res) {
      print(res.data[0]);
      setState(() {

        _nameshow = res.data[0]['name'];
        _vatidshow = res.data[0]['vatid'];
        _telshow = res.data[0]['tel'];
        _address1show = res.data[0]['address1'];
        _address2show = res.data[0]['address2'];
        _line1show = res.data[0]['endline1'];
        _line2show = res.data[0]['endline2'];
        _line3show = res.data[0]['endline3'];
        _logo = urlpic+'logo/'+res.data[0]['logo'];
        localIp = res.data[0]['ipprint'];
        print(_logo);
      });
    });
  }



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
        await printer.connect(localIp, port: 9100);

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
    final ByteData data = (await NetworkAssetBundle(Uri.parse(_logo)).load(_logo));
    Uint8List? uint8list = data.buffer.asUint8List();
    final image = decodeImage(uint8list!)!;
    printer.image(image);

    printer.feed(2);
    printer.text(
        _nameshow,styles: PosStyles(align: PosAlign.center),linesAfter: 1);
    printer.text(
        'Tax ID : $_vatidshow',styles: PosStyles(align: PosAlign.center),linesAfter: 1);
    printer.text(
        _address1show,linesAfter: 1);
    printer.text(
       _address2show,linesAfter: 1);

    printer.text(
        'TEL : $_telshow',linesAfter: 1);
    printer.feed(1);
    printer.text(
        'NO : ${_docid}',linesAfter: 1);
    printer.feed(1);
    printer.row([
      PosColumn(text: 'Date : ${_docdate}', width: 7),
      PosColumn(text: 'By : ${_empname}', width: 5),

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
          text: 'Subtotal',
          width: 6 ,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: _textsubtotal,
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1 ,codeTable: "CP437" )),
      PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),

    ]);
    printer.feed(1);
    _dicount!=0?printer.row([
      PosColumn(
          text: 'Discount',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: _textdiscount+"",
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1,codeTable: "CP437")),
      PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),

    ]):null;
    _dicount!=0?printer.feed(1):null;
    printer.row([
      PosColumn(
          text: 'BeforeVat',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: _textbeforevat,
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),

    ]);
    printer.feed(1);
    printer.row([
      PosColumn(
          text: 'Vat 7%',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: _textvat,
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),

    ]);
    printer.feed(1);
    printer.row([
      PosColumn(
          text: 'Total',
          width: 6,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: _texttotal,
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '',
          width: 1,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);



    printer.feed(2);
    printer.text(_line1show,
        styles: PosStyles(align: PosAlign.center, bold: true),linesAfter: 2);
    printer.text(_line2show,
        styles: PosStyles(align: PosAlign.center, bold: true),linesAfter: 2);
    printer.text(_line3show!,
        styles: PosStyles(align: PosAlign.center, bold: true),linesAfter: 2);


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
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ListOrder()));
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'Check Out',
                style: textBodyLage.copyWith(fontSize: 20),
              ),
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
        )
    );
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
                 color: Colors.black, fontSize: 18),
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

                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));

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

  Widget P(){
    return Column(
      children: [
        Container(
          height: 500,
            padding: const EdgeInsets.only(left: 18.0,right: 18,top: 2),
            child: Column(
              children: [
                 SizedBox(
                   height: 20,
                 ),
                SizedBox(
                  height: 40,
                  child: _statuorder !=2? Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                _payme = 'cash';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      color: HexColor('c7dca6'),
                                      width: 1
                                  ),
                                  color: _payme == 'cash'?Theme.of(context).primaryColor:Colors.white

                              ),
                              height: 80,
                              child:  Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children:  [
                                        SizedBox(
                                          height:50,
                                          child: ClipRRect(
                                            child: CircleAvatar(
                                              backgroundColor: HexColor('c7dca6'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height:20,
                                          child: ClipRRect(
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  Text(
                                    "CASH",
                                    style: textBodyLage.copyWith(fontSize: 14,color: _payme == 'cash'?Colors.white:Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                _payme = 'qr';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      color: HexColor('c7dca6'),
                                      width: 1
                                  ),
                                  color: _payme == 'qr'?Theme.of(context).primaryColor:Colors.white

                              ),
                              height: 80,
                              child:  Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children:  [
                                        SizedBox(
                                          height:65,
                                          child: ClipRRect(
                                            child: CircleAvatar(
                                              backgroundColor: HexColor('c7dca6'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height:20,
                                          child: ClipRRect(
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  Text(
                                    "QR",
                                    style: textBodyLage.copyWith(fontSize: 14,color: _payme == 'qr'?Colors.white:Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                _payme = 'credit';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                      color: HexColor('c7dca6'),
                                      width: 1
                                  ),
                                  color: _payme == 'credit'?Theme.of(context).primaryColor:Colors.white

                              ),
                              height: 80,
                              child:  Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children:  [
                                        SizedBox(
                                          height:65,
                                          child: ClipRRect(
                                            child: CircleAvatar(
                                              backgroundColor: HexColor('c7dca6'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height:20,
                                          child: ClipRRect(
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  Text(
                                    "CREDIT",
                                    style: textBodyLage.copyWith(fontSize: 14,color: _payme == 'credit'?Colors.white:Colors.black),
                                  ),

                                ],
                              ),
                            ),
                          )),
                    ],

                  ):Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 200,
                          child:  Container(
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
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _statuorder !=2?ElevatedButton(
                    onPressed: () async {

                      ConfirmOrderPay();

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('96b389')
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            LineIcons.dollarSign,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("PAY", style: textBodyLage.copyWith(fontSize: 20)),
                        ],
                      ),
                    )):Row(),
                SizedBox(
                  height: 16,
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('TOTAL : ',style: textBodyLage.copyWith(fontSize: 16,color: Colors.black),),
                        Expanded(child: Container(
                          alignment: Alignment.centerRight,
                          child:   Text('${oCcy.format(_amonut)}',style: textBodyLage.copyWith(fontSize: 16,color: Colors.black),),
                        ))

                      ],
                    ),
                  )),


                ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    Expanded(child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('CHANGE : ',style: textBodyLage.copyWith(fontSize: 16,color: Colors.black),),
                          Expanded(child:  Container(
                            alignment: Alignment.centerRight,
                            child:  Text('${oCcy.format(_change)}',style: textBodyLage.copyWith(fontSize: 16,color: Colors.black),),
                          ))

                        ],
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),

                Row(
                  children: [

                    Expanded(
                        flex: 2,
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                          color: HexColor('c7dca6'),
                                          width: 1
                                      ),


                                    ),

                                    child:  Container(
                                      padding: EdgeInsets.all(5),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        oCcy2.format(num.parse(_paynumshow)),
                                        style: textBodyLage.copyWith(fontSize: 16,color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(

                              children: [

                                Expanded(child:  NumberButton(1, 50, _pay),),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:  NumberButton(2, 50, _pay),),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:  NumberButton(3, 50, _pay),)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(

                              children: [

                                Expanded(child:  NumberButton(4, 50, _pay),),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:  NumberButton(5, 50, _pay),),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:  NumberButton(6, 50, _pay),)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(

                              children: [

                                Expanded(child:  NumberButton(7, 50, _pay),),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:  NumberButton(8, 50, _pay),),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:  NumberButton(9, 50, _pay),)

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(

                              children: [

                                Expanded(
                                  child:    SizedBox(
                                    height:50,
                                    child: OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor('e0e7ee'),
                                        elevation: 0,
                                        side: const BorderSide(
                                            color: Colors.white12, width: 0, style: BorderStyle.solid),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50 / 5),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _paynumshow += ".";

                                          if(num.parse(_paynumshow) > _amonut) {
                                            _change =  num.parse(_paynumshow) - _amonut;
                                          }
                                        });
                                      },
                                      child: const Center(
                                        child: Text(
                                          '.',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),),

                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:  NumberButton(0, 50, _pay),),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child:    SizedBox(
                                  height: 50,
                                  child: OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor('e0e7ee'),
                                      elevation: 0,
                                      side: const BorderSide(
                                          color: Colors.white12, width:0 , style: BorderStyle.solid),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60 / 5),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _paynumshow += "00";

                                        if(num.parse(_paynumshow) > _amonut) {
                                          _change =  num.parse(_paynumshow) - _amonut;
                                        }

                                      });
                                    },
                                    child: const Center(
                                      child: Text(
                                        '00',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),),

                              ],
                            )
                          ],
                        )),
                    SizedBox(
                      width: 20,
                    ),

                    Expanded(
                      flex:1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _paynumshow = '0';
                                  _change = 0;
                                  _paynum = 0;
                                });

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor('ea7e7e')
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      LineIcons.times,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("CLAR", style: textBodyLage.copyWith(fontSize: 16)),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {

                                setState(() {
                                  _paynumshow = _paynumshow.substring(0, _paynumshow.length - 1);


                                  if(num.parse(_paynumshow) > _amonut) {
                                    _change =  num.parse(_paynumshow) - _amonut;
                                  }
                                  if(_paynumshow == ''){
                                    _paynumshow = '0';
                                  }
                                });

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      LineIcons.alternateLongArrowLeft,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("DEL", style: textBodyLage.copyWith(fontSize: 16)),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                AddNote();
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
                                    Text("Note", style: textBodyLage.copyWith(fontSize: 16)),
                                  ],
                                ),
                              )),

                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                PosPrint(context, 'default', localIp, 1.5,2);
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
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("Print", style: textBodyLage.copyWith(fontSize: 16)),
                                  ],
                                ),
                              ))

                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

              ],
            )),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
            width: 300,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: kElevationToShadow[
                          2] // Use This kElevationToShadow ***********
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

                                  child: Column(
                                    children: [



                                      Row(
                                        children: [
                                          Text(
                                            'No.  ${_docid}',
                                            style: textBody.copyWith(
                                              fontSize: 18,
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
                                            flex:2,
                                            child: Text(
                                              'Date   ${_docdate}',
                                              style: textBody.copyWith(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: Text(
                                              'By  ${_empname}',
                                              style: textBody.copyWith(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              const Divider(
                                height: 3,
                                thickness: 2,
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
                                          fontSize: 18,),
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
                                              fontSize: 18,
                                              color: Colors.black,
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
                                              fontSize: 18,),
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
                                                      fontSize: 18,),
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
                                                          fontSize: 18,
                                                          color: Colors
                                                              .black,

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
                                                          18,),
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
                                height: 3,
                                thickness: 2,
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
                                              "Subtotal",
                                              style: textBody.copyWith(
                                                  fontSize: 18,
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
                                            "  ${_befordiscount != 0 ? oCcy.format(_befordiscount + _dicount).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 18,
                                            ),
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
                                              "Discount",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_dicount != 0 ? oCcy.format(_dicount).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 3,
                                thickness: 2,
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
                                              "Items $_count",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
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
                                              "Amount",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_amonut != null ? oCcy.format(_amonut).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
                                              "Beforvat",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_beforvat != null ? oCcy.format(_beforvat).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
                                              "Vat 7%",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_vatamount != null ? oCcy.format(_vatamount).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
                                              "Total",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_amonut != null ? oCcy.format(_amonut).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
              ),
            )),


      ],
    );
  }
  Widget L(){
    return Row(
      children: [
        SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: kElevationToShadow[
                          2] // Use This kElevationToShadow ***********
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



                                      Row(
                                        children: [
                                          Text(
                                            'No.  ${_docid}',
                                            style: textBody.copyWith(
                                              fontSize: 18,
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
                                            flex:2,
                                            child: Text(
                                              'Date   ${_docdate}',
                                              style: textBody.copyWith(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: Text(
                                              'By  ${_empname}',
                                              style: textBody.copyWith(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              const Divider(
                                height: 3,
                                thickness: 2,
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
                                          fontSize: 18,),
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
                                              fontSize: 18,
                                              color: Colors.black,
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
                                              fontSize: 18,),
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
                                                      fontSize: 18,),
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
                                                          fontSize: 18,
                                                          color: Colors
                                                              .black,

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
                                                          18,),
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
                                height: 3,
                                thickness: 2,
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
                                              "Subtotal",
                                              style: textBody.copyWith(
                                                  fontSize: 18,
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
                                            "  ${_befordiscount != 0 ? oCcy.format(_befordiscount + _dicount).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 18,
                                            ),
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
                                              "Discount",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_dicount != 0 ? oCcy.format(_dicount).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 3,
                                thickness: 2,
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
                                              "Items $_count",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
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
                                              "Amount",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_amonut != null ? oCcy.format(_amonut).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
                                              "Beforvat",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_beforvat != null ? oCcy.format(_beforvat).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
                                              "Vat 7%",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_vatamount != null ? oCcy.format(_vatamount).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
                                              "Total",
                                              style: textBody.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          alignment:
                                          Alignment.centerRight,
                                          child: Text(
                                            "  ${_amonut != null ? oCcy.format(_amonut).toString() : "0.00"}",
                                            style: textBody.copyWith(
                                              fontSize: 20,
                                            ),
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
              ),
            )),
        Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18,top: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 80,
                    child: _statuorder !=2? Row(
                      children: [
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  _payme = 'cash';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                        color: HexColor('c7dca6'),
                                        width: 1
                                    ),
                                    color: _payme == 'cash'?Theme.of(context).primaryColor:Colors.white

                                ),
                                height: 80,
                                child:  Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children:  [
                                          SizedBox(
                                            height:50,
                                            child: ClipRRect(
                                              child: CircleAvatar(
                                                backgroundColor: HexColor('c7dca6'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height:20,
                                            child: ClipRRect(
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                    Text(
                                      "CASH",
                                      style: textBodyLage.copyWith(fontSize: 18,color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  _payme = 'qr';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                        color: HexColor('c7dca6'),
                                        width: 1
                                    ),
                                    color: _payme == 'qr'?Theme.of(context).primaryColor:Colors.white

                                ),
                                height: 80,
                                child:  Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children:  [
                                          SizedBox(
                                            height:65,
                                            child: ClipRRect(
                                              child: CircleAvatar(
                                                backgroundColor: HexColor('c7dca6'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height:20,
                                            child: ClipRRect(
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                    Text(
                                      "QR",
                                      style: textBodyLage.copyWith(fontSize: 18,color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  _payme = 'credit';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                        color: HexColor('c7dca6'),
                                        width: 1
                                    ),
                                    color: _payme == 'credit'?Theme.of(context).primaryColor:Colors.white

                                ),
                                height: 80,
                                child:  Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children:  [
                                          SizedBox(
                                            height:65,
                                            child: ClipRRect(
                                              child: CircleAvatar(
                                                backgroundColor: HexColor('c7dca6'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height:20,
                                            child: ClipRRect(
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                    Text(
                                      "CREDIT",
                                      style: textBodyLage.copyWith(fontSize: 18,color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],

                    ):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 200,
                            child:  Container(
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
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(child:   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('TOTAL : ',style: textBodyLage.copyWith(fontSize: 24,color: Colors.black),),
                            Expanded(child: Container(
                              alignment: Alignment.centerRight,
                              child:   Text('${oCcy.format(_amonut)}',style: textBodyLage.copyWith(fontSize: 24,color: Colors.black),),
                            ))

                          ],
                        ),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('CHANGE : ',style: textBodyLage.copyWith(fontSize: 24,color: Colors.black),),
                            Expanded(child:  Container(
                              alignment: Alignment.centerRight,
                              child:  Text('${oCcy.format(_change)}',style: textBodyLage.copyWith(fontSize: 24,color: Colors.black),),
                            ))

                          ],
                        ),
                      ))
                    ],
                  ),),

                  SizedBox(
                    height: 10,
                  ),

                  Expanded(
                      flex: 3,
                      child: Row(
                        children: [

                          Expanded(
                              flex: 2,
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(13),
                                            border: Border.all(
                                                color: HexColor('c7dca6'),
                                                width: 1
                                            ),


                                          ),

                                          child:  Container(
                                            padding: EdgeInsets.all(5),
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              oCcy2.format(num.parse(_paynumshow)),
                                              style: textBodyLage.copyWith(fontSize: 20,color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(

                                    children: [

                                      Expanded(child:  NumberButton(1, 50, _pay),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:  NumberButton(2, 50, _pay),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:  NumberButton(3, 50, _pay),)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(

                                    children: [

                                      Expanded(child:  NumberButton(4, 50, _pay),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:  NumberButton(5, 50, _pay),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:  NumberButton(6, 50, _pay),)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(

                                    children: [

                                      Expanded(child:  NumberButton(7, 50, _pay),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:  NumberButton(8, 50, _pay),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:  NumberButton(9, 50, _pay),)

                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(

                                    children: [

                                      Expanded(
                                        child:    SizedBox(
                                          height:60,
                                          child: OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: HexColor('e0e7ee'),
                                              elevation: 0,
                                              side: const BorderSide(
                                                  color: Colors.white12, width: 0, style: BorderStyle.solid),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50 / 5),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _paynumshow += ".";

                                                if(num.parse(_paynumshow) > _amonut) {
                                                  _change =  num.parse(_paynumshow) - _amonut;
                                                }
                                              });
                                            },
                                            child: const Center(
                                              child: Text(
                                                '.',
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),),

                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:  NumberButton(0, 50, _pay),),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child:    SizedBox(
                                        height: 50,
                                        child: OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor('e0e7ee'),
                                            elevation: 0,
                                            side: const BorderSide(
                                                color: Colors.white12, width:0 , style: BorderStyle.solid),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(60 / 5),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _paynumshow += "00";

                                              if(num.parse(_paynumshow) > _amonut) {
                                                _change =  num.parse(_paynumshow) - _amonut;
                                              }

                                            });
                                          },
                                          child: const Center(
                                            child: Text(
                                              '00',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),),

                                    ],
                                  )
                                ],
                              )),
                          SizedBox(
                            width: 20,
                          ),

                          Expanded(
                            flex:1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _paynumshow = '0';
                                        _change = 0;
                                        _paynum = 0;
                                      });

                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: HexColor('ea7e7e')
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            LineIcons.times,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text("CLAR", style: textBodyLage.copyWith(fontSize: 20)),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async {

                                      setState(() {
                                        _paynumshow = _paynumshow.substring(0, _paynumshow.length - 1);


                                        if(num.parse(_paynumshow) > _amonut) {
                                          _change =  num.parse(_paynumshow) - _amonut;
                                        }
                                        if(_paynumshow == ''){
                                          _paynumshow = '0';
                                        }
                                      });

                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            LineIcons.alternateLongArrowLeft,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text("DEL", style: textBodyLage.copyWith(fontSize: 20)),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      AddNote();
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
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text("Note", style: textBodyLage.copyWith(fontSize: 20)),
                                        ],
                                      ),
                                    )),

                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      PosPrint(context, 'default', localIp, 1.5,2);
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
                                          Text("PrintEng", style: textBodyLage.copyWith(fontSize: 18)),
                                        ],
                                      ),
                                    ))

                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  _statuorder !=2?ElevatedButton(
                      onPressed: () async {

                        ConfirmOrderPay();

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor('96b389')
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              LineIcons.dollarSign,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("PAY", style: textBodyLage.copyWith(fontSize: 28)),
                          ],
                        ),
                      )):Row(),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )),
      ],
    );
  }

}
class ListItemshow {
  String name;
  String  qty;
  String  price;

  ListItemshow({required this.name,required this.qty,required this.price});

}
