import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:spacemoon/Static/theme.dart';

String exampleJson =
    '{"document":{"type":"page","children":[{"type":"heading","data":{"level":3,"delta":[{"insert":"AppFlowy Editor is now in","attributes":{"italic":false,"bold":true}}]}},{"type":"heading","data":{"level":1,"delta":[{"insert":"👏 Mobile"},{"insert":" ","attributes":{"italic":false,"bold":true}},{"insert":"📱","attributes":{"bold":true}}]}},{"type":"paragraph","data":{"level":1,"delta":[{"insert":"AppFlowy Editor","attributes":{"bold":true,"italic":false,"underline":false}},{"insert":"  empowers your flutter app with seamless document editing features.","attributes":{"bold":false,"italic":false,"underline":false}}]}},{"type":"paragraph","data":{"delta":[{"insert":"Adding the "},{"insert":"AppFlowy Editor","attributes":{"bold":true}},{"insert":" package in your flutter app will allow you to unlock powerful and customizable document editing capabilities, all without building it from scratch. "}]}},{"type":"heading","data":{"level":1,"delta":[{"insert":"👀 Let’s check it out"}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Text Decoration"}]}},{"type":"paragraph","data":{"delta":[{"insert":"Bold","attributes":{"bold":true}},{"insert":"  "},{"insert":"Italic  ","attributes":{"italic":true}},{"insert":"underLine","attributes":{"italic":false,"underline":true}},{"insert":"   ","attributes":{"italic":true}},{"insert":"Strikethrough","attributes":{"italic":false,"strikethrough":true}}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Colorful Text"}]}},{"type":"paragraph","data":{"delta":[{"insert":"Infuse","attributes":{"font_color":"0xfff44336"}},{"insert":" "},{"insert":"your","attributes":{"font_color":"0xffffeb3b"}},{"insert":" "},{"insert":"texts","attributes":{"font_color":"0xff2196f3"}},{"insert":" "},{"insert":"with","attributes":{"font_color":"0xff4caf50"}},{"insert":" "},{"insert":"the","attributes":{"font_color":"0xff795548"}},{"insert":" "},{"insert":"vibrant","attributes":{"font_color":"0xffe91e63"}},{"insert":" "},{"insert":"hues","attributes":{"font_color":"0xff9c27b0"}},{"insert":" "},{"insert":"of","attributes":{"font_color":"0xff9e9e9e"}},{"insert":" "},{"insert":"a","attributes":{"bg_color":"0x4d9e9e9e"}},{"insert":" "},{"insert":"rainbow","attributes":{"bg_color":"0x4df44336"}},{"insert":" "},{"insert":"to","attributes":{"bg_color":"0x4d4caf50"}},{"insert":" "},{"insert":"brighten","attributes":{"bg_color":"0x4dffeb3b"}},{"insert":" "},{"insert":"up","attributes":{"bg_color":"0x4d795548"}},{"insert":" "},{"insert":"your","attributes":{"bg_color":"0x4d9c27b0"}},{"insert":" "},{"insert":"day","attributes":{"bg_color":"0x4d2196f3"}},{"insert":"! "}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Lists"}]}},{"type":"todo_list","data":{"checked":false,"delta":[{"insert":"To Do List"}]}},{"type":"todo_list","data":{"delta":[{"insert":"Checked"}],"checked":true}},{"type":"bulleted_list","data":{"delta":[{"insert":"Bulleted List"}]}},{"type":"bulleted_list","data":{"delta":[]}},{"type":"numbered_list","data":{"delta":[{"insert":"Numbered List"}]}},{"type":"numbered_list","data":{"delta":[]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Link & Quote"}]}},{"type":"quote","data":{"delta":[{"insert":"Here’s where you can find the "},{"insert":"AppFlowy Editor flutter package","attributes":{"href":"https://pub.dev/packages/appflowy_editor"}},{"insert":" to add to your environment."}]}},{"type":"heading","data":{"level":3,"delta":[{"insert":"Code Inline"}]}},{"type":"paragraph","data":{"delta":[{"insert":"flutter pub add appflowy_editor\\nflutter pub get","attributes":{"code":true}}]}}]}}';

class AppFlowy extends StatefulWidget {
  const AppFlowy({
    super.key,
    required this.jsonData,
    this.header,
    this.footer,
    this.editable = true,
    this.showAppbar = true,
    this.onPopInvoked,
  });

  final String jsonData;
  final Widget? header;
  final Widget? footer;
  final bool editable;
  final bool showAppbar;
  final void Function(bool pop, String data)? onPopInvoked;

  @override
  State<AppFlowy> createState() => _AppFlowyState();
}

class _AppFlowyState extends State<AppFlowy> {
  late EditorState editorState;
  late final EditorScrollController editorScrollController;

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

    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: false,
    );
  }

  @override
  void dispose() {
    editorScrollController.dispose();
    editorState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => widget.onPopInvoked?.call(didPop, toFile),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: PlatformExtension.isDesktopOrWeb,
        appBar: !widget.showAppbar
            ? null
            : AppBar(
                title: const Text('Editor'),
                actions: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.upload_file_outlined),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     showImageMenu(
                  //       Overlay.of(context),
                  //       editorState,
                  //       SelectionMenu(
                  //         context: context,
                  //         editorState: editorState,
                  //         selectionMenuItems: [],
                  //       ),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.image),
                  // ),
                  IconButton(
                    onPressed: () {
                      undoCommand.execute(editorState);
                    },
                    icon: const Icon(Icons.undo),
                  ),
                ],
              ),
        body: SafeArea(
          child: PlatformExtension.isDesktopOrWeb
              ? DesktopEditor(
                  editorState: editorState,
                  editorScrollController: editorScrollController,
                  header: widget.header,
                  footer: widget.footer,
                  editable: widget.editable,
                )
              : MobileEditor(
                  editorState: editorState,
                  editorScrollController: editorScrollController,
                  header: widget.header,
                  footer: widget.footer,
                  editable: widget.editable,
                ),
        ),
      ),
    );
  }
}

class DesktopEditor extends StatelessWidget {
  const DesktopEditor({
    super.key,
    required this.editorState,
    required this.editorScrollController,
    this.header,
    this.footer,
    this.editable = true,
  });

  final EditorState editorState;
  final EditorScrollController editorScrollController;
  final Widget? header;
  final Widget? footer;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return FloatingToolbar(
      items: [
        paragraphItem,
        ...headingItems,
        ...markdownFormatItems,
        quoteItem,
        bulletedListItem,
        numberedListItem,
        linkItem,
        buildTextColorItem(),
        buildHighlightColorItem(),
        ...textDirectionItems,
        ...alignmentItems,
      ],
      editorState: editorState,
      textDirection: TextDirection.ltr,
      editorScrollController: editorScrollController,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AppFlowyEditor(
          editorState: editorState,
          editable: editable,
          editorScrollController: editorScrollController,
          blockComponentBuilders: buildBlockComponentBuilders(editorState),
          editorStyle: customizeEditorStyle(editable),
          commandShortcutEvents: buildCommandShortcuts(context),
          header: header,
          footer: footer,
        ),
      ),
    );
  }
}

class MobileEditor extends StatelessWidget {
  const MobileEditor({
    super.key,
    required this.editorState,
    required this.editorScrollController,
    this.header,
    this.footer,
    this.editable = true,
  });

  final EditorState editorState;
  final EditorScrollController editorScrollController;
  final Widget? header;
  final Widget? footer;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MobileFloatingToolbar(
            editorState: editorState,
            editorScrollController: editorScrollController,
            toolbarBuilder: (context, anchor, closeToolbar) {
              return AdaptiveTextSelectionToolbar.editable(
                onLookUp: () {},
                onSearchWeb: () {},
                onShare: () {},
                clipboardStatus: ClipboardStatus.pasteable,
                onCopy: () {
                  copyCommand.execute(editorState);
                  closeToolbar();
                },
                onCut: () => cutCommand.execute(editorState),
                onPaste: () => pasteCommand.execute(editorState),
                onSelectAll: () => selectAllCommand.execute(editorState),
                onLiveTextInput: null,
                anchors: TextSelectionToolbarAnchors(
                  primaryAnchor: anchor,
                ),
              );
            },
            child: AppFlowyEditor(
              editorState: editorState,
              editable: editable,
              editorScrollController: editorScrollController,
              blockComponentBuilders: buildBlockComponentBuilders(editorState),
              editorStyle: customizeEditorStyle(editable),
              header: header,
              footer: footer,
            ),
          ),
        ),
        // build mobile toolbar
        MobileToolbar(
          editorState: editorState,
          toolbarItems: [
            textDecorationMobileToolbarItem,
            buildTextAndBackgroundColorMobileToolbarItem(),
            headingMobileToolbarItem,
            todoListMobileToolbarItem,
            listMobileToolbarItem,
            linkMobileToolbarItem,
            quoteMobileToolbarItem,
            dividerMobileToolbarItem,
            codeMobileToolbarItem,
          ],
        ),
      ],
    );
  }
}

EditorStyle customizeEditorStyle(bool editable) {
  return EditorStyle(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    cursorColor: AppTheme.seedCard,
    selectionColor: AppTheme.seedCard.withOpacity(0.5),

    textStyleConfiguration: TextStyleConfiguration(
      text: TextStyle(
        fontSize: (16, 18).c,
        fontWeight: FontWeight.w300,
        color: AppTheme.darkness ? Colors.white : Colors.black,
      ),
      // text: GoogleFonts.poppins(
      //   fontSize: 14.0,
      //   color: Colors.white,
      // ),
      // bold: const TextStyle(
      //   fontWeight: FontWeight.w900,
      // ),
      // href: TextStyle(
      //   color: Colors.amber,
      //   decoration: TextDecoration.combine(
      //     [
      //       TextDecoration.underline,
      //     ],
      //   ),
      // ),
      code: TextStyle(
        color: Colors.blue,
        backgroundColor: AppTheme.darkness ? const Color.fromARGB(255, 66, 66, 66) : const Color.fromARGB(15, 0, 0, 0),
      ),
    ),
    textSpanDecorator:
        PlatformExtension.isDesktopOrWeb ? defaultTextSpanDecoratorForAttribute : mobileTextSpanDecoratorForAttribute,
    // textSpanDecorator: (context, node, index, text, textSpan) {
    //   final attributes = text.attributes;
    //   final href = attributes?[AppFlowyRichTextKeys.href];
    //   if (href != null) {
    //     return TextSpan(
    //       text: text.text,
    //       style: textSpan.style,
    //       recognizer: TapGestureRecognizer()
    //         ..onTap = () {
    //           debugPrint('onTap: $href');
    //         },
    //     );
    //   }
    //   return textSpan;
    // },
  );
}

Map<String, BlockComponentBuilder> buildBlockComponentBuilders(
  EditorState editorState,
) {
  const configuration = BlockComponentConfiguration();
  // final configuration = BlockComponentConfiguration(
  //   padding: (node) {
  //     if (HeadingBlockKeys.type == node.type) {
  //       return const EdgeInsets.symmetric(vertical: 30);
  //     }
  //     return const EdgeInsets.symmetric(vertical: 5);
  //   },
  //   textStyle: (node) {
  //     if (HeadingBlockKeys.type == node.type) {
  //       return const TextStyle(color: Colors.yellow);
  //     }
  //     return const TextStyle();
  //   },
  // );

  final map = {
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
          child: Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Icon(
              checked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: AppTheme.darkness ? Colors.white : Colors.black,
            ),
          ),
        );
      },
    ),
    // bulleted list block
    BulletedListBlockKeys.type: BulletedListBlockComponentBuilder(
      configuration: configuration,
      iconBuilder: (context, node) {
        return Container(
          width: 18,
          height: 18,
          padding: const EdgeInsets.only(right: 6.0),
          alignment: Alignment.center,
          child: const Icon(
            Icons.circle_outlined,
            size: 10,
            color: Colors.black,
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
  // customize the heading block component
  final levelToFontSize = PlatformExtension.isMobile
      ? [
          24.0,
          22.0,
          20.0,
          18.0,
          16.0,
          14.0,
        ]
      : [
          30.0,
          26.0,
          22.0,
          18.0,
          16.0,
          14.0,
        ];
  map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
    textStyleBuilder: (level) => TextStyle(
      fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? 14.0,
      fontWeight: FontWeight.w600,
    ),
  );
  map[ImageBlockKeys.type] = ImageBlockComponentBuilder(
    showMenu: true,
    menuBuilder: (node, _) {
      return const Positioned(
        right: 10,
        child: Text('⭐️ Here is a menu!'),
      );
    },
  );
  map[ParagraphBlockKeys.type] = ParagraphBlockComponentBuilder(
    configuration: BlockComponentConfiguration(
      placeholderText: (node) => 'Type something...',
    ),
  );
  if (PlatformExtension.isDesktopOrWeb) {
    map.forEach((key, value) {
      value.configuration = value.configuration.copyWith(
        padding: (_) => const EdgeInsets.symmetric(vertical: 8.0),
      );
    });
  }
  return map;
}

List<CommandShortcutEvent> buildCommandShortcuts(BuildContext context) {
  return [
    // customize the highlight color
    customToggleHighlightCommand(
      style: ToggleColorsStyle(
        highlightColor: Colors.orange.shade700,
      ),
    ),
    ...[
      ...standardCommandShortcutEvents
        ..removeWhere(
          (el) => el == toggleHighlightCommand,
        ),
    ],
    ...findAndReplaceCommands(
      context: context,
      localizations: FindReplaceLocalizations(
        find: 'Find',
        previousMatch: 'Previous match',
        nextMatch: 'Next match',
        close: 'Close',
        replace: 'Replace',
        replaceAll: 'Replace all',
        noResult: 'No result',
      ),
    ),
  ];
}
