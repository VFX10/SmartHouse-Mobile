import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final String placeholder;

  final Icon icon;
  final Widget suffix;
  final List items;
  final String defaultValue;
  final Function(dynamic) onChanged;
  final dynamic Function(String) validator;
  final bool autoValidate;
  final Color cardBorderColor;

  List<DropdownMenuItem> getDropDownMenuItems(List source) {
    List<DropdownMenuItem> items = new List();
    for (var element in source) {
      items.add(new DropdownMenuItem(
          value: element, child: Text(element.toString())));
    }
    return items;
  }

  CustomDropDownButton(this.defaultValue,
      {this.placeholder = "",
      this.onChanged,
      this.items,
      this.icon,
      this.suffix,
      this.cardBorderColor = Colors.white,
      this.validator,
      this.autoValidate = false})
      : super();

  @override
  Widget build(BuildContext context) {
    final convertedItems = getDropDownMenuItems(items);
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: this.cardBorderColor == null
                    ? Colors.white
                    : this.cardBorderColor,
                width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonFormField(
            validator: this.validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.only(left: 13, right: 9),
              prefixIcon: this.icon,
              suffixIcon: this.suffix,
              labelText: this.placeholder,
            ),
            value: this.defaultValue,
            items: convertedItems,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
