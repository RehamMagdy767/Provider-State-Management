import 'package:ass2/AllStoreScreen.dart';
import 'package:ass2/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:ass2/SQLite/database_helper.dart';
import 'package:ass2/provider/store_provider.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
        return false; // Return false to avoid the default behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign in',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final db = DatabaseHelper.instance;
                        final user =
                            await db.getUserByEmail(_emailController.text);

                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User not found'),
                            ),
                          );
                        } else if (user.password != _passwordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Incorrect password'),
                            ),
                          );
                        } else {
                          final storeProvider = Provider.of<StoreProvider>(
                              context,
                              listen: false);
                          storeProvider.setCurrentUser(user);
                          storeProvider.fetchUserFavorites(
                              user.id!); // Load the user's favorite stores

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AllStoresScreen(),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred: $e'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Sign In'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
