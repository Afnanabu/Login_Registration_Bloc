
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
 import 'package:login_registration_screen/register/register_bloc.dart';
import 'package:login_registration_screen/register/register_event.dart';
import 'package:login_registration_screen/register/register_state.dart';
 import 'dart:io';
import 'home_Screen.dart';

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  XFile? imageFile;
  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = new TextEditingController();

  final lastNameEditingController = new TextEditingController();

  final emailEditingController = new TextEditingController();

  final passwordEditingController = new TextEditingController();

  final confirmPasswordEditingController = new TextEditingController();
   bool _obscureText = true;
  RegisterBloc? registerBloc;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .width;
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  BlocListener<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterInitial) {
                          Center(child: Text('Waiting'));
                        }
                        if (state is RegisterSucced ) {
                          Navigator.pushReplacementNamed(
                              context, HomePage.routeName);
                        }
                      },
                      child: BlocBuilder<RegisterBloc, RegisterState>
                        (
                        builder: (context, state) {
                          if (state is RegisterLoading)
                            return Center(child: CircularProgressIndicator());
                          else if (state is RegisterFaild)
                            return // just in case of an unexpected error
                              Center(child: Text(state.message));
                          else
                            return Container();
                        },
                      )
                  ),
                  Container(
                      width: width * 0.3,
                      height:  150,
                      child: CircleAvatar(
                           radius: 100,
                          backgroundImage:AssetImage('Image/logo.png'))),
                  SizedBox(height: 25),
                  // first name
                  TextFormField(
                      autofocus: false,
                      controller: firstNameEditingController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstNameEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "First Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 15),
                  // last name
                  TextFormField(
                      autofocus: false,
                      controller: lastNameEditingController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Last Name cannot be Empty");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lastNameEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Last Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 15),
                  // email field
                  TextFormField(
                      autofocus: false,
                      controller: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        // reg expression for email validation
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 15),

                  // password field
                  TextFormField(
                      autofocus: false,
                      controller: passwordEditingController,
                      obscureText: _obscureText,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                      },
                      onSaved: (value) {
                        passwordEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _toggle,
                          icon: Icon(
                              _obscureText ? Icons.visibility : Icons
                                  .visibility_off),
                        ),
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 15),
                  // confirm field
                  TextFormField(
                      autofocus: false,
                      controller: confirmPasswordEditingController,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (confirmPasswordEditingController.text !=
                            passwordEditingController.text) {
                          return "Password don't match";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        confirmPasswordEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 15),
                  // image doesn't upload to firebase, didn't have time to
                  Row(
                    children: [
                      Text('Add image: ', style: TextStyle(fontSize: 20),),
                      SizedBox(width: 90,),
                      ElevatedButton(
                        child: Text('Upload Photo'),
                        onPressed: () {
                          _showMyDialog(context);
                        },
                      ),
                    ],
                  ),
                  imageFile == null
                      ? Text('No Image Selected!')
                      : Image.file(
                    File(imageFile!.path),
                    width: 100,
                    height: 100,
                    errorBuilder: (BuildContext context,
                        Object error,
                        StackTrace? stackTrace,) {
                      return Icon(
                        Icons.image,
                        size: 45,
                      );
                    },
                  ),
                  SizedBox(height: 25),
                  MaterialButton(
                      color: Colors.transparent,
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width,
                      onPressed: () {
                        signUp(emailEditingController.text,
                            passwordEditingController.text);
                      },
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        registerBloc!.add(SignUpButtonPress(email: emailEditingController.text,
            password: passwordEditingController.text, firstName: firstNameEditingController.text, lastName: lastNameEditingController.text,));
      }
      catch
      (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> _showMyDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Take Picture'),
            actions: [
              ListTile(
                title: Text('From Gallery'),
                onTap: () {
                  _uploadImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text('From Camera'),
                onTap: () {
                  _uploadImage(context, ImageSource.camera);
                },
              ),
            ],
            scrollable: true,
          );
        });
  }

  _uploadImage(BuildContext context, ImageSource imageSource) async {
    var picture = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      imageFile = picture!;
    });
    Navigator.of(context).pop();
  }
}