import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> alerts = [
      {
        'color': isDarkMode ? Colors.greenAccent : Colors.green,
        'icon': Icons.lock_clock,
        'title': 'Pickup Reminder',
        'description': 'You have an upcoming pickup for today at 7:00 AM',
        'time': '1 hr ago',
      },
      {
        'color': Colors.red,
        'icon': Icons.cancel,
        'title': 'Pickup Cancelled',
        'description': 'Your pickup for today at 8:00 AM has been cancelled.',
        'time': '5 hrs ago',
      },
    ];

    return Card(
      surfaceTintColor: isDarkMode ? Colors.transparent : AppColors.white,
      color: isDarkMode ? Colors.transparent : AppColors.white,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[800]! : Colors.redAccent.shade100,
          width: 1,
        ),
      ),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [Colors.grey[900]!, Colors.grey[800]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:
                alerts.map((alert) => _buildAlertItem(context, alert)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertItem(BuildContext context, Map<String, dynamic> alert) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: alert['color'].withOpacity(0.2),
            child: Icon(alert['icon'], color: alert['color']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['title'],
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Text(
                  alert['description'],
                  style: GoogleFonts.montserrat(
                    fontSize: 8,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            alert['time'],
            style: GoogleFonts.montserrat(
              fontSize: 8,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
