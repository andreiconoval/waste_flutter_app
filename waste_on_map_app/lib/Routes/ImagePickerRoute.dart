import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:waste_on_map_app/Widgets/TakePictureWidget.dart';

class ImagePickerRoute extends StatelessWidget {
  Future<CameraDescription> getFirstCamera() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    Future<CameraDescription> currentCamera = getFirstCamera();
    return Scaffold(
        appBar: AppBar(
          title: Text("Image"),
        ),
        body: Center(
          child: FutureBuilder<CameraDescription>(
            future: currentCamera,
            builder: (BuildContext context,
                AsyncSnapshot<CameraDescription> snapshot) {
              if (snapshot.hasData) {
                // while data is loading:
                return TakePictureScreen(camera: snapshot.data);
              } else {
                // data loaded:
                return Center(
                  child: Text('mapEror'),
                );
              }
            },
          ),
        ));
  }
}
