import 'package:coderz_inc/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  void loginUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                height: deviceHeight * 0.25,
                child: FittedBox(
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/employee.png',
                    ),
                    radius: 120,
                  ),
                ),
              ),
              Container(
                height: deviceHeight * 0.65,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login Now',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.01,
                        ),
                        Text('Please enter the details below to continue'),
                        SizedBox(
                          height: constraints.maxHeight * 0.08,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.12,
                          decoration: BoxDecoration(
                            color: Color(0xffB4B4B4).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Center(
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'employee@xyz.com',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.12,
                          decoration: BoxDecoration(
                            color: Color(0xffB4B4B4).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Center(
                              child: TextField(
                                controller: passwordController,
                                obscureText: _isVisible ? false : true,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisible = !_isVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      color: Color.fromARGB(245, 54, 111, 209)),
                                ))
                          ],
                        ),
                        Container(
                          // height: deviceHeight * 0.10,
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.05,
                          ),
                          child: ElevatedButton(
                            onPressed: loginUser,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(245, 54, 111, 209),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                          ),

                          // child: Container(
                          //   color: Colors.green,
                          //   height: deviceHeight * 0.05,
                          // ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
