import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

extension NavigationExtensions on BuildContext {
  void go(String location) {
    AutoRouter.of(this).replacePath(location);
  }

  Future<T?> push<T extends Object?>(String location) {
    return AutoRouter.of(this).pushPath<T>(location);
  }
}
