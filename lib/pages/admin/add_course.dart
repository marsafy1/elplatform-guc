import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/services/course_service.dart';
import 'package:guc_swiss_knife/services/image_upload_service.dart';
import 'package:image_picker/image_picker.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  late final GlobalKey<FormState> _formKey;
  late final Map<String, dynamic> fields;
  File? _pickedImage;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    fields = {
      "title": FormInputField(
        name: "title",
        controller: TextEditingController(),
        icon: Icons.info,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Title is required';
          }
          return null;
        },
      ),
      "sized_box1": const SizedBox(height: 20),
      "description": FormInputField(
        name: "Description",
        controller: TextEditingController(),
        icon: Icons.description,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Description is required';
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
        title: const Text('Add Course'),
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
                  GestureDetector(
                    onTap: pickImage,
                    child: Column(
                      children: [
                        _pickedImage != null
                            ? Image.file(_pickedImage!,
                                width: 100.0, height: 100.0, fit: BoxFit.cover)
                            : Container(
                                width: 100.0,
                                height: 100.0,
                                color: Colors.grey[300],
                                child: const Icon(Icons.camera_alt,
                                    size: 50.0, color: Colors.grey),
                              ),
                        const SizedBox(height: 10.0),
                        const Text('Tap to pick image'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print("hello");
                      String? photoUrl =
                          await ImageUploadService.uploadImage(_pickedImage!);
                      print(photoUrl);
                      if (_formKey.currentState!.validate()) {
                        CourseService.addCourse(Course(
                            title: fields['title']!.controller.text,
                            description: fields['description']!.controller.text,
                            photoUrl: photoUrl ?? ''));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      return File(pickedFile.path);
    }
    return null;
  }
}
