import 'package:flutter/material.dart';

import '../api/apiselectprovice.dart';
import '../theme/textshow.dart';

class AutoShowDistice extends StatefulWidget {

  final TextEditingController   code;
  final TextEditingController   disticcode;
   final TextEditingController controller;

   AutoShowDistice({Key? key,required this.code, required this.controller, required this.disticcode}) : super(key: key);

  @override
  State<AutoShowDistice> createState() => _AutoShowDisticeState();
}

class fianl {
}

class _AutoShowDisticeState extends State<AutoShowDistice> {
  TextEditingController _scr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * .4,
      child: Column(
        children: [
          TextFormField(
            decoration: inputForm1('scr'),
            controller: _scr,
            onChanged: (e){
              setState(() {
                getDataAmp(widget.code.text,e);
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
                future: getDataAmp(widget.code.text,_scr.text),
                builder: (context, shapshot) {
                  if(shapshot.hasError){
                    return Row();
                  }
                  if (shapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: shapshot.data?.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: (){
                              setState(() {
                                final te = shapshot.data?[i].nameTh.toString();
                                final cd = shapshot.data?[i].id.toString();
                                widget.controller.text =  te!;
                                widget.disticcode.text = cd!;


                                Navigator.pop(context);
                                FocusScope.of(context).unfocus();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Text('${shapshot.data?[i].nameTh}',
                                style: textBodyLage.copyWith(color: Colors.black),),
                            ),
                          );
                        });
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator()
                      ],
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
