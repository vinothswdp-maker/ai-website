import 'package:flutter/material.dart';

class PageScroll extends InheritedWidget {
  final ScrollController controller;

  const PageScroll({
    super.key,
    required this.controller,
    required super.child,
  });

  static ScrollController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<PageScroll>();
    assert(result != null, 'PageScroll not found in widget tree');
    return result!.controller;
  }

  @override
  bool updateShouldNotify(PageScroll old) => controller != old.controller;
}
