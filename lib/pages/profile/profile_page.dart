import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/analytics_service.dart';
import 'package:guc_swiss_knife/services/user_service.dart';
import 'package:guc_swiss_knife/utils_functions/profile.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  Future<User> _loadUser(String? userId) {
    try {
      return userId != null
          ? UserService.getUserById(userId)
          : Future(() => _authProvider.user!);
    } catch (e) {
      print('Error loading user data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context);

    final Map<String, dynamic>? routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? userId = routeArgs?['userId'];

    bool isOwnProfile = userId == null || userId == _authProvider.user?.id;

    if (!isOwnProfile) {
      AnalyticsService.logViewOthersProfile();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: isOwnProfile ? [_optionsMenu(context)] : [],
      ),
      body: FutureBuilder<User>(
          future: _loadUser(userId),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _header(snapshot.data!),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoTile('Email', snapshot.data!.email),
                        if (snapshot.data!.gucId != null)
                          _buildInfoTile('GUC ID', snapshot.data!.gucId!),
                        _buildInfoTile('Publisher',
                            snapshot.data!.isPublisher ? 'Yes' : 'No'),
                        _buildInfoTile('Bio', snapshot.data!.bio ?? ''),
                      ],
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  ListTile _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _header(User user) {
    return Column(
      children: [
        generateAvatar(context, user, radius: 100),
        const SizedBox(height: 20),
        Text(
          "${user.firstName} ${user.lastName}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${StringUtils.capitalize(user.userType.toShortString())} @ ${user.faculty ?? "GUC"}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          user.header ?? "",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

Widget _optionsMenu(BuildContext context) {
  return PopupMenuButton<String>(
    onSelected: (value) {
      if (value == 'editProfile') {
        Navigator.of(context).pushNamed('/editProfile');
      } else if (value == 'changePassword') {
        Navigator.of(context).pushNamed('/changePassword');
      }
    },
    itemBuilder: (BuildContext context) {
      return [
        const PopupMenuItem(
          value: 'editProfile',
          child: Text('Edit Profile'),
        ),
        const PopupMenuItem(
          value: 'changePassword',
          child: Text('Change Password'),
        ),
      ];
    },
  );
}
