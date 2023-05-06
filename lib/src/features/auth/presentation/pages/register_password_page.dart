import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../../../../core/presentation/my_alert_widget.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';


class RegisterPasswordPage extends StatefulWidget {
  const RegisterPasswordPage({required this.data, super.key});
  final Map<String, dynamic> data;

  @override
  State<RegisterPasswordPage> createState() => _RegisterPasswordPageState();
}

class _RegisterPasswordPageState extends State<RegisterPasswordPage> {
  final _textControllerPass = TextEditingController();

  @override
  void dispose() {
    _textControllerPass.dispose();
    super.dispose();
  }

  void _validate(BuildContext context) async {
    if(_textControllerPass.text == ''){
      MyAlert.showToast('Password is required');
      return;
    }

    final provider = BlocProvider.of<AuthBloc>(context);
    provider.add(SignUpEvent(
      email: widget.data['email'], 
      password: _textControllerPass.text,
      username: widget.data['username']
    ));
  }

  void _goToNextPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false
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
            if(state is Authenticated){
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
              child: Text("Create a password", style: Theme.of(context).textTheme.headlineSmall),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: MyPasswordField(
                controller: _textControllerPass,
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
        )
      ]
    );
  }

}