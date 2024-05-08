import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _birthdateController = TextEditingController();

  late String _email = '';
  late String _password = '';
  late String _birthdate = '';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    String? savedBirthdate = prefs.getString('birthdate');
    setState(() {
      _email = savedEmail ?? '';
      _password = savedPassword ?? '';
      _birthdate = savedBirthdate ?? '';
    });
    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: _password);
    _birthdateController = TextEditingController(text: _birthdate);
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setString('birthdate', _birthdateController.text);
    setState(() {
      _email = _emailController.text;
      _password = _passwordController.text;
      _birthdate = _birthdateController.text;
      _isEditing = false;
      _updateLastLoginAutofill();
    });
  }

  Future<void> _updateLastLoginAutofill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastEmail', _emailController.text);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing
                ? _saveUserData
                : () => setState(() => _isEditing = true),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                if (!_isEditing) return;
                _updateLastLoginAutofill();
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                if (!_isEditing) return;
                _updateLastLoginAutofill();
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _birthdateController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Birth Date'),
              onTap: () async {
                if (_isEditing) {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _birthdateController.text =
                        pickedDate.toString().split(' ')[0];
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
