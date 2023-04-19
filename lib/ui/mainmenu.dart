
import 'package:falconpos/api/apiservice.dart';

import 'package:falconpos/ui/cyclecount.dart';
import 'package:falconpos/ui/item.dart';
import 'package:falconpos/ui/listorder.dart';
import 'package:falconpos/ui/login.dart';
import 'package:falconpos/ui/mainpage.dart';
import 'package:falconpos/ui/received.dart';
import 'package:falconpos/ui/report.dart';
import 'package:falconpos/ui/setting.dart';
import 'package:falconpos/ui/uploadreport.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/menmodel.dart';
import '../theme/textshow.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  List<ListMenuShow> _memu = [];
  final oCcy = NumberFormat("#,###.##", "th_TH");

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _memu.add(ListMenuShow(name: 'POS', icon: Icon(LineIcons.shoppingBag,color: Colors.black,size: 40,), link: MainPage()));
    _memu.add(ListMenuShow(name: 'ListOrder', icon: Icon(LineIcons.list,color: Colors.black,size: 40), link: ListOrder()));
    _memu.add(ListMenuShow(name: 'Daily update', icon: Icon(LineIcons.upload,color: Colors.black,size: 40), link: UPloadReport()));
    _memu.add(ListMenuShow(name: 'Received', icon: Icon(LineIcons.qrcode,color: Colors.black,size: 40), link: received()));
    _memu.add(ListMenuShow(name: 'Check Stock', icon: Icon(LineIcons.tasks,color: Colors.black,size: 40), link: CycelCount()));
    _memu.add(ListMenuShow(name: 'Item', icon: Icon(LineIcons.boxes,color: Colors.black,size: 40), link: ItemList()));
    _memu.add(ListMenuShow(name: 'Report', icon: Icon(LineIcons.barChart,color: Colors.black,size: 40), link: Report()));

    !kIsWeb?_memu.add(ListMenuShow(name: 'Setting', icon: Icon(LineIcons.cogs,color: Colors.black,size: 40), link: Setting())):null;

  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){

            Navigator.of(context).pop();

          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text('Menu',style: textBodyLage,),
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
  Widget L(){
  return Column(
    children: [
      Expanded(child:   Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*.6,
                  width: MediaQuery.of(context).size.width*.8,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: MediaQuery.of(context).size.height*.3),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _memu.length,
                    itemBuilder: (BuildContext context, int i){
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>_memu[i].link));
                        },
                        child: Card(
                          color: Colors.white,
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      radius: MediaQuery.of(context).size.width*.04,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: MediaQuery.of(context).size.width*.039,
                                        backgroundColor: Colors.white,
                                        child: _memu[i].icon,
                                      )
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('${_memu[i].name}',
                                    style: textBodyLage.copyWith(
                                        fontSize: 18,color: Colors.black),
                                  ),
                                ],
                              )
                          ),
                        ),
                      );

                    },
                  ),
                )
              ],
            ),
          ),

        ],
      ),

      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0,bottom: 20,right: 30),
            child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await ApiSerivces().logoout(prefs.getInt('id'), prefs.getString('name')).then((e){
                  prefs.clear();


                });



                await   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));

              },
              child: Column(
                children: [
                  Icon(LineIcons.alternateSignOut,size: 60,),
                  Text("Logout",style: textBodyLage.copyWith(fontSize: 20,color: Colors.black),)
                ],
              ),
            ),
          )
        ],
      )


    ],
  );
  }
  Widget P(){
    return Column(
      children: [
        Expanded(child:   Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*.7,
                    width: MediaQuery.of(context).size.width*.7,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 240),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _memu.length,
                      itemBuilder: (BuildContext context, int i){
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>_memu[i].link));
                          },
                          child: Card(
                            color: Colors.white,
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          radius: MediaQuery.of(context).size.width*.2,
                                          backgroundColor: Colors.white,
                                          child: _memu[i].icon,
                                        )
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('${_memu[i].name}',
                                      style: textBodyLage.copyWith(
                                          fontSize: 14,color: Colors.black),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        );

                      },
                    ),
                  )
                ],
              ),
            ),

          ],
        ),

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0,bottom: 20,right: 30),
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await ApiSerivces().logoout(prefs.getInt('id'), prefs.getString('name')).then((e){
                    prefs.clear();


                  });



                  await   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));

                },
                child: Column(
                  children: [
                    Icon(LineIcons.alternateSignOut,size: 40,),
                    Text("Logout",style: textBodyLage.copyWith(fontSize: 16,color: Colors.black),)
                  ],
                ),
              ),
            )
          ],
        )


      ],
    );
  }
}

