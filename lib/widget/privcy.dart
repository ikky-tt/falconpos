import 'package:falconpos/theme/textshow.dart';
import 'package:falconpos/ui/regsiter.dart';
import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {

  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {

  ScrollController _scrollController = ScrollController();
  Future<void> scrollLister() async {

     if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){

      setState(() {
        _chk = true;
      });

     }


  }
  bool _chk = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(scrollLister);

  }
  @override
  Widget build(BuildContext context) {
    return
    AlertDialog(
      title: const Text('Privacy'),
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: ListBody(
            children: [
              Text('We use your Personal Information for providing and improving the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, accessible at https://falconcirrus.com',style: textBodyMedium,),
              SizedBox(
                height: 5,
              ),
              Text('Information Collection And Use',style: textBodyMedium.copyWith(fontSize: 16,fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text('While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information (“Personal Information”) may include, but is not limited to:',style: textBodyMedium),
              Text('- Name',style: textBodyMedium),
              Text('- Eamil Address',style: textBodyMedium),
              Text('- Tel',style: textBodyMedium),
              Text('- Bussiness Name',style: textBodyMedium),
              Text('* We are using a camera to enable you to upload pictures of application documents',style: textBodyMedium),
              Text('* We are using your photo library to enable you to download and save pictures of application documents',style: textBodyMedium),
              SizedBox(
                height: 5,
              ),
              Text('Service Providers',style: textBodyMedium.copyWith(fontSize: 16,fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text('We may employ third party companies and individuals to facilitate our Service, to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used.',style: textBodyMedium),
              Text('These third parties have access to your Personal Information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.',style: textBodyMedium),
              SizedBox(
                height: 5,
              ),
              Text('Security',style: textBodyMedium.copyWith(fontSize: 16,fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text('The security of your Personal Information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.',style: textBodyMedium),
              SizedBox(
                height: 5,
              ),
              Text('Links To Other Sites',style: textBodyMedium.copyWith(fontSize: 16,fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text('Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party’s site. We strongly advise you to review the Privacy Policy of every site you visit.',style: textBodyMedium),
              Text('We have no control over, and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',style: textBodyMedium),
              SizedBox(
                height: 5,
              ),
              Text('Changes To This Privacy Policy',style: textBodyMedium.copyWith(fontSize: 16,fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text('We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',style: textBodyMedium),
              Text('You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',style: textBodyMedium),

            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child:  Text('I Agree',style: _chk?textBodyMedium:textBodyMedium.copyWith(color: Colors.grey),),
          onPressed: () {
            _chk?Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser())):null;
          },
        ),
        TextButton(
          child:  Text('Cancel',style: textBodyMedium,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
