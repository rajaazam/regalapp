import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:relgal/widget/flutter_toast.dart';
import 'package:relgal/widget/round_button.dart';

import 'homescree.dart';

class CarDataScreen extends StatefulWidget {
  @override
  _CarDataScreenState createState() => _CarDataScreenState();
}

class _CarDataScreenState extends State<CarDataScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _image;
  String? _imageUrl;
  String? _carName;
  String? _model;
  String? _color;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile.path;
        });
        String imageUrl = await _uploadImage(File(pickedFile.path));
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('images').child(fileName);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      // Handle error
      return '';
    }
  }

  final fireStore = FirebaseFirestore.instance.collection('cars');
  Future<void> _submitData() async {
    if (_carName != null &&
        _model != null &&
        _color != null &&
        _imageUrl != null) {
      setState(() {
        _isLoading = true;
      });

      // Assuming user is logged in and their UID can be retrieved
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      await fireStore.doc(id).set({
        'carId': id,
        'userId': userId,
        'carName': _carName,
        'model': _model,
        'carcolor': _color,
        'imageUrl': _imageUrl,
        'createdAt': Timestamp.now(),
      });
      // await FirebaseFirestore.instance.collection('cars').add({
      //   'carId': id,
      //   'userId': userId,
      //   'carName': _carName,
      //   'model': _model,
      //   'color': _color,
      //   'imageUrl': _imageUrl,
      //   'createdAt': Timestamp.now(),
      // });

      setState(() {
        _isLoading = false;
        Utils().toastMessage('Successful add car');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeDriver()));
      });

      // Clear the form or navigate away
    }

    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child:  Text(
              'Add Car Data',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Car Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _carName = value,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _model = value,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Color',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _color = value,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(15), // Set the border radius
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(
                              File(_image!)), // Load the image from the file
                          fit: BoxFit
                              .cover, // Ensure the image covers the container
                        )
                      : null, // No image if _image is null
                ),
                height: 200,
                width: 300,
                child: _image == null // Show text if there's no image
                    ? const Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      )
                    : null,
              ),
              const SizedBox(
                height: 30,
              ),
              // _image != null
              //     ? Image.file(File(_image!))
              //     : const Text('No image selected'),

              ElevatedButton(
                onPressed: () => _showImagePickerOptions(),
                child: const Text('Choose Image'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : RoundButton(
                      title: 'Submit',
                      onTap: _submitData,
                    )
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }
}
