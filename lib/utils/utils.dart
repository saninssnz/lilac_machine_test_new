import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils{
  static Widget backButton({required VoidCallback onTap}){
    return  InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:  BorderRadius.circular(15),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0,top: 8,bottom: 8,left: 12),
            child:Icon(
              Icons.arrow_back_ios,
                color: Colors.black
            ),
            )
          ),
        ),
    );
  }

  static Widget forwardButton({required VoidCallback onTap}){
    return  InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:  BorderRadius.circular(15),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0,top: 8,bottom: 8,left: 5),
            child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black
            ),
            )
          ),
        ),
    );
  }
}