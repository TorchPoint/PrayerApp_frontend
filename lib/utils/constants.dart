import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Constants {
  static const Pattern EMAIL_VALIDATION_REGEX =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static const Pattern PASSWORD_VALIDATE_REGEX =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  //MaskTextInputFormatter for Card Number Field
  static MaskTextInputFormatter cardNumberMaskFormatter =
      MaskTextInputFormatter(
          mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
}
