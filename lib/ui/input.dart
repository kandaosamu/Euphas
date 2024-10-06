import 'package:euphas/config/constants.dart';
import 'package:flutter/material.dart';

Widget emailInput(TextEditingController controller, String hint, TextInputType textInputType) {
  return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      validator: (email) {
        if (email == '') {
          return 'email不得為空';
        } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]'
            r'{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(email!) || email.substring(email.indexOf('@')+1)!="gmail.com" && email.substring(email.indexOf('@')+1)!="gs.ncku.edu.tw") {
          return '請輸入有效email';
        } else {
          return null;
        }
      });
}

Widget invitationInput(TextEditingController controller, String hint, TextInputType textInputType) {
  return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      validator: (email) {
        if (email == '') {
          return 'email不得為空';
        } else if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]'
                r'{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(email!) || email.substring(email.indexOf('@')+1)!="gmail.com" && email.substring(email.indexOf('@')+1)!="gs.ncku.edu.tw") {
          return '請輸入有效email';
        } else if(email==currentProfile['email']){
          return '這是您的email，請更改為其他email';
        } else if(hint == 'email' && currentProfile['myPatients'].contains(email)==true){
          return '該用戶已是您的患者';
        }else {
          return null;
        }
      });
}

Widget passwordInput(TextEditingController controller, String hint, TextInputType textInputType) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType,
    decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100),
    validator: (v) {
      return v!.trim().isNotEmpty ? null : "$hint不得為空";
    },
  );
}
