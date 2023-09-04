import 'package:falconpos/api/apiservice.dart';
import 'package:falconpos/ui/login.dart';
import 'package:flutter/material.dart';

import '../theme/textshow.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
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
          title: Text('Register',style: textBodyLage,),
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
                      controller: _name,
                      decoration: inputForm1('Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: TextFormField(
                      controller: _email,
                      decoration: inputForm1('Email'),
                    ),
                  )
                  ,Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: TextFormField(
                      controller: _tel,
                      decoration: inputForm1('Tel'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: TextFormField(
                      controller: _bus,
                      decoration: inputForm1('Bussiness Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Text('** ลงทะเบียนสำเร็จ จะมีอีเมล์ตอบกลับไป ยืนยัน การสมัคร',style: textBodyMedium.copyWith(color: Colors.red),)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: ()  async {

                            await  ApiSerivces().Register(_name.text, _tel.text, _email.text, _bus.text).then((e)  {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                            });

                              },
                            child: Text('Register',style: textBodyMedium.copyWith(color: Colors.white))
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
