import 'package:falconpos/api/constant.dart';
import 'package:falconpos/function/function.dart';
import 'package:falconpos/theme/textshow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../model/modeluser.dart';
import 'mainpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscureText = true;

  bool _chkusername = false;

  late FocusNode _focusNode;

  final _text = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _text.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

//This will change the color of the icon based upon the focus on the field
  Color getPrefixIconColor() {
    return _focusNode.hasFocus ? Colors.black : Colors.grey;
  }


  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child:  SingleChildScrollView(
          child: Container(
            margin:  const EdgeInsets.all(20.0),
            child: Center(
              child: Form(
                key: _key,
                child: OrientationBuilder(
                    builder:  (context, orientation){
                      if(orientation == currentOrientation){

                        print(orientation);
                        return portraitMode();
                      }else{
                        return landscapeMode();
                      }
                    },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget portraitMode() {
    return   Card(
      elevation: 10,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(28)),
          color: Theme.of(context).primaryColor,
        ),
        width: MediaQuery.of(context).size.width*.9,
        height: MediaQuery.of(context).size.height*.8,
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(28),topRight: Radius.circular(28)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/images/logow.png',
                          height: MediaQuery.of(context).size.height*.1,

                        ),
                      ),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${version}',style: textBodyMedium.copyWith(fontWeight: FontWeight.w800,),),
                      )
                    ],
                  ),

                )
            ),
            Expanded(
              flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Row(
                            children: [
                              Text('Login Ponit of Sale',style: textBodyLage.copyWith(color: Colors.white,fontSize: 20),),
                            ],
                          )),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('Username',style: textBodyLage.copyWith(color: Colors.white,fontSize: 18),),
                          ),
                        ],
                      ),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(15.0, 3.0, 3.0, 10.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder:  const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'กรุณาใส่ ชื่อผู้ใช้';
                          }
                          return null;
                        },
                        controller: _email,

                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('Password',style: textBodyLage.copyWith(color: Colors.white,fontSize: 18),),
                          ),
                        ],
                      ),
                      TextFormField(
                          autofocus: false,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: '',
                            contentPadding: const EdgeInsets.fromLTRB(15.0, 3.0, 3.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder:  const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(width: 1, color: Colors.white),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: getPrefixIconColor(),
                                semanticLabel:
                                _obscureText ? 'show password' : 'hide password',
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 4) {
                              return 'พลาสเวิร์ด ไม่ตำว่า 4 ตัวอักษร';
                            }
                            return null;
                          },
                          controller: _password,
                          onSaved: (value) {

                          }),
                      const SizedBox(height: 15.0),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0
                                ),

                                onPressed: _sendToServer,

                                child:  Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text('LOGIN',style: textBodyLage.copyWith(fontSize: 21,color: Theme.of(context).primaryColor),),
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  ),


                ))
          ],
        ),




      ),
    );
  }
  Widget landscapeMode() {
    return  Card(
      elevation: 10,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(

        width: MediaQuery.of(context).size.width*.5,
        height: MediaQuery.of(context).size.height*.6,
        child: Row(
          children: [
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(28),bottomLeft:Radius.circular(28)  ),
                    color: Colors.white,
                ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/images/logow.png',
                          height: MediaQuery.of(context).size.height*.1,

                        ),
                      ),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${version}',style: textBodyMedium.copyWith(fontWeight: FontWeight.w800,),),
                      )
                    ],
                  ),

            )
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(28),bottomRight: Radius.circular(28) ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Row(
                            children: [
                              Text('Login Ponit of Sale',style: textBodyLage.copyWith(color: Colors.white,fontSize: 18),),
                            ],
                          )),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('Username',style: textBodyLage.copyWith(color: Colors.white,fontSize: 18),),
                          ),
                        ],
                      ),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(15.0, 3.0, 3.0, 10.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder:  const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'กรุณาใส่ ชื่อผู้ใช้';
                          }
                          return null;
                        },
                        controller: _email,

                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('Password',style: textBodyLage.copyWith(color: Colors.white,fontSize: 18),),
                          ),
                        ],
                      ),
                      TextFormField(
                          autofocus: false,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: '',
                            contentPadding: const EdgeInsets.fromLTRB(15.0, 3.0, 3.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder:  const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(width: 1, color: Colors.white),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: getPrefixIconColor(),
                                semanticLabel:
                                _obscureText ? 'show password' : 'hide password',
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 4) {
                              return 'พลาสเวิร์ด ไม่ตำว่า 4 ตัวอักษร';
                            }
                            return null;
                          },
                          controller: _password,
                          onSaved: (value) {

                          }),
                      const SizedBox(height: 15.0),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0
                                ),

                                onPressed: _sendToServer,

                                child:  Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text('LOGIN',style: textBodyLage.copyWith(fontSize: 21,color: Theme.of(context).primaryColor),),
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),


            ))
          ],
        ),




      ),
    );
  }




  _sendToServer() async {
    FocusScope.of(context).unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isvalid;
    isvalid = _key.currentState?.validate();

    if (isvalid == true) {

      ApiSerivces().LoginApi(_email.text, _password.text).then((res) async {

        if (res.data.length > 0 ) {

          UserModel user =  UserModel.fromJson(res.data[0]);

          await prefs.setString("name", user.empName);
          await prefs.setInt("id", user.empId);
          await prefs.setInt("lv", user.empLv);
          await prefs.setString("dep", user.empDepartment);
          await prefs.setString('wh',user.empwarehouse);
          await prefs.setString('branch', user.branch);
          await prefs.setInt('branchid', user.branchid);
          await prefs.setInt("login", 1);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainPage()));

        } else {

         prefs.clear();
         SnackBar  sk = SnackBar(content: const Text('Username or Password is incorrect.'),
           behavior: SnackBarBehavior.floating,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(15),
           ),
           margin: EdgeInsets.only(
               bottom: MediaQuery.of(context).size.height - 100,
               right: 30,
               left: 30),
         );
         ScaffoldMessenger.of(context).showSnackBar(sk);

        }





      });

      print("Email ${_email.text}");
      print("Password ${_password.text}");
    }
// validation error
  }

// Creates an alertDialog for the user to enter their email
}