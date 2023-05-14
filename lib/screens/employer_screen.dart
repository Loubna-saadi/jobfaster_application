// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'storage_service.dart';
// import 'firestore_service.dart';

// class UploadPage extends StatefulWidget {
//   // static const String screenRoute = 'employer_screen';
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }

// class _UploadPageState extends State<UploadPage> {
//   File _image;
//   File _cv;
//   final StorageService _storageService = StorageService();
//   final FirestoreService _firestoreService = FirestoreService();

//   Future<void> _pickImage(ImageSource source) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile imageFile = await _picker.pickImage(source: source);

//     if (imageFile != null) {
//       setState(() {
//         _image = File(imageFile.path);
//       });
//     }
//   }

//   Future<void> _pickCV() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile cvFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (cvFile != null) {
//       setState(() {
//         _cv = File(cvFile.path);
//       });
//     }
//   }

//   Future<void> _uploadData() async {
//     if (_image != null && _cv != null) {
//       final String imageName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
//       final String cvName = '${DateTime.now().microsecondsSinceEpoch}.pdf';

//       final String imageFolderPath = 'images';
//       final String cvFolderPath = 'cv';

//       final String imagePath = '$imageFolderPath/$imageName';
//       final String cvPath = '$cvFolderPath/$cvName';

//       final String imageUrl = await _storageService.uploadFile(_image, imageFolderPath, imageName);
//       final String cvUrl = await _storageService.uploadFile(_cv, cvFolderPath, cvName);

//       if (imageUrl != null && cvUrl != null) {
//         _firestoreService.uploadUserData('John Doe', imageUrl, cvUrl);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Data uploaded successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error uploading data')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select an image and CV')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Page'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: _image == null ? Text('No image selected') : Image.file(_image),
//           ),
//           ElevatedButton(
//             onPressed: () => _pickImage(ImageSource.gallery),
//             child: Text('Select Image'),
//           ),
//           Center(
//             child: _cv == null ? Text('No CV selected') : Text(path.basename(_cv.path)),
//           ),
//           ElevatedButton(
//             onPressed: _pickCV,
//             child: Text('Select CV'),
//           ),
//           ElevatedButton(
//             onPressed: _uploadData,
//             child: Text('Upload Data'),
//           ),
//         ],
//       ),
//     );
//   }
// }
