part of 'my_form_bloc.dart';

abstract class MyFormEvent extends Equatable {
  const MyFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChangeEvent extends MyFormEvent {
  const EmailChangeEvent({required this.email});
  final String email;

  @override
  List<Object> get props => [email];
}

class EmailUnfocusedEvent extends MyFormEvent {}

class PasswordChangeEvent extends MyFormEvent {
  const PasswordChangeEvent({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class PasswordUnfocusedEven extends MyFormEvent {}

class FormSubmittedEvent extends MyFormEvent {}
