import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../api/constant.dart';
import '../theme/textshow.dart';
import 'mainmenu.dart';

class CycelCount extends StatefulWidget {
  const CycelCount({Key? key}) : super(key: key);

  @override
  State<CycelCount> createState() => _CycelCountState();
}

class _CycelCountState extends State<CycelCount> {
  final StreamController _streamController = StreamController();
  final StreamController _streamController2 = StreamController();
  final StreamController _stream = StreamController();
  final TextEditingController _scr = TextEditingController();
  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _brachid = 0;

  GetLogin()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;
      print(_wh);
    });
  }
  List<Iterable> addItem = [];

  LoadProudct(scr, set) async {
    ApiSerivces().GetProductPos(scr, 0).then((res) async {
      _streamController.add(res.data);

    //  print(res.data);
    });
  }

  Future<List<ListStockbranch>> chkecyelcount(proid) async {
    List<ListStockbranch> _liststockbrach = [];
    var res =  await ApiSerivces().ChekCycelcount(proid,DateFormat('yyyy-MM-dd').format(DateTime.now()),_brachid,_wh);

    res.data.forEach((e) {

     // print(e['sku']);

      _liststockbrach.add(ListStockbranch(wh: e['wh'], qty: e['qty'],whname: e['sku']));

    });


    return _liststockbrach;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetLogin();
   LoadProudct('', 'set');
  }
  bool _folded  = true;
  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainMenu()));
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text('Check Stock',style: textBodyLage,),
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

  Widget P() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: TextFormField(
                    controller: _scr,
                    decoration: inputForm1('search'),
                    onChanged: (v){
                      LoadProudct(v, 'set');
                    },
                  )
              ),

            ],
          ),
        ),
        Expanded(child: StreamBuilder(
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if(snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context,i)  {
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: (){
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black12,
                              style: BorderStyle.solid,
                              width: 1.0,

                            ),

                            color: Colors.white,

                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              snapshot.data[i]['path']!=null?ClipRRect(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: urlpic+ snapshot.data[i]['path'],
                                  placeholder: (context, url) => Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      )),
                                  errorWidget: (context, url, error) => Icon(LineIcons.imageAlt),
                                  fit: BoxFit.cover,
                                  width: 60,

                                ),

                              ):Row(),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex:2,

                                        child: Text('${snapshot.data[i]['name']}',style: textBodyLage.copyWith(fontSize: 12,color: Colors.black),)),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    Expanded(child: TextFormField(
                                      decoration: inputForm1('QTY'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (e){
                                        print(e);
                                        ApiSerivces().CycelCountapi(snapshot.data[i]['id'], num.parse(e), _wh, _brachid, _brach,DateFormat('yyyy-MM-dd H:mm').format(DateTime.now()),_empname ).then((value) => print(value));

                                      },
                                    )),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    Container(
                                        width: 80,
                                        height: 40,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 10),

                                        child:   FutureBuilder(
                                            future: chkecyelcount(snapshot.data[i]['id']),
                                            builder: (context,snapshot){

                                              if(snapshot.data == null) {

                                                return Text('');

                                              }
                                              return ListView.builder(
                                                  itemCount: snapshot.data!.length,
                                                  itemBuilder:(context,i){
                                                    return Container(
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(LineIcons.checkCircle,size: 32,),
                                                          Text(' qty : ${snapshot.data![i].qty}',style:  textBodyLage.copyWith(fontSize: 12,color: Colors.black)),
                                                        ],
                                                      ),
                                                    );
                                                  } );


                                            })
                                    )

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  );
                } ,
              );
            }
            return const Text("NO DATA");
          },

        ),)
      ],
    );
  }
  Widget L() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _folded?56:MediaQuery.of(context).size.width*.4,
                height: 56,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Theme.of(context).primaryColor,
                    boxShadow: kElevationToShadow[0]
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30,7,10,7),
                          child: !_folded?TextFormField(
                            controller: _scr,
                            decoration: InputDecoration(
                                hintText: 'search...'
                            ),
                            onChanged: (v){
                              LoadProudct(v, 'set');
                            },
                          ):null,
                        )),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_folded?32:0),
                              topRight: Radius.circular(32),
                              bottomLeft: Radius.circular(_folded?32:0),
                              bottomRight: Radius.circular(32)


                          ),
                          child:  Padding(
                            padding: EdgeInsets.all(16.0),
                            child: _folded ?Icon(Icons.search,color: Colors.white,):Icon(Icons.close),
                          ),
                          onTap: (){
                            setState(() {
                              _folded = !_folded;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
        Expanded(child: StreamBuilder(
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if(snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context,i)  {
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: (){
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black12,
                              style: BorderStyle.solid,
                              width: 1.0,

                            ),

                            color: Colors.white,

                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              snapshot.data[i]['path']!=null?ClipRRect(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: urlpic+ snapshot.data[i]['path'],
                                  placeholder: (context, url) => Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      )),
                                  errorWidget: (context, url, error) => Icon(LineIcons.imageAlt),
                                  fit: BoxFit.cover,
                                  width: 150,

                                ),

                              ):Row(),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex:2,

                                        child: Text('${snapshot.data[i]['name']}',style: textBodyLage.copyWith(fontSize: 18,color: Colors.black),)),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    Expanded(child: TextFormField(
                                      decoration: inputForm1('QTY'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (e){

                                        ApiSerivces().CycelCountapi(snapshot.data[i]['id'], num.parse(e), _wh, _brachid, _brach,DateFormat('yyyy-MM-dd H:mm').format(DateTime.now()),_empname ).then((value) => print(value));

                                      },
                                    )),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    Container(
                                        width: 200,
                                        height: 60,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 10),

                                        child:   FutureBuilder(
                                            future: chkecyelcount(snapshot.data[i]['id']),
                                            builder: (context,snapshot){

                                              if(snapshot.data == null) {

                                                return Text('');

                                              }
                                              return ListView.builder(
                                                  itemCount: snapshot.data!.length,
                                                  itemBuilder:(context,i){
                                                    return Container(
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(LineIcons.checkCircle,size: 32,),
                                                          Text(' qty : ${snapshot.data![i].qty}',style:  textBodyLage.copyWith(fontSize: 18,color: Colors.black)),
                                                        ],
                                                      ),
                                                    );
                                                  } );


                                            })
                                    )

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  );
                } ,
              );
            }
            return const Text("NO DATA");
          },

        ),)
      ],
    );
  }
}

class ListStockbranch {
  String wh;
  String whname;
  num qty;
  ListStockbranch({required this.wh,required this.qty ,required this.whname});

}