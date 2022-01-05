import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Padding title(String name) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Text(
      name,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Padding DropButtonCustom(String dropdownValue, Function(String?)? handle) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
    child: DropdownButtonFormField<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.black, width: 1)),
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.5,
        ),
      ),
      onChanged: handle,
      items: <String>['Male', 'Female']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              value == 'Male'
                  ? Icon(Icons.male, color: Colors.blue)
                  : Icon(Icons.female, color: Colors.pink.shade300),
              SizedBox(
                width: 2.w,
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

// ignore: non_constant_identifier_names
Padding BuildTextField(
    Widget? icon,
    TextInputType tyle,
    bool isRead,
    String vali,
    TextEditingController nameController,
    String placeholder,
    Function() handle) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: TextFormField(
        keyboardType: tyle,
        readOnly: isRead,
        onTap: handle,
        controller: nameController,
        validator: (val) => val!.trim().length == 0 ? vali : null,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          fillColor: Colors.black,
          hintText: placeholder,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
          // floatingLabelStyle: TextStyle(
          //   color: Colors.black,
          //   fontSize: 15,
          //   fontWeight: FontWeight.normal,
          //   letterSpacing: 0.5,
          // ),
          prefixIcon: icon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black, width: 1)),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
        ),
      ));
}
