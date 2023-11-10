import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacemoon/Widget/AppFlowy/desktop_editor.dart';
import 'package:spacemoon/Widget/AppFlowy/mobile_editor.dart';

String exampleJson =
    '{"document":{"type":"page","children":[{"type":"heading","data":{"level":3,"delta":[{"insert":"AppFlowy Editor is now in","attributes":{"italic":false,"bold":true}}]}},{"type":"heading","data":{"level":1,"delta":[{"insert":"👏 Mobile"},{"insert":" ","attributes":{"italic":false,"bold":true}},{"insert":"📱","attributes":{"bold":true}}]}},{"type":"paragraph","data":{"level":1,"delta":[{"insert":"AppFlowy Editor","attributes":{"bold":true,"italic":false,"underline":false}},{"insert":"  empowers your flutter app with seamless document editing features.","attributes":{"bold":false,"italic":false,"underline":false}}]}},{"type":"paragraph","data":{"delta":[{"insert":"Adding the "},{"insert":"AppFlowy Editor","attributes":{"bold":true}},{"insert":" package in your flutter app will allow you to unlock powerful and customizable document editing capabilities, all without building it from scratch. "}]}},{"type":"heading","data":{"level":1,"delta":[{"insert":"👀 Let’s check it out"}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Text Decoration"}]}},{"type":"paragraph","data":{"delta":[{"insert":"Bold","attributes":{"bold":true}},{"insert":"  "},{"insert":"Italic  ","attributes":{"italic":true}},{"insert":"underLine","attributes":{"italic":false,"underline":true}},{"insert":"   ","attributes":{"italic":true}},{"insert":"Strikethrough","attributes":{"italic":false,"strikethrough":true}}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Colorful Text"}]}},{"type":"paragraph","data":{"delta":[{"insert":"Infuse","attributes":{"font_color":"0xfff44336"}},{"insert":" "},{"insert":"your","attributes":{"font_color":"0xffffeb3b"}},{"insert":" "},{"insert":"texts","attributes":{"font_color":"0xff2196f3"}},{"insert":" "},{"insert":"with","attributes":{"font_color":"0xff4caf50"}},{"insert":" "},{"insert":"the","attributes":{"font_color":"0xff795548"}},{"insert":" "},{"insert":"vibrant","attributes":{"font_color":"0xffe91e63"}},{"insert":" "},{"insert":"hues","attributes":{"font_color":"0xff9c27b0"}},{"insert":" "},{"insert":"of","attributes":{"font_color":"0xff9e9e9e"}},{"insert":" "},{"insert":"a","attributes":{"bg_color":"0x4d9e9e9e"}},{"insert":" "},{"insert":"rainbow","attributes":{"bg_color":"0x4df44336"}},{"insert":" "},{"insert":"to","attributes":{"bg_color":"0x4d4caf50"}},{"insert":" "},{"insert":"brighten","attributes":{"bg_color":"0x4dffeb3b"}},{"insert":" "},{"insert":"up","attributes":{"bg_color":"0x4d795548"}},{"insert":" "},{"insert":"your","attributes":{"bg_color":"0x4d9c27b0"}},{"insert":" "},{"insert":"day","attributes":{"bg_color":"0x4d2196f3"}},{"insert":"! "}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Lists"}]}},{"type":"todo_list","data":{"checked":false,"delta":[{"insert":"To Do List"}]}},{"type":"todo_list","data":{"delta":[{"insert":"Checked"}],"checked":true}},{"type":"bulleted_list","data":{"delta":[{"insert":"Bulleted List"}]}},{"type":"bulleted_list","data":{"delta":[]}},{"type":"numbered_list","data":{"delta":[{"insert":"Numbered List"}]}},{"type":"numbered_list","data":{"delta":[]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Link & Quote"}]}},{"type":"quote","data":{"delta":[{"insert":"Here’s where you can find the "},{"insert":"AppFlowy Editor flutter package","attributes":{"href":"https://pub.dev/packages/appflowy_editor"}},{"insert":" to add to your environment."}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Code Inline"}]}},{"type":"paragraph","data":{"delta":[{"insert":"flutter pub add appflowy_editor\\nflutter pub get","attributes":{"code":true}}]}}]}}';

class AppFlowy extends StatefulWidget {
  const AppFlowy({super.key, required this.jsonData});

  final String jsonData;

  @override
  State<AppFlowy> createState() => _AppFlowyState();
}

class _AppFlowyState extends State<AppFlowy> {
  late EditorState editorState;

  String get jsonData => widget.jsonData;
  String get toFile => jsonEncode(editorState.document.toJson());

  @override
  void initState() {
    super.initState();

    editorState = EditorState(
      document: Document.fromJson(
        Map<String, Object>.from(
          json.decode(jsonData),
        ),
      ),
    );
    editorState.logConfiguration
      ..handler = debugPrint
      ..level = LogLevel.off;

    // _editorState.transactionStream.listen((event) {
    //   if (event.$1 == TransactionTime.after) {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: PlatformExtension.isDesktopOrWeb,
      appBar: AppBar(
        title: const Text('Editor'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: PlatformExtension.isDesktopOrWeb
              ? DesktopEditor(
                  editorState: editorState,
                  textDirection: TextDirection.ltr,
                  // blockComponentBuilders: customBuilder(editorState),
                  // editorStyle: customizeEditorStyle(),
                )
              : MobileEditor(
                  editorState: editorState,
                  // blockComponentBuilders: customBuilder(editorState),
                  editorStyle: customizeEditorStyle(),
                ),
        ),
      ),
    );
  }
}

EditorStyle customizeEditorStyle() {
  return EditorStyle(
    padding: PlatformExtension.isDesktopOrWeb
        ? const EdgeInsets.only(left: 200, right: 200)
        : const EdgeInsets.symmetric(horizontal: 20),
    cursorColor: Colors.green,
    selectionColor: Colors.green.withOpacity(0.5),
    textStyleConfiguration: TextStyleConfiguration(
      text: GoogleFonts.poppins(
        fontSize: 14.0,
        color: Colors.white,
      ),
      bold: const TextStyle(
        fontWeight: FontWeight.w900,
      ),
      href: TextStyle(
        color: Colors.amber,
        decoration: TextDecoration.combine(
          [
            TextDecoration.overline,
            TextDecoration.underline,
          ],
        ),
      ),
      code: const TextStyle(
        fontSize: 14.0,
        fontStyle: FontStyle.italic,
        color: Colors.blue,
        backgroundColor: Colors.black12,
      ),
    ),
    textSpanDecorator: (context, node, index, text, textSpan) {
      final attributes = text.attributes;
      final href = attributes?[AppFlowyRichTextKeys.href];
      if (href != null) {
        return TextSpan(
          text: text.text,
          style: textSpan.style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              debugPrint('onTap: $href');
            },
        );
      }
      return textSpan;
    },
  );
}

/// custom the block style
Map<String, BlockComponentBuilder> customBuilder(
  EditorState editorState,
) {
  final configuration = BlockComponentConfiguration(
    padding: (node) {
      if (HeadingBlockKeys.type == node.type) {
        return const EdgeInsets.symmetric(vertical: 30);
      }
      return const EdgeInsets.symmetric(vertical: 5);
    },
    textStyle: (node) {
      if (HeadingBlockKeys.type == node.type) {
        return const TextStyle(color: Colors.yellow);
      }
      return const TextStyle();
    },
  );

  // customize heading block style
  return {
    ...standardBlockComponentBuilderMap,
    // heading block
    HeadingBlockKeys.type: HeadingBlockComponentBuilder(
      configuration: configuration,
    ),
    // todo-list block
    TodoListBlockKeys.type: TodoListBlockComponentBuilder(
      configuration: configuration,
      iconBuilder: (context, node) {
        final checked = node.attributes[TodoListBlockKeys.checked] as bool;
        return GestureDetector(
          onTap: () => editorState.apply(
            editorState.transaction..updateNode(node, {TodoListBlockKeys.checked: !checked}),
          ),
          child: Icon(
            checked ? Icons.check_box : Icons.check_box_outline_blank,
            size: 20,
            color: Colors.white,
          ),
        );
      },
    ),
    // bulleted list block
    BulletedListBlockKeys.type: BulletedListBlockComponentBuilder(
      configuration: configuration,
      iconBuilder: (context, node) {
        return Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          child: const Icon(
            Icons.circle,
            size: 10,
            color: Colors.red,
          ),
        );
      },
    ),
    // quote block
    QuoteBlockKeys.type: QuoteBlockComponentBuilder(
      configuration: configuration,
      iconBuilder: (context, node) {
        return const EditorSvg(
          width: 20,
          height: 20,
          padding: EdgeInsets.only(right: 5.0),
          name: 'quote',
          color: Colors.pink,
        );
      },
    ),
  };
}
