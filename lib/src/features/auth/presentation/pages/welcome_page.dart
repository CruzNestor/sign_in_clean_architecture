import 'package:flutter/material.dart';

import '../../../../core/constants/ui_constants.dart';
import '../../../../core/presentation/my_appbar_widget.dart';

import 'register_email_page.dart';
import 'sign_in_page.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MyAppBar.hidden(context),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 40, bottom: 10),
          child: Text(
            UIConstants.APP_NAME, 
            textAlign: TextAlign.center, 
            style: Theme.of(context).textTheme.headlineLarge
          )
        ),
        Container(
          alignment: Alignment.center,
          child: const FlutterLogo(
            size: 200
          )
        ),
        SizedBox(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10),
                child: Text('We welcome to',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                )
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  UIConstants.APP_NAME,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                )
              ),
              Container(
                height: 50.0,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RegisterEmailPage())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9)
                  ), 
                  child: const Text('Sign Up')
                )
              ),
              Container(
                height: 50.0,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10, right: 10, bottom: 20, left: 10),
                child: OutlinedButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignInPage()),
                    );
                  },
                  child: const Text('Sign in')
                )
              )
            ]
          )
        )
      ]
    );
  }

}