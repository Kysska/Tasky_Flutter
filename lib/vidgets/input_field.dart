import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInputField extends StatelessWidget{
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({Key? key, required this.title, required this.hint, this.controller, this.widget}) : super(key: key );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: const EdgeInsets.only(top: 16,),
        child: Column(
            children: [
              Text(
                title,
                style: GoogleFonts.comfortaa(fontSize: 16, fontWeight:FontWeight.bold, color:Colors.black),
              ),
              Container(
                  height: 42,
                  margin: const EdgeInsets.only(top: 8),
                  decoration:  BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1.0
                      ),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              readOnly: widget==null?false:true,
                              autofocus: false,
                              cursorColor: Colors.grey[700],
                              controller: controller,
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              decoration:  InputDecoration(
                                  hintText: hint,
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white10,
                                          width: 0
                                      )
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white10,
                                          width: 0
                                      )
                                  )
                              ),
                            ),
                          )
                      ),
                      widget==null?Container():Container(child:widget)
                    ],
                  )
              )
            ]
        )
    );
  }

}