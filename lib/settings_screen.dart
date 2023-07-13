import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String modelValue;

  @override
  void initState() {
    super.initState();

    modelValue = Provider.of<ChatModel>(context, listen: false).modelSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  // Add Horizontal padding using menuItemStyleData.padding so it matches
                  // the menu padding when button's width is not specified.
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(),
                  labelText: 'Model',
                ),
                value: modelValue,
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (String? newValue) {
                  setState(() {
                    modelValue = newValue!;
                  });
                },
                items:
                    Provider.of<ChatModel>(context, listen: false).models.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  Provider.of<ChatModel>(context, listen: false).setModel(modelValue);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
