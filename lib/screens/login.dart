import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/shared_preference.dart';
import '../providers/auth.dart';
import '../utils/validators.dart';
import '../providers/user_provider.dart';
import '../domain/models/session.dart';
import '../utils/app_routes.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String? _username = '', _password = '';
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) {
        return validateUserName(value);
      },
      onSaved: (value) => _username = value,
      decoration: const InputDecoration(
        hintText: 'enter user name',
      ),
    );

    final passwordField = TextFormField(
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

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
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

    void doLogin() {
      if (_formKey.currentState!.validate()) {
        UserPreferences().removeSession();
        _formKey.currentState!.save();
        auth.authenticate(_username as String, _password as String)
            .then((response) {
          if (response['status']) {
            var session = response['session'] as Session;
            Provider.of<UserProvider>(context, listen: false).setUser(session.user);
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

    ElevatedButton loginButton() {
      return ElevatedButton(
        autofocus: false,
        onPressed: doLogin,
        child: const Text('Login'),
      );
    }

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
                children: [
                  const SizedBox(height: 5.0),
                  const SizedBox(height: 5.0),
                  const Text('User'),
                  usernameField,
                  const SizedBox(height: 20.0),
                  const Text("Password"),
                  passwordField,
                  const SizedBox(height: 5.0),
                  const SizedBox(height: 20.0),
                  auth.loggedInStatus == Status.authenticating
                      ? loading
                      : loginButton(),
                  const SizedBox(height: 5.0),
                  forgotLabel
                ],
              ),
            ),
          ),
      ),
    );
  }

  void showLoginFailure(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login failed")),
    );
  }
}