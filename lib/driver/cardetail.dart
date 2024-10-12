// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class CarDetailsScreen extends StatelessWidget {
//   final String carId;
//   final String carName;
//   final String imageUrl;
//   final String model;
//   // final String carcolor;

//   const CarDetailsScreen({
//     Key? key,
//     required this.carId,
//     required this.carName,
//     required this.imageUrl,
//     required this.model,
//     //required this.carcolor,
//   }) : super(key: key);

//   void _deleteCar(BuildContext context) {
//     FirebaseFirestore.instance.collection('cars').doc(carId).delete().then((_) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Car deleted successfully')),
//       );
//     });
//   }

//   void _updateCar(BuildContext context) {
//     // Navigate to an update screen or implement inline update logic here
//     // Example: Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateCarScreen(carId: carId)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(carName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl,
//                 height: 200,
//                 width: 300,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) =>
//                     const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Car Name: $carName',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text('Model: $model', style: const TextStyle(fontSize: 18)),
//             Text('Carid: $carId', style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => _updateCar(context),
//                   child: const Text('Update'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => _deleteCar(context),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   child: const Text('Delete'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class CarDetailsScreen extends StatefulWidget {
  final String carId;
  final String carName;
  final String imageUrl;
  final String model;

  const CarDetailsScreen({
    Key? key,
    required this.carId,
    required this.carName,
    required this.imageUrl,
    required this.model,
  }) : super(key: key);

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  String? _imageUrl;
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _carNameController.text = widget.carName;
    _modelController.text = widget.model;
    _imageUrl = widget.imageUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateCarDetails() async {
    setState(() {
      _isUpdating = true;
    });

    String? newImageUrl;
    if (_imageFile != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      await storageRef.putFile(_imageFile!);
      newImageUrl = await storageRef.getDownloadURL();
    }

    FirebaseFirestore.instance.collection('cars').doc(widget.carId).update({
      'carName': _carNameController.text,
      'model': _modelController.text,
      'imageUrl': newImageUrl ?? _imageUrl,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car details updated successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating car details: $error')),
      );
    }).whenComplete(() {
      setState(() {
        _isUpdating = false;
      });
    });
  }

  void _deleteCar(BuildContext context) {
    FirebaseFirestore.instance
        .collection('cars')
        .doc(widget.carId)
        .delete()
        .then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car deleted successfully')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text(widget.carName, style: TextStyle(fontSize: 18, color: Colors.white),)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: CachedNetworkImageProvider(_imageUrl!),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: _imageFile == null && _imageUrl == null
                      ? const Center(
                          child: Icon(Icons.camera_alt,
                              size: 40, color: Colors.white),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _carNameController,
                decoration: const InputDecoration(
                  labelText: 'Car Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _isUpdating
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _updateCarDetails,
                          child: const Text('Update'),
                        ),
                        ElevatedButton(
                          onPressed: () => _deleteCar(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
