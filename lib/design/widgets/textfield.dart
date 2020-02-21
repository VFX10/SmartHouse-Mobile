import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final Icon icon;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final Widget suffix;
  final Function() onSubmitted;
  final Function(dynamic) onChanged;
  final dynamic Function(String) validator;
  final FocusNode focusNode;
  final bool autoValidate, enabled;

  Widget generateTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
          cursorRadius: Radius.circular(16.0),
          onChanged: this.onChanged,
          enabled: this.enabled,
          controller: this.controller,
          obscureText: isPassword,
          textInputAction: this.inputAction,
          focusNode: this.focusNode,
          validator: this.validator,
          autovalidate: this.autoValidate,
          onEditingComplete: this.onSubmitted,
          //onSubmitted: this.onSubmitted,
          keyboardType: this.inputType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 3.0),),
            contentPadding: EdgeInsets.symmetric(horizontal: 13),
            prefixIcon: this.icon,
            suffixIcon: this.suffix,
            labelText: this.placeholder,
            alignLabelWithHint: true,
          ),
          ),
    );
  }

  CustomTextField(
      {this.placeholder = '',
      this.controller,
      this.isPassword = false,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.focusNode,
      this.enabled = true,
      this.onChanged,
      this.onSubmitted,
      this.icon,
      this.suffix,
      this.validator,
      this.autoValidate = false})
      : super();

  @override
  Widget build(BuildContext context) {
    return generateTextField();
  }
}
