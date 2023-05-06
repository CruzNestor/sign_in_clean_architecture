import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../../../../core/presentation/my_alert_widget.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';

import 'register_email_page.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _textControllerUser = TextEditingController();
  final _textControllerPass = TextEditingController();

  @override
  void dispose() {
    _textControllerUser.dispose();
    _textControllerPass.dispose();
    super.dispose();
  }

  void _signIn(BuildContext context) async{
    final username = _textControllerUser.text.trim();
    final password = _textControllerPass.text;

    if(username.isEmpty || password.isEmpty){
      MyAlert.showToast('The username and password are required.');
      return;
    }
    final provider = BlocProvider.of<AuthBloc>(context);
    provider.add(SignInEvent(username: username, password: password));
  }

  void _goToHome(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: buildScaffold(context)
    );
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
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
              child: buildForm(context)
            )
          )
        )
      )
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Column(children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Hello again!', style: Theme.of(context).textTheme.headlineSmall),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('Account information', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: _textControllerUser,
              decoration: const InputDecoration(
                hintText: 'Email or username'
              )
            )
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: MyPasswordField(
              controller: _textControllerPass
            )
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (_, state) {
              if (state is Authenticated) {
                _goToHome(context);
              } else if (state is AuthenticationFailure) {
                MyAlert.showToast(state.toString());
              }
            },
            builder: (context, state) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: (){
                      state is Authenticating ? null : _signIn(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9)
                    ),  
                    child: state is Authenticating 
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)
                        )
                      : const Text('Sign in')
                  ),
                )
              );
            }
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't you have an account?"),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegisterEmailPage())
                ), 
                child: const Text('Sign up')
              )
            ]
          )
        )
      ]
    );
  }

}