import '../logic/sizes_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/text_field_container.dart';
import '../components/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final  onTap;
  final ValueChanged<String> onSubmitted;
  final onEditingComplete;
  final bool readOnlyFlag;
  final String errorText;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnlyFlag=false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Center(
        child: TextField(
          keyboardType: keyboardType,
          enableInteractiveSelection: true,
          onTap: onTap,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          cursorColor: kPrimaryColor,
          readOnly: readOnlyFlag,
          decoration: InputDecoration(
            errorText: errorText,
            contentPadding: EdgeInsets.only(bottom: displayHeight(context)*0.01,),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            isCollapsed: true,

            icon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.subtitle2,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
