import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayer_hybrid_app/chat_audio_video/screens/audio_screen.dart';
import 'package:prayer_hybrid_app/common_classes/image_gallery_class.dart';
import 'package:prayer_hybrid_app/models/group_prayer_model.dart';
import 'package:prayer_hybrid_app/models/message_model.dart';
import 'package:prayer_hybrid_app/models/user_model.dart';
import 'package:prayer_hybrid_app/providers/provider.dart';
import 'package:prayer_hybrid_app/services/API_const.dart';
import 'package:prayer_hybrid_app/services/base_service.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/app_strings.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/widgets/custom_chat_app_bar.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final AppUser user;
  final GroupPrayerModel groupPrayerModel;
  final int role; // role=0 is for 1:1 chat and role=1 is for group chat

  ChatScreen({this.user, this.role, this.groupPrayerModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  RtcEngine rtcEngine;

  IO.Socket socket;
  List<MessageModel> userMessage = [];
  TextEditingController _sendMessageController = TextEditingController();
  File profileFileImage;
  String profileImagePath;
  ImageGalleryClass imageGalleryClass = ImageGalleryClass();
  BaseService baseService = BaseService();
  ScrollController _controller = ScrollController();

  Future getTokenRTC() async {
    var user = Provider.of<AppUserProvider>(context, listen: false);
    return await baseService.postBaseMethod(
      "${ApiConst.AGORA_BASE_URL}/rtctoken",
      {
        "isPublisher": true,
        "sender_id": baseService.id,
        "reciever_id": widget.role == 0 ? widget.user.id : null,
        "group_id": widget.role == 1 ? widget.groupPrayerModel.id : null,
        "group_name": widget.role == 1 ? widget.groupPrayerModel.name : null,
        "name": user.appUser.firstName
      },
    ).onError((error, stackTrace) {
      baseService.showToast("Server Error", AppColors.ERROR_COLOR);
      EasyLoading.dismiss();
    });
  }

  void connect(BuildContext context) {
    print("----ROLE----:" + widget.role.toString());
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    socket = IO.io(ApiConst.SOCKET_BASE_URL, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    print(socket.connected);
    EasyLoading.show(status: "Loading...", dismissOnTap: true);
    socket.onError((data) {
      print("erroe");
      baseService.showToast("Connection Error", AppColors.ERROR_COLOR);
      EasyLoading.dismiss();
    });
    socket.onConnectError((data) {
      print("error");
      EasyLoading.dismiss();
      baseService.showToast("Connection Error", AppColors.ERROR_COLOR);
      chatProvider.resetMessageList();
      AppNavigation.navigatorPop(context);
    });
    socket.onConnect((data) {
      print("connected");

      var dataChatSingle = {
        "sender_id": baseService.id,
        "reciever_id": widget.user?.id ?? 0
      };
      var dataChatGroup = {
        "sender_id": baseService.id,
        "group_id": widget.groupPrayerModel?.id
      };

      var singleChat = "get_messages";
      var groupChat = "group_get_messages";

      print(widget.role == 0
          ? dataChatSingle.toString()
          : dataChatGroup.toString());
      socket.emit(
        widget.role == 0 ? singleChat : groupChat,
        widget.role == 0 ? dataChatSingle : dataChatGroup,
      );
      socket.on("response", (data) {
        EasyLoading.dismiss();
        print("DATA" + data.toString());

        chatProvider.fetchMessages(data["data"]);
        // setState(() {
        //   data["data"].forEach((element) {
        //     userMessage.insert(0, MessageModel.fromJson(element));
        //   });
        // });
      });
    });
    socket.onConnectTimeout((data) {
      print(data);
      print("timeout");
      baseService.showToast("Session TimeOut Error", AppColors.ERROR_COLOR);
      EasyLoading.dismiss();
    });
  }

  void sendMessage(text) {
    setState(() {
      if (_sendMessageController.text.isNotEmpty) {
        var data = {
          'sender_id': baseService.id,
          'reciever_id': widget.user?.id,
          'message': _sendMessageController.text
        };
        var dataGroup = {
          'sender_id': baseService.id,
          'group_id': widget.groupPrayerModel?.id,
          'message': _sendMessageController.text
        };
        var single = "send_message";
        var group = "group_send_message";

        socket.emit(widget.role == 0 ? single : group,
            widget.role == 0 ? data : dataGroup);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    connect(context);

    baseService.loadLocalUser();
    chatProvider.messageList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        AppNavigation.navigatorPop(context);
        chatProvider.resetMessageList();
        return;
      },
      child: CustomBackgroundContainer(
        child: Scaffold(
          backgroundColor: AppColors.TRANSPARENT_COLOR,
          body: Column(
            children: [
              _customChatAppBar(),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: chatProvider.messageList == null ||
                        chatProvider.messageList?.length == 0
                    ? Center(
                        child: Text(
                          "No History Found",
                          style: TextStyle(color: AppColors.WHITE_COLOR),
                        ),
                      )
                    : ListView.builder(
                        controller: _controller,
                        reverse: true,
                        itemCount: chatProvider.messageList.length ?? 0,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return widget.role == 0
                              ? baseService.id ==
                                      chatProvider.messageList[index].senderId
                                  ? sendUser(
                                      chatProvider.messageList[index].message)
                                  : receiveUser(
                                      chatProvider.messageList[index].message,
                                      index: index)
                              : baseService.id ==
                                      chatProvider.messageList[index].senderId
                                  ? sendUser(
                                      chatProvider.messageList[index].message)
                                  : receiveUser(
                                      chatProvider.messageList[index].message,
                                      index: index);
                        }),
              ),
              SizedBox(
                height: 7.0,
              ),
              _sendMessageContainerWidget(),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Custom Chat App Bar Widget
  Widget _customChatAppBar() {
    var chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return CustomChatAppBar(
      title: widget.role == 0
          ? "${widget.user.firstName + " " + widget.user.lastName}"
          : "${widget.groupPrayerModel.name}",
      leadingIconPath: AssetPaths.BACK_ICON,
      leadingTap: () {
        print("Leading tap");
        //socket.dispose();
        chatProvider.resetMessageList();

        AppNavigation.navigatorPop(context);
      },
      // trailingVideoIconPath: AssetPaths.VIDEO_ICON,
      // trailingVideoTap: () {
      //   AppNavigation.navigateTo(context, VideoScreen());
      // },
      trailingAudioIconPath: AssetPaths.AUDIO_ICON,
      trailingAudioTap: () {
        print("check");
        if (widget.role == 0) {
          getTokenRTC().then((value) {
            AppNavigation.navigateTo(
                context,
                AudioScreen(
                  appUser: widget.user,
                  channelName: value["channel"],
                  channelToken: value["token"],
                ));
          });
        } else {
          getTokenRTC().then((value) {
            AppNavigation.navigateTo(
                context,
                AudioScreen(
                  groupPrayerModel: widget.groupPrayerModel,
                  channelName: value["channel"],
                  channelToken: value["token"],
                ));
          });
        }
      },
    );
  }

  Widget sendUser(String sendMessage) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: 10.0,
          bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 0.0,
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: AppColors.BUTTON_COLOR,
                borderRadius: BorderRadius.circular(5.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.LIGHT_BLACK_COLOR.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Text(
                sendMessage.toString(),
                style: TextStyle(
                    color: AppColors.WHITE_COLOR, fontWeight: FontWeight.w800),
                textScaleFactor: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget receiveUser(String receiveMessage, {index}) {
    var chatProvider = Provider.of<ChatProvider>(context, listen: true);
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          top: 10.0,
          bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: widget.role == 0
                      ? widget.user.profileImage == null
                          ? AssetImage(AssetPaths.NO_IMAGE)
                          : NetworkImage(widget.user.profileImage)
                      : chatProvider.messageList[index].profileImage == null
                          ? AssetImage(AssetPaths.NO_IMAGE)
                          : NetworkImage(
                              chatProvider.messageList[index].profileImage),
                  fit: BoxFit.fill,
                )),
          ),
          SizedBox(
            width: 10.0,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 0.0,
                maxWidth: MediaQuery.of(context).size.width * 0.55),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: AppColors.WHITE_COLOR,
                borderRadius: BorderRadius.circular(5.5),
              ),
              child: Text(
                receiveMessage,
                style: TextStyle(
                    color: AppColors.BLACK_COLOR, fontWeight: FontWeight.w700),
                textScaleFactor: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendMessageContainerWidget() {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 0.0, maxHeight: MediaQuery.of(context).size.height * 0.15),
      child: Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            bottom: 10,
            right: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(
          color: AppColors.WHITE_COLOR,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            Expanded(child: _sendMessageTextField()),
            // Padding(
            //   padding: EdgeInsets.only(right: 10.0, top: 2.0, bottom: 2.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       _imageGalleryOption();
            //     },
            //     child: Image.asset(
            //       AssetPaths.ATTACHMENT_ICON,
            //       width: 23.0,
            //       height: 23.0,
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(right: 12.0, top: 2.0, bottom: 2.0),
              child: GestureDetector(
                onTap: () {
                  sendMessage(_sendMessageController.text);
                  _sendMessageController.clear();
                },
                child: Image.asset(
                  AssetPaths.SEND_CHAT_IMAGE,
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sendMessageTextField() {
    return TextField(
      onTap: () {},
      controller: _sendMessageController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: AppColors.WHITE_COLOR)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: AppColors.WHITE_COLOR)),
        isCollapsed: true,
        hintText: AppStrings.CHAT_MESSAGE_HINT_TEXT,
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: AppColors.BLACK_COLOR.withOpacity(0.4),
          fontWeight: FontWeight.w500,
        ),
        contentPadding:
            EdgeInsets.only(top: 15.0, bottom: 15.0, left: 12.0, right: 12.0),
        fillColor: AppColors.WHITE_COLOR,
        filled: true,
      ),
      style: TextStyle(
        fontSize: 15.0,
        color: AppColors.BLACK_COLOR,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: AppColors.BLACK_COLOR,
      maxLines: null,
    );
  }

  //Select Image Start
  void _imageGalleryOption() {
    imageGalleryClass.imageGalleryBottomSheet(
        context: context,
        onCameraTap: () {
          _getImage(imageText: AppStrings.CAMERA_TEXT);
        },
        onGalleryTap: () {
          _getImage(imageText: AppStrings.GALLERY_TEXT);
        });
  }

  void _getImage({String imageText}) async {
    if (imageText == AppStrings.CAMERA_TEXT) {
      profileImagePath = await imageGalleryClass.getCameraImage();
      _cropImage(imagePath: profileImagePath);
    } else if (imageText == AppStrings.GALLERY_TEXT) {
      profileImagePath = await imageGalleryClass.getGalleryImage();
      _cropImage(imagePath: profileImagePath);
    }
  }

  void _cropImage({String imagePath}) async {
    //Ya use hoa modal bottom sheet ko remove krna ka liya
    AppNavigation.navigatorPop(context);

    if (imagePath != null) {
      profileFileImage =
          await imageGalleryClass.cropImage(imageFilePath: imagePath);

      if (profileFileImage != null) {}

      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _sendMessageController.dispose();
    socket.dispose();
  }
}
