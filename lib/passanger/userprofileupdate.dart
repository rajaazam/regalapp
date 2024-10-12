import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:relgal/home.dart';
import 'package:relgal/model/DriverProfile.dart';
import 'package:relgal/model/passangerProfile.dart';

import '../services/session_manager.dart';
import '../widget/flutter_toast.dart';
import '../widget/get_text_filed.dart';
import '../widget/round_button.dart';
import 'home.dart';

class UserProfileUpdate extends StatefulWidget {
  UserProfileUpdate({
    required this.sessionController,
  });

  final SessionController sessionController;

  @override
  State<UserProfileUpdate> createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate> {
  final TextEditingController NameController = TextEditingController();

  final TextEditingController _phonenumberController = TextEditingController();

  final TextEditingController _dateOfBirthController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _driverCNCController = TextEditingController();
  final TextEditingController _driverLicenceController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  String? _image;
  String? _imageUrl;

  bool _isLoading = false;
  bool _isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    NameController.text = widget.sessionController.userName ?? '';
    _phonenumberController.text = widget.sessionController.phoneNumber ?? '';
    _emailController.text = widget.sessionController.userEmail ?? '';
    _driverCNCController.text = widget.sessionController.driverCNIC ?? '';
    _driverLicenceController.text =
        widget.sessionController.driverLicense ?? '';
    _imageUrl = widget.sessionController.image;
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_imageUrl != null) {
        await widget.sessionController.updatePassenger(
          passangerProfile(
            userId: widget.sessionController.userId,
            Name: NameController.text,
            phoneNumber: _phonenumberController.text,
            dateofBirth: _dateOfBirthController.text,
            email: _emailController.text,
            image: _imageUrl,
            // driverCNIC: _driverCNCController.text,
            // driverLicense: _driverLicenceController.text
          ),
        );
      } else {
        Utils().toastMessage('Image not selected');
      }

      Utils().toastMessage('Successful update');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => passangerHome()));
    } catch (error) {
      Utils().toastMessage('Unsuccessful update');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NameController.text = SessionController().userName ?? '';
    _phonenumberController.text = SessionController().phoneNumber ?? '';
    _emailController.text = SessionController().userEmail ?? '';
    _driverCNCController.text = SessionController().driverCNIC ?? '';
    _driverLicenceController.text = SessionController().driverLicense ?? '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 245, 245),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'profile Update',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_imageUrl != null &&
                                _imageUrl!.isNotEmpty &&
                                _isValidUrl(_imageUrl!))
                              CircleAvatar(
                                radius: 50,
                                child: CachedNetworkImage(
                                  imageUrl: _imageUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              )
                            else
                              const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 60,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(
                              onPressed: () {
                                _showImagePickerOptions();
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    GetTextField(
                      labelText: 'Name',
                      textEditingController: NameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GetTextField(
                      readOnly: true,
                      labelText: 'Email',
                      textEditingController: _emailController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GetTextField(
                      labelText: 'Phone',
                      textEditingController: _phonenumberController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // GetTextField(
                    //   labelText: 'CNIC',
                    //   textEditingController: _driverCNCController,
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // GetTextField(
                    //   labelText: 'License No',
                    //   textEditingController: _driverLicenceController,
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: RoundButton(
                          loading: _isLoading,
                          title: ('Update'),
                          onTap: () {
                            _saveChanges();
                          }),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
              onTap: () async {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

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
    } catch (e) {}
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('images').child(fileName);

      await ref.putFile(imageFile);

      return await ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
