import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/chat_audio_video/widgets/common_audio_video_icons_container.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';
import 'package:prayer_hybrid_app/utils/asset_paths.dart';
import 'package:prayer_hybrid_app/utils/navigation.dart';
import 'package:prayer_hybrid_app/widgets/custom_background_container.dart';


class VideoScreen extends StatefulWidget {

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomBackgroundContainer(
      child: Scaffold(
        backgroundColor: AppColors.TRANSPARENT_COLOR,
        body: Stack(
          children: [
            _user1ImageContainerWidget(),
            _user2ImageContainerWidget(),
            _videoIconsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _user1ImageContainerWidget()
  {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPaths.VIDEO_USER1_IMAGE),
          fit: BoxFit.cover
        )
      ),
    );
  }

  Widget _user2ImageContainerWidget()
  {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 120.0,
        height: 150.0,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1,right: MediaQuery.of(context).size.width*0.08),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
                image: AssetImage(AssetPaths.VIDEO_USER2_IMAGE),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }


  Widget _videoIconsWidget()
  {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.07),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _cameraContainerWidget(),
            _endCallContainerWidget(),
            _loudSpeakerContainerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _cameraContainerWidget()
  {
    return CommonAudioVideoIconsContainer(
        image: AssetPaths.CAMERA_ICON,
        imageWidth: 28.0,
        shadow: true,
        onTap: (){
          log("camera");
        }
    );
  }


  Widget _endCallContainerWidget()
  {
    return CommonAudioVideoIconsContainer(
        image: AssetPaths.END_CALL_ICON,
        imageWidth: 28.0,
        containerColor: AppColors.RED_COLOR,
        shadow: true,
        onTap: (){
          log("chat");
          AppNavigation.navigatorPop(context);
        }
    );
  }


  Widget _loudSpeakerContainerWidget()
  {
    return CommonAudioVideoIconsContainer(
        image: AssetPaths.LOUDSPEAKER_ICON,
        imageWidth: 28.0,
        shadow: true,
        onTap: (){
          log("loudspeaker");
        }
    );
  }


}
