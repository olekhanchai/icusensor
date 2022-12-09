// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import '../../../constants.dart';

// class CameraView extends StatefulWidget {
//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView> {
//   List<CameraDescription>? cameras; //list out the camera available
//   CameraController? controller; //controller for camera
//   XFile? image; //for caputred image

//   final isSelected = <bool>[false, false, true];

//   @override
//   void initState() {
//     loadCamera();
//     super.initState();
//   }

//   void loadCamera() async {
//     try {
//       cameras = await availableCameras();
//     } catch (err) {
//       print('Caught error: $err');
//     }
//     if (cameras != null) {
//       controller = CameraController(cameras![0], ResolutionPreset.max);
//       //cameras[0] = first camera, change to 1 to another camera

//       controller!.initialize().then((_) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {});
//       });
//     } else {
//       print("NO any camera found");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //body:
//     return Container(
//         padding: const EdgeInsets.all(defaultPadding),
//         decoration: const BoxDecoration(
//           color: secondaryColor,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         child: Column(children: [
//           SizedBox(
//               height: 180,
//               width: 400,
//               child: controller == null
//                   ? const Center(child: Text("Loading Camera..."))
//                   : !controller!.value.isInitialized
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : CameraPreview(controller!)),
//           Container(
//               padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//               child: ToggleButtons(
//                 color: Colors.black, //.withOpacity(0.60),
//                 selectedColor: const Color(0xFF6200EE),
//                 selectedBorderColor: const Color(0xFF6200EE),
//                 fillColor: const Color(0xFF6200EE).withOpacity(0.08),
//                 splashColor: const Color(0xFF6200EE).withOpacity(0.12),
//                 hoverColor: const Color(0xFF6200EE).withOpacity(0.04),
//                 borderRadius: BorderRadius.circular(4.0),
//                 constraints: const BoxConstraints(minHeight: 25.0),
//                 isSelected: isSelected,
//                 onPressed: (index) {
//                   // Respond to button selection
//                   setState(() {
//                     for (int i = 0; i < 3; i++) {
//                       isSelected[i] = (i == index);
//                     }
//                   });
//                 },
//                 children: const [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Text('THERMAL'),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Text('IPCAM'),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Text('FRONT'),
//                   ),
//                 ],
//               ))
//           // Container(
//           //   //show captured image
//           //   padding: EdgeInsets.all(20),
//           //   child: image == null
//           //       ? Text("No image captured")
//           //       : Image.file(
//           //           File(image!.path),
//           //           height: 200,
//           //         ),
//           //   //display captured image
//           // )
//         ]));
//     // floatingActionButton: FloatingActionButton(
//     //   onPressed: () async {
//     //     try {
//     //       if (controller != null) {
//     //         //check if contrller is not null
//     //         if (controller!.value.isInitialized) {
//     //           //check if controller is initialized
//     //           image = await controller!.takePicture(); //capture image
//     //           setState(() {
//     //             //update UI
//     //           });
//     //         }
//     //       }
//     //     } catch (e) {
//     //       print(e); //show error
//     //     }
//     //   },
//     //   child: Icon(Icons.camera),
//     // ),
//     // );
//   }
// }
