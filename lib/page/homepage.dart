import 'package:flutter/material.dart';
import 'package:oslar/index/standard.dart';

class HomeArea extends StatefulWidget {
  const HomeArea({super.key});

  @override
  State<HomeArea> createState() => _HomeAreaState();
}

class _HomeAreaState extends State<HomeArea> {

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text('This is Home!')
        )
      ]
    );
  }
}