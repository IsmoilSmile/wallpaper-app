import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imaUrl;

  ImageView({@required this.imaUrl});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imaUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imaUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              GestureDetector(
                onTap: (){
                  _save();
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff1C1B1B).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width/2,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15,right: 15,top: 6,bottom: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70,width: 2),
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ]
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text("Set Wallpaper",style: TextStyle(fontSize: 16,color: Colors.grey.shade300),),
                          Text("Image will be saved in gallery",style: TextStyle(color: Colors.grey.shade300,fontSize: 13),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: Text("Cancel", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _save() async {
    if(Platform.isAndroid){
      await _askPermission();
    }
    var response = await Dio().get(
    widget.imaUrl,
        options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */await PermissionHandler()
          .requestPermissions([PermissionGroup.photos]);
    } else {
      /* PermissionStatus permission = */await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}
