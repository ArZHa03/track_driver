import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mediator/i_mediator_data.dart';
import '../responsive/i_responsive.dart';
import 'package:flutter/material.dart';

import '../mediator/i_mediator.dart';

part 'login_register_view.dart';
part 'login_register_builder.dart';
part 'login_register_service.dart';

class LoginRegisterController {
  final _loginRegisterView = _LoginRegisterView();

  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _isLoadingButton = false;
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool _loginMode = true;

  late IMediator _mediatorApp;
  late IResponsive _responsive;
  late IMediatorData _mediatorData;

  BuildContext? _context;

  static const routeSuccessLogin = 'go to home page from login page';

  void _navigateToSuccessLoginRegister(BuildContext context) => _mediatorApp.notify(routeSuccessLogin, context);

  void setMediatorApp(IMediator mediatorApp) => _mediatorApp = mediatorApp;

  Widget build() {
    _responsive = _mediatorApp.getResponsive();
    _mediatorData = _mediatorApp.getMediatorData();
    _loginRegisterView.setController(this);
    return _loginRegisterView;
  }

  Future<void> _autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> userData = {};
        userData['email'] = user.email;
        userData['token'] = user.uid;
        _mediatorData.setUser(userData);
        _navigateToSuccessLoginRegister(_context!);
      }
    }
  }

  Future<void> loginRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final result =
        await _LoginRegisterService.loginRegister({'email': _email.text, 'password': _password.text}, _loginMode);

    if (result != null) {
      Map<String, dynamic> user = {};
      user['email'] = result.email;
      user['token'] = result.uid;
      _mediatorData.setUser(user);

      ScaffoldMessenger.of(_context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${_loginMode ? 'Login' : 'Register'} success'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

      _defaultValue();
      _navigateToSuccessLoginRegister(_context!);
    } else {
      ScaffoldMessenger.of(_context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${_loginMode ? 'Login' : 'Register'} failed'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void _defaultValue() {
    _email.clear();
    _password.clear();
  }
}
