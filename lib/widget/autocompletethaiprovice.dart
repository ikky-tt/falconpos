import 'package:falconpos/theme/textshow.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../api/apiselectprovice.dart';

class AuotProivceShow extends StatefulWidget {


   TextEditingController  pv;
   TextEditingController  dis;
   TextEditingController  amp;
   TextEditingController  zip;


   AuotProivceShow({Key? key,  required this.pv, required this.dis, required this.amp, required this.zip}) : super(key: key);

  @override
  State<AuotProivceShow> createState() => _AuotProivceShowState();
}

class _AuotProivceShowState extends State<AuotProivceShow> {
  TextEditingController _scr = TextEditingController();


  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [ TextSpan(text: source) ];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * .4,
      child: Column(
        children: [
          TextFormField(
            decoration: inputForm1('Search'),
            controller: _scr,
            onChanged: (e){
              setState(() {
                getThaiProvince(e);
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
                future: getThaiProvince(_scr.text),
                builder: (context, shapshot) {
                  print(shapshot.hasError);
                  if(shapshot.hasError){
                    return Row();
                  }
                  if (shapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: shapshot.data?.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: (){
                             setState(() {
                               widget.zip.text = shapshot.data![i].zipcode.toString();
                               widget.amp.text = shapshot.data![i].amphoe;
                               widget.dis.text = shapshot.data![i].district;
                               widget.pv.text = shapshot.data![i].province;


                               Navigator.pop(context);
                               FocusScope.of(context).unfocus();
                             });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(16),
                              child:Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: highlightOccurrences(shapshot.data?[i].district, _scr.text),
                                      style:  textBodyLage.copyWith(color: Colors.grey),),

                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(",",style: textBodyLage.copyWith(color: Colors.grey),),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: highlightOccurrences(shapshot.data?[i].amphoe, _scr.text),
                                      style:  textBodyLage.copyWith(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(",",style: textBodyLage.copyWith(color: Colors.grey),),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: highlightOccurrences(shapshot.data?[i].province, _scr.text),
                                      style:  textBodyLage.copyWith(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(",",style: textBodyLage.copyWith(color: Colors.grey),),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: highlightOccurrences(shapshot.data![i].zipcode.toString(), _scr.text),
                                      style:  textBodyLage.copyWith(color: Colors.grey),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator()
                      ],
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
