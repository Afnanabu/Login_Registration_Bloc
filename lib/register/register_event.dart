 import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable{
  const RegisterEvent();

  @override
   List<Object?> get props => [];
}
class SignUpButtonPress extends RegisterEvent{
  String? email,password,firstName,lastName;
  SignUpButtonPress({  this.email,  this.password, this.firstName ,this.lastName});
}