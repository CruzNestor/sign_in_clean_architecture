import 'package:flutter/material.dart';


class MyPasswordField extends StatefulWidget {
  const MyPasswordField({
    this.controller,
    this.hintText = 'Password',
    super.key
  });
  final TextEditingController? controller;
  final String hintText;
  @override
  State<MyPasswordField> createState() => _MyPasswordFieldState();
}

class _MyPasswordFieldState extends State<MyPasswordField> {
  bool _isObscure = true;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller!,
      obscureText: _isObscure,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: _focusNode.hasFocus 
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.70)

          ),
          onPressed: (){
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        )
      ),
    );
    
  }
}