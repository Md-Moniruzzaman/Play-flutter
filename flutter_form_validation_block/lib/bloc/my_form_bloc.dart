import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_form_validation_block/models/models.dart';
import 'package:formz/formz.dart';

part 'my_form_event.dart';
part 'my_form_state.dart';

class MyFormBloc extends Bloc<MyFormEvent, MyFormState> {
  MyFormBloc() : super(MyFormInitial()) {
    on<EmailChangeEvent>((event, emit) {
      final email = Email.dirty(event.email);

      emit(state.copyWith(
          email: email.valid ? email : Email.pure(event.email),
          status: Formz.validate([email, state.password])));
    });

    on<PasswordChangeEvent>((event, emit) {
      final password = Password.dirty(event.password);

      emit(state.copyWith(
          password: password.valid ? password : Password.pure(event.password),
          status: Formz.validate([state.email, password])));
    });

    on<EmailUnfocusedEvent>((event, emit) {
      final email = Email.dirty(state.email.value);

      emit(state.copyWith(
          email: email, status: Formz.validate([email, state.password])));
    });

    on<PasswordUnfocusedEven>((event, emit) {
      final password = Password.dirty(state.password.value);

      emit(state.copyWith(
          password: password, status: Formz.validate([state.email, password])));
    });

    on<FormSubmittedEvent>((event, emit) {
      final email = Email.dirty(state.email.value);
      final password = Password.dirty(state.password.value);

      emit(state.copyWith(
          email: email,
          password: password,
          status: Formz.validate([email, password])));

      if (state.status.isValidated) {
        emit(state.copyWith(status: FormzStatus.submissionInProgress));
        Future<void>.delayed(const Duration(seconds: 2));
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }
    });
  }
}
