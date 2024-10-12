import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relgal/passanger/userprofileupdate.dart';

import '../auth/login_screen.dart';
import '../services/session_manager.dart';
import '../widget/flutter_toast.dart';
import 'driverDetails.dart';
import 'userprofile.dart';

class passangerHome extends StatefulWidget {
  const passangerHome({super.key});

  @override
  State<passangerHome> createState() => _passangerHomeState();
}

class _passangerHomeState extends State<passangerHome> {
  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'images/car2.jpg',
      'images/car3.jpg',
      'images/car2.jpg',
      'images/car3.jpg',
    ];
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final SessionController sessionController = SessionController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('passanger'),
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
                        builder: (context) => UserProfileUpdate(
                              sessionController: sessionController,
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile '),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen()));
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
                  .collection('Driver')
                  .where('userId')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Driver found'));
                }

                final carDocs = snapshot.data!.docs;

                return GridView.count(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.all(10),
                  childAspectRatio: 0.8, // Adjust to fit your design
                  children: List.generate(carDocs.length, (index) {
                    final carData =
                        carDocs[index].data() as Map<String, dynamic>;
                    final Name = carData['Name'];
                    final imageUrl = carData['image'];
                    final phoneNumber = carData['phoneNumber'];
                    final carColor = carData['carcolor'];
                    final Id = carData['userId'];

                    return GestureDetector(
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverDetials(
                             Id:Id ,
                             Name: Name,
                             imageUrl: imageUrl,
                             phone: phoneNumber,
                              //carcolor: carcolor,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: (imageUrl != null && imageUrl.isNotEmpty)
                                  ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            height: 120,
                            width: double.infinity,
                            child: (imageUrl == null || imageUrl.isEmpty)
                                ? const Center(
                                    child: Icon(Icons.person, size: 40),
                                  )
                                : null,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(15),
                          //     image: imageUrl != null
                          //         ? DecorationImage(
                          //             image: NetworkImage(imageUrl),
                          //             fit: BoxFit.cover,
                          //           )
                          //         : null,
                          //   ),
                          //   height: 120,
                          //   width: double.infinity,
                          //   child: imageUrl == null
                          //       ? const Center(
                          //           child: Icon(Icons.person, size: 40),
                          //         )
                          //       : null,
                          // ),
                          const SizedBox(height: 10),
                          Text(
                            Name ?? 'Unknown Car',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            phoneNumber ?? 'Unknown Color',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          //  Center(
          //   child: Text('wellcom to passanger '),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: const Text('Logout'),
          //   onTap: () {
          //     final auth = FirebaseAuth.instance;
          //     auth.signOut().then((value) {
          //       SessionController().userId = '';
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => LoginScreen()));
          //     }).onError((error, stackTrace) {
          //       Utils().toastMessage(error.toString());
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
