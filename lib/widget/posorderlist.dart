import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/apiservice.dart';
import '../theme/textshow.dart';
import 'barcodescan.dart';
import 'divbraek.dart';

class Possuplist extends StatefulWidget {
  final Function delete;
  final genorer;
  const Possuplist({Key? key, this.genorer, required this.delete}) : super(key: key);

  @override
  State<Possuplist> createState() => _PossuplistState();
}

class _PossuplistState extends State<Possuplist> {
   StreamController _stream3 =  StreamController();
   List _controllerlist2 = [];

   final oCcy = NumberFormat("#,###.##", "th_TH");

  ShowOrder(genorder) async {

    ApiSerivces().ShowChart(genorder).then((res) async {

      _stream3.add(res.data);
      // _stream3.add(res.data);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StreamController _stream3 = new StreamController();
    ShowOrder(widget.genorer);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        divb(),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 2,
          child: StreamBuilder(
            stream: _stream3.stream,
            builder: (context, stream) {
              if (!stream.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                return Center(child: Text(stream.error.toString()));
              }
              var querySnapshot = stream.data;

              return ListView.builder(
                  itemCount: stream.data!.length,
                  itemBuilder: (context, i) {
                    num qtyd = 0;
                    qtyd = querySnapshot[i]['qty'];

                    var id = querySnapshot[i]['id'];
                    _controllerlist2.add(TextEditingController(
                        text: qtyd.toString()));

                    return Container(
                      padding: const EdgeInsets.all(8),
                      height: 75,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text(
                                querySnapshot[i]['name'],
                                style: textLanadscapL.copyWith(
                                    fontSize: 14,color: Colors.black),
                              )),
                          Card(
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              child: Text(
                                  oCcy.format(
                                      querySnapshot[i]['price']),
                                  overflow: TextOverflow.ellipsis,
                                  style: textLanadscapL.copyWith(
                                      fontSize: 14,
                                      color: Colors.black)),
                            ),
                          ),
                          InkWell(
                            onTap: () {

                            },
                            child: Card(
                              child: Container(
                                alignment: Alignment.center,
                                width: 50,
                                padding: EdgeInsets.all(5),
                                child: Text('${qtyd}',
                                    style: textLanadscapL.copyWith(
                                        fontSize: 14,
                                        color: Colors.black)),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: querySnapshot[i]['dicount'] ==
                                  0
                                  ? Container(
                                alignment:
                                Alignment.centerRight,
                                child: Text(
                                    oCcy.format(
                                        querySnapshot[i]
                                        ['price'] *
                                            qtyd),
                                    style: textLanadscapL
                                        .copyWith(
                                        fontSize: 18,color: Colors.black)),
                              )
                                  : Container(
                                alignment:
                                Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        oCcy.format(
                                            querySnapshot[i]
                                            ['totprice']),
                                        style: textLanadscapL
                                            .copyWith(
                                            fontSize:
                                            22,color: Colors.black)),
                                    Text(
                                        oCcy.format(
                                            querySnapshot[i][
                                            'price'] *
                                                qtyd),
                                        style: textLanadscapL
                                            .copyWith(
                                            fontSize: 14,
                                            color: Colors
                                                .red,
                                            decoration:
                                            TextDecoration
                                                .lineThrough)),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            child: Icon(Icons.remove_circle),
                            onTap: () {
                              ApiSerivces()
                                  .DeleteItem(id)
                                  .then((e) {
                                ShowOrder(widget.genorer);
                                 widget.delete;
                              });


                            },
                          )
                        ],
                      ),
                    );
                  });
            },
          ),
        ),
        divb(),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: Card(

              )),
              ElevatedButton(onPressed: (){}, child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Submit',style: textBodyLage.copyWith(fontSize: 18),),
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),

      ],
    );
  }




}
