import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spm_shoppingmall_mobile/auth/firebase_auth_impl/firebase_auth_impl.dart';
import 'package:spm_shoppingmall_mobile/common/home_page.dart';
import 'package:spm_shoppingmall_mobile/eventsFunction/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();
  String? _errormessage;
  var error;

  Future<void> _signIn() async {
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      setState(() {
        _errormessage = 'empty-fields';
      });
      return;
    }else{
      error = await _auth.signInWithEmailAndPassword(
        _emailController.text, _passwordController.text);

    setState(() {
      _errormessage = error;
    });
    }

    if (error == null) {
      //get current user and pass it to the home page
      User? user = FirebaseAuth.instance.currentUser;

      _setUserIDInPreferences(user!.uid);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
    } else {
      debugPrint('Login failed');
    }
  }

  Future<void> _setUserIDInPreferences(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
        color: const Color.fromARGB(255, 5, 176, 255),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Text(
              "Let's Sign you In",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign in with your details \n that you have entered during registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 100),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text('Email'),
                      TextField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      const Text("Password"),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 10),
                      if (_errormessage != null) ...[
                        if (_errormessage == 'empty-fields')
                          const Text(
                            'Please enter email and password before login',
                            style:  TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        if (_errormessage == 'channel-error')
                          const Text(
                            'There was a problem with the authentication channel. Please try again.',
                            style:  TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        if (_errormessage == 'popup-blocked')
                          const Text(
                            'Popup blocked. Please allow popups and try again.',
                            style:  TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        if (_errormessage == 'network-error')
                          const Text(
                            'Network error. Please check your internet connection.',
                            style:  TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        if (_errormessage == 'invalid-email')
                          const Text(
                            'The email address is invalid. Please provide a valid email.',
                            style:  TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        // Add more conditions as needed for other error types
                        if (_errormessage != 'channel-error' &&
                            _errormessage != 'popup-blocked' &&
                            _errormessage != 'network-error' &&
                            _errormessage != 'invalid-email'&&
                            _errormessage != 'empty-fields')
                          Text(
                            '$_errormessage',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                      ],
                        
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _signIn,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't Have An Account? "),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signup');
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
        ),
      ),
    );
  }
}