import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/profile/form_input_field.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/utils_functions/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final AuthProvider _authProvider;
  late User user;
  late ImagePicker _imagePicker;
  late final Map<String, FormInputField> fields;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = _authProvider.user!;

    _imagePicker = ImagePicker();
    fields = {
      "first_name": FormInputField(
        name: "First Name",
        controller: TextEditingController(text: user.firstName),
      ),
      "last_name": FormInputField(
        name: "Last Name",
        controller: TextEditingController(text: user.lastName),
      ),
      "email": FormInputField(
        name: "Email",
        controller: TextEditingController(text: user.email),
        enabled: false,
      ),
      "header": FormInputField(
        name: "Header",
        controller: TextEditingController(text: user.header ?? ''),
        maxLength: 35,
      ),
      "guc_id": FormInputField(
        name: "GUC ID",
        controller: TextEditingController(text: user.gucId ?? ''),
      ),
      "bio": FormInputField(
        name: "Bio",
        controller: TextEditingController(text: user.bio ?? ''),
        multiline: true,
        hintText: "Enter your bio...",
      ),
    };
    super.initState();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // TODO: Implement logic to update user's profile picture
      // You can use pickedFile.path to get the file path of the selected image
    }
  }

  @override
  void dispose() {
    for (var element in fields.entries) {
      element.value.controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _profilePictureSection(),
              const SizedBox(height: 20),
              _inputFieldsSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePictureSection() {
    return Center(
      child: InkWell(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.center,
          children: [
            generateAvatar(context, user, radius: 100, isClickable: false),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputFieldsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...fields.values
            .toList()
            .expand((widget) => [widget, const SizedBox(height: 5)])
            .toList(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            saveChangesClicked();
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  Future<void> saveChangesClicked() async {
    final firstName = fields["first_name"]!.controller.text;
    final lastName = fields["last_name"]!.controller.text;
    final header = fields["header"]!.controller.text;
    final gucId = fields["guc_id"]!.controller.text;
    final bio = fields["bio"]!.controller.text;

    await _authProvider.updateUser(
      firstName: firstName,
      lastName: lastName,
      header: header,
      gucId: gucId,
      bio: bio,
    );
    Navigator.of(context).pop();
  }
}
