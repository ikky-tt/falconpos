
import 'package:falconpos/theme/textshow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/apiservice.dart';

class BarcodeScan extends StatefulWidget {
  TextEditingController barCodecontroller;

  final brachid;
  final genorder;
  final wh;
  Future countorder;
  Function submit;

   BarcodeScan({Key? key , required this.barCodecontroller,this.brachid, this.genorder ,required this.countorder, this.wh,required this.submit}) : super(key: key);

  @override
  State<BarcodeScan> createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  late FocusNode focusBarCode;

  @override
  void initState() {
    super.initState();
    focusBarCode = FocusNode();
    Future.delayed(
      Duration(),
          () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );

  }

  @override



  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            enabled: true,
            decoration: inputForm1('Barcode'),
            autofocus: true,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            focusNode: focusBarCode,
            onFieldSubmitted:  (e) async {
              print(widget.barCodecontroller.text);

              var s = e.split('-');

              print(s[1]);


              await   ApiSerivces().GetProductid(int.parse(s[1]),widget.brachid).then((ee) async {
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
                      widget.wh,
                    ee.data[0]['promotionname'],
                    ee.data[0]['promotionid'],
                    widget.brachid
                  )
                      .then((v) {
                    widget.barCodecontroller.text = '';
                    print('ssd');
                    setState(() {
                      print('ss');
                      widget.countorder;
                    });
                    focusBarCode.requestFocus();
                    widget.submit();

                    ApiSerivces().updateaddserail(widget.genorder, e).then((e) {

                    });
                  }
                  );



                } else {
                  widget.barCodecontroller.text = '';

                  focusBarCode.requestFocus();
                }




              });


            },
            controller: widget.barCodecontroller,
          ),
          SizedBox(
            height: 20,
          ),
          MediaQuery.of(context).size.width < 800?
          ElevatedButton(
              onPressed:  () async {
                print(widget.barCodecontroller.text);

                var s = widget.barCodecontroller.text.split('-');

                print(s[1]);


                await   ApiSerivces().GetProductid(int.parse(s[1]),widget.brachid).then((ee) async {
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
                        widget.wh,
                      ee.data[0]['promotionname'],
                      ee.data[0]['promotionid'],
                      widget.brachid
                    )
                        .then((v) async {

                      print('ssd');
                      print(widget.genorder);
                      print(widget.barCodecontroller.text);

                      focusBarCode.requestFocus();
                      widget.submit();

                   await   ApiSerivces().updateaddserail(widget.genorder, widget.barCodecontroller.text).then((e) {
                     widget.barCodecontroller.text = '';
                      });
                    }
                    );



                  } else {
                    widget.barCodecontroller.text = '';

                    focusBarCode.requestFocus();
                  }




                });

                Navigator.of(context).pop();
              }, child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('OK',style: textBodyLage.copyWith(fontSize: 18),),
              )):Row()
        ],
      ),
    );
  }
}
