import 'dart:io';
import 'package:chatapp_flutter/chat/model/user_model.dart';
import 'package:chatapp_flutter/chat/provider/provider.dart';
import 'package:chatapp_flutter/chat/screen/chat_screen/widgets/message_and_inage_display.dart';
import 'package:chatapp_flutter/chat/screen/chat_screen/widgets/user_chat_profile.dart';
import 'package:chatapp_flutter/chat/screen/chat_screen/widgets/video_audio_call_button.dart';
import 'package:chatapp_flutter/core/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final UserModel otherUser;
  const ChatScreen({super.key, required this.chatId, required this.otherUser});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingImage = false;

  //send text message
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    _messageController.clear();
    // reset the flage to allow marking as read for response

    final chatService = ref.read(chatServiceProvider);
    final result = await chatService.sendMessage(
      chatId: widget.chatId,
      message: message,
    );

    if (result != 'success') {
      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description: "Failed to send message: $result",
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatService = ref.read(chatServiceProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: UserChatProfile(widget: widget),

        // in appbar acitions: we will implemet video and audion call feature
        actions: [
          //audio call
          actionButton(
            false,
            widget.otherUser.uid,
            widget.otherUser.name,
            ref,
            widget.chatId,
          ),

          //video call
          actionButton(
            true,
            widget.otherUser.uid,
            widget.otherUser.name,
            ref,
            widget.chatId,
          ),

          //popup mrnu-> unfried option
          PopupMenuButton(
            onSelected: (value) async {
              if (value == "unfriend") {
                final result = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Unfriend User"),
                    content: Text(
                      "Are you sure you want to unfriend ${widget.otherUser.name}? ",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Unfriend"),
                      ),
                    ],
                  ),
                );
                //if confirmed -> unriednd
                if (result == true) {
                  final unfriendResult = await ref
                      .read(chatServiceProvider)
                      .unfriendUser(widget.chatId, widget.otherUser.uid);

                  if (unfriendResult == "success" && context.mounted) {
                    Navigator.pop(context);
                    showAppSnackbar(
                      context: context,
                      type: SnackbarType.success,
                      description: "Your Friendship is Disconnected",
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "unfriend", child: Text("Unfriend")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            //============ message section ==================
            child: StreamBuilder(
              stream: chatService.getChatMessages(widget.chatId),
              builder: (context, snapshot) {
                //loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                // ======== error ===============
                if (snapshot.hasError) {
                  return Center(child: Text("Error :${snapshot.error}"));
                }
                final messages = snapshot.data ?? [];
                if (snapshot.hasData && messages.isNotEmpty) {
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                }
                //============ empty chat ui =================

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      "No Messages yet. Start the conversation!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                //================ Build Message List =============
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe =
                        message.senderId ==
                        FirebaseAuth.instance.currentUser!.uid;
                    final isSystem = message.type == "system";
                    return Column(
                      children: [
                        //system generate message when you are friend
                        if (isSystem)
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        //display the audio and video call history
                        else if (message.type == 'call')
                          Container()
                        else
                          //display the text messaage and
                          MessageAndInageDisplay(
                            isMe: isMe,
                            widget: widget,
                            message: message,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // ================= Message Input Bar ===============
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              right: 1,
              left: 1,
              bottom: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(0, -5),
                    color: Colors.grey.withAlpha(100),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Image Pickker Button
                    IconButton(
                      //last work do here
                      // onPressed: () {},
                      onPressed: _isUploadingImage
                          ? null
                          : () => _showImageOptions(),
                      icon: Icon(
                        Icons.image,
                        size: 30,
                        color: _isUploadingImage ? Colors.grey : Colors.blue,
                      ),
                    ),

                    // ====== text field ===========
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Text a message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        maxLength: null,
                        onSubmitted: (value) => _sendMessage(),
                        // onChanged: ,
                        // onTap: ,
                      ),
                    ),

                    SizedBox(width: 8),
                    //============ Send Button =-==============
                    FloatingActionButton(
                      onPressed: _isUploadingImage ? null : _sendMessage,
                      mini: true,
                      backgroundColor: Colors.white,
                      elevation: 0,

                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _isUploadingImage
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.send,
                                color: Colors.blueAccent,
                                size: 27,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // image handlilng methods
  // has methods isfor image picker
  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);

                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);

                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text("Cancel"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        // image preview
        await _showImagePreview(imageFile);
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context: context,
          type: SnackbarType.error,
          description: "Error Picking Image: $e",
        );
      }
    }
  }

  //========= preview image before sending ================
  Future<void> _showImagePreview(File imageFile) async {
    final TextEditingController captionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              child: Image.file(imageFile, fit: BoxFit.contain),
            ),

            SizedBox(height: 16),
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                hintText: "Add a Caption (Optional)",
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
              maxLines: 1,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Send"),
          ),
        ],
      ),
    );
    if (result == true) {
      await _sendImageMessae(imageFile, captionController.text);
    }
  }

  // send image to firestore/Cloudinary

  Future<void> _sendImageMessae(File imageFile, String caption) async {
    setState(() {
      _isUploadingImage = true;
    });
    try {
      final ChatService = ref.read(chatServiceProvider);

      final result = await ChatService.sendImageWithUpload(
        chatId: widget.chatId,
        imageFile: imageFile,
        caption: caption.isEmpty ? null : caption,
      );

      if (result == 'success') {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        if (mounted) {
          showAppSnackbar(
            context: context,
            type: SnackbarType.error,
            description: "Field to Send Image: $result",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context: context,
          type: SnackbarType.error,
          description: "Field to Send Image: $e",
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }
}
