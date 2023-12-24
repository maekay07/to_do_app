import 'package:to_do_app/models/enums/CRUD.dart';
import 'package:flutter/material.dart';

class AlertDialogController{
  Future<dynamic> displayAlertDialog(BuildContext context, CRUD crud, String content){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(crud == CRUD.C ? "Fail to add" : "Fail to update"),
          content: Text(content),
          actions:[
            TextButton(
              onPressed:(){
                Navigator.of(context).pop(); //pop: to close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
