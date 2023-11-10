import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileEditor extends StatefulWidget {
  const MobileEditor({
    super.key,
    required this.editorState,
    this.editorStyle,
  });

  final EditorState editorState;
  final EditorStyle? editorStyle;

  @override
  State<MobileEditor> createState() => _MobileEditorState();
}

class _MobileEditorState extends State<MobileEditor> {
  EditorState get editorState => widget.editorState;

  late final EditorScrollController editorScrollController;

  late EditorStyle editorStyle;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;

  @override
  void initState() {
    super.initState();

    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: false,
    );

    editorStyle = _buildMobileEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  void reassemble() {
    super.reassemble();

    editorStyle = _buildMobileEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  Widget build(BuildContext context) {
    assert(PlatformExtension.isMobile);
    return Column(
      children: [
        // build appflowy editor
        Expanded(
          child: MobileFloatingToolbar(
            editorState: editorState,
            editorScrollController: editorScrollController,
            toolbarBuilder: (context, anchor) {
              return AdaptiveTextSelectionToolbar.editable(
                onLiveTextInput: () {},
                clipboardStatus: ClipboardStatus.pasteable,
                onCopy: () => copyCommand.execute(editorState),
                onCut: () => cutCommand.execute(editorState),
                onPaste: () => pasteCommand.execute(editorState),
                onSelectAll: () => selectAllCommand.execute(editorState),
                anchors: TextSelectionToolbarAnchors(
                  primaryAnchor: anchor,
                ),
              );
            },
            child: AppFlowyEditor(
              editorStyle: editorStyle,
              editorState: editorState,
              editorScrollController: editorScrollController,
              blockComponentBuilders: blockComponentBuilders,
              header: const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(child: Text('Header')),
              ),
              footer: const SizedBox(
                height: 100,
              ),
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

  EditorStyle _buildMobileEditorStyle() {
    return EditorStyle.mobile(
      cursorColor: const Color.fromARGB(255, 134, 46, 247),
      selectionColor: const Color.fromARGB(50, 134, 46, 247),
      textStyleConfiguration: TextStyleConfiguration(
        text: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
        ),
        code: GoogleFonts.sourceCodePro(
          backgroundColor: Colors.grey.shade200,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
    );
  }

  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    // customize the heading block component
    final levelToFontSize = [
      24.0,
      22.0,
      20.0,
      18.0,
      16.0,
      14.0,
    ];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => GoogleFonts.poppins(
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
}
