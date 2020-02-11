# SelectableLinkify workaround

This project contains a workaround for https://github.com/flutter/flutter/issues/43494 .

Directly inspired by https://github.com/flutter/flutter/issues/43494#issuecomment-581232016 , just put in a working example.

## Relevant files

* [`lib/main.dart`](lib/main.dart): the example, with working and non-working text.
* [`lib/selectable_text_workaround.dart`](lib/selectable_text_workaround.dart#L74): the actual workaround.
* [`lib/fixed_selectable_linkify.dart`](lib/fixed_selectable_linkify.dart#L154): an example on how to fix a [`SelectableLinkfy`](https://pub.dev/packages/flutter_linkify) widget.