import 'package:flutter/material.dart';

class DriverDetials extends StatefulWidget {
  final String? Id;
  final String? Name;
  final String? imageUrl;
  final String? phone;
  const DriverDetials(
      {super.key, this.Id, this.Name, this.imageUrl, this.phone});

  @override
  State<DriverDetials> createState() => _DriverDetialsState();
}

class _DriverDetialsState extends State<DriverDetials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Name!),
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl!),
            ),
            
            title: Text(widget.phone!),
          )
        ],
      ),
    );
  }
}
