import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DisplayRow {
  final TextStyle textStyle;
  final EdgeInsets padding;
  final TextEditingController _textEditingController = TextEditingController();
  bool nextRemove = false;

  DisplayRow(this.textStyle, this.padding);

  Widget createRow() {
    return Padding(
      child: TextField(
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        style: textStyle,
        decoration: InputDecoration(
          labelText: '',
        ),
      ),
      padding: padding,
    );
  }

  void remove() {
    _textEditingController.text = '';
  }

  void addText(String text) {
    if (nextRemove) {
      remove();
      nextRemove = false;
    }
    _textEditingController.text = '${_textEditingController.text}${text}';
  }

  void deletePrevText() {
    _textEditingController.text = _textEditingController.text.substring(0, _textEditingController.text.length - 1);
  }
}

