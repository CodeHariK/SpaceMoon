import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';

/// Prompt the user for feedback using `StringFeedback`.
Widget simpleFeedbackBuilder(
  BuildContext context,
  OnSubmit onSubmit,
  ScrollController? scrollController,
) =>
    FeedbackForm(onSubmit: onSubmit, scrollController: scrollController);

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({
    super.key,
    required this.onSubmit,
    required this.scrollController,
  });

  final OnSubmit onSubmit;
  final ScrollController? scrollController;

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  late TextEditingController controller;
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                controller: widget.scrollController,
                padding: EdgeInsets.fromLTRB(16, widget.scrollController != null ? 20 : 16, 16, 0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: const Key('text_input_field'),
                      focusNode: focusNode,
                      controller: controller,
                      maxLines: null,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'abc...',
                        prefixIcon: const Icon(Icons.error),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              widget.onSubmit(controller.text);
                            },
                            child: const Icon(Icons.send),
                          ),
                        ),
                        labelText: FeedbackLocalizations.of(context).feedbackDescriptionText,
                        labelStyle: context.tm,
                      ),
                      textInputAction: TextInputAction.done,
                      onTap: () {},
                      onTapOutside: (v) {
                        focusNode.unfocus();
                      },
                      onFieldSubmitted: (value) {
                        widget.onSubmit(controller.text);
                      },
                    ),
                  ),
                ],
              ),
              if (widget.scrollController != null) const FeedbackSheetDragHandle(),
            ],
          ),
        ),
      ],
    );
  }
}
