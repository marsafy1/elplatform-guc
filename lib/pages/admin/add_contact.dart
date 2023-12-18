import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';
import 'package:guc_swiss_knife/models/contact.dart';
import 'package:guc_swiss_knife/services/contact_service.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  ContactService contactService = ContactService();

  int _iconCodePoint = Icons.phone.codePoint;
  String _iconFontFamily = Icons.phone.fontFamily ?? "";
  Icon? _icon = const Icon(Icons.phone);

  late final GlobalKey<FormState> _formKey;
  late final Map<String, dynamic> fields;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    fields = {
      "name": FormInputField(
        name: "name",
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
      "phone_number": FormInputField(
        keyboardType: TextInputType.number,
        name: "Phone Number",
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

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);
    icon ??= IconData(_iconCodePoint, fontFamily: _iconFontFamily);
    _iconCodePoint = icon.codePoint;
    _iconFontFamily = icon.fontFamily ?? _iconFontFamily;
    setState(() {
      _icon = Icon(icon);
    });

    debugPrint('Picked Icon:  ${icon.codePoint} ${icon.fontFamily}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Contact'),
        ),
        // add icon picker and two text fields for name and phone number
        body: SingleChildScrollView(
          child: Center(
            child: Card(
              elevation: 2.0,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _pickIcon,
                          child: Row(
                            children: [
                              const Text('Icon: '),
                              _icon ?? const Icon(Icons.apps),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    ...fields.values,
                    ElevatedButton(
                      onPressed: () {
                        // Add your save logic here
                        if (_formKey.currentState!.validate()) {
                          contactService.addContact(
                            Contact(
                              name: fields['name']!.controller.text,
                              phoneNumber:
                                  fields['phone_number']!.controller.text,
                              iconCodePoint: _iconCodePoint,
                              iconFontFamily: _iconFontFamily,
                            ),
                          );
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
