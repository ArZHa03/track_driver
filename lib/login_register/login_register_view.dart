part of 'login_register_controller.dart';

class _LoginRegisterView extends StatefulWidget {
  late LoginRegisterController _controller;

  void setController(LoginRegisterController controller) => _controller = controller;

  @override
  State<_LoginRegisterView> createState() => _LoginRegisterViewState();
}

class _LoginRegisterViewState extends State<_LoginRegisterView> {
  late LoginRegisterController _controller;
  late _LoginRegisterBuilder _loginRegisterBuilder;

  @override
  void initState() {
    _controller = widget._controller;
    _controller._context = context;
    _LoginRegisterBuilder._controller = _controller;
    _loginRegisterBuilder = _LoginRegisterBuilder();
    _buildLoginView();
    _autoLogin();
    super.initState();
  }

  void _autoLogin() async {
    setState(() => _controller._isLoading = true);
    await _controller._autoLogin();
    setState(() => _controller._isLoading = false);
  }

  void _buildLoginView() {
    _loginRegisterBuilder
        .buildLogo(path: 'assets/logo.png', loginMode: true)
        .buildTitle(title: 'Masuk')
        .buildSubtitle(subtitle: 'Masukkan email dan kata sandi anda')
        .buildEmailField()
        .buildPasswordField()
        .buildLoginRegisterButton(text: 'Masuk')
        .buildLoginRegisterButtonPage(
            ask: 'Belum punya akun?', action: 'Daftar sekarang', onTap: _changeModeLoginRegister);
  }

  void _buildRegisterView() {
    _loginRegisterBuilder
        .buildLogo(path: 'assets/logo.png', loginMode: false)
        .buildTitle(title: 'Daftar Akun')
        .buildEmailField()
        .buildPasswordField()
        .buildConfirmPasswordField()
        .buildLoginRegisterButton(text: 'Daftar')
        .buildLoginRegisterButtonPage(ask: 'Sudah punya akun?', action: 'Masuk', onTap: _changeModeLoginRegister);
  }

  void _changeModeLoginRegister() {
    setState(() {
      _controller._defaultValue();
      _loginRegisterBuilder.reset();
      _controller._loginMode = !_controller._loginMode;
      if (_controller._loginMode) {
        _LoginRegisterBuilder._isLoginMode = true;
        _buildLoginView();
      } else {
        _LoginRegisterBuilder._isLoginMode = false;
        _buildRegisterView();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _loginRegisterBuilder.build(),
        _loadingOverlay(),
      ],
    );
  }

  Widget _loadingOverlay() {
    return _controller._isLoading
        ? Container(color: Colors.black.withOpacity(0.8), child: Center(child: CircularProgressIndicator()))
        : SizedBox();
  }
}
