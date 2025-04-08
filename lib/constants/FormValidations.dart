import 'package:flutter_translate/flutter_translate.dart';

String? notEmptyValidator(String? value) {
  if (value == null || value.isEmpty) {
    return translate("input_error.error_empty_field");
  }

  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return translate("input_error.error_empty_field");
  }

  if (value.length > 20) {
    return translate("input_error.error_too_long");
  }

  if (RegExp(r'[0-9]|[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return translate("form_validations.error_name_invalid");
  }

  return null;
}

String? longTextValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  if (value.length > 255) {
    return translate("input_error.error_too_long");
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return translate("input_error.error_empty_field");
  }

  if (value.length < 6) {
    return translate("input_error.error_too_short");
  }

  if (value.length > 20) {
    return translate("input_error.error_too_long");
  }

  bool hasNumbers = value.contains(RegExp(r'[0-9]'));
  bool hasLetters = value.contains(RegExp(r'[A-Za-z]'));

  // if (!hasNumbers || !hasLetters) {
  //   return translate("Registrations.error_password_format");
  // }

  return null;
}

String? emailValidator(String? value, {String? takenEmail}) {
  if (value == null || value.isEmpty) {
    return translate("input_error.error_empty_field");
  }

  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return translate("form_validations.error_email_format");
  }

  if (value == takenEmail) {
    return translate("auth_pages.form_validations.error_email_taken");
  }

  return null;
}