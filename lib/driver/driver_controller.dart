import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mediator/i_mediator.dart';
import '../mediator/i_mediator_data.dart';
import '../responsive/i_responsive.dart';

part 'driver_service.dart';
part 'driver_tracker.dart';
part 'driver_view.dart';

class DriverController {
  final _service = _DriverService();
  final _view = _DriverView();

  final _driverEmailController = TextEditingController();

  late IMediator _mediatorApp;
  late IResponsive _responsive;
  late IMediatorData _mediatorData;

  final List<String> _drivers = [];

  LatLng _currentPosition = LatLng(0, 0);
  Timer? _timer;
  bool _isTracking = false;
  bool _isLoading = true;

  static const routeLogout = 'go to login page from home page';

  Widget build() {
    _responsive = _mediatorApp.getResponsive();
    _mediatorData = _mediatorApp.getMediatorData();
    _service._controller = this;
    _service._listenGps();
    _view.setController(this);
    return _view;
  }

  void setMediatorApp(IMediator mediatorApp) => _mediatorApp = mediatorApp;

  void _logout(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
    _mediatorData.clear();
    _mediatorApp.notify(routeLogout, context);
  }

  String _convertEmailToDisplayName(String email) {
    final displayName = email.split('@').first;
    return displayName;
  }

  Future<void> _getDrivers() async {
    await _service._getDrivers(_mediatorData.getUser()['token']).then((emails) {
      _mediatorData.setDrivers({'emails': emails});
      _drivers.clear();
      _drivers.addAll(emails);
    });
  }

  Future<void> _setDriver(BuildContext context) async {
    await _service._addUpdateDriver(_mediatorData.getUser()['token'], _driverEmailController.text).then((message) {
      _driverEmailController.clear();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: _responsive.text(message, color: Colors.white)));
      Navigator.pop(context);
    });
  }

  Future<void> _deleteDriver(BuildContext context, String email) async {
    await _service._removeDriver(_mediatorData.getUser()['token'], email).then((message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: _responsive.text(message, color: Colors.white)));
      Navigator.pop(context);
    });
  }
}
