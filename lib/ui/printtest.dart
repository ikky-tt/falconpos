import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/textshow.dart';

class PrintTest extends StatefulWidget {
  const PrintTest({Key? key}) : super(key: key);

  @override
  State<PrintTest> createState() => _PrintTestState();
}

class _PrintTestState extends State<PrintTest> {



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

        await PrintEng(printer, pixelRatio);

      // TEST PRINT
      // await testReceipt(printer);
      printer.disconnect();
    }
  }
  Future<void> PrintEng(
      NetworkPrinter printer, date) async {
    // printer.textEncoded(convertStringToUint8List('สวัสดี'),styles: PosStyles(codeTable: 'CP874'));

    printer.text('Receipt',styles: PosStyles(align: PosAlign.center));
    printer.feed(4);
    String b = 'BA01HB0001LTMN00';
    List<dynamic> clist = b.split("");
    print(b);
    printer.barcode(Barcode.code128("A978020137962".split("")));
    printer.feed(4);

    printer.feed(2);
    printer.text(
        'VENICH SOCIAL COMMERCE Co.,Ltd.',styles: PosStyles(align: PosAlign.center),linesAfter: 1);
    printer.text(
        'Tax ID : 0105561025421',styles: PosStyles(align: PosAlign.center),linesAfter: 1);
    printer.text(
        'B207 Building B, 2nd Floor, Soi Chula 7, Rama 4 Road, ',linesAfter: 1);
    printer.text(
        'Wang Mai, Pathum Wan, Bangkok 10330, ',linesAfter: 1);



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


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Test Slip',
          style: textBodyLage.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              PosPrint(context, 'XP-N160I', localIp, 1.5 ,1);
            }, child: Text('TEST'))
          ],
        ),
      ),
    );
  }
}
