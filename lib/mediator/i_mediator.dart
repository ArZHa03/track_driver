import '../responsive/i_responsive.dart';

import 'i_mediator_data.dart';

import 'package:flutter/material.dart';

abstract class IMediator {
  IMediatorData getMediatorData();
  IResponsive getResponsive();
  void notify(String route, BuildContext context);
}
