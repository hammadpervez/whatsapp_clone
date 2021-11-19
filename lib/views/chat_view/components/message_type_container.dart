import 'dart:io';
import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:whatsapp_clone/config/without_glow_scroll_configuraiton.dart';
import 'package:whatsapp_clone/controllers/emoji_visiblity_controller.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/pods.dart';
import 'package:whatsapp_clone/res/colors.dart';
import 'package:whatsapp_clone/res/extensions.dart';
import 'package:whatsapp_clone/views/components/custom_icon_button.dart';

class MessageTypeContainer extends ConsumerStatefulWidget {
  const MessageTypeContainer({Key? key, required this.height})
      : super(key: key);
  final double height;

  @override
  ConsumerState<MessageTypeContainer> createState() =>
      _MessageTypeContainerState();
}

class _MessageTypeContainerState extends ConsumerState<MessageTypeContainer> {
  //  double _insets = EdgeInsets.fromWindowPadding(
  //           WidgetsBinding.instance!.window.viewInsets,
  //           WidgetsBinding.instance!.window.devicePixelRatio)
  //       .bottom;

  // final viewInsets = EdgeInsets.fromWindowPadding(
  //     WidgetsBinding.instance!.window.viewInsets,
  //     WidgetsBinding.instance!.window.devicePixelRatio);

  @override
  Widget build(BuildContext context) {
    double _textFieldHeight = (context.height * .15);

    return WillPopScope(
      onWillPop: ref.watch(emojiVisiblityController).onBackPress,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        color: kCreamColor,
        constraints: BoxConstraints(maxHeight: widget.height),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: _textFieldHeight),
              child: Stack(children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: _buildMessageIcon(
                                  Icons.emoji_emotions_outlined,
                                  ref
                                      .watch(emojiVisiblityController)
                                      .showEmojis),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                spacer(),
                                Expanded(
                                  child: ScrollConfiguration(
                                    behavior: NoGlowScrollBehavior(),
                                    child: Scrollbar(
                                      child: TextField(
                                        focusNode: ref
                                            .watch(emojiVisiblityController)
                                            .messageFieldNode,
                                        controller: ref
                                            .watch(emojiVisiblityController)
                                            .messageFieldController,
                                        onTap: ref
                                            .watch(emojiVisiblityController)
                                            .onFieldTap,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          isCollapsed: true,
                                          isDense: true,
                                          hintText: 'Message',
                                          border: InputBorder.none,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                                  ),
                                ),
                                //Row of Camera and Attachfile IconButton
                                spacer(),
                              ],
                            ),
                            endedButtons(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: kMinInteractiveDimension + 8,
                        height: kMinInteractiveDimension * .9),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    color: context.primaryColor,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                      color: kWhiteColor,
                      constraints: const BoxConstraints(
                          minHeight: kMinInteractiveDimension * .8),
                      icon: _swtichingMicIcon(),
                      onPressed: () {},
                    ),
                  ),
                ),
              ]),
            ),
            !ref.watch(emojiVisiblityController).isEmojiVisible
                ? const SizedBox()
                : Flexible(
                    child: SizedBox(
                      height: cacheKeyboardHeight ??
                          (widget.height - _textFieldHeight) * .5,
                      child: EmojiPicker(onEmojiSelected: (category, emoji) {
                        var getController = ref.read(emojiVisiblityController);
                        getController.messageFieldController.text +=
                            emoji.emoji;
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  AnimatedSwitcher _swtichingMicIcon() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !ref.watch(emojiVisiblityController).isEmpty
          ? const Icon(Icons.send, key: ValueKey('send_icon'))
          : const Icon(Icons.mic, key: ValueKey('mic_icon')),
      transitionBuilder: (widget, animation) =>
          ScaleTransition(scale: animation, child: widget),
    );
  }

  SizedBox spacer() {
    return const SizedBox(
      width: kMinInteractiveDimension * .8,
    );
  }

  Widget endedButtons() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      bottom: 0,
      right: ref.watch(emojiVisiblityController).isEmpty
          ? 0
          : -kMinInteractiveDimension * .7,
      child: Row(
        children: [
          _buildMessageIcon(Icons.attach_file, () {}),
          _buildMessageIcon(Icons.camera_alt, () {}),
        ],
      ),
    );
  }

  Material _buildMessageIcon(IconData icon, [VoidCallback? onTap]) {
    return Material(
      type: MaterialType.transparency,
      child: CustomIconButton(
        splashSize: 15,
        factorWidth: .8,
        icon: Icon(icon, size: 20),
        onTap: onTap,
      ),
    );
  }
}
