import 'package:flutter/material.dart';
import '/responsive/responsive.dart';
import '/mediator/mediator_data.dart';
import '/mediator/app_mediator.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(_TrackDriver());
}

class _TrackDriver extends StatefulWidget {
  @override
  State<_TrackDriver> createState() => _TrackDriverState();
}

class _TrackDriverState extends State<_TrackDriver> {
  final _mediatorApp = MediatorApp();
  late Responsive _responsive;

  @override
  void initState() {
    super.initState();
    _responsive = Responsive(context);
    _mediatorApp.setResponsive(_responsive);
    _mediatorApp.setMediatorData(MediatorData());
  }

  @override
  Widget build(BuildContext context) => MaterialApp(home: _mediatorApp.initFirstPage());
}
