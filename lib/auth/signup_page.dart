import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/auth/firebase_auth_impl/firebase_auth_impl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _auth = AuthService();
  String? _errormessage;

  Future<void> _signUp() async {
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty || _phoneController.text.isEmpty){
      setState(() {
        _errormessage = 'empty-fields';
      });
      return;
    }else{
        final error = await _auth.signUpWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _phoneController.text,
        );

      setState(() {
        _errormessage = error;
      });

      if (error == null) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
    
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
              const SizedBox(height: 90),
              const Text(
                "Let's Create a Account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Lets join you in... \n enter your details below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
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
                        const Text('Name'),
                        TextField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          controller: _nameController, 
                        ),
                        const SizedBox(height: 20),
                        const Text("Phone"),
                        TextField(                          
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          controller: _phoneController,
                        ),
                        const SizedBox(height: 20),
                        const Text("Email"),
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
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        if (_errormessage != null) ...[                          
                          if (_errormessage == 'empty-fields')
                          const Text(
                            'Please fill all the fields before signing up',
                            style:  TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          if (_errormessage != 'empty-fields')
                          Text(
                            'An unknown error occurred: $_errormessage',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                          
                        const SizedBox(height: 10),
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
                              onPressed: _signUp,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already Have An Account? "),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                child: const Text(
                                  "Sign In",
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
        )),
      ),
    );
  }
}