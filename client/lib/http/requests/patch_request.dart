import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyper_tools/http/http.dart';
import 'package:hyper_tools/http/requests/http_request.dart';

abstract class PatchRequest<T> extends HttpRequest<T> {
  Future<T> patch() => Http.patch(uri, body, builder, private: private);

  @protected
  T builder(Map<String, dynamic> json);

  @protected
  Map<String, dynamic>? get body;
}
