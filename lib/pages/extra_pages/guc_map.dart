import 'package:flutter/material.dart';

class GucMap extends StatelessWidget {
  const GucMap({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GUC Map'),
      ),
      body: const Center(
        child: Image(image: AssetImage('assets/guc_map.png')),
      ),
    );
  }
}
