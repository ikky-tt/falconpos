import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dash.dart';

Widget divb(context) {

  return  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height:20,
        width: 10,
        decoration:  BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
      ),
      Expanded(
        child:  Container(
          alignment: Alignment.center,
          child:  MySeparator(color: Theme.of(context).colorScheme.background,),
        ),),
      Container(
        height:20,
        width: 10,
        decoration:  BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
      ),
    ],
  );

}