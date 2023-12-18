import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/services/course_service.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  late final GlobalKey<FormState> _formKey;
  late final Map<String, dynamic> fields;

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
        keyboardType: TextInputType.number,
        name: "Description",
        controller: TextEditingController(),
        icon: Icons.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Phone number is required';
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
                    ElevatedButton(
                      onPressed: () {
                        // Add your save logic here
                        if (_formKey.currentState!.validate()) {
                          CourseService.addCourse(Course(
                              title: fields['title']!.controller.text,
                              description:
                                  fields['description']!.controller.text));
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
