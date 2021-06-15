import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraDescription camera;
  CameraController controller;
  bool _isInited = false;
  String _url;

  var image;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cameras = await availableCameras();
      print(cameras);
      // setState(() {});
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize().then((value) => {
            setState(() {
              _isInited = true;
            })
          });
    });
  }

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // child: _isInited ? CameraPreview(controller) : Container()
        child: Column(
          children: [
            Expanded(
              child: _isInited
                  ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    )
                  : Container(),
            ),
            Container(
              height: 152,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    child: _url != null
                        ? Image.file(
                            File(_url),
                            height: 120,
                            width: 120,
                          )
                        : Container(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          image = await controller.takePicture();
          setState(() {
            _url = image.path;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
