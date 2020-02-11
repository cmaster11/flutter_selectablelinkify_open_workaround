import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectableTextTapWorkaroundWrapper extends StatefulWidget {
  final TextSpan textSpan;
  final SelectableText selectableText;

  const SelectableTextTapWorkaroundWrapper({
    Key key,
    @required this.textSpan,
    @required this.selectableText,
  }) : super(key: key);

  @override
  _SelectableTextTapWorkaroundWrapperState createState() => _SelectableTextTapWorkaroundWrapperState();
}

class _SelectableTextTapWorkaroundWrapperState extends State<SelectableTextTapWorkaroundWrapper> {
  Paragraph _paragraph;
  ParagraphStyle _paragraphStyle;
  ParagraphConstraints _paragraphConstraints;

  int _currentTapUrlSpanIndex;
  Offset _startPosition;
  Offset _nowPosition;
  Timer _cancelTapTimer;

  bool _needRebuildParagraph(ParagraphStyle style, ParagraphConstraints constraints) {
    if (_paragraph == null || _paragraphConstraints != constraints || _paragraphStyle != style) {
      _paragraphStyle = style;
      _paragraphConstraints = constraints;
      return true;
    } else {
      return false;
    }
  }

  TextSpan _getSpanByOffset(
    Offset offset,
    TextStyle textStyle,
    BoxConstraints constraints,
  ) {
    if (_needRebuildParagraph(
      ParagraphStyle(
        fontSize: textStyle.fontSize,
        fontFamily: textStyle.fontFamily,
        fontWeight: textStyle.fontWeight,
        fontStyle: textStyle.fontStyle,
      ),
      ParagraphConstraints(width: constraints.maxWidth),
    )) {
      final ParagraphBuilder builder = ParagraphBuilder(_paragraphStyle);
      widget.textSpan.build(builder);
      _paragraph = builder.build();
      _paragraph.layout(_paragraphConstraints);
    }
    final TextPosition position = _paragraph.getPositionForOffset(offset);
    if (position == null) {
      return null;
    }
    return widget.textSpan.getSpanForPosition(position) as TextSpan;
  }

  void _checkTap() {
    if (_currentTapUrlSpanIndex != null) {
      final span = widget.textSpan.children[_currentTapUrlSpanIndex] as TextSpan;
      _currentTapUrlSpanIndex = null;
      if ((_nowPosition - _startPosition).distanceSquared <= 900 && _cancelTapTimer.isActive) {
        _cancelTapTimer.cancel();
        final recognizer = span.recognizer as TapGestureRecognizer;
        if (recognizer?.onTap != null) {
          recognizer.onTap();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Listener(
        onPointerDown: (PointerDownEvent event) {
          _startPosition = event.localPosition;
          _nowPosition = event.localPosition;
          _cancelTapTimer = Timer(const Duration(milliseconds: 300), _checkTap);
          final TextSpan span = _getSpanByOffset(
            _startPosition,
            // This may need to NOT be hardcoded
            Theme.of(context).textTheme.bodyText2,
            constraints,
          );
          if (span.recognizer is TapGestureRecognizer) {
            _currentTapUrlSpanIndex = widget.textSpan.children.indexOf(span);
            if (_currentTapUrlSpanIndex == -1) {
              _currentTapUrlSpanIndex = null;
              return;
            }
          }
        },
        onPointerMove: (PointerMoveEvent event) => _nowPosition = event.localPosition,
        onPointerUp: (PointerUpEvent event) => _checkTap(),
        child: widget.selectableText,
      ),
    );
  }
}
