// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show FlutterView;
import 'package:flutter/material.dart';
import 'src/multiview.dart';
import 'page.dart';

void main() {
  runAppWithoutImplicitView(MultiViewApp(
    viewBuilder: (BuildContext context) {
      final FlutterView view = View.of(context);
      final Key key = Key('${view.viewId}');
      return ViewHome(key: key);
    },
  ));
}
