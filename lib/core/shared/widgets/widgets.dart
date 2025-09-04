import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

TextField buildSearchTextField({
  controller,
  keyboardType = TextInputType.text,
  obscureText = false,
  hintText = "Where to?",
  bool isEnabled = false,
  Function(String)? onSubmitted,
}) {
  return TextField(
    controller: controller,
    onSubmitted: onSubmitted,
    keyboardType: keyboardType,
    obscureText: obscureText,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.accent,
      hintText: hintText,
      hintStyle: AppTextStyles.body2.copyWith(fontSize: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent),
      ),
      prefixIcon: Icon(Icons.search),
      enabled: isEnabled,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );
}

TextFormField buildTextFormField({
  required controller,
  required keyboardType,
  obscureText = false,
  required validator,
  required hintText,
  bool readOnly = false,
  VoidCallback? onTap,
  List<TextInputFormatter>? inputFormatters,
  Widget? suffixIcon,
  Function(String)? onChanged,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    validator: validator,
    readOnly: readOnly,
    onTap: onTap,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.accent,
      hintText: hintText,
      hintStyle: AppTextStyles.body.copyWith(fontSize: 16),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent),
      ),
      // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)
    ),
  );
}

MaterialButton buildMaterialButton({
  required onPressed,
  required String label,
  color = AppColors.primary,
}) {
  return MaterialButton(
    onPressed: onPressed,
    disabledColor: AppColors.primary.withOpacity(0.1),
    color: color,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(10),
    ),
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Text(label, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
  );
}

class SelectionRow extends StatefulWidget {
  final String title; // "Theme" or "Language"
  final List<String> options; // ["Light", "Dark"]
  final String initialValue;
  final ValueChanged<String>? onSelected;

  const SelectionRow({
    super.key,
    required this.title,
    required this.options,
    required this.initialValue,
    this.onSelected,
  });

  @override
  State<SelectionRow> createState() => _SelectionRowState();
}

class _SelectionRowState extends State<SelectionRow> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  void _showSelectionDialog() {
    String tempValue = selectedValue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(widget.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.options.map((option) {
              return RadioListTile<String>(
                activeColor: Theme.of(context).primaryColor,
                title: Text(option),
                value: option,
                groupValue: tempValue,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedValue = value;
                    });
                    widget.onSelected?.call(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showSelectionDialog,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 16)),
            Text(selectedValue, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

Widget buildAppBar(BuildContext context, String title, {onTap}) {
  return Padding(
    padding: const EdgeInsets.only(top:10.0),
    child: Column(

      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Positioned(
              left: 0,
              child: IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Colors.white,
              ),
            ),
            Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 22),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}
