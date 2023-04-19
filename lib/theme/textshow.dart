
import 'package:flutter/material.dart';

import '../function/function.dart';
TextStyle headingStyle =  const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'sarabun'

);

TextStyle textBody =  const TextStyle(
    fontSize: 12                            ,
    fontFamily: 'sarabun'


);
TextStyle textBodyLage =  const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: 'sarabun',
    color: Colors.white

);

TextStyle textBodyMedium =  const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'sarabun',
  color: Colors.black



);

TextStyle textBodySmall =  const TextStyle(
    fontSize: 8,
    fontFamily: 'sarabun'

);
TextStyle textLanadscapL =  const TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontFamily: 'sarabun'

);


InputDecoration inputForm1(String lable) {
  return InputDecoration(

    enabledBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide:  BorderSide(color: HexColor('3ea3d4'), width: 1.0),
    ),
    labelStyle: textBody.copyWith(fontSize: 14,color: HexColor('3ea3d4')),
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    focusedBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(width: 1, color: HexColor('3ea3d4'),),
    ),
      labelText: lable,


  );
}
InputDecoration inputForm2(String lable) {
  return InputDecoration(

    enabledBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide:  BorderSide(color: HexColor('1d4f90'), width: 1.0),
    ),
    labelStyle: textBody.copyWith(fontSize: 14,color: HexColor('1d4f90')),
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

    focusedBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(width: 1, color: HexColor('1d4f90'),),
    ),
    labelText: lable,


  );
}

InputDecoration inputForm3(String lable) {
  return InputDecoration(

    enabledBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide:  BorderSide(color: HexColor('1d4f90'), width: 1.0),
    ),
    labelStyle: textBody.copyWith(fontSize: 14,color: HexColor('1d4f90')),
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),


    focusedBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(width: 1, color: HexColor('1d4f90'),),
    ),
    labelText: lable,
    contentPadding: EdgeInsets.only(left: 10.0, top: 2.0, bottom: 2.0),


  );
}