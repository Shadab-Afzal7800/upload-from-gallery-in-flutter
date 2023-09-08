import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File? _selectedImage;

  Future _uploadImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage!.path,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio7x5
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarColor: Colors.black,
              toolbarTitle: 'Crop',
              initAspectRatio: CropAspectRatioPreset.original,
              hideBottomControls: false,
              lockAspectRatio: false,
              backgroundColor: const Color.fromARGB(255, 65, 63, 63),
              statusBarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.black,
              showCropGrid: false)
        ]);

    if (croppedImage != null) {
      setState(() {
        _selectedImage = File(croppedImage.path);
      });
    }
  }

  final List<String> assetsURL = [
    'assets/frames1.png',
    'assets/frames2.png',
    'assets/frames3.png',
    'assets/frames4.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Image / Icon',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Upload Image',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      _uploadImageFromGallery();
                    },
                    color: const Color.fromARGB(255, 36, 116, 77),
                    child: const Text('Choose from Device'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 450,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!)
                    : const Text('Please select an Image'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
