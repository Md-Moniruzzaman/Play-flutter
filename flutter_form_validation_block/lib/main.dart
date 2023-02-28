import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_validation_block/bloc/my_form_bloc.dart';
import 'package:formz/formz.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => MyFormBloc(),
        child: const FormWidget(),
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<MyFormBloc>().add(EmailUnfocusedEvent());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<MyFormBloc>().add(PasswordUnfocusedEven());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form validation'),
        centerTitle: true,
      ),
      body: BlocListener<MyFormBloc, MyFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            showDialog(
              context: context,
              builder: (_) => const SuccessDialog(),
            );
          }

          if (state.status.isSubmissionInProgress) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Submitting...')));
          }
        },
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              EmailInput(focusNode: _emailFocusNode),
              PasswordInput(focusNode: _passwordFocusNode),
              const SubmitButton()
            ],
          ),
        )),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: const Icon(Icons.email),
            helperText: 'A complete, valid email e.g. example@gmail.com',
            errorText: state.email.invalid
                ? 'Please ensure the email entered is valid'
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) =>
              context.read<MyFormBloc>().add(EmailChangeEvent(email: value)),
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        return TextFormField(
            initialValue: state.password.value,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: 'Password',
              icon: const Icon(Icons.lock),
              helperMaxLines: 2,
              helperText:
                  '''Password should be at least 8 characters with at least one letter and number''',
              errorMaxLines: 2,
              errorText: state.password.invalid
                  ? '''Password must be at least 8 characters and contain at least one letter and number'''
                  : null,
            ),
            obscureText: true,
            onChanged: (value) => context
                .read<MyFormBloc>()
                .add(PasswordChangeEvent(password: value)),
            textInputAction: TextInputAction.done);
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFormBloc, MyFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.status.isValidated
              ? () => context.read<MyFormBloc>().add(FormSubmittedEvent())
              : null,
          child: const Text('Submit'),
        );
      },
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: const <Widget>[
                Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Form Submitted Successfully!',
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
