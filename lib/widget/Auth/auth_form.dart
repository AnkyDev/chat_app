import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFun, this.isloading);

  void Function(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFun;
  bool isloading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _username = '';
  String _useremail = '';
  String _userpass = '';
  void _trySubmit() {
    final isValidate = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValidate) {
      _formKey.currentState!.save();
      widget.submitFun(_useremail.trim(), _username.trim(), _userpass.trim(),
          _isLogin, context);
      print(_username);
      print(_useremail);
      print(_userpass);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please Enter a Valid Email';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                      onSaved: (value) {
                        _useremail = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.length < 4) {
                            return 'Please at least enter 4 Charachters!!';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _username = value!;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('Password'),
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password Must be 8 letter long!!';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userpass = value!;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isloading) CircularProgressIndicator(),
                    if (!widget.isloading)
                      ElevatedButton(
                        child: Text(_isLogin ? 'Login' : 'Sign up'),
                        onPressed: () {
                          _trySubmit();
                        },
                      ),
                    if (!widget.isloading)
                      TextButton(
                        child: Text(
                          _isLogin
                              ? 'Create new account'
                              : 'I already Have an account!',
                        ),
                        style: TextButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
