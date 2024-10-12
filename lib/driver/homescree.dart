import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relgal/driver/profile_screen.dart';

import '../auth/login_screen.dart';
import '../services/session_manager.dart';
import '../widget/flutter_toast.dart';
import 'cardata.dart';
import 'cardetail.dart';
import 'profile_update.dart';

class HomeDriver extends StatefulWidget {
  const HomeDriver({super.key});

  @override
  State<HomeDriver> createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SessionController sessionController = SessionController();

  void _handleLogout(BuildContext context) {
    _auth.signOut().then((value) {
      sessionController.userId = '';
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }).catchError((error) {
      Utils().toastMessage(error.toString());
    });
  }

  final List<String> imgList = [
    'images/car2.jpg',
    'images/car3.jpg',
    'images/car2.jpg',
    'images/car3.jpg',
  ];
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'home ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            FutureBuilder<void>(
              future: sessionController.DriverInfo(
                  sessionController.userId.toString()),
              builder: (context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          'Error loading user info',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: sessionController.image != null &&
                                    sessionController.image!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 40,
                                    backgroundImage: CachedNetworkImageProvider(
                                        sessionController.image!),
                                  )
                                : const Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              sessionController.userName ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Update'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileUpdateDriverScreen(
                              sessionController: sessionController,
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile '),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.car_crash),
              title: const Text('Car Add'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CarDataScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                final auth = FirebaseAuth.instance;
                auth.signOut().then((value) {
                  SessionController().userId = '';
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              enableInfiniteScroll: true,
              viewportFraction: 0.8,
            ),
            items: imgList
                .map((item) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cars')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No cars found'));
                }

                final carDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: carDocs.length,
                  itemBuilder: (context, index) {
                    final carData =
                        carDocs[index].data() as Map<String, dynamic>;
                    final carName = carData['carName'];
                    final imageUrl = carData['imageUrl'];
                    final model = carData['model'];
                    final carcolor = carData['carcolor'];
                    final carId = carData['carId'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarDetailsScreen(
                              carId: carId,
                              carName: carName,
                              imageUrl: imageUrl,
                              model: model,
                              //carcolor: carcolor,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15), // Set the border radius
                              image: imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          imageUrl), // Use NetworkImage for the image
                                      fit: BoxFit
                                          .cover, // Ensure the image covers the container
                                    )
                                  : null, // No image if imageUrl is null
                            ),
                            height: 200,
                            width: 300,
                            child: imageUrl ==
                                    null // Show an icon if there's no image
                                ? const Center(
                                    child: Icon(Icons.directions_car, size: 40),
                                  )
                                : null,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(15)),
                          //   height: 200,
                          //   width: 300,
                          //   child: imageUrl != null
                          //       ? Image.network(imageUrl,
                          //           width: 150, height: 250, fit: BoxFit.cover)
                          //       : const Icon(Icons.directions_car),
                          // ),
                          Text(
                            carName ?? 'Unknown Car',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Text(
                          //   carcolor ?? 'Unknown Car',
                          //   style: const TextStyle(
                          //       fontSize: 20, fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Center(
          //   child: Text('wellcom to driver '),
          // ),
          //  ListTile(
          //     leading: const Icon(Icons.logout),
          //     title: const Text('Logout'),
          //     onTap: () {
          //       final auth = FirebaseAuth.instance;
          //       auth.signOut().then((value) {
          //         SessionController().userId = '';
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => LoginScreen()));
          //       }).onError((error, stackTrace) {
          //         Utils().toastMessage(error.toString());
          //       });
          //     },
          //   ),
        ],
      ),
    );
  }
}
