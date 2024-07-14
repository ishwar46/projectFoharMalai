import 'package:flutter/material.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:foharmalai/core/utils/helpers/helper_functions.dart';

import '../dashboard/presentation/widgets/notification_card_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('notifications')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return const AlertCard();
        },
      ),
    );
  }
}
