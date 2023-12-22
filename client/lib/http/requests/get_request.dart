import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyper_tools/http/http.dart';
import 'package:hyper_tools/http/requests/http_request.dart';

abstract class GetRequest<T> extends HttpRequest<T> {
  Future<T> get() => Http.get(uri, builder, private: private);

  @protected
  T builder(Map<String, dynamic> json);
}