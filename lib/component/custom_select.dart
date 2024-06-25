import 'dart:ffi';
import 'package:flutter/material.dart';
import '../data_type/select_time_data.dart';

class CustomSelect extends StatelessWidget {
  final void Function(int?) onChanged;
  final List<SelectTimeDate> data;
  final String text;

  CustomSelect({
    required this.onChanged,
    required this.data,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        onSelected: onChanged,
        width: MediaQuery.of(context).size.width*0.44,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        label:  Text(text,style: TextStyle(fontWeight: FontWeight.bold),),
        dropdownMenuEntries: data.map<DropdownMenuEntry<int>>(
              (SelectTimeDate i) {
            return DropdownMenuEntry<int>(
              value: i.value,
              label: i.key,
              style: MenuItemButton.styleFrom(
                textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)

              ),
            );
          },
        ).toList());
  }
}
