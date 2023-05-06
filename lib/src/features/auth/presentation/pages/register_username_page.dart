import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../../../../core/presentation/my_alert_widget.dart';
import '../bloc/auth_bloc.dart';

import 'register_password_page.dart';


class RegisterUsernamePage extends StatefulWidget {
  const RegisterUsernamePage({required this.data, super.key});
  final Map<String, dynamic> data;
  @override
  State<RegisterUsernamePage> createState() => _RegisterUsernamePageState();
}

class _RegisterUsernamePageState extends State<RegisterUsernamePage> {
  final _textControllerUsername = TextEditingController();

  @override
  void dispose() {
    _textControllerUsername.dispose();
    super.dispose();
  }

  void _validate(BuildContext context) async {
    if(_textControllerUsername.text == ''){
      MyAlert.showToast('Username is required');
      return;
    }
    final provider = BlocProvider.of<AuthBloc>(context);
    provider.add(ValidateUsernameEvent(username: _textControllerUsername.text));
  }

  void _goToNextPage(BuildContext context) {
    widget.data['username'] = _textControllerUsername.text;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RegisterPasswordPage(data: widget.data))
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
            if(state is ValidUsername){
              _goToNextPage(context);
            } else if(state is AuthenticationFailure){
              MyAlert.showToast(state.toString());
            }
          },
          builder: (context, state) => buildBody(context, state),
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
              child: Text("Create a username", style: Theme.of(context).textTheme.headlineSmall),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: TextField(
                controller: _textControllerUsername,
                decoration: const InputDecoration(
                  hintText: 'Username'
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
                  backgroundColor: Theme.of(context).primaryColor
                ),
                child: state is Authenticating 
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    ) 
                  : const Text('Next')
              )
            )
          ]
        )
      ]
    );
  }

}