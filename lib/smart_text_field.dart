import 'package:flutter/material.dart';
import 'package:text_editor_sample/editor_provider.dart';

enum SmartTextType { H1, T, QUOTE, BULLET }

//Using extension for adding attribute for smartTextType
extension SmartTextStyle on SmartTextType {
  TextStyle get textStyle {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextStyle(
            fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.white70);
      case SmartTextType.H1:
        return TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
        break;
      default:
        return TextStyle(fontSize: 16.0);
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case SmartTextType.H1:
        return EdgeInsets.fromLTRB(16, 24, 16, 8);
        break;
      case SmartTextType.BULLET:
        return EdgeInsets.fromLTRB(24, 8, 16, 8);
      default:
        return EdgeInsets.fromLTRB(16, 8, 16, 8);
    }
  }

  TextAlign get align {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextAlign.center;
        break;
      default:
        return TextAlign.start;
    }
  }

  String get prefix {
    switch (this) {
      case SmartTextType.BULLET:
        return '\u2022 ';
        break;
      default:
    }
  }
}

class SmartTextField extends StatelessWidget {
  final LineTextEditor lineTextEditor;

  const SmartTextField({Key key, this.lineTextEditor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: lineTextEditor.controller,
        focusNode: lineTextEditor.focusNode,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: Colors.teal,
        textAlign: lineTextEditor.smartTextType.align,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixText: lineTextEditor.smartTextType.prefix,
            prefixStyle: lineTextEditor.smartTextType.textStyle,
            isDense: true,
            contentPadding: lineTextEditor.smartTextType.padding),
        style: lineTextEditor.smartTextType.textStyle);
  }
}
