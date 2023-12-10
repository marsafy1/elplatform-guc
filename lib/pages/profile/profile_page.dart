import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final AuthProvider _authProvider;
  late User user;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = _authProvider.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/editProfile');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoTile('Email', user.email),
                if (user.gucId != null) _buildInfoTile('GUC ID', user.gucId!),
                _buildInfoTile('Publisher', user.isPublisher ? 'Yes' : 'No'),
                _buildInfoTile('Bio', user.bio ?? ''),
              ],
            )
          ],
        ),
      ),
    );
  }

  ListTile _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircleAvatar(
              backgroundImage:
                  user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : const AssetImage('assets/default_profile_picture.png')
                          as ImageProvider<Object>?,
            ),
          ),
        ),
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
