import 'package:falconpos/widget/alert.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../theme/textshow.dart';
import 'login.dart';

class Usersetting extends StatefulWidget {
  const Usersetting({Key? key}) : super(key: key);

  @override
  State<Usersetting> createState() => _UsersettingState();
}

class _UsersettingState extends State<Usersetting> {
  TextEditingController _name  = TextEditingController();
  TextEditingController _tel  = TextEditingController();
  String _empname = '';
  String _wh = '';
  String _brach = '';
  int _brachid = 0;

  int _id = 0;

  GetLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      _empname = prefs.getString('name')!;
      _brach = prefs.getString('branch')!;
      _brachid = prefs.getInt('branchid')!;
      _wh = prefs.getString('wh')!;
      _id = prefs.getInt('id')!;

      if (prefs.getInt('login') != 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }else {
        await ApiSerivces().chklogin(prefs.getInt('id')).then((e) async {

          if(e.data.length == 0 || e.data[0]['emp_status'] == 2){

            prefs.clear();
            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));

          } else {


            setState(() {
              _name.text = e.data[0]['emp_name'];
              _tel.text = e.data[0]['emp_tel'];
            });

          }


        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetLogin();
  }


  @override
  Widget build(BuildContext context) {
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
          'Setting User',
          style: textBodyLage.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: MediaQuery.of(context).size.width>800?EdgeInsets.only(right: (400 / 1024) * MediaQuery.of(context).size.height,bottom: 20,left: (400 / 1024) * MediaQuery.of(context).size.height,top: 50):EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListBody(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: inputForm1('Name'),
                  controller: _name,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: inputForm1('Tel'),
                  controller: _tel,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                    await  ApiSerivces().UserUpdate(_id, _name.text, _tel.text, '1').then((value) => AlertShowSucces(context, 'SUECSS'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LineIcons.saveAlt,color: Colors.white,),
                          Text(' SAVE',style: textBodyMedium.copyWith(color: Colors.white),)
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                    onPressed: () async {
                      await  ApiSerivces().UserUpdate(_id, _name.text, _tel.text, '2').then((value) {
                        ConfirmAlert(()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage())), context, 'Do you want to delete account?');
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LineIcons.timesCircleAlt,color: Colors.white,),
                          Text(' DEL USER',style: textBodyMedium.copyWith(color: Colors.white),)
                        ],
                      ),
                    ))

              ],
            )
          ],
        ),
      ),
    );
  }
}
