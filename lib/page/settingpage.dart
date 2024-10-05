import 'package:flutter/material.dart';
import 'package:oslar/index/standard.dart';

class SettingArea extends StatefulWidget {
  const SettingArea({super.key});

  @override
  State<SettingArea> createState() => _SettingAreaState();
}

class _SettingAreaState extends State<SettingArea> {

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text('hello!')
        )
      ]
    );
  }
}