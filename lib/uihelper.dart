import 'package:flutter/material.dart';

class uihelper{
  static customalertbox(BuildContext context,String message){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(onPressed:(){
            Navigator.pop(context);
          }, child:Text('ok',style: TextStyle(fontSize: 15),))
        ],
      );
    });
  }
}