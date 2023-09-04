import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../theme/textshow.dart';

Future ConfirmAlert(Function onSubmit ,BuildContext context ,String  text ){

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
                      Icon(LineIcons.exclamationTriangle,size: 124,color: Colors.redAccent,),
                      Text(text,style: textBodyMedium.copyWith(fontSize: 16,color: Colors.black),)
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
                        onPressed: () {
                          onSubmit();
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

Future AlertShow(BuildContext context ,String  text ){

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
                      Icon(LineIcons.exclamationTriangle,size: 124,color: Colors.redAccent,),
                      Text(text,style: textBodyMedium.copyWith(fontSize: 16,color: Colors.black),)
                    ],
                  ),
                )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Text('OK',style: textBodyLage.copyWith(fontSize: 18)),
                        )),


                  ],
                ),
              ],
            ),
          )

      )
  );
}
Future AlertShowSucces(BuildContext context ,String  text ){

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
                      Icon(LineIcons.checkCircle,size: 124,color: Colors.green,),
                      Text(text,style: textBodyMedium.copyWith(fontSize: 16,color: Colors.black),)
                    ],
                  ),
                )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Text('OK',style: textBodyLage.copyWith(fontSize: 18)),
                        )),


                  ],
                ),
              ],
            ),
          )

      )
  );
}
