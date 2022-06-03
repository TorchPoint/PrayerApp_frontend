import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prayer_hybrid_app/utils/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final double containerWidth,
      borderRadius,
      contentPaddingTop,
      contentPaddingBottom,
      contentPaddingLeft,
      contentPaddingRight,
      prefixIconWidth,
      suffixIconWidth;
  final String hintText, prefixIcon, suffixIcon;
  final bool obscureText, isCollapsed, textFieldReadOnly;
  final TextEditingController textController;
  final Function(String) onValidate;
  final int errorMaxLines, maxLines;
  final double hintSize, textSize;
  final Color borderColor,
      filledColor,
      hintColor,
      textColor,
      cursorColor,
      prefixIconColor,
      suffixColor;
  final TextInputType keyBoardType;
  final List<TextInputFormatter> textInputFormatter;
  final Function onTextFieldTap, onSuffixIconTap, onChange;

  CustomTextFormField(
      {this.textController,
      this.containerWidth,
      this.hintText,
      this.borderRadius,
      this.contentPaddingTop,
      this.contentPaddingBottom,
      this.contentPaddingLeft,
      this.contentPaddingRight,
      this.prefixIcon,
      this.prefixIconWidth,
      this.suffixIcon,
      this.suffixIconWidth,
      this.obscureText,
      this.errorMaxLines,
      this.onValidate,
      this.maxLines,
      this.hintSize,
      this.textSize,
      this.isCollapsed,
      this.borderColor,
      this.filledColor,
      this.hintColor,
      this.textColor,
      this.cursorColor,
      this.keyBoardType,
      this.textInputFormatter,
      this.textFieldReadOnly,
      this.onTextFieldTap,
      this.prefixIconColor,
      this.onSuffixIconTap,
      this.onChange,
      this.suffixColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      child: TextFormField(
        controller: textController,
        validator: onValidate,
        onTap: onTextFieldTap,
        readOnly: textFieldReadOnly ?? false,
        autovalidateMode: AutovalidateMode.disabled,
        onChanged: onChange,
        decoration: InputDecoration(
          isCollapsed: isCollapsed ?? false,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: borderColor ?? AppColors.WHITE_COLOR, width: 1.3)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: borderColor ?? AppColors.WHITE_COLOR, width: 1.3)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.ERROR_COLOR, width: 1.3)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.ERROR_COLOR, width: 1.3)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            //borderSide: BorderSide(color: AppColors.WHITE_COLOR)
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: hintSize ?? 17.0,
            color: hintColor ?? AppColors.WHITE_COLOR,
            fontWeight: FontWeight.w500,
          ),
          errorStyle: TextStyle(
            fontSize: 13.0,
            color: AppColors.ERROR_COLOR,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: EdgeInsets.only(
              top: contentPaddingTop ?? 15.0,
              bottom: contentPaddingBottom ?? 15.0,
              left: contentPaddingLeft ?? 14.0,
              right: contentPaddingRight ?? 14.0),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 18.0, right: 10.0),
                  child: Image.asset(
                    prefixIcon,
                    width: prefixIconWidth,
                    color: prefixIconColor,
                  ))
              : null,
          prefixIconConstraints: BoxConstraints(),
          suffixIcon: suffixIcon != null
              ? InkWell(
                  onTap: onSuffixIconTap,
                  child: Padding(
                      padding: EdgeInsets.only(right: 14.0),
                      child: Image.asset(
                        suffixIcon,
                        width: suffixIconWidth,
                        color: suffixColor,
                      )),
                )
              : null,
          suffixIconConstraints: BoxConstraints(),
          errorMaxLines: errorMaxLines ?? 1,
          fillColor: filledColor ?? AppColors.TRANSPARENT_COLOR,
          filled: true,
        ),
        style: TextStyle(
          fontSize: textSize ?? 17.0,
          color: textColor ?? AppColors.WHITE_COLOR,
          fontWeight: FontWeight.w700,
        ),
        keyboardType: keyBoardType ?? TextInputType.text,
        textInputAction: Platform.isAndroid
            ? TextInputAction.done
            : TextInputAction.unspecified,
        obscureText: obscureText ?? false,
        cursorColor: cursorColor ?? Colors.white,
        maxLines: maxLines ?? 1,
        inputFormatters: textInputFormatter ?? [],
      ),
    );
  }
}
