import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../../../../core/presentation/my_alert_widget.dart';
import '../bloc/auth_bloc.dart';

import 'register_username_page.dart';


class RegisterEmailPage extends StatefulWidget {
  const RegisterEmailPage({super.key});

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  final _textControllerEmail = TextEditingController();
  
  @override
  void dispose() {
    _textControllerEmail.dispose();
    super.dispose();
  }

  void _validate(BuildContext context) async {
    if (_textControllerEmail.text == '') {
      MyAlert.showToast('Email is required.');
      return;
    }
    final provider = BlocProvider.of<AuthBloc>(context, listen: false);
    provider.add(ValidateEmailEvent(email: _textControllerEmail.text));
  }

  void _goToNextPage(BuildContext context) {
    final data = {'email' : _textControllerEmail.text};
    Navigator.of(context).push( 
      MaterialPageRoute(builder: (_) => RegisterUsernamePage(data: data))
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is ValidEmail){
              _goToNextPage(context);
            } else if(state is AuthenticationFailure){
              MyAlert.showToast(state.toString());
            }
          },
          builder: (context, state) => buildBody(context, state)
        )
      )
    );
  }

  Widget buildBody(BuildContext context, AuthState state) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LayoutBuilder(
        builder: (_, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildForm(context, state)
            )
          )
        )
      )
    );
  }

  Widget buildForm(BuildContext context, AuthState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text("What's your email?",
                style: Theme.of(context).textTheme.headlineSmall
              )
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: TextField(
                controller: _textControllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email'
                )
              )
            ),
            SizedBox(
              height: 50.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  state is Authenticating ? null : _validate(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9)
                ), 
                child: state is Authenticating
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    )
                  : const Text('Next')
              )
            )
          ]
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Do you have an account?"),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/signin'),
                child: const Text('Sign in')
              )
            ]
          )
        )
      ]
    );
  }

}