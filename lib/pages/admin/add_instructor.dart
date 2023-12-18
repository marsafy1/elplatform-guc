import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';

const String emailRegex = r'^[a-zA-Z]+\.[a-zA-Z]+@(student\.)?guc\.edu\.eg$';

class AddInstructor extends StatefulWidget {
  const AddInstructor({super.key});

  @override
  State<AddInstructor> createState() => _AddInstructorState();
}

class _AddInstructorState extends State<AddInstructor> {
  late final GlobalKey<FormState> _formKey;
  late final Map<String, dynamic> fields;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    fields = {
      "first_name": FormInputField(
        name: "First Name",
        controller: TextEditingController(),
        icon: Icons.person,
        validator: (value) {
          if (value!.isEmpty) {
            return 'First Name is required';
          }
          return null;
        },
      ),
      "sized_box1": const SizedBox(height: 20),
      "last_name": FormInputField(
        name: "Last Name",
        controller: TextEditingController(),
        icon: Icons.person,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Last Name is required';
          }
          return null;
        },
      ),
      "sized_box2": const SizedBox(height: 20),
      "email": FormInputField(
        name: "Email",
        controller: TextEditingController(),
        icon: Icons.email,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email is required';
          } else if (!RegExp(emailRegex).hasMatch(value)) {
            return 'Email should be a valid GUC email';
          }
          return null;
        },
      ),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Instructor'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Card(
              elevation: 2.0,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ...fields.values,
                    ElevatedButton(
                      onPressed: () {
                        // Add your save logic here
                        if (_formKey.currentState!.validate()) {
                          UserService.createUser(
                              id: '',
                              firstName: fields['first_name']!.controller.text,
                              lastName: fields['last_name']!.controller.text,
                              email: fields['email']!.controller.text,
                              userType: UserType.instructor,
                              isPublisher: false);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 14)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
