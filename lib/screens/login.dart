import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/shared_preference.dart';
import '../providers/auth.dart';
import '../utils/validators.dart';
import '../providers/user_provider.dart';
import '../utils/app_routes.dart';
import '../providers/meta_provider.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String? _username = '', _password = '', _serverUrl = '';
  bool _passwordVisible = false;

  AuthProvider? _authProvider;

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Connect2 Bahmni'),
            elevation: 0.1,
          ),
          body: Container(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _formWidgets(''),
              ),
            ),
          ),
      ),
    );
  }

  void _doLogin() {
    if (_formKey.currentState!.validate()) {
      UserPreferences().removeSession();
      _formKey.currentState!.save();
      _authProvider!.authenticate(_username as String, _password as String)
          .then((response) {
        if (response.status) {
          var session = response.session!;
          Provider.of<UserProvider>(context, listen: false).setUser(session.user);
          Provider.of<MetaProvider>(context, listen: false).initialize();
          var providerLoginLocations = session.user.provider?.attrValue('locations');
          if (providerLoginLocations != null && providerLoginLocations.isNotEmpty) {
            var assignedLocations = <String, String>{};
            for (var loc in providerLoginLocations) {
              assignedLocations.putIfAbsent(loc['uuid'], () => loc['name']);
            }
            Navigator.pushNamed(context, AppRoutes.loginLocations,
              arguments: assignedLocations,
            );
          } else {
            Navigator.pushNamed(context, AppRoutes.loginLocations,);
          }
        } else {
          showLoginFailure(context);
        }
      });
    } else {
      showLoginFailure(context);
    }
  }

  Row _showLoading() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );
  }

  TextFormField _userNameField() {
    return TextFormField(
      autofocus: false,
      validator: (value) {
        return validateUserName(value);
      },
      onSaved: (value) => _username = value,
      decoration: const InputDecoration(
        hintText: 'enter user name',
      ),
    );
  }

  TextFormField _serverUrlField() {
    return TextFormField(
      autofocus: false,
      initialValue: _serverUrl,
      validator: (value) {
        return validateUrl(value);
      },
      onSaved: (value) => _serverUrl = value,
      decoration: const InputDecoration(
        hintText: 'enter server url',
      ),
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      autofocus: false,
      obscureText: !_passwordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
      onSaved: (value) => _password = value,
      decoration: InputDecoration(
        //suffixIcon: Icon(Icons.visibility, color: Color.fromRGBO(50, 62, 72, 1.0)),
        hintText: 'enter password',
        suffixIcon: GestureDetector(
          onLongPress: () {
            setState(() {
              _passwordVisible = true;
            });
          },
          onLongPressUp: () {
            setState(() {
              _passwordVisible = false;
            });
          },
          child: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

  Row _forgotLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
          child: const Text('Forgot password?'),
        ),
      ],
    );
  }

  ElevatedButton _loginButton() {
    return ElevatedButton(
      autofocus: false,
      onPressed: _doLogin,
      child: const Text('Login'),
    );
  }

  List<Widget> _formWidgets(String? serverInfo) {
    List<Widget> formElements = [];
    if (serverInfo == null) {
      formElements.addAll([
        const SizedBox(height: 5.0),
        const SizedBox(height: 5.0),
        const Text('Server'),
        _serverUrlField()
      ]);
    }
    formElements.addAll([
      const SizedBox(height: 5.0),
      const SizedBox(height: 5.0),
      const Text('User'),
      _userNameField(),
      const SizedBox(height: 20.0),
      const Text("Password"),
      _passwordField(),
      const SizedBox(height: 5.0),
      const SizedBox(height: 20.0),
      _authProvider!.loggedInStatus == Status.authenticating
          ? _showLoading()
          : _loginButton(),
      const SizedBox(height: 5.0),
      _forgotLabel()
    ]);
    return formElements;
  }

  void showLoginFailure(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login failed")),
    );
  }

  void showError(BuildContext context, String err) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err)),
    );
  }
}