

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_registration_screen/Ui/Register_Screen.dart';
import 'package:login_registration_screen/login/login_bloc.dart';
import 'package:login_registration_screen/login/login_event.dart';
import 'package:login_registration_screen/login/login_state.dart';

import 'home_Screen.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  LoginBloc? loginBloc;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
   loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginInitial) {
                          Center(child: Text('Waiting'));
                        }

                        if (state is LoginSucced) {
                          Navigator.pushReplacementNamed(context, HomePage.routeName);
                        }

                      },
                      child: BlocBuilder<LoginBloc, LoginState>
                        (
                        builder: (context, state){
                          if (state is LoginLoading)
                            return Center(child: CircularProgressIndicator());
                          else if (state is LoginFailed)
                            return // just in case of an unexpected error
                              Center(child: Text(state.message));
                          else
                            return Container();
                        },
                      )
                  ),
                  Container(
                      width: width * 0.3,
                      height: height * 0.3,
                      child: CircleAvatar(
                           radius: 100,
                          backgroundImage: AssetImage('Image/logo.png'))),
                  SizedBox(height: 25),

                  SizedBox(height: 25),
                  TextField(
                      autofocus: false,
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Enter Your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  TextField(
                      autofocus: false,
                      controller: passwordController,
                      obscureText: _obscureText,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _toggle,
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  MaterialButton(
                      color: Colors.transparent,
                      height: 50,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        loginBloc!.add(SignInButtonPressed(email: usernameController.text, password: passwordController.text));},
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen())),
                          child: Text('Sign up.'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}