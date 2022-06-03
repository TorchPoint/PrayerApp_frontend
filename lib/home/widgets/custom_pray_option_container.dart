import 'package:flutter/material.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';

class CustomPrayOptionContainer extends StatelessWidget {
  final String title,imagePath;
  final double imageWidth,imageHeight;
  CustomPrayOptionContainer({this.title,this.imagePath,this.imageWidth,this.imageHeight});

  @override
  Widget build(BuildContext context) {
   return Container(
      width: 125.0,
      decoration: BoxDecoration(
          color: AppColors.TRANSPARENT_COLOR,
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Column(
        children: [
          Container(
            width: 125.0,
            height: 115.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                BoxShadow(
                  color: AppColors.BLACK_COLOR.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3), // changes position of shadow
                )],
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.BACKGROUND1_COLOR,
                      AppColors.BACKGROUND2_COLOR,
                      AppColors.BACKGROUND2_COLOR,
                    ],
                    stops: [0.04,0.5,1.0]

                )
            ),
            child: _imageWidget()
          ),

          SizedBox(height: 10.0,),

          Text(title,style: TextStyle(color: AppColors.WHITE_COLOR,fontWeight: FontWeight.w700),textScaleFactor: 1.05,)

        ],
      ),
    );
  }


  Widget _imageWidget()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: imageWidth ?? 50.0,
          height: imageHeight ?? 50.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain
              )
          ),
        ),
      ],
    );
  }
}
