// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  final BuildContext context;
  AppDialog({
    required this.context,
  });

  void normalDialog({required String title, required String subTitle}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: const Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                title:
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(subTitle),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }
}
