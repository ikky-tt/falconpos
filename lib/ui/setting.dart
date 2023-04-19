import 'package:falconpos/ui/settingslip.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../model/menmodel.dart';
import '../theme/textshow.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List<ListMenuShow> _memu = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _memu.add(ListMenuShow(name: 'Setting Slip', icon: Icon(LineIcons.receipt,size: 32,color: Colors.black,), link: SettingSlip()));
  }
  
  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
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
          'Setting ',
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
      ),
    );
  }
  Widget P(){
    return  Column(
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
                                        radius: 40 ,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          radius: 40,
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



      ],
    );
  }
  Widget L(){
    return  Column(
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
                                          fontSize: 24,color: Colors.black),
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



      ],
    );
  }
}
