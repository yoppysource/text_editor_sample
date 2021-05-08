import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:text_editor_sample/editor_provider.dart';
import 'package:text_editor_sample/smart_text_field.dart';

import 'toolbar.dart';

class TextEditor extends StatefulWidget {
  TextEditor({Key key}) : super(key: key);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  bool showToolbar = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (isVisible) {
        if (!isVisible) {
          FocusScope.of(context).unfocus();
        }
        setState(() {
          showToolbar = isVisible;
        });
      },
    );
  }

  @override
  void dispose() {
    KeyboardVisibilityNotification().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorProvider>(
        create: (context) => EditorProvider(),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
                body: Stack(
              children: <Widget>[
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  bottom: 56,
                  child: Consumer<EditorProvider>(builder: (context, model, _) {
                    return ListView.builder(
                        itemCount: model.editors.length,
                        itemBuilder: (context, index) {
                          return Focus(
                              onFocusChange: (hasFocus) {
                                if (hasFocus)
                                  model.setFocusedTextType(
                                      model.editors[index].smartTextType);
                              },
                              child: SmartTextField(
                                lineTextEditor: model.editors[index],
                              ));
                        });
                  }),
                ),
                if (showToolbar)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Selector<EditorProvider, SmartTextType>(
                      selector: (buildContext, model) => model.selectedType,
                      builder: (context, selectedType, _) {
                        return Toolbar(
                          selectedType: selectedType,
                          // Set false not to rebuild uselessly
                          onSelected: Provider.of<EditorProvider>(context,
                                  listen: false)
                              .setTypeFromToolbar,
                        );
                      },
                    ),
                  )
              ],
            )),
          );
        });
  }
}
