import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('whatapp')),
        backgroundColor: const Color.fromARGB(44, 155, 12, 12),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Azam',
              style: TextStyle(color: Colors.amber, fontSize: 30),
            ),
            subtitle: Text('hhdfdf'),
            trailing: Text('8:00pm'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Azam',
              style: TextStyle(color: Colors.amber, fontSize: 30),
            ),
            subtitle: Text('hhdfdf'),
            trailing: Text('8:00pm'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Azam',
              style: TextStyle(color: Colors.amber, fontSize: 30),
            ),
            subtitle: Text('hhdfdf'),
            trailing: Text('8:00pm'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Azam',
              style: TextStyle(color: Colors.amber, fontSize: 30),
            ),
            subtitle: Text('hhdfdf'),
            trailing: Text('8:00pm'),
          )
        ],
      ),
      // backgroundColor: Color.fromARGB(44, 155, 12, 12)
    );
  }
}
