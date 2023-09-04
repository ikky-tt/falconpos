import 'package:flutter/material.dart';

import '../theme/textshow.dart';
import 'login.dart';

class RecoveryPassword extends StatefulWidget {
  const RecoveryPassword({Key? key}) : super(key: key);

  @override
  State<RecoveryPassword> createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _bus = TextEditingController();
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
          title: Text('Recovery Password',style: textBodyLage,),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 40),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListBody(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: TextFormField(
                      controller: _email,
                      decoration: inputForm1('username or email'),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: ()  async {


                              },
                              child: Text('Recovery Password ',style: textBodyMedium.copyWith(color: Colors.white))
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
