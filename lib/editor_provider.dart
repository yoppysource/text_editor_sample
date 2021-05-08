import 'package:flutter/material.dart';
import 'package:text_editor_sample/smart_text_field.dart';

class LineTextEditor {
  final FocusNode focusNode;
  final TextEditingController controller;
  SmartTextType smartTextType;

  LineTextEditor({this.focusNode, this.controller, this.smartTextType});
}

class EditorProvider extends ChangeNotifier {
  // using List for store states for textfield
  List<LineTextEditor> editors = [];
  //SelectedType for storing state for toolbar
  SmartTextType selectedType;

  EditorProvider({SmartTextType defaultType = SmartTextType.T}) {
    selectedType = defaultType;
    //call function when initialize.
    insert(index: 0);
  }

  // int get length => editors.length;
  //focus is the storage for which index user set.
  int get focusedEditerIndex =>
      editors.indexWhere((editor) => editor.focusNode.hasFocus);
  LineTextEditor getEditorByIndex(int index) => editors.elementAt(index);

  void setTypeFromToolbar(SmartTextType type) {
    if (selectedType == type) {
      //If user click the icon, it will set default Text for the fleid
      selectedType = SmartTextType.T;
    } else {
      selectedType = type;
    }
    //get index where user is focused by "focus" and remove it.
    editors[focusedEditerIndex].smartTextType = selectedType;
    notifyListeners();
  }

  void setFocusedTextType(SmartTextType type) {
    selectedType = type;
    notifyListeners();
  }

  void insert({int index, String text, SmartTextType type = SmartTextType.T}) {
    final TextEditingController controller =
        TextEditingController(text: '\u200B' + (text ?? ''));
    controller.addListener(() {
      //Store index for listener
      final int index =
          editors.indexWhere((editor) => editor.controller == controller);
      // \u200B is used for detect(Same as Flag) whether the text is deleted completely
      // or the curser goes to last sentences.
      // Thus, this implementation related to how to merge or delete already existed editors
      if (!controller.text.startsWith('\u200B')) {
        if (index > 0) {
          final previousEditor = editors[index - 1];
          previousEditor.controller.text += controller.text;
          previousEditor.controller.selection = TextSelection.fromPosition(
              TextPosition(
                  offset: editors[index - 1].controller.text.length -
                      controller.text.length));
          previousEditor.focusNode.requestFocus();
          editors.removeAt(index);
          notifyListeners();
        }
      }
      // This implementation is about how to generate new line and new editor instance.
      if (controller.text.contains('\n')) {
        final List<String> _split = controller.text.split('\n');
        controller.text = _split.first;
        final currentEditor = editors[index];
        insert(
            index: index + 1,
            text: _split.last,
            type: currentEditor.smartTextType == SmartTextType.BULLET
                ? SmartTextType.BULLET
                : SmartTextType.T);
        final followingEditor = editors[index + 1];
        followingEditor.controller.selection =
            TextSelection.fromPosition(TextPosition(offset: 1));
        followingEditor.focusNode.requestFocus();
        notifyListeners();
      }
    });
    editors.insert(
        index,
        new LineTextEditor(
            controller: controller,
            smartTextType: type,
            focusNode: FocusNode()));
  }
}
