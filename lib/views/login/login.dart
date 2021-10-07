import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour/constants/global.dart';
import 'package:tour/providers/auth.provider.dart';
import 'package:tour/views/login/widgets/logo.dart';
import 'package:tour/views/login/widgets/login_text.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  bool showSpinner = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: LOGIN_BG_COLOR,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 65,
              ),
              const Logo(),
              const LoginText(),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'E-mail',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: TEXT_FILL_COLOR,
                          filled: true,
                          prefixIcon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: LOGIN_BUTTON_BG_COLOR, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        controller: emailController),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Password',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                        obscureText: true,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: TEXT_FILL_COLOR,
                          filled: true,
                          prefixIcon: Icon(Icons.lock_outline),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: LOGIN_BUTTON_BG_COLOR, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        controller: passwordController),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(200, 60)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            LOGIN_BUTTON_BG_COLOR),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ))),
                    onPressed: () async {
                      context.read<AuthenticationProvider>().signInUserPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                    },
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: LOGIN_BUTTON_BG_COLOR),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account?',
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Text('asd')));
                    },
                    child: const Text('Sign up',
                        style: TextStyle(
                          color: LOGIN_BUTTON_BG_COLOR,
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
