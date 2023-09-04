import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'mainmenu.dart';

class DashBorad extends StatefulWidget {
  const DashBorad({Key? key}) : super(key: key);

  @override
  State<DashBorad> createState() => _DashBoradState();
}

class _DashBoradState extends State<DashBorad> {





  @override
  Widget build(BuildContext context) {
     Orientation currentOrientation = MediaQuery
        .of(context)
        .orientation;
    return  OrientationBuilder(
      builder: (context, orientation) {
        if (Orientation.portrait  == currentOrientation) {
          print(orientation);
          return   DashboadP();
        } else {

          if(MediaQuery.of(context).size.width>1000){
            return DashboadL();

          } else {
            return DashboadP();

          }


        }
      },
    );
  }
}

class DashboadP extends StatefulWidget {
  const DashboadP({Key? key}) : super(key: key);

  @override
  State<DashboadP> createState() => _DashboadPState();
}

class _DashboadPState extends State<DashboadP> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DashboadL extends StatefulWidget {
  const DashboadL({Key? key}) : super(key: key);

  @override
  State<DashboadL> createState() => _DashboadLState();
}

class _DashboadLState extends State<DashboadL> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dash Board',style: Theme.of(context).textTheme.headlineLarge,),
              Container(
                child: IconButton(

                  icon:  Icon(
                    Icons.list,

                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainMenu()));
                  },
                ),
              ),

            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('Sale Report',style: Theme.of(context).textTheme.headlineMedium),
              Expanded(
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                       alignment: Alignment.center,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide()
                          )
                        ),
                        child: Text('RealTime',style: Theme.of(context).textTheme.headlineMedium)
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide()
                              )
                          ),
                          child: Text('Week',style: Theme.of(context).textTheme.headlineMedium)
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide()
                              )
                          ),
                          child: Text('Mounth',style: Theme.of(context).textTheme.headlineMedium)
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide()
                              )
                          ),
                          child: Text('Year',style: Theme.of(context).textTheme.headlineMedium)
                      )

                    ],

              ))
            ],

          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width/5.5,
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Retail',style: Theme.of(context).textTheme.headlineLarge,)
                          ],
                        )),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('10,000',style: Theme.of(context).textTheme.headlineLarge,)
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width/5.5,
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Discount',style: Theme.of(context).textTheme.headlineLarge,)
                              ],
                            )),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('10,000',style: Theme.of(context).textTheme.headlineLarge,)
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width/5.5,
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('GP/Grossprofit',style: Theme.of(context).textTheme.headlineLarge,)
                              ],
                            )),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('10,000',style: Theme.of(context).textTheme.headlineLarge,)
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width/5.5,
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Tax',style: Theme.of(context).textTheme.headlineLarge,)
                              ],
                            )),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('10,000',style: Theme.of(context).textTheme.headlineLarge,)
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width/5.5,
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Total',style: Theme.of(context).textTheme.headlineLarge,)
                              ],
                            )),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('10,000',style: Theme.of(context).textTheme.headlineLarge,)
                          ],
                        ))
                      ],
                    ),
                  ),
                ),




              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('Channels',style: Theme.of(context).textTheme.headlineMedium),

            ],

          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context,i){
                return   Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          child: Container(
                            height: 60,
                            width: 60,
                            child: Icon(LineIcons.warehouse),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 60,
                          width: MediaQuery.of(context).size.width*230/MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,

                          child: Text('OwnShop',style: Theme.of(context).textTheme.titleLarge,),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 60,
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width*200/MediaQuery.of(context).size.width,
                            child: Text('s'),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 60,
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width*200/MediaQuery.of(context).size.width,
                            child: Text('s'),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 60,
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width*200/MediaQuery.of(context).size.width,
                            child: Text('s'),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 60,
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width*200/MediaQuery.of(context).size.width,
                            child: Text('s'),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 60,
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width*200/MediaQuery.of(context).size.width,
                            child: Text('s'),
                          ),
                        ),

                      ],
                    )
                  ],

                );
              })


        ],
      ),
    );
  }
}
