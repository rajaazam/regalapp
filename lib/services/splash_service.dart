import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import '../driver/homescree.dart';
import '../driver/splachscreen.dart';
import '../passanger/home.dart';
import '../passanger/splach.dart';
import 'session_manager.dart';

// class SplashServices {
//   void isLogin(BuildContext context) {
//     final auth = FirebaseAuth.instance;

//     final user = auth.currentUser;

//     if (user != null) {
//       SessionController().userId = user!.uid.toString();
//       SessionController().driverId = SessionController().driverId;
//       Timer(
//           const Duration(seconds: 2),
//           () => Navigator.push(context,
//               MaterialPageRoute(builder: (context) => Splachscreendriver())));
//     } else {
//       Timer(
//           const Duration(seconds: 2),
//           () => Navigator.push(
//               context, MaterialPageRoute(builder: (context) => Splachscreen())));
//     }
//   }
// }
// class SplashServices {
//   void checkUserTypeAndNavigate(BuildContext context) {
//     final auth = FirebaseAuth.instance;
//     final user = auth.currentUser;

//     if (user != null) {
//       SessionController().userId = user.uid;
      
//       // Fetch user info to check if it's a driver or passenger
//       SessionController().fetchUserInfo(user.uid).then((_) {
//         // Check if driverId == '0', then navigate to the driver's splash screen
//         if (SessionController().driverId == '0') {
//           Timer(
//             const Duration(seconds: 2),
//             () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomeDriver()),
//             ),
//           );

//         } else {
//           // Otherwise, navigate to the passenger's splash screen
//           Timer(
//             const Duration(seconds: 2),
//             () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const passangerHome()),
//             ),
//           );
//         }
//       }).catchError((error) {
//         // Handle error (e.g., user not found)
//         print('Error fetching user info: $error');
//       });
//     } else {
//       // If no user is logged in, navigate to the appropriate sign-up screen
//       Timer(
//         const Duration(seconds: 2),
//         () => Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//         ),
//       );
//     }
//   }
// }
class SplashServices {
  void checkUserTypeAndNavigate(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      SessionController().userId = user.uid;

      // Fetch driver info
      SessionController().DriverInfo(user.uid).then((_) {
        // Check if driverId == '0', navigate to the driver's home screen
        if (SessionController().driverId == '0') {
          Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeDriver()),
            ),
          );
        } else {
          // Fetch passenger info only if not a driver
          SessionController().passengerInfo(user.uid).then((_) {
            // Check if passengerId == '1', navigate to the passenger's home screen
            if (SessionController().passengerId == '1') {
              Timer(
                const Duration(seconds: 2),
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => passangerHome()),
                ),
              );
            } else {
              // Otherwise, navigate to a different screen (e.g., passenger login screen)
              Timer(
                const Duration(seconds: 2),
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
              );
            }
          }).catchError((error) {
            // Handle error (e.g., passenger info not found)
            print('Error fetching passenger info: $error');
          });
        }
      }).catchError((error) {
        // Handle error (e.g., driver info not found)
        print('Error fetching driver info: $error');
      });
    } else {
      // If no user is logged in, navigate to the login screen
      Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
      );
    }
  }
}
