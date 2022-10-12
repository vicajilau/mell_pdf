import 'package:flutter/material.dart';

import '../../common/localization/localization.dart';
import '../utils.dart';

class CustomDialog {
  static void showError(
      {required BuildContext context,
      required Object error,
      required String titleLocalized,
      required String subtitleLocalized,
      required String buttonTextLocalized,
      bool isReportable = false}) {
    Utils.printInDebug(error);
    String content = Localization.of(context).string(subtitleLocalized);
    final actions = <Widget>[];
    if (isReportable) {
      content += Localization.of(context).string('report_error_subtitle');
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
              Localization.of(context).string('report_error_button_accept'))));
      actions.add(TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
              Localization.of(context).string('report_error_button_cancel'))));
    } else {
      actions.add(TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(Localization.of(context).string(buttonTextLocalized)),
      ));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Localization.of(context).string(titleLocalized)),
            content: Text(content),
            actions: actions,
          );
        });
  }
}
