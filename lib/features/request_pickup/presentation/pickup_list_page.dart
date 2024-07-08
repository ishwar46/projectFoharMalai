import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/helpers/user_sessions.dart';
import '../data/pickup_service.dart';
import '../model/PickupRequest.dart';

class PickupListPage extends StatefulWidget {
  @override
  _PickupListPageState createState() => _PickupListPageState();
}

class _PickupListPageState extends State<PickupListPage> {
  final PickupService _pickupService = PickupService();
  late Future<List<PickupRequest>> _futurePickups;

  @override
  void initState() {
    super.initState();
    _futurePickups = _loadPickupRequests();
  }

  Future<List<PickupRequest>> _loadPickupRequests() async {
    String? userId =
        await getUserId(); // Retrieve user ID from storage, if logged in
    return _pickupService.getPickupsByUserIdOrSessionId(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<PickupRequest>>(
        future: _futurePickups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var pickup = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.teal,
                    ),
                    title: Text(
                      pickup.fullName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          pickup.address,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Date: ${pickup.date} Time: ${pickup.time}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 20,
                          color: Colors.teal,
                        ),
                        SizedBox(height: 5),
                        Text(
                          pickup.phoneNumber,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No pickups found'));
          }
        },
      ),
    );
  }
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}
