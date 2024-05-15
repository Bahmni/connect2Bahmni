import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/login_location.dart';
import '../providers/meta_provider.dart';
import '../utils/shared_preference.dart';
import '../providers/auth.dart';
import '../utils/validators.dart';
import '../providers/user_provider.dart';
import '../utils/app_routes.dart';

const locationAttributeName = 'Login Locations';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


const lblUserName = 'User name';
const lblPassword = 'Password';
const msgEnterPwd = 'Please enter password';
const msgLoginFailed = 'Login failed';
const lblTitle = 'Connect2 Bahmni';

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String? _username = '', _password = '';
  bool _passwordVisible = false;

  AuthProvider? _authProvider;

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(lblTitle),
            elevation: 0.1,
          ),
          body: Container(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _formWidgets(),
              ),
            ),
          ),
      ),
    );
  }

  void _doLogin() async {
    if (_formKey.currentState!.validate()) {
      UserPreferences().removeSession();
      _formKey.currentState!.save();
      _authProvider!.authenticate(_username as String, _password as String)
          .then((response) {
        if (response.status) {
          var session = response.session!;
          Provider.of<UserProvider>(context, listen: false).setUser(session.user);
          initMetaData();
          var providerLoginLocations = session.user.provider?.attrValue(locationAttributeName);
          if (providerLoginLocations != null && providerLoginLocations.isNotEmpty) {
            var assignedLocations = <String, String>{};
            for (var loc in providerLoginLocations) {
              assignedLocations.putIfAbsent(loc['uuid'], () => loc['name']);
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginLocation(assignedLocations: assignedLocations)),
            );
          } else {
            Navigator.pushNamed(context, AppRoutes.loginLocations,);
          }
        } else {
          showLoginFailure(context, response: response);
        }
      });
    } else {
      showLoginFailure(context);
    }
  }

  void initMetaData() async {
    await Provider.of<MetaProvider>(context, listen: false).initMetaData();
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
        hintText: lblUserName,
      ),
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      autofocus: false,
      obscureText: !_passwordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return msgEnterPwd;
        }
        return null;
      },
      onSaved: (value) => _password = value,
      decoration: InputDecoration(
        //suffixIcon: Icon(Icons.visibility, color: Color.fromRGBO(50, 62, 72, 1.0)),
        hintText: lblPassword,
        suffixIcon:  IconButton(
            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            }
        ),
      ),
    );
  }

  Widget _forgotLabel() {
    return TextButton(
      onPressed: (){
        //TODO FORGOT PASSWORD SCREEN GOES HERE
      },
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.blue, fontSize: 15),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        autofocus: false,
        onPressed: _doLogin,
        child: const Text('Login', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  List<Widget> _formWidgets() {
    List<Widget> formElements = [];
    formElements.addAll([
      const SizedBox(height: 10.0),
      _userNameField(),
      const SizedBox(height: 20.0),
      _passwordField(),
      const SizedBox(height: 25.0),
      _authProvider!.loggedInStatus == Status.authenticating
          ? _showLoading()
          : _loginButton(),
      const SizedBox(height: 10.0),
      _forgotLabel()
    ]);
    return formElements;
  }

  void showLoginFailure(BuildContext context, { AuthResponse? response }) {
    String errorMessage = msgLoginFailed;
    if (response != null && response.message != null) {
      errorMessage = response.message!;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void showError(BuildContext context, String err) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err)),
    );
  }
}