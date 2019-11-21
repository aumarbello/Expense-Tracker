import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String label;
  final Function clickListener;

  const AdaptiveFlatButton(this.label, this.clickListener);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: clickListener,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: clickListener,
          );
  }
}
