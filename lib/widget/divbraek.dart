import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dash.dart';

Widget divb() {

  return  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height:20,
        width: 10,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
      ),
      Expanded(
        child:  Container(
          alignment: Alignment.center,
          child: const MySeparator(color: Colors.white),
        ),),
      Container(
        height:20,
        width: 10,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
      ),
    ],
  );

}