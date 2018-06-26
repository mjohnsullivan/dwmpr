// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';

class Repository {
  final String name;
  final String url;
  final String description;
  final int forkCount;
  final int starCount;

  Repository(
      {@required this.name,
      @required this.url,
      this.description,
      @required this.forkCount,
      @required this.starCount});

  String toString() => '$name, $description, $url, $forkCount, $starCount';
}
