import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/welcome_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goToWelcome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false
    );
  }

  void _signOut(BuildContext context){
    AuthBloc provider = BlocProvider.of<AuthBloc>(context);
    provider.add(SignOutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: buildScaffold(context),
    );
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home')
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener:(context, state) {
          if(state is Unauthenticated){
            _goToWelcome(context);
          }
        },
        builder: (context, state) {
          return buildBody(context, state);
        }
      ),
    );
  }

  Widget buildBody(BuildContext context, AuthState state){
    if(state is AuthInitial){
      final provider = BlocProvider.of<AuthBloc>(context);
      provider.add(GetUserEvent());
    }
    return Column(children: [
      if(state is UserData)
        Container(
          alignment: Alignment.center,
          child: Text('Welcome ${state.user.username}', 
            style: Theme.of(context).textTheme.titleLarge
          )
        ),
      Expanded(
        child: Center(
          child: SizedBox(
            height: 50.0,
            width: 150.0,
            child: ElevatedButton(
              onPressed: () {
                state is Authenticating || state is LoadingUser 
                  ? null 
                  : _signOut(context);
              }, 
              child: state is Authenticating ||state is LoadingUser
                ? const SizedBox(width: 50, height: 50,
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Text('Sign out')
            )
          ),
        )
      )
    ]);
  }

}