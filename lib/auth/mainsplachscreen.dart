import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/splash_service.dart';

class Splascmain extends StatefulWidget {
  const Splascmain({super.key});

  @override
  State<Splascmain> createState() => _SplascmainState();
}

class _SplascmainState extends State<Splascmain> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    splashScreen.checkUserTypeAndNavigate(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.amber,
      body: const Column(
        children: [
          Center(child: Text('wellcome regel')),
        ],
      ),
    );
  }
}