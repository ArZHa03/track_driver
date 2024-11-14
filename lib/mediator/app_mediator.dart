import 'package:track_driver/driver/driver_controller.dart';

import '../login_register/login_register_controller.dart';

import '../responsive/i_responsive.dart';
import 'package:flutter/material.dart';

import 'i_mediator.dart';
import 'mediator_data.dart';

class MediatorApp implements IMediator {
  LoginRegisterController? _loginRegisterController;
  DriverController? _driverController;

  late IResponsive _responsive;
  late MediatorData _mediatorData;

  void setMediatorData(MediatorData mediatorData) => _mediatorData = mediatorData;
  void setResponsive(IResponsive responsive) => _responsive = responsive;

  @override
  MediatorData getMediatorData() => _mediatorData;

  @override
  IResponsive getResponsive() => _responsive;

  @override
  void notify(String route, BuildContext context) async {
    if (route == LoginRegisterController.routeSuccessLogin) {
      final controller = _driverController ?? _createDriverController();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => controller.build()));
    }

    if (route == DriverController.routeLogout) {
      final controller = _loginRegisterController ?? _createLoginRegisterController();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => controller.build()));
    }
  }

  Widget initFirstPage() {
    _loginRegisterController = _createLoginRegisterController();
    return _loginRegisterController!.build();
  }

  LoginRegisterController _createLoginRegisterController() {
    if (_loginRegisterController == null) {
      _loginRegisterController = LoginRegisterController();
      _loginRegisterController!.setMediatorApp(this);
    }
    return _loginRegisterController!;
  }

  DriverController _createDriverController() {
    if (_driverController == null) {
      _driverController = DriverController();
      _driverController!.setMediatorApp(this);
    }
    return _driverController!;
  }
}
