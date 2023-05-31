import 'package:flutter/material.dart';

void cleanErrorsValidation(Map<String, dynamic> errors) {
  errors.clear();
}

void errorValidation(
    Map<String, dynamic> response, Map<String, dynamic> errors) {
  for (var key in response['errors'].keys) {
    errors[key] = response['errors'][key].first;
  }
}
