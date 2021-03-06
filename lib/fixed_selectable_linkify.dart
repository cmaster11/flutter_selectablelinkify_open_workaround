import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';
import 'package:selectabletext_fix/selectable_text_workaround.dart';

/// Turns URLs into links
class FixedSelectableLinkify extends StatelessWidget {
  /// Text to be linkified
  final String text;

  /// Linkifiers to be used for linkify
  final List<Linkifier> linkifiers;

  /// Callback for tapping a link
  final LinkCallback onOpen;

  /// linkify's options.
  final LinkifyOptions options;

  // TextSpan

  /// Style for non-link text
  final TextStyle style;

  /// Style of link text
  final TextStyle linkStyle;

  // RichText

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Text direction of the text
  final TextDirection textDirection;

  /// The maximum number of lines for the text to span, wrapping if necessary
  final int maxLines;

  /// The strut style used for the vertical layout
  final StrutStyle strutStyle;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis textWidthBasis;

  // SelectableText

  /// Defines the focus for this widget.
  final FocusNode focusNode;

  /// Whether to show cursor
  final bool showCursor;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Configuration of toolbar options
  final ToolbarOptions toolbarOptions;

  /// How thick the cursor will be
  final double cursorWidth;

  /// How rounded the corners of the cursor should be
  final Radius cursorRadius;

  /// The color to use when painting the cursor
  final Color cursorColor;

  /// Determines the way that drag start behavior is handled
  final DragStartBehavior dragStartBehavior;

  /// If true, then long-pressing this TextField will select text and show the cut/copy/paste menu,
  /// and tapping will move the text caret
  final bool enableInteractiveSelection;

  /// Called when the user taps on this selectable text (not link)
  final GestureTapCallback onTap;

  final ScrollPhysics scrollPhysics;

  const FixedSelectableLinkify({
    Key key,
    @required this.text,
    this.linkifiers = defaultLinkifiers,
    this.onOpen,
    this.options,
    // TextSpan
    this.style,
    this.linkStyle,
    // RichText
    this.textAlign,
    this.textDirection,
    this.maxLines,
    // SelectableText
    this.focusNode,
    this.strutStyle,
    this.showCursor = false,
    this.autofocus = false,
    this.toolbarOptions,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.scrollPhysics,
    this.textWidthBasis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final elements = linkify(
      text,
      options: options,
      linkifiers: linkifiers,
    );

    final span = buildTextSpan(
      elements,
      style: Theme.of(context).textTheme.bodyText2.merge(style),
      onOpen: onOpen,
      linkStyle: Theme.of(context)
          .textTheme
          .bodyText2
          .merge(style)
          .copyWith(
            color: Colors.blueAccent,
            decoration: TextDecoration.underline,
          )
          .merge(linkStyle),
    );

    final selectableText = SelectableText.rich(
      span,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      focusNode: focusNode,
      strutStyle: strutStyle,
      showCursor: showCursor,
      autofocus: autofocus,
      toolbarOptions: toolbarOptions,
      cursorWidth: cursorWidth,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      onTap: onTap,
      scrollPhysics: scrollPhysics,
      textWidthBasis: textWidthBasis,
    );

    // This is the required wrapper fix
    return SelectableTextTapWorkaroundWrapper(
      textSpan: span,
      selectableText: selectableText,
    );
  }
}
