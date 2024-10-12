import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relgal/model/passangerProfile.dart';

import '../model/DriverProfile.dart';
import '../widget/flutter_toast.dart';

class SessionController {
  static final SessionController _session = SessionController._internal();

  String? userId;
  String? userName;
  String? userEmail;
  String? phoneNumber;
  String? image;
  String? driverId;
  String? passengerId;
  String? driverCNIC;
  String? driverLicense;

  factory SessionController() {
    return _session;
  }

  SessionController._internal();

  Future<void> DriverInfo(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Driver')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        userName = userDoc['Name'];
        userEmail = userDoc['email'];
        phoneNumber = userDoc['phoneNumber'];
        image = userDoc['image'];
        driverId = userDoc['driverId'];
        driverCNIC = userDoc['driverCNIC'];
        driverLicense = userDoc['driverLicense'];
        // driverCNIC:userDoc['Driver_CNIC'];
        // driverLicense:userDoc['Driver_License'];
      }
    } catch (error) {
      print('Error fetching driver information: $error');
    }
  }

//drive update
  Future<void> updateDriver(DriverProfile updatedProfile) async {
    try {
      await FirebaseFirestore.instance.collection('Driver').doc(userId).update({
        'Name': updatedProfile.Name,
        'email': updatedProfile.email,
        'phoneNumber': updatedProfile.phoneNumber,
        'image': updatedProfile.image,
        'dateofBirth': updatedProfile.dateofBirth,
        'driverCNIC': updatedProfile.driverCNIC,
        'driverLicense': updatedProfile.driverLicense
        // 'Driver_License': updatedProfile.driverLicense,
        // 'Driver_CNIC': updatedProfile.driverCNIC
      });

      userName = updatedProfile.Name;
      userEmail = updatedProfile.email;
      phoneNumber = updatedProfile.phoneNumber;
      image = updatedProfile.image;
      driverCNIC = updatedProfile.driverCNIC;
      driverLicense = updatedProfile.driverLicense;
      // driverCNIC = updatedProfile.driverCNIC;
      // driverLicense = updatedProfile.driverLicense;
    } catch (error) {
      Utils().toastMessage('Error updating driver information: $error');
    }
  }

//passanger
  Future<void> passengerInfo(String userId) async {
    try {
      DocumentSnapshot passengerDoc = await FirebaseFirestore.instance
          .collection('passanger')
          .doc(userId)
          .get();

      if (passengerDoc.exists) {
        userName = passengerDoc['Name'];
        userEmail = passengerDoc['email'];
        phoneNumber = passengerDoc['phoneNumber'];
        image = passengerDoc['image'];
        passengerId = passengerDoc['passengerId'];
      }
    } catch (error) {
      print('Error fetching passenger information: $error');
    }
  }

  Future<void> updatePassenger(passangerProfile updatedProfile) async {
    try {
      await FirebaseFirestore.instance
          .collection('passanger')
          .doc(userId)
          .update({
        'Name': updatedProfile.Name,
        'email': updatedProfile.email,
        'phoneNumber': updatedProfile.phoneNumber,
        'image': updatedProfile.image,
        'dateofBirth': updatedProfile.dateofBirth,
      });

      userName = updatedProfile.Name;
      userEmail = updatedProfile.email;
      phoneNumber = updatedProfile.phoneNumber;
      image = updatedProfile.image;
    } catch (error) {
      print('this is err $error');
      Utils().toastMessage('Error updating passenger information: $error');
    }
  }
}
