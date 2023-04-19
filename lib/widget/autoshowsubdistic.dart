import 'package:falconpos/api/apiselectprovice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/textshow.dart';

class AutoShowSubdistic extends StatefulWidget {
  final TextEditingController   pvcode;
  final TextEditingController  dicticcode;
  final TextEditingController controller;
  final TextEditingController zipcode;
   AutoShowSubdistic( {Key? key, required this.pvcode, required this.dicticcode, required this.zipcode ,required this.controller, }) : super(key: key);

  @override
  State<AutoShowSubdistic> createState() => _AutoShowSubdisticState();
}

class _AutoShowSubdisticState extends State<AutoShowSubdistic> {
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
                getDataDistir(widget.dicticcode,e);
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
                future: getDataDistir(widget.dicticcode.text,_scr.text),
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
                                final zi = shapshot.data?[i].zip_code.toString();
                                widget.controller.text =  te!;
                                widget.zipcode.text = zi!;

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
