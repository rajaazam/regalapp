// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:relgal/services/session_manager.dart';

// import '../auth/login_screen.dart';
// import 'flutter_toast.dart';

// class myDawer extends StatelessWidget {
//   const myDawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//      final SessionController sessionController;
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           FutureBuilder<void>(
//             future: sessionController.DriverInfo(
//                 sessionController.userId.toString()),
//             builder: (context, AsyncSnapshot<void> snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasError) {
//                   return const DrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Error loading user info',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return DrawerHeader(
//                     decoration: const BoxDecoration(
//                       color: Colors.blue,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           child: sessionController.image != null &&
//                                   sessionController.image!.isNotEmpty
//                               ? CircleAvatar(
//                                   radius: 40,
//                                   backgroundImage: CachedNetworkImageProvider(
//                                       sessionController.image!),
//                                 )
//                               : const Icon(Icons.person, size: 40),
//                         ),
//                         const SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Text(
//                             sessionController.userName ?? '',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               } else {
//                 return const DrawerHeader(
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                   ),
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                     ),
//                   ),
//                 );
//               }
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Profile Update'),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProfileUpdateDriverScreen(
//                             sessionController: sessionController,
//                           )));
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Profile '),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => ProfileScreen()));
//             },
//           ),
          
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () {
//               final auth = FirebaseAuth.instance;
//               auth.signOut().then((value) {
//                 SessionController().userId = '';
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const LoginScreen()));
//               }).onError((error, stackTrace) {
//                 Utils().toastMessage(error.toString());
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
