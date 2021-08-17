import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_rentry_new/widgets/take_picture_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
   CameraController _controller;
   Future<void> _initializeControllerFuture;
   List cameras;
   int selectedCameraIdx;
   String imagePath;
   CameraDescription camera;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      camera = availableCameras.first;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      }else{
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

   // 1, 2
   Future _initCameraController(CameraDescription cameraDescription) async {
     if (_controller != null) {
       await _controller.dispose();
     }
     // 3
     _controller = CameraController(cameraDescription, ResolutionPreset.high);

     // If the controller is updated then update the UI.
     // 4
     _controller.addListener(() {
       // 5
       if (mounted) {
         setState(() {});
       }
       if (_controller.value.hasError) {
         print('Camera error ${_controller.value.errorDescription}');
       }
     });

     // 6
     try {
       await _controller.initialize();
     } on CameraException catch (e) {
       debugPrint("CAMERA_EXCEPTION--> ${e}");
     }

     if (mounted) {
       setState(() {});
     }
   }

   @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          _showCamera(context);
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

   void _showCamera(BuildContext context) async {

     final cameras = await availableCameras();
     final camera = cameras.first;

     final result = await Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) => TakePicturePage(camera: camera)));
    debugPrint("IMG_PATH-->> ${result}");
     setState(() {
       // _path = result;
     });

   }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, @required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}