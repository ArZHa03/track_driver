part of 'login_register_controller.dart';

class _LoginRegisterBuilder {
  static Color _primaryColor = Color(0xffFFFFFF);
  static Color _secondaryColor = Color(0xff3A75C4);
  static Color _tertiaryColor = Color(0xff2C3E50);

  static Color _hedgeColor = Color(0xffDADADA);
  static Color _labelColor = Color(0xffA6A6AA);
  static Color _otherColor = Color(0xff333333);

  static final _textStyle = _controller._responsive.textStyle(
    fontSize: 10,
    color: _otherColor,
  );

  static final _inputDecoration = InputDecoration(
    labelStyle: _textStyle.copyWith(fontWeight: FontWeight.bold, color: _labelColor),
    hintStyle: _textStyle.copyWith(color: _hedgeColor),
    errorStyle: _textStyle.copyWith(color: Colors.redAccent),
    floatingLabelStyle: _textStyle.copyWith(color: _secondaryColor),
    helperStyle: _textStyle.copyWith(color: _hedgeColor),
    contentPadding: EdgeInsets.symmetric(horizontal: _controller._responsive.wp(15)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _secondaryColor),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _secondaryColor, width: 2),
      borderRadius: BorderRadius.circular(15),
    ),
    border: const OutlineInputBorder(),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      borderRadius: BorderRadius.circular(15),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: _secondaryColor.withOpacity(0.5)),
    ),
  );

  static late LoginRegisterController _controller;
  static bool _isLoginMode = true;

  _LoginRegisterBuilder setColor(
      {Color? primaryColor,
      Color? secondaryColor,
      Color? tertiaryColor,
      Color? hedgeColor,
      Color? labelColor,
      Color? otherColor}) {
    _primaryColor = primaryColor ?? _primaryColor;
    _secondaryColor = secondaryColor ?? _secondaryColor;
    _tertiaryColor = tertiaryColor ?? _tertiaryColor;
    _hedgeColor = hedgeColor ?? _hedgeColor;
    _labelColor = labelColor ?? _labelColor;
    _otherColor = otherColor ?? _otherColor;
    return this;
  }

  _LoginRegisterBuilder reset() {
    _buildLogo = SizedBox();
    _buildTitle = SizedBox();
    _buildSubtitle = SizedBox();
    _buildEmailField = SizedBox();
    _buildPasswordField = SizedBox();
    _buildConfirmPasswordField = SizedBox();
    _buildLoginRegisterButton = SizedBox();
    _buildLoginRegisterButtonPage = SizedBox();
    return this;
  }

  Widget _buildLogo = SizedBox();
  _LoginRegisterBuilder buildLogo({required String path, required bool loginMode}) {
    _buildLogo = Container(
      margin: EdgeInsets.only(
        top: _controller._responsive.hp(loginMode ? 50 : 25),
        bottom: _controller._responsive.hp(50),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset(
            path,
            height: _controller._responsive.hp(100),
            fit: BoxFit.contain,
          ),
          _controller._responsive.text(
            "Track Driver",
            fontSize: 20,
            color: _secondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
    return this;
  }

  Widget _buildTitle = SizedBox();
  _LoginRegisterBuilder buildTitle({required title}) {
    _buildTitle = _controller._responsive.text(
      title,
      color: _secondaryColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
    return this;
  }

  Widget _buildSubtitle = SizedBox();
  _LoginRegisterBuilder buildSubtitle({required subtitle}) {
    _buildSubtitle = _controller._responsive.text(subtitle, color: _otherColor);
    return this;
  }

  Widget _buildEmailField = SizedBox();
  _LoginRegisterBuilder buildEmailField() {
    _buildEmailField = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: _textStyle,
      controller: _controller._email,
      validator: (value) {
        if (value == null || value.isEmpty) return "Anda belum mengisi kolom email";
        return null;
      },
      decoration: _inputDecoration.copyWith(labelText: "Email", hintText: "Contoh: johndoe@gmail.com"),
    );
    return this;
  }

  Widget _buildPasswordField = SizedBox();
  _LoginRegisterBuilder buildPasswordField() {
    _buildPasswordField = _AtTextFormField(
      style: _textStyle,
      controller: _controller,
      inputDecoration: _inputDecoration,
      isLoginMode: _isLoginMode,
    );
    return this;
  }

  Widget _buildConfirmPasswordField = SizedBox();
  _LoginRegisterBuilder buildConfirmPasswordField() {
    _buildConfirmPasswordField = _AtTextFormField(
      style: _textStyle,
      controller: _controller,
      inputDecoration: _inputDecoration,
      isConfirmPassword: true,
    );
    return this;
  }

  Widget _buildLoginRegisterButton = SizedBox();
  _LoginRegisterBuilder buildLoginRegisterButton({required String text}) {
    _buildLoginRegisterButton = _AtButton(text: text);
    return this;
  }

  Widget _buildLoginRegisterButtonPage = SizedBox();
  _LoginRegisterBuilder buildLoginRegisterButtonPage(
      {required String ask, required String action, required void Function()? onTap}) {
    _buildLoginRegisterButtonPage = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controller._responsive.text(ask, textStyle: _textStyle),
        GestureDetector(
          onTap: onTap,
          child: _controller._responsive.text(
            " $action",
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: _secondaryColor,
          ),
        ),
      ],
    );
    return this;
  }

  Widget build() {
    return Scaffold(
      backgroundColor: _primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: _controller._responsive.wp(50)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo,
              _buildTitle,
              _buildSubtitle,
              Form(
                key: _controller._formKey,
                child: Column(
                  children: [
                    SizedBox(height: _controller._responsive.hp(_isLoginMode ? 30 : 15)),
                    _buildEmailField,
                    SizedBox(height: _controller._responsive.hp(15)),
                    _buildPasswordField,
                    if (!_isLoginMode) SizedBox(height: _controller._responsive.hp(15)),
                    _buildConfirmPasswordField,
                  ],
                ),
              ),
              SizedBox(height: _controller._responsive.hp(_isLoginMode ? 40 : 25)),
              _buildLoginRegisterButton,
              SizedBox(height: _controller._responsive.hp(_isLoginMode ? 21 : 7)),
              _buildLoginRegisterButtonPage,
            ],
          ),
        ),
      ),
    );
  }
}

class _AtButton extends StatefulWidget {
  final String _text;
  final Widget? _child;
  final void Function()? _onPressed;
  final Color? _backgroundColor;

  const _AtButton({String text = '', Widget? child, void Function()? onPressed, Color? backgroundColor})
      : _text = text,
        _child = child,
        _onPressed = onPressed,
        _backgroundColor = backgroundColor;

  @override
  State<_AtButton> createState() => __AtButtonState();
}

class __AtButtonState extends State<_AtButton> {
  final LoginRegisterController _controller = _LoginRegisterBuilder._controller;

  @override
  Widget build(BuildContext context) {
    final elevatedButton = ElevatedButton.styleFrom(
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: _controller._responsive.hp(5)),
      disabledBackgroundColor: _LoginRegisterBuilder._secondaryColor.withOpacity(0.5),
      backgroundColor: widget._backgroundColor ?? _LoginRegisterBuilder._secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      alignment: Alignment.center,
      side: BorderSide(color: Color(0xffB1B1B1)),
    );
    return SizedBox(
      width: double.infinity,
      height: _controller._responsive.hp(35),
      child: ElevatedButton(
        key: const ValueKey('login_register_button'),
        onPressed: widget._onPressed == null
            ? _controller._isLoadingButton
                ? null
                : () async {
                    setState(() => _controller._isLoadingButton = true);
                    await _controller.loginRegister();
                    setState(() => _controller._isLoadingButton = false);
                  }
            : widget._onPressed!,
        style: elevatedButton,
        child: widget._child == null
            ? _controller._isLoadingButton
                ? CircularProgressIndicator(color: _LoginRegisterBuilder._primaryColor)
                : _controller._responsive.text(widget._text,
                    color: _LoginRegisterBuilder._primaryColor, fontWeight: FontWeight.w600, fontSize: 17)
            : widget._child!,
      ),
    );
  }
}

class _AtTextFormField extends StatefulWidget {
  final TextStyle _textStyle;
  final LoginRegisterController _controller;
  final InputDecoration _inputDecoration;
  final bool _isConfirmPassword;
  final bool _isLoginMode;

  const _AtTextFormField({
    required TextStyle style,
    required LoginRegisterController controller,
    required InputDecoration inputDecoration,
    bool isConfirmPassword = false,
    bool isLoginMode = true,
  })  : _textStyle = style,
        _controller = controller,
        _inputDecoration = inputDecoration,
        _isConfirmPassword = isConfirmPassword,
        _isLoginMode = isLoginMode;

  @override
  State<_AtTextFormField> createState() => __AtTextFormFieldState();
}

class __AtTextFormFieldState extends State<_AtTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: ValueKey(!widget._isConfirmPassword ? 'password_field' : 'confirm_password_field'),
      // onChanged: (value) => _controller.interactionRecorder.logInteraction("Text input: $value", "password_field"),
      style: widget._textStyle,
      validator: (value) {
        if (!widget._isConfirmPassword) {
          if (value == null || value.isEmpty) return "Anda belum mengisi kolom kata sandi";
          if (widget._isLoginMode) return null;
          if (value.length < 8) return "Kata sandi minimal 8 karakter";
          if (!RegExp(r'\d').hasMatch(value)) return "Kata sandi harus mengandung angka";
          if (!RegExp(r'[A-Z]').hasMatch(value)) return "Kata sandi harus mengandung huruf besar";
          if (!RegExp(r'[a-z]').hasMatch(value)) return "Kata sandi harus mengandung huruf kecil";
        } else {
          if (value == null || value.isEmpty) return "Anda belum mengisi kolom konfirmasi kata sandi";
          if (value != widget._controller._password.text) return "Kata sandi tidak sama";
        }

        return null;
      },
      controller: !widget._isConfirmPassword ? widget._controller._password : null,
      textInputAction: TextInputAction.next,
      obscureText: !widget._isConfirmPassword ? widget._controller._isObscure : widget._controller._isObscureConfirm,
      decoration: widget._inputDecoration.copyWith(
        suffixIcon: IconButton(
          iconSize: widget._controller._responsive.wp(18),
          key: ValueKey(
              !widget._isConfirmPassword ? 'password_visibility_toggle' : 'confirm_password_visibility_toggle'),
          onPressed: () => setState(() {
            if (!widget._isConfirmPassword) {
              widget._controller._isObscure = !widget._controller._isObscure;
            } else {
              widget._controller._isObscureConfirm = !widget._controller._isObscureConfirm;
            }
          }),
          icon: Icon(
            widget._isConfirmPassword
                ? widget._controller._isObscureConfirm
                    ? Icons.visibility_off
                    : Icons.visibility
                : widget._controller._isObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
            applyTextScaling: false,
          ),
        ),
        hintText: !widget._isConfirmPassword ? "Masukkan Kata Sandi" : "Konfirmasi Kata Sandi",
        labelText: !widget._isConfirmPassword ? "Kata Sandi" : "Konfirmasi Kata Sandi",
      ),
    );
  }
}
